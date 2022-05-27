//
//  SignupController.swift
//  Xeat
//
//  Created by apple on 16/12/21.
//

import UIKit
import SafariServices
import CountryPickerView
import libPhoneNumber_iOS
import Alamofire
import SwiftyJSON

class SignupController: UIViewController , SFSafariViewControllerDelegate,  CountryPickerViewDelegate, CountryPickerViewDataSource,UITextFieldDelegate{
    var termsAccepted = 0
    var strCountryCode = "+44"
    var strDailCode = "+44"
    var strPassword = ""
    var strOTP = ""
    var strPhone = ""
    var strName = ""
    var otpScreen = 0
    var strEmail = ""
    
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var edEmail: UITextField!
    
    @IBOutlet weak var edUserName: UITextField!
    
    @IBOutlet weak var edPhone: UITextField!
    @IBOutlet weak var edPassword: UITextField!
    
   
    
    @IBOutlet weak var txtTermsConditions: UIButton!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBAction func btnLoginAction(_ sender: Any) {
     
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var txtLogin: UILabel!
    
    @IBAction func btnSignUpActions(_ sender: Any) {
        if(currentReachabilityStatus != .notReachable)
        {
          //  languageButtonAction()
     loginValue()
        }
        else{
            alertFailure(title: "No Internet Connection", Message: "It seems your internet connection lost. Please reconnect it and try again")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnSignUp.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
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
    
    @IBAction func btnTerms(_ sender: UIButton) {
        if (sender.isSelected == true)
            {
            termsAccepted = 0
            sender.setBackgroundImage(UIImage(systemName: "stop"), for: UIControl.State.normal)
            sender.isSelected = false;
            }
            else
            {
                termsAccepted = 1
                sender.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: UIControl.State.normal)
                sender.isSelected = true;
            }
    }
    
    @IBAction func btnTermsconditions(_ sender: Any) {
        let url = URL(string: "https://xeat.co.uk/privacy.html")!
               let controller = SFSafariViewController(url: url)
               self.present(controller, animated: true, completion: nil)
               controller.delegate = self
    }
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
   
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
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
        
        
        btnSignUp.setTitle("Sign Up", for: .normal)
        self.edUserName.tag = 0
        self.edEmail.tag = 1
        self.edPhone.tag = 2
        self.edPassword.tag = 3
        
        self.edUserName.delegate = self
        self.edEmail.delegate = self
        self.edPhone.delegate = self
        self.edPassword.delegate = self
        
        countryPicker.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.showCountryNameInView = false
        countryPicker.showCountryCodeInView = false
        strCountryCode = "GB"
        
        countryPicker.setCountryByCode("GB")
        btnSignUp.layer.cornerRadius=10
        btnSignUp.clipsToBounds=true
        btnSignUp.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        viewPhoneNumber.layer.borderWidth = 0.2
        viewPhoneNumber.layer.masksToBounds = false
        viewPhoneNumber.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
       // viewPhoneNumber.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewPhoneNumber.layer.cornerRadius = 5
        
        txtLogin.isUserInteractionEnabled = true
        txtLogin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
    
        edPhone.attributedPlaceholder = NSAttributedString(string: "xxxxxxxxxx",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
       

        edPassword.attributedPlaceholder = NSAttributedString(string: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password", comment: ""),
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        
        edUserName.attributedPlaceholder = NSAttributedString(string: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Name", comment: ""),
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        
        edEmail.attributedPlaceholder = NSAttributedString(string: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Email", comment: ""),
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        
        
    }
    
    @objc func imageTap() {
        
        _ = navigationController?.popViewController(animated: true)
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
        if let text2 = edUserName.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
            alertFailure(title: "User Name empty", Message: "Please enter your name")
       }
     else if let text = edEmail.text, text.isEmpty
       {
        alertFailure(title: "Email empty", Message: "Please enter your email address")
       }
       else if edEmail.text?.trimmingCharacters(in: .whitespaces).isValidateEmail()==false
       {
        alertFailure(title: "Email wrong", Message: "Please enter valid email address")
           
       }
      else  if let text2 = edPhone.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
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
        else if (termsAccepted == 0)
        {
           alertFailure(title: "Terms & Conditions", Message: "Please accept Terms & Conditions before proceeding")
        }
        else{
            
             strPassword = edPassword.text!.trimmingCharacters(in: .whitespaces)
            strPhone = edPhone.text!.trimmingCharacters(in: .whitespaces)
            strName = edUserName.text!.trimmingCharacters(in: .whitespaces)
            strEmail =   edEmail.text!.trimmingCharacters(in: .whitespaces)
        
            btnSignUp.isEnabled = false
           // print(strPassword + "    " + strPhoneNumber!)
            otpCall()
           //performSegue(withIdentifier: "otp", sender: nil)
        }
           
        }
        else{
           alertInternet()
        }
    }
    
    func languageButtonAction() {
        // This is done so that network calls now have the Accept-Language as "hi" (Using Alamofire) Check if you can remove these
        UserDefaults.standard.set(["ro"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        // Update the language by swaping bundle
        Bundle.setLanguage("ro")

        // Done to reintantiate the storyboards instantly
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(otpScreen == 1)
        {
        let secondViewController = segue.destination as! OTPController
        secondViewController.intentName = strName
            secondViewController.strDailCode = strDailCode

        secondViewController.intentOTP = strOTP
        secondViewController.strScreenType = "2"
        secondViewController.strPassword = strPassword
        secondViewController.strEmail = strEmail
        secondViewController.strPhone = strPhone
        }
        else{
            
        }
    }
    
    func otpCall()
    {
        
        let parameters = ["accesstoken" : Constant.APITOKEN,"contact": strDailCode + strPhone]
        
        APIsManager.shared.requestService(withURL: Constant.otpSendApi, method: .post, param: parameters, viewController: self) { (json) in
         print(json)
            if("\(json["code"])" == "200")
            {
                self.otpScreen = 1
                self.strOTP = "\(json["data"]["otp"])"
                    print(self.strOTP)
                self.performSegue(withIdentifier: "otp", sender: nil)
                
            }
            else
            {
                self.btnSignUp.isEnabled = true
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
            
           
    }
    }
}
