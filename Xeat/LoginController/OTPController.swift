//
//  OTPController.swift
//  Xeat
//
//  Created by apple on 16/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import FirebaseMessaging

class OTPController: UIViewController , UITextFieldDelegate{
    var intentName = ""
    var intentOTP = ""
    var strScreenType = ""
    var strOTP = ""
    var strPassword = ""
    var strEmail = ""
    var strPhone = ""
    var strDeviceToken = ""
    var strDailCode = ""
    
    @IBOutlet weak var verifyLine: UILabel!
    @IBOutlet var btnResend: UIButton!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var txtEmail: UILabel!
    @IBOutlet var btnVerify: UIButton!
    @IBOutlet var edEmail: UITextField!
    
    @IBAction func btnResnd(_ sender: Any) {
        btnResend.isEnabled = false
        otpCall()
    }
    
    @IBAction func btnVerify(_ sender: Any) {
        
        forgotValue()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.isHidden = true
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        txtEmail.text = strDailCode + strPhone
        self.setupToHideKeyboardOnTapOnView()
        verifyLine.text = "Verify your one time password"
        //  self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        btnVerify.layer.cornerRadius=10
        btnVerify.clipsToBounds=true
     //   btnVerify.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        // Do any additional setup after loading the view.
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(systemName: "lock")
        leftImageView.tintColor = UIColor.systemGray2
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView.frame = CGRect(x: 12, y: 12, width: 20, height: 15)
        edEmail.leftViewMode = .always
        edEmail.leftView = leftView
        edEmail.attributedPlaceholder = NSAttributedString(string: "XXXX",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        
        
        self.edEmail.delegate = self
        
        //        strDeviceToken =  UserDefaults.standard.string(forKey: Constant.deviceToken)!
        
        if(strScreenType == "1")
        {
            btnResend.isHidden = true
        }
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            self.strDeviceToken = "\(token)"
            UserDefaults.standard.setValue(self.strDeviceToken, forKey:  Constant.deviceToken)
//            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
          }
        }
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        navigationController?.setNavigationBarHidden(true, animated: animated)
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //      //  navigationController?.setNavigationBarHidden(false, animated: animated)
    //    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = (edEmail.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= 4
    }
    
    func forgotValue()
    {
        
        if(currentReachabilityStatus != .notReachable)
        {
            
            strOTP = edEmail.text!.trimmingCharacters(in: .whitespaces)
            print(strOTP)
            if let text = edEmail.text?.trimmingCharacters(in: .whitespaces), text.isEmpty
            {
                alertUI(title: "OTP empty", Message: "Please enter your OTP")
            }
            // let isEqual = (x == y)
            else if (strOTP != intentOTP)
            {
                alertUI(title: "OTP wrong", Message: "OTP does not match")
                
            }
            else{
                if (strScreenType == "1"){
                    
                    // performSegue(withIdentifier: "reset", sender: nil)
                    showAlertTrack()
                }
                else
                {
                    self.btnVerify.isEnabled = false
                    loginAPICall()
                }
                
            }
        }
        else{
            alertInternet()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if(strScreenType == "1")
        //        {
        //            let secondViewController = segue.destination as! ResetPasswordController
        //            secondViewController.intentName = intentName
        //        }
        //        else{
        //
        //        }
        
    }
    
    
    
    private func showAlertTrack()
    {
        
        let string = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Reset Password", comment: "")
        // lblCurrentLanguage.text = LocalizationSystem.sharedInstance.getLanguage()
        
        let alertController = UIAlertController(title: string, message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancel", comment: ""), style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        let saveAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Reset", comment: ""), style: .default, handler: {
            alert -> Void in
            
            let eventNameTextField = alertController.textFields![0] as UITextField
            eventNameTextField.autocapitalizationType = .allCharacters
            
            print("firstName \(String(describing: eventNameTextField.text))")
            
            let strName = eventNameTextField.text?.trimmingCharacters(in: .whitespaces)
            if  ((strName) != "") {
                var str = eventNameTextField.text!.trimmingCharacters(in: .whitespaces)
                print(str)
                str =  String(str.filter { !" \n\t\r".contains($0) })
                if (strName!.count < 7)
                {
                   // self.present(alertController, animated: true, completion: nil)
                    self.alertFailure(title: "Password length", Message: "Please enter your password upto 7 characters")
                }
                else {
                if(self.currentReachabilityStatus != .notReachable)
                {
                    self.resetPasswordCall(strPassword : str)
                    
                    // loginAPICall(email : strEmail, password : strPassword)
                }
                else{
                    self.alertInternet()
                }
                
                }
            }
            
           
            
        })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter password", comment: "")
            textField.isSecureTextEntry = true
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        // saveAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        // cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        self.present(alertController, animated: true, completion: nil)
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
    
    func alertUISuccess(title: String,Message : String) -> Void {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            print("default")
                                            _ = self.navigationController?.popViewController(animated: true)
                                        case .cancel:
                                            print("cancel")
                                            
                                        case .destructive:
                                            print("destructive")
                                            
                                        @unknown default:
                                            break;
                                        }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginAPICall()
    {
        btnVerify.isEnabled = false
      
        let parameters = ["accesstoken" : Constant.APITOKEN,"email": strEmail , "password":strPassword, "device_token" : strDeviceToken , "device_type" : "0", "contact" : strDailCode +  strPhone, "countryCode" : strDailCode , "name" : intentName]
        //        let parameters = ["category": "Movies", "genre": "Action"]
        
        print("parameters",parameters)
        
        APIsManager.shared.requestService(withURL: Constant.signupAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            if("\(json["code"])" == "200")
            {
                UserDefaults.standard.set(self.strEmail, forKey: Constant.EMAIL)
                UserDefaults.standard.set(self.intentName, forKey: Constant.NAME)
                UserDefaults.standard.set("",forKey: Constant.PROFILE_PICTURE)

                UserDefaults.standard.set("1", forKey: Constant.IS_LOGGEDIN)
                UserDefaults.standard.set("0", forKey: Constant.SELECTION_MODE)
                UserDefaults.standard.set(self.strDailCode +  self.strPhone, forKey: Constant.CONTACT_NO)
                UserDefaults.standard.set("\(json["data"]["id"])", forKey: Constant.USER_UNIQUE_ID)

                self.performSegue(withIdentifier: "select", sender: nil)
                
            }
            else
            {
                self.btnVerify.isEnabled = true
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
           
            
        }
    }
    
    func otpCall()
    {
        
        let parameters = ["accesstoken" : Constant.APITOKEN,"contact": strPhone]
        
        APIsManager.shared.requestService(withURL: Constant.otpSendApi, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            if("\(json["code"])" == "201")
            {
                self.btnResend.isEnabled = true
                self.intentOTP = "\(json["data"]["otp"])"
                print(self.strOTP)
                
            }
            else
            {
                self.btnResend.isEnabled = true
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
                
            }

            
        }
        
    }
    
    func resetPasswordCall(strPassword : String)
    {
        let parameters = ["accesstoken" : Constant.APITOKEN,"contact": intentName, "password" : strPassword]
        print(parameters)
        APIsManager.shared.requestService(withURL: Constant.forgotPasswordAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            if("\(json["code"])" == "200")
            {
                self.alertRootRedirection(title: "Password reset", Message: "Password reset successfully, now you may login to access your account")
               
            }
            else
            {
                
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//    func otpCall()
//    {
//        btnResend.isEnabled = false
//        let parameters = ["email": intentName]
//        indicator.isHidden = false
//        indicator.startAnimating()
//        print("parameters",parameters)
//        AF.request(Constant.baseURL + Constant.signupOTPApit, method: .post, parameters: parameters).validate().responseJSON { (response) in
//            debugPrint(response)
//            switch response.result {
//            case .success:
//                print("Validation Successful)")
//                self.indicator.isHidden = true
//                if let json = response.data {
//                    do{
//                        let data = try JSON(data: json)
//                        let status = data["code"]
//                        print("DATA PARSED email: \(status)")
//
//                        let arrdata =  try JSONDecoder().decode(OtpSignUpResponse.self, from: response.data!)
//                        let code = arrdata.code
//                        if(code != "200")
//                        {
//                            self.btnResend.isEnabled = true
//                            self.indicator.isHidden = true
//                            let message = data["message"]
//                            self.alertUI(title: "Invalid", Message: "\(message)")
//                        }
//                        else
//                        {
//                            self.btnResend.isEnabled = true
//                            self.indicator.isHidden = true
//                            let message = data["otp"]
//                            self.intentOTP = "\(message)"
//                        }
//                    }
//                    catch{
//                        print("JSON Error")
//                        print(error)
//                    }
//
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }





