//
//  AddHelpController.swift
//  Xeat
//
//  Created by apple on 26/12/21.
//

import UIKit

class AddHelpController: UIViewController {
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        getInputValues()
    }
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var edDesc: UITextView!
    @IBOutlet weak var edTitle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        edDesc.layer.masksToBounds = true
       // edDesc.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        edDesc.contentInset = UIEdgeInsets.zero;
        edDesc.clipsToBounds = true
        edDesc.layer.cornerRadius = 5
        edDesc.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        edDesc.layer.borderWidth = 0.3
        btnSave.layer.cornerRadius = 10
    }
    
    
    func getInputValues()
    {
        
        if(currentReachabilityStatus != .notReachable)
        {
            if let text2 = edTitle.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
                alertFailure(title: "Title empty", Message: "Please enter your request title")
            }
            else if let text = edDesc.text?.trimmingCharacters(in: .whitespaces), text.isEmpty
            {
                alertFailure(title: "Description empty", Message: "Please enter valid request description")
            }
            
            else{
                let title = edTitle.text!.trimmingCharacters(in: .whitespaces)
                let description = edDesc.text.trimmingCharacters(in: .whitespaces)
                btnSave.isEnabled = false
                addHelpAPI(title : title , desc : description )
            }
        }
        else{
            alertInternet()
        }
        
    }
    func addHelpAPI(title : String , desc : String )
    {
        
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "help_title": title, "accesstoken" : Constant.APITOKEN, "comment" : desc ]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.addHelpRequestApi, method: .post, param: parameters, viewController: self) { (json) in
            // print(json)
            
            
            if("\(json["code"])" == "200")
            {
                self.btnSave.isEnabled = true
                self.alertSucces(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Success", comment: ""), Message:  "\(json["message"])")
                
            }
            else
            {
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
            
        }
    }
    
    
}
