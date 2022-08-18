//
//  LoginController.swift
//  Xeat
//
//  Created by apple on 16/12/21.
//

import UIKit
import CountryPickerView
import libPhoneNumber_iOS
import Alamofire
import SwiftyJSON
import FirebaseMessaging

class LoginController: UIViewController, CountryPickerViewDelegate, CountryPickerViewDataSource, UITextFieldDelegate{

    var strCountryCode = "+44"
    var strDailCode = "+44"
    var strDeviceToken = ""
    @IBOutlet weak var edPhone: UITextField!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
 
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var edPassword: UITextField!
    @IBOutlet weak var txtSignup: UILabel!
   
    @IBAction func btnForgot(_ sender: Any) {
        performSegue(withIdentifier: "forgot", sender: nil)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: nil)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
//        languageButtonAction()
       loginValue()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    

    func initView()
    {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        setupToHideKeyboardOnTapOnView()
        UITextField.appearance().tintColor = .black
        indicator.isHidden = true
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.color = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        self.edPhone.tag = 0
        self.edPassword.tag = 1
        
        self.edPhone.delegate = self
        self.edPassword.delegate = self
        
        countryPicker.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.showCountryNameInView = false
        countryPicker.showCountryCodeInView = false
        strCountryCode = "GB"
        countryPicker.setCountryByCode("GB")
        
        btnLogin.layer.cornerRadius=10
        btnLogin.clipsToBounds=true
        btnLogin.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        viewPhoneNumber.layer.borderWidth = 0.2
        viewPhoneNumber.layer.masksToBounds = false
        viewPhoneNumber.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
       // viewPhoneNumber.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewPhoneNumber.layer.cornerRadius = 5
        
        //let stringPhone = LocalizationSystem.sharedInstance.localizedStringForKey(key: , comment: "")
        
        edPhone.attributedPlaceholder = NSAttributedString(string: "xxxxxxxxxx",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
       

        edPassword.attributedPlaceholder = NSAttributedString(string: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password", comment: ""),
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
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
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(countryPickerView.selectedCountry)
        
        strCountryCode =   countryPickerView.selectedCountry.code
        strDailCode = countryPickerView.selectedCountry.phoneCode
    }
    
    
      func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
          if countryPickerView.tag == countryPicker.tag {
              switch 1 {
              case 1: return .hidden
              default: return .hidden
              }
          }
          return .tableViewHeader
      }
    func loginValue()
    {
        if(currentReachabilityStatus != .notReachable)
        {
        var validNumber : Bool = false
        let strPhoneNumber = edPhone.text?.trimmingCharacters(in: .whitespaces)
        
        guard let phoneUtil = NBPhoneNumberUtil.sharedInstance() else {
            return
        }
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(strPhoneNumber, defaultRegion: strCountryCode)
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
            
            NSLog("[%@]", formattedString)
            validNumber =  phoneUtil.isValidNumber(phoneNumber)
            print(validNumber)
        }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        if let text2 = edPhone.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
            alertFailure(title: "Mobile Number empty", Message: "Please enter your mobile number")
        }
       else if(!validNumber)
        {
        alertFailure(title: "Mobile Number invalid", Message: "Please enter valid mobile number")
        }
        else if let text2 = edPassword.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
            alertFailure(title: "Password empty", Message: "Please enter your password")
        }
        else if let text2 = edPassword.text, text2.count<7 {
            alertFailure(title: "Password length", Message: "Please enter your password upto 7 characters")
        }
        else{
            
            let strPassword = edPassword.text!.trimmingCharacters(in: .whitespaces)
            let strPhoneNumber = edPhone.text?.trimmingCharacters(in: .whitespaces)
            print(strPassword + "    " + strPhoneNumber!)
            btnLogin.isEnabled = false
           
                loginAPICALL(email: strDailCode + strPhoneNumber!, password: strPassword)
            }
        }
            else{
               alertInternet()
            }
           // loginAPICall(email: strPhoneNumber!, password: strPassword)
        }
    
//    func languageButtonAction() {
//        // This is done so that network calls now have the Accept-Language as "hi" (Using Alamofire) Check if you can remove these
//        UserDefaults.standard.set(["fr"], forKey: "AppleLanguages")
//        UserDefaults.standard.synchronize()
//
//        // Update the language by swaping bundle
//        Bundle.setLanguage("fr")
//
//        // Done to reintantiate the storyboards instantly
////        let storyboard = UIStoryboard.init(name: "login", bundle: nil)
////     UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = storyboard.instantiateInitialViewController()
////        let next = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginController
////        self.present(next, animated: true, completion: nil)
//    }
    
    func loginAPICALL(email :String, password : String)
    {
        
        let param =
            ["accesstoken" : Constant.APITOKEN,"contact": email , "password":password, "device_token" : strDeviceToken , "device_type" : "0"]
        print(param)
        APIsManager.shared.requestService(withURL: Constant.loginAPI, method: .post, param: param, viewController: self) { (json) in
         print(json)
             
            if("\(json["code"])" == "201")
            {
                self.btnLogin.isEnabled = true
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
            else
            {
                
                UserDefaults.standard.set("\(json["data"]["email"])", forKey: Constant.EMAIL)
                UserDefaults.standard.set("\(json["data"]["name"])", forKey: Constant.NAME)
                UserDefaults.standard.set("\(json["data"]["image"])",forKey: Constant.PROFILE_PICTURE)

                UserDefaults.standard.set("1", forKey: Constant.IS_LOGGEDIN)
                UserDefaults.standard.set("0", forKey: Constant.SELECTION_MODE)

                UserDefaults.standard.set(email, forKey: Constant.CONTACT_NO)
                UserDefaults.standard.set("\(json["data"]["id"])", forKey: Constant.USER_UNIQUE_ID)
            self.getPrimaryAddress(strUserId: "\(json["data"]["id"])")
               
            }
           
        }
    }
    
    func ongoingOrderAPI()
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.ongoingOrderAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "201")
            {
                UserDefaults.standard.set("0", forKey: Constant.ONGOING_ORDERAPIHIT)
            }
            else
            {
                UserDefaults.standard.set("1", forKey: Constant.ONGOING_ORDERAPIHIT)
                
                //  if("\(json["data"]["oid"])")
                
            }
            
        }
    }
    
    func getPrimaryAddress(strUserId : String)
    {
        let param = ["accesstoken" : Constant.APITOKEN,"user_id" : strUserId]
        print(param)
        APIsManager.shared.requestService(withURL: Constant.getPrimaryAddressAPI, method: .post, param: param, viewController: self) { (jsonAddress) in
         print(jsonAddress)
             
            if("\(jsonAddress["code"])" == "201")
            {
                UserDefaults.standard.set(nil, forKey: Constant.USERADDRESS)
                UserDefaults.standard.set(nil, forKey: Constant.USERLATITUDE)
                UserDefaults.standard.set(nil, forKey: Constant.USERADDRESSID)
                UserDefaults.standard.set(nil, forKey: Constant.USERLONGITUDE)
            
                self.performSegue(withIdentifier: "select", sender: nil)
            }
            else
            {
                UserDefaults.standard.set("\(jsonAddress["data"]["name"])" + ", " + "\(jsonAddress["data"]["address"])"
                                       , forKey: Constant.USERADDRESS)
                UserDefaults.standard.set("\(jsonAddress["data"]["a_lat"])", forKey: Constant.USERLATITUDE)
                UserDefaults.standard.set("\(jsonAddress["data"]["id"])", forKey: Constant.USERADDRESSID)
                UserDefaults.standard.set("\(jsonAddress["data"]["a_long"])", forKey: Constant.USERLONGITUDE)
            
                self.performSegue(withIdentifier: "select", sender: nil)
            }
           
        }
    }
   
}
