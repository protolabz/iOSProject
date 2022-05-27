//
//  ChangePasswordController.swift
//  Xeat
//
//  Created by apple on 24/12/21.
//

import UIKit

class ChangePasswordController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var edConfirmPassword: UITextField!
    @IBOutlet weak var edNewPassword: UITextField!
    @IBOutlet weak var edOldPassword: UITextField!
    
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBAction func btnResetPassword(_ sender: Any) {
        
        if(currentReachabilityStatus != .notReachable)
        {
            forgotValueReset()
        }
        else{
            alertFailure(title: "No Internet Connection", Message: "It seems your internet connection lost. Please reconnect it and try again")
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        intilaizeViews()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
               let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                   return false
           }
           let substringToReplace = textFieldText[rangeOfTextToReplace]
           let count = textFieldText.count - substringToReplace.count + string.count
           return count <= 30
    }
    
    func intilaizeViews()
    {
        
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        
        indicator.isHidden = true
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        self.setupToHideKeyboardOnTapOnView()
        
        UITextField.appearance().tintColor = .black
        
        self.edOldPassword.delegate = self
        self.edNewPassword.delegate = self
        self.edConfirmPassword.delegate = self
        
        self.edOldPassword.tag = 0
        self.edNewPassword.tag = 1
        self.edConfirmPassword.tag = 2
        
        btnReset.layer.cornerRadius=10
        btnReset.clipsToBounds=true
        btnReset.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        edOldPassword.layer.borderWidth = 0
        edNewPassword.layer.borderWidth = 0
        
        edOldPassword.attributedPlaceholder = NSAttributedString(string: "Old Password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        edNewPassword.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        edConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(systemName: "lock")
        leftImageView.tintColor = UIColor.systemGray2
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView.frame = CGRect(x: 12, y: 12, width: 20, height: 15)
        edOldPassword.leftViewMode = .always
        edOldPassword.leftView = leftView
        
        let leftImageView2 = UIImageView()
        leftImageView2.image = UIImage(systemName: "lock")
        leftImageView2.tintColor = UIColor.systemGray2
        
        let leftView2 = UIView()
        leftView2.addSubview(leftImageView2)
        
        leftView2.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView2.frame = CGRect(x: 12, y: 12, width: 20, height: 17)
        edNewPassword.leftViewMode = .always
        edNewPassword.leftView = leftView2
        
        let leftImageView3 = UIImageView()
        leftImageView3.image = UIImage(systemName: "lock")
        leftImageView3.tintColor = UIColor.systemGray2
        
        let leftView3 = UIView()
        leftView3.addSubview(leftImageView3)
        
        leftView3.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView3.frame = CGRect(x: 12, y: 12, width: 20, height: 17)
        edConfirmPassword.leftViewMode = .always
        edConfirmPassword.leftView = leftView3
        
    }
    
    
    func forgotValueReset()
    {
        if(currentReachabilityStatus != .notReachable)
        {
        let strPassword = edNewPassword.text!
        let  strCPassword = edConfirmPassword.text!
        let strOPassword = edOldPassword.text!

       
        if let text2 = edOldPassword.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
            alertFailure(title: "Old Password empty", Message: "Please enter your password")
        }
        else if let text2 = edOldPassword.text, text2.count<7 {
            alertFailure(title: "Invalid Password", Message: "Please enter your password upto 7 characters")
        }
       else if let text = edNewPassword.text?.trimmingCharacters(in: .whitespaces), text.isEmpty
        {
        alertFailure(title: "New Password empty", Message: "Please enter your password")
        }
        else if edNewPassword.text!.count<7
        {
            alertFailure(title: "Invalid New Password", Message: "Please enter your password up to 7 characters")
            
        }
        else if let text = edConfirmPassword.text?.trimmingCharacters(in: .whitespaces), text.isEmpty
        {
            alertFailure(title: "Confirm Password empty", Message: "Please enter confirm password")
        }
        else if (strPassword != strCPassword)
        {
            alertFailure(title: "Confirm Password mismatch", Message: "Confirm password should be same as new password")
        }
        
        else{
            btnReset.isEnabled = false
            resetAPICall(old: strOPassword, new: strCPassword)
        }
        }
        else
        {
            alertInternet()
        }
    }
    
    func resetAPICall(old : String, new : String)
    {
        
        let strContact = UserDefaults.standard.string(forKey: Constant.CONTACT_NO)!
        let parameters = ["olt_password": old, "new_password": new, "accesstoken" : Constant.APITOKEN, "contact" : strContact]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.chnagePasswordAPI, method: .post, param: parameters, viewController: self) { (json) in
         print(json)
            
            
            if("\(json["code"])" == "200")
            {
                self.btnReset.isEnabled = true
                self.alertSucces(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Success", comment: ""), Message:  "\(json["message"])")
                
            }
            else
            {
               
                self.btnReset.isEnabled = true
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
           
        }
    }
  
    
}
