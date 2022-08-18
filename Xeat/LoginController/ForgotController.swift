//
//  ForgotController.swift
//  CoPilot
//
//  Created by apple on 14/05/21.
//

import UIKit

import SwiftyJSON
import CountryPickerView
import CountryPickerView
import libPhoneNumber_iOS

class ForgotController: UIViewController, UITextFieldDelegate, CountryPickerViewDelegate,  CountryPickerViewDataSource{
    
    var strCountryCode = "+44"
    var strDailCode = "+44"
    var strEmail = ""
    var strOTP = ""
    var strPhone  = ""
    var pickerShow = 0
    @IBAction func btnLogin(_ sender: Any) {
       
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var edEmail: UITextField!
    @IBAction func btnNextAction(_ sender: Any) {
        forgotValue()
       //
    }
    @IBOutlet var btnNext: UIButton!
    override func viewDidLoad() {
       
        super.viewDidLoad()
         self.setupToHideKeyboardOnTapOnView()
        self.edEmail.delegate = self
        
        btnNext.layer.cornerRadius=10
        btnNext.clipsToBounds=true
        btnNext.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
//        self.navigationController?.navigationBar.barTintColor  = UIColor.white
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;

        
       
        self.edEmail.delegate = self
        
        countryPicker.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
 
        countryPicker.showCountryNameInView = false
        countryPicker.showCountryCodeInView = false
        strCountryCode = "GB"
        countryPicker.setCountryByCode("GB")
        
       
        
        edEmail.attributedPlaceholder = NSAttributedString(string: "xxxxxxxxxx",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        
    }
   
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(countryPickerView.selectedCountry)
        
        strCountryCode =   countryPickerView.selectedCountry.code
        strDailCode = countryPickerView.selectedCountry.phoneCode
     //   countryPicker.didMoveToSuperview()
    }
  
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        if countryPickerView.tag == countryPicker.tag {
            switch pickerShow {
            case 0: return .hidden
            case 1: return .hidden
            default: return .hidden
            }
        }
        return .tableViewHeader
    }
    


//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    
    func forgotValue()
    {
        if(currentReachabilityStatus != .notReachable)
        {
        var validNumber : Bool = false
        let strPhoneNumber = edEmail.text?.trimmingCharacters(in: .whitespaces)
        
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
        
        if let text2 = edEmail.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
             alertFailure(title: "Mobile Number empty", Message: "Please enter your mobile number")
         }
        else if(!validNumber)
         {
         alertFailure(title: "Mobile Number invalid", Message: "Please enter valid mobile number")
         }
        else{
            strPhone = edEmail.text!.trimmingCharacters(in: .whitespaces)
             strEmail = strDailCode + edEmail.text!.trimmingCharacters(in: .whitespaces)
            btnNext.isEnabled = false
           
                otpCall()
            }
        }
            else{
               alertInternet()
            }
        
    }
   
    func otpCall()
    {
        
        let parameters = ["accesstoken" : Constant.APITOKEN,"contact": strEmail]
        
        APIsManager.shared.requestService(withURL: Constant.forgotPasswordOTP, method: .post, param: parameters, viewController: self) { (json) in
         print(json)
            if("\(json["code"])" == "200")
            {
                self.strOTP = "\(json["data"]["otp"])"
                  print(self.strOTP)
           self.performSegue(withIdentifier: "otp", sender: nil)
            }
            else
            {
               
                self.btnNext.isEnabled = true
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
                
             
            }
            
    }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! OTPController
        secondViewController.strDailCode = strDailCode
        secondViewController.strPhone = strPhone
     secondViewController.intentOTP = strOTP
        secondViewController.strScreenType = "1"
        secondViewController.strPassword = ""

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


