//
//  UpdateProfileController.swift
//  Xeat
//
//  Created by apple on 24/12/21.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class UpdateProfileController: UIViewController , UITextFieldDelegate,UIImagePickerControllerDelegate,
                               UINavigationControllerDelegate {
    
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var edEmail: UITextField!
    
    @IBOutlet weak var edUserName: UITextField!
    
    @IBOutlet weak var edMobile: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    private let pickerController = UIImagePickerController()
    var context = CIContext(options: nil)
    var strUserId = ""
    var strName = ""
    var strGender = "Male"
    var strEmail = ""
    var strBio = ""
    var imageContains = ""
    var filePath : URL? = nil
    var imageOrg : UIImage? = nil
    var imageoptionSelected = 0
    
    
    
    @IBAction func btnUploadImage(_ sender: Any) {
        optionSelection()
    }
    
    
    @IBAction func btnSaveAction(_ sender: Any) {
        UserInputValue()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        intilaizeViews()
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        navigationController?.setNavigationBarHidden(false, animated: animated)
    //    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    func intilaizeViews()
    {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        //       .self.navigationController?.navigationBar.barTintColor  = UIColor.white
        // self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        
        indicator.isHidden = true
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        self.setupToHideKeyboardOnTapOnView()
        
        UITextField.appearance().tintColor = .black
        
        self.edEmail.delegate = self
        self.edUserName.delegate = self
        
        self.edUserName.tag = 0
        self.edEmail.tag = 1
        
        btnSave.layer.cornerRadius=10
        btnSave.clipsToBounds=true
        btnSave.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        edEmail.layer.borderWidth = 0
        
        edEmail.attributedPlaceholder = NSAttributedString(string: "Email address",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
          edMobile.attributedPlaceholder = NSAttributedString(string: "Mobile Number",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        edUserName.attributedPlaceholder = NSAttributedString(string: "User Name",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        
        
        
        edUserName.delegate = self
        edMobile.delegate = self
       
        edMobile.isEnabled = false
        imgProfile.isUserInteractionEnabled = true
        imgProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = #colorLiteral(red: 0.1764705882, green: 0.3294117647, blue: 0.5607843137, alpha: 1)
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
        
        
        edEmail.text =  UserDefaults.standard.string(forKey: Constant.EMAIL)
        edUserName.text = UserDefaults.standard.string(forKey: Constant.NAME)
        edMobile.text = UserDefaults.standard.string(forKey: Constant.CONTACT_NO)
        let strImageURL =
            UserDefaults.standard.string(forKey: Constant.PROFILE_PICTURE)!
        print(strImageURL)
        if(strImageURL.count>2){
            let urlYourURL = URL (string:strImageURL )
            imgProfile.loadurl(url: urlYourURL!)
        }
        
      
        
       
        strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        
    }
    
    @objc func imageTap() {
        optionSelection()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
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
            imgProfile.contentMode = .scaleAspectFit
            imgProfile.image = possibleImage
            imageOrg = possibleImage
          //  let data = possibleImage.pngData()
            
        }
        else if let possibleImage = info[.editedImage] as? UIImage {
            print("if works")
            imgProfile.contentMode = .scaleAspectFit
            imgProfile.image = possibleImage
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
            let image             = info[UIImagePickerController.InfoKey.editedImage]as! UIImage
            
            let data              = image.jpeg(.medium)
            
            imageContains = localPath!.absoluteString
            
            filePath = localPath!
            print(localPath)
            do
            {
                try data?.write(to: localPath!, options: Data.WritingOptions.atomic)
                if let imageData = image.jpeg(.lowest) {
                    print(imageData.count)
                }
            }
            catch
            {
                // Catch exception here and act accordingly
            }
        } else
        {
            print(imageoptionSelected)
            
            let folderName = "updateprofile" + "/"
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
            // alertUI(title: "camera", Message: "\(photoURL)")
            
            
        }
        
        self.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func UserInputValue()
    {
        if let text = edUserName.text, text.isEmpty
        {
            alertFailure(title: "Name empty", Message: "Please enter your name")
        }
        else if let text2 = edMobile.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
            alertFailure(title: "Mobile Number empty", Message: "Please enter your mobile number")
        }
       else if let text = edEmail.text, text.isEmpty
        {
        alertFailure(title: "Email empty", Message: "Please enter your email address")
        }
        else if edEmail.text?.trimmingCharacters(in: .whitespaces).isValidateEmail()==false
        {
            alertFailure(title: "Email wrong", Message: "Please enter valid email address")
            
        }
        else{
            strEmail = edEmail.text!.trimmingCharacters(in: .whitespaces)
           
            strName = edUserName.text!.trimmingCharacters(in: .whitespaces)
 
            if(currentReachabilityStatus != .notReachable)
            {
                if((imageContains.count) < 2)
                {
                    profileUpdateAPI()
                }
                else{
                    uploadDocument()
                }
            }
            else{
                alertFailure(title: "No Internet Connection", Message: "It seems your internet connection lost. Please reconnect it and try again")
            }
        }
    }
    
    func uploadDocument() {
        self.btnSave.isEnabled = false
        indicator.isHidden = false
        indicator.startAnimating()
        let strContact = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!

        
        let parameters = ["name": strName , "email":strEmail , "userid": strContact , "accesstoken" : Constant.APITOKEN]
        print(parameters)
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(self.filePath!, withName: "user_img" , fileName: "1.png", mimeType: "image/jpeg")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
            to: Constant.baseURL + Constant.profileUpdateApi, method: .post)
            //    .response { response in
            .responseJSON { (response) in
                let status = response.response?.statusCode
                if(status == 401)
                {
                    self.indicator.isHidden = true
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
                                let str = data["data"]["api_token"]
                                let status = data["code"]
                                print("DATA PARSED email: \(str)")
                                self.indicator.stopAnimating()
                                self.indicator.isHidden = true
                                
                                if("\(status)" == "200")
                                {
                                    self.btnSave.isEnabled = true
                                    UserDefaults.standard.set("\(data["data"]["name"])", forKey: Constant.NAME)
                                    UserDefaults.standard.set("\(data["data"]["image"])", forKey:Constant.PROFILE_PICTURE)
                                    
                                    UserDefaults.standard.set(self.strName, forKey: Constant.NAME)
                                    UserDefaults.standard.set(self.strEmail, forKey: Constant.EMAIL)
                                    let strr = UserDefaults.standard.string(forKey: Constant.PROFILE_PICTURE)
                                    print(strr!)
                                    self.alertSucces(title: "Profile Updated", Message: "Your profile updated successfully ")
                                }
                                
                                else
                                {
                                    self.btnSave.isEnabled = true
                                    let message = data["message"]
                                    self.alertFailure(title: "Invalid", Message: "\(message)")
                                    self.indicator.stopAnimating()
                                    self.indicator.isHidden = true
                                }
                            }
                            catch{
                                self.btnSave.isEnabled = true
                                self.indicator.stopAnimating()
                                self.indicator.isHidden = true
                                print("JSON Error", error)
                                //    self.alertUI(title: "Invalid json", Message: "\(error)")
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                        self.btnSave.isEnabled = true
                    // self.alertUI(title: "Invalid faliure", Message: "\(error)")
                    }
                }
            }
    }
    
    func profileUpdateAPI()
    {
        
        let strContact = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["name": strName , "email":strEmail , "userid": strContact , "accesstoken" : Constant.APITOKEN]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.profileUpdateApi, method: .post, param: parameters, viewController: self) { (json) in
         print(json)
            
            
            if("\(json["code"])" == "201")
            {
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
            else
            {
                UserDefaults.standard.set(self.strName, forKey: Constant.NAME)
                UserDefaults.standard.set(self.strEmail, forKey: Constant.EMAIL)

                self.alertSucces(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Success", comment: ""), Message:  "\(json["message"])")
            }
           
        }
     
       
      
    }

    
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
extension UIImage
{
    var highestQualityJPEGNSData: NSData { return self.jpegData(compressionQuality: 1.0)! as NSData }
    var highQualityJPEGNSData: NSData    { return self.jpegData(compressionQuality: 0.75)! as NSData}
    var mediumQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.5)! as NSData }
    var lowQualityJPEGNSData: NSData     { return self.jpegData(compressionQuality: 0.25)! as NSData}
    var lowestQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.0)! as NSData }
}
extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                    print(folderURL)
                    print("===============")
                } catch {
                    print(error.localizedDescription)
                    print("8989898998989")
                    return nil
                }
            }
            return folderURL
        }
        return nil
    }
    
    
    
}
