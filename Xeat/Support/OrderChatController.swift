//
//  OrderChatController.swift
//  Xeat
//
//  Created by apple on 05/01/22.
//

import UIKit
import SafariServices
import Alamofire
import SwiftyJSON
import IQKeyboardManagerSwift

class OrderChatController: UIViewController, UITableViewDelegate,UITableViewDataSource , UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFSafariViewControllerDelegate{
    
    @IBAction func btnReferesh(_ sender: Any) {
        self.orderChatAPI()
    }
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var orderID = ""
    var chatId = ""
    
    private let pickerController = UIImagePickerController()
    var context = CIContext(options: nil)
    
    var imageContains = ""
    var filePath : URL? = nil
    var imageOrg : UIImage? = nil
    var imageoptionSelected = 0
    @IBOutlet weak var txtHeading: UILabel!
    
    @IBOutlet weak var txtHeadingMain: UINavigationItem!
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var imgSend: UIImageView!
    
    
    @IBOutlet weak var edMessag: UITextField!
    
    @IBOutlet weak var imgAttachment: UIImageView!
    var arrOfTrans : [DatumOrderChat] = []
    @IBOutlet weak var tableView: UITableView!
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func keyboard(notification:Notification) {
        guard let keyboardReact = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||  notification.name == UIResponder.keyboardWillChangeFrameNotification {
            self.view.frame.origin.y = -keyboardReact.height
        }else{
            self.view.frame.origin.y = 0
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //IQKeyboardManager.shared.enable = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]

        self.setupToHideKeyboardOnTapOnView()
        
        print(orderID)
        print(chatId)
        let nib = UINib(nibName: "ChatViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChatViewCell")
        
        
        let nib2 = UINib(nibName: "ChatImageCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "ChatImageCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        edMessag.attributedPlaceholder = NSAttributedString(string: "Type message...",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        indicator.isHidden = true
        
        if(currentReachabilityStatus != .notReachable)
        {
            orderChatAPI()
        }
        else{
            alertInternet()
        }
        print(orderID)
        txtHeadingMain.title
            = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order id #", comment: "") + orderID
        
        imgSend.isUserInteractionEnabled = true
        imgSend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.messageSend)))
        
        imgAttachment.isUserInteractionEnabled = true
        imgAttachment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
    }
    
    
    
    
    @objc func imageTap() {
        optionSelection()
    }
    
    func optionSelection()
    {
        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.imageoptionSelected = 1
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.imageoptionSelected = 2
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        //        alert.popoverPresentationController!.sourceView = self.view
        //        alert.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallery()  {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary;
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    func openCamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.delegate = self
            pickerController.sourceType = .camera;
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let possibleImage = info[.editedImage] as? UIImage {
            //newImage = possibleImage
            print("if works edited")
            //            imgProfile.contentMode = .scaleAspectFit
            //            imgProfile.image = possibleImage
            imageOrg = possibleImage
        }
        else if let possibleImage = info[.originalImage] as? UIImage {
            print("if works")
            //            imgProfile.contentMode = .scaleAspectFit
            //            imgProfile.image = possibleImage
            imageOrg = possibleImage
        } else {
            print("else works")
            return
        }
        dismiss(animated: true, completion: nil)
        if(imageoptionSelected == 2)
        {
            let imageUrl          = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
            let imageName         = imageUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let photoURL          = NSURL(fileURLWithPath: documentDirectory)
            let localPath         = photoURL.appendingPathComponent(imageName!)
            let image             = info[UIImagePickerController.InfoKey.originalImage]as! UIImage
            
            let data              = image.jpeg(.medium)
            
            imageContains = localPath!.absoluteString
            
            filePath = localPath!
            
            print(filePath)
            
            do
            {
                try data?.write(to: localPath!, options: Data.WritingOptions.atomic)
                if let imageData = image.jpeg(.lowest) {
                    print(imageData.count)
                }
                if(currentReachabilityStatus != .notReachable)
                {
                    uploadDocument()
                }
                else{
                    alertInternet()
                }
            }
            catch
            {
                // Catch exception here and act accordingly
            }
        } else
        {
            print(imageoptionSelected)
            
            let folderName = "chat" + "/"
            let    userFolder = URL.createFolder(folderName: folderName)
            
            let localPath = userFolder?.appendingPathComponent("image" + ".jpg")
            
            let image = imageOrg
            let data = image!.jpegData(compressionQuality: 0.5)! as NSData
            data.write(to: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            imageContains = folderName
            // let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            let photoURL = localPath?.absoluteURL
            filePath = photoURL
            
            uploadDocument()
            // alertUI(title: "camera", Message: "\(photoURL)")
            
            
        }
        
        self.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func messageSend()
    {
        if(currentReachabilityStatus != .notReachable)
        {
            if let text2 = edMessag.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
                
            }
            else{
                let strMessage = edMessag.text?.trimmingCharacters(in: .whitespaces)
                
                sendTextMessageAPI(comment: strMessage!, type : "0")
            }
        }
        else{
            alertInternet()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(arrOfTrans[indexPath.row].comment)
        let string = arrOfTrans[indexPath.row].comment
        if string.isValidURL {
            let url = URL(string: string)!
            let controller = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
            controller.delegate = self// TODO
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfTrans.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(arrOfTrans[indexPath.row].type == "1")
        {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "ChatImageCell", for: indexPath) as! ChatImageCell
            cell2.selectionStyle = .none
            let urll = URL(string: arrOfTrans[indexPath.row].comment)!
                           cell2.imgSender.af.setImage(withURL: urll)
            
            cell2.txtSenderDate.text =   arrOfTrans[indexPath.row].createdAt
            cell2.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell2
            
        }
        else{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "ChatViewCell", for: indexPath) as! ChatViewCell
            cell2.selectionStyle = .none
            
            
            let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
            if(arrOfTrans[indexPath.row].userID == strUserId)
            {
                cell2.viewSender.isHidden = false
                cell2.viewReceiver.isHidden = true
                cell2.txtSenderDate.text =   arrOfTrans[indexPath.row].createdAt
                cell2.txtSenderMessage.text =  arrOfTrans[indexPath.row].comment
                
            }
            else{
                cell2.viewSender.isHidden = true
                cell2.viewReceiver.isHidden = false
                cell2.txtResceDate.text =   arrOfTrans[indexPath.row].createdAt
                cell2.txtReceiveMessage.text =  arrOfTrans[indexPath.row].comment
            }
            cell2.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            return cell2
        }
      
    }
    
    func orderChatAPI()
    {
        
        
        indicator.isHidden = false
        indicator.startAnimating()
        let parameters = ["order_help_id": chatId, "accesstoken" : Constant.APITOKEN]
        print(parameters)
        AF.request(Constant.baseURL + Constant.orderChatMessageListAPI, method: .post,parameters: parameters).validate().responseJSON { (response) in
            debugPrint(response)
            let status = response.response?.statusCode
            if(status == 401)
            {
                self.indicator.isHidden = true
                self.alertUIUnauthorised()
                
            }
            else{
                self.imgSend.isUserInteractionEnabled = true
                switch response.result {
                case .success:
                    print("Validation Successful)")
                    self.indicator.isHidden = true
                    if let json = response.data {
                        do{
                            let data = try JSON(data: json)
                            
                            let status = data["data"]
                            print("data : \(status)")
                            
                            if(status.count == 0)
                            {
                                //                            self.viewNoData.isHidden = false
                                self.tableView.isHidden = true
                                
                            }
                            else
                            {
                                //                            self.viewNoData.isHidden = true
                                self.tableView.isHidden = false
                                
                                let arrdata =  try JSONDecoder().decode(HelpOrdertChatResponse.self, from: response.data!)
                                self.arrOfTrans = arrdata.data.reversed()
                                
                                self.tableView.reloadData()
                            }
                        }
                        catch{
                            
                            self.indicator.isHidden = true
                            print(error)
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    
                    self.indicator.isHidden = true
                }
            }
        }
    }
    
    
    func sendTextMessageAPI(comment : String , type : String )
    {
        imgSend.isUserInteractionEnabled = false
        let strContact = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strContact, "order_help_id": chatId, "accesstoken" : Constant.APITOKEN, "comment" : comment , "type" :type ]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.orderChatAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            
            if("\(json["code"])" == "200")
            {
                self.edMessag.text = ""
                self.orderChatAPI()
                
            }
            else
            {
                self.imgSend.isUserInteractionEnabled = true
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
            
        }
    }
    
    
    func uploadDocument() {
        imgSend.isUserInteractionEnabled = false
        //        self.btnSave.isEnabled = false
        indicator.isHidden = false
        indicator.startAnimating()
        let strContact = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        
        
        let parameters = [ "accesstoken" : Constant.APITOKEN ]
        
        print(parameters)
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(self.filePath!, withName: "image" , fileName: "1.png", mimeType: "image/jpeg")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
            to: Constant.baseURL + Constant.uploadImageAPI, method: .post)
            //    .response { response in
            .responseJSON { (response) in
                let status = response.response?.statusCode
                if(status == 401)
                {
                    // self.indicator.isHidden = true
                    self.alertUIUnauthorised()
                    
                }
                else{
                    debugPrint(response)
                    switch response.result{
                    case .success:
                        print("Validation Successful)")
                        
                        if let json = response.data {
                            do{
                                let data = try JSON(data: json)
                                let status = data["code"]
                                
                                self.indicator.stopAnimating()
                                self.indicator.isHidden = true
                                
                                if("\(status)" == "200")
                                {
                                    //self.btnSave.isEnabled = true
                                    
                                    self.sendTextMessageAPI(comment: "\(data["data"]["image_hrl"])", type: "1")
                                }
                                
                                else
                                {
                                    self.imgSend.isUserInteractionEnabled = true
                                    //  self.btnSave.isEnabled = true
                                    let message = data["message"]
                                    self.alertFailure(title: "Invalid", Message: "\(message)")
                                    self.indicator.stopAnimating()
                                    self.indicator.isHidden = true
                                }
                            }
                            catch{
                                //  self.btnSave.isEnabled = true
                                self.indicator.stopAnimating()
                                self.indicator.isHidden = true
                                print("JSON Error", error)
                                //    self.alertUI(title: "Invalid json", Message: "\(error)")
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                        self.imgSend.isUserInteractionEnabled = true
                    // self.btnSave.isEnabled = true
                    // self.alertUI(title: "Invalid faliure", Message: "\(error)")
                    }
                }
            }
    }
    
}
extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
