//
//  ChatController.swift
//  Xeat
//
//  Created by apple on 28/01/22.
//


import UIKit
import Firebase

class Comments {
    
    var id: String
    var text: String
    var createdAt: Double
    var order: Double
    
    
    init(id: String, text: String, createdAt : Double, order: Double) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.order = order
    }
}

class ChatController: UIViewController,UITableViewDelegate,UITableViewDataSource , UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        myArray.count
        
    }
   
    @IBOutlet weak var imgSend: UIImageView!
   
    var myArray : [Comments] = []
  
    
    @IBOutlet var txtComments: UILabel!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var tableLevel: UITableView!

    @IBOutlet var edMessage: UITextField!
 
    var videoId = ""
   var driverDeviceToken = ""
    var driverDeviceType = ""
    var strID = ""
    var strMessage = ""
    var ref: DatabaseReference! = Database.database().reference()
    
    
    //  var arrOFMessage : [] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edMessage.delegate = self
        indicator.isHidden = true
        strID = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        print(videoId)
        self.setupToHideKeyboardOnTapOnView()
        tableLevel.separatorStyle = UITableViewCell.SeparatorStyle.none
        let nib = UINib(nibName: "ChatViewCell", bundle: nil)
        tableLevel.register(nib, forCellReuseIdentifier: "ChatViewCell")
        tableLevel.delegate=self
        tableLevel.dataSource=self
        edMessage.delegate = self
        edMessage.attributedPlaceholder = NSAttributedString(string: "Type message...",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
       

        txtComments.text = "Order id #" + videoId
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
  //      self.keyboardSettings()
       
        loadData()
        
        self.ref.child("MESSAGE/\(self.videoId)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists(){


            }else{

               // self.alertUI(title: "No comments found", Message: "There is no comment found realted to this")
            }


        })
        
        var milliStamp : String {
            let currentDate = Date()
            let since1970 = currentDate.timeIntervalSince1970
            // let timeInterval: TimeInterval = timeIntervalSince1970
            let millisecond = CLongLong(round(since1970*1000))
            
            return "\(millisecond)"
        }
        print(milliStamp)
        imgSend.isUserInteractionEnabled = true
        imgSend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.messageSend)))
        let dic2 = NSMutableDictionary()
        dic2 .setValue(Double(milliStamp), forKey: "createdAt")
        dic2 .setValue("0", forKey: "READ")
        
        self.ref.child("MESSAGE_READ").child(videoId).child("USER").setValue(dic2 as [NSObject : AnyObject]) { (error, ref) in
                if(error != nil){
                    print("Error",error)
                    self.edMessage.text = ""
                }
                else{
                    
                }
            }
       
       }
    override func viewDidDisappear(_ animated: Bool) {
        self.ref.child("MESSAGE/\(videoId)").removeAllObservers()
        self.ref.child("MESSAGE_READ/\(videoId)").removeAllObservers()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        sendMessage()
        return false
    }
    @objc func messageSend()
    {
        if(currentReachabilityStatus != .notReachable)
        {
                sendMessage()
        }
        else{
            alertInternet()
        }
        
    }
  
    func sendMessage()
    {
        let mesg = edMessage.text?.trimmingCharacters(in: .whitespaces)
        if (mesg!.isEmpty)
        {
            
        }
        else
        {
            self.strMessage = (edMessage.text?.trimmingCharacters(in: .whitespaces))!
        
        
        var milliStamp : String {
            let currentDate = Date()
            let since1970 = currentDate.timeIntervalSince1970
            // let timeInterval: TimeInterval = timeIntervalSince1970
            let millisecond = CLongLong(round(since1970*1000))
            
            return "\(millisecond)"
        }
        print(milliStamp)
        let dic = NSMutableDictionary()
        dic .setValue(Double(milliStamp), forKey: "createdAt")
        dic .setValue(strMessage, forKey: "text")
        dic .setValue(strID,forKey: "_id")
        dic .setValue(Double(milliStamp),forKey: "order")
     
   
        //
                self.ref.child("MESSAGE").child(videoId).child(milliStamp).setValue(dic as [NSObject : AnyObject]) { (error, ref) in
                        if(error != nil){
                            print("Error",error)
                            self.edMessage.text = ""
                        }else{
                            
                            print("Added successfully...")
                            print(self.driverDeviceToken)
                            let sender = PushNotificationSender()
                            sender.sendPushNotification(to: self.driverDeviceToken, title: "New message", body: self.edMessage.text!, driverDeviceType : self.driverDeviceType)
                            self.edMessage.text = ""

                        }
                    }
            
            let dic2 = NSMutableDictionary()
           // dic2 .setValue(Double(milliStamp), forKey: "createdAt")
            dic2 .setValue("1", forKey: "READ")
            
            self.ref.child("MESSAGE_READ").child(videoId).child("DRIVER").setValue(dic2 as [NSObject : AnyObject]) { (error, ref) in
                    if(error != nil){
                        print("Error",error)
                        self.edMessage.text = ""
                    }
                    else{
                        
                    }
                }
        }
    }
    
    func loadData() {
        
       self.ref.child("MESSAGE/\(videoId)").observe(.childAdded, with: { (snapshot) in
                    let results = snapshot.value as? [String : AnyObject]
     
        self.indicator.isHidden = false
                    let text = results?["text"]
                    let createdAt = results?["createdAt"]
            let order = results?["order"]
            let id = results?["_id"]
                    let myCalls = Comments(id: id as! String, text: text as! String, createdAt: createdAt as! Double, order: order as! Double)
           // let array = Comments(id: id, text: text, createdAt: createdAt, userName: userName)
                    self.myArray.append(myCalls)
            self.indicator.isHidden = true
          
                DispatchQueue.main.async {
               
                    self.tableLevel.reloadData()
                   // self.txtComments.text = "Comments (" + "\(self.myArray.count)" + ")"
                    let indexPath = IndexPath(row: self.myArray.count-1, section: 0)
                    self.tableLevel.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
        
    
        let dic2 = NSMutableDictionary()
        dic2 .setValue("0", forKey: "READ")
        
        self.ref.child("MESSAGE_READ").child(self.videoId).child("USER").setValue(dic2 as [NSObject : AnyObject]) { (error, ref) in
                if(error != nil){
                    print("Error",error)
                    self.edMessage.text = ""
                }
                else{
                    
                }
            }
        
            })
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
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatViewCell",for: indexPath)
                as! ChatViewCell
//                cell.viewSender.isHidden = true
//            cell.viewReceiver.isHidden = false
        cell.txtResceDate.text = "\(convertEpochToStringDate(dateTime: "\(self.myArray[indexPath.row].createdAt)"))"
            //cell.txtReceiverDate.text = String( self.myArray[indexPath.row].createdAt)
            cell.txtReceiveMessage.text = String( self.myArray[indexPath.row].text)
        if(self.myArray[indexPath.row].id == strID)
        {
            cell.viewSender.isHidden = false
            cell.viewReceiver.isHidden = true
            cell.txtSenderDate.text = "\(convertEpochToStringDate(dateTime: "\(self.myArray[indexPath.row].createdAt)"))"
                //cell.txtReceiverDate.text = String( self.myArray[indexPath.row].createdAt)
                cell.txtSenderMessage.text = String( self.myArray[indexPath.row].text)
        }
        else
        {
            cell.txtResceDate.text = "\(convertEpochToStringDate(dateTime: "\(self.myArray[indexPath.row].createdAt)"))"
                //cell.txtReceiverDate.text = String( self.myArray[indexPath.row].createdAt)
                cell.txtReceiveMessage.text = String( self.myArray[indexPath.row].text)
            cell.viewSender.isHidden = true
            cell.viewReceiver.isHidden = false
        }
            return cell
       // }
    }
    func convertEpochToStringDate(dateTime: String) -> String {
        let timestampDouble: Double = Double(Double(dateTime)!/1000)
        let timestamp = Date(timeIntervalSince1970: timestampDouble)
        let formattedTimestamp = DateFormatter.localizedString(from: timestamp , dateStyle: .medium, timeStyle: .short)
        return formattedTimestamp
    }
   
    func alertUI(title: String,Message : String) -> Void {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("default")
              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")

              @unknown default:
                break;
              }}))
        self.present(alert, animated: true, completion: nil)

    }
    
}


class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String, driverDeviceType : String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
    
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body, "sound" : "default"],
                                           "data" : ["title" : title, "body" : body, "sound" : "default"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAA0PvpKXA:APA91bEHSxVNy6HqC7CGFb1-nVoOz9PMgs0rcxBzhUN4QeIeNbP6KizbyoQqT_l855jN7DPFP649ZkSVUAn00pyLW0elbjo_lAk57iJtwHU2akiHfYdoh3VdI_LZSpQsrQCiAYUXdim9", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
