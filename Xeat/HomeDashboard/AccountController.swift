//
//  AccountController.swift
//  Xeat
//
//  Created by apple on 24/12/21.
//

import UIKit
import SafariServices
import SystemConfiguration
import Alamofire
import AlamofireImage
import SwiftyJSON

class AccountController: UIViewController , SFSafariViewControllerDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var vLogout: UIView!
    @IBOutlet weak var vChangePassword: UIView!
   
    @IBOutlet weak var vShare: UIView!
    
    @IBOutlet weak var vProfile: UIView!
    @IBOutlet weak var vYourOrder: UIView!
    @IBOutlet weak var vTrackOrder: UIView!
    
    @IBOutlet weak var vWallet: UIView!
    @IBOutlet weak var vSuppourt: UIView!
    
    @IBOutlet weak var vlanguage: UIView!
    
    @IBOutlet weak var vManageAddress: UIView!
   
    
    @IBOutlet weak var txtEmailAddress: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .darkContent
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        txtEmailAddress.text =  UserDefaults.standard.string(forKey: Constant.EMAIL)
        txtName.text = UserDefaults.standard.string(forKey: Constant.NAME)
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = #colorLiteral(red: 0.1764705882, green: 0.3294117647, blue: 0.5607843137, alpha: 1)
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
        let strImageURL = UserDefaults.standard.string(forKey: Constant.PROFILE_PICTURE)!
        print(strImageURL)
        if(strImageURL.count>2){
            let urlYourURL = URL (string:strImageURL )
            imgProfile.loadurl(url: urlYourURL!)
            //            DLImageLoader.shared.image(from: urlYourURL, into: imgProfile)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
       // self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        indicator.isHidden = true
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        
        vChangePassword.isUserInteractionEnabled = true
        vChangePassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
        
        
        vLogout.isUserInteractionEnabled = true
        vLogout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.logoutCall)))
        
//        vTrackOrder.isUserInteractionEnabled = true
//        vTrackOrder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.trackOrderCall)))
        
        vWallet.isUserInteractionEnabled = true
        vWallet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.walletCall)))
        
        vSuppourt.isUserInteractionEnabled = true
        vSuppourt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.supportCall)))
        
        vProfile.isUserInteractionEnabled = true
        vProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileCall)))
        
//        vManageAddress.isUserInteractionEnabled = true
//        vManageAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.preOderCall)))
        
        vlanguage.isUserInteractionEnabled = true
        vlanguage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.BookOderCall)))
        
        vYourOrder.isUserInteractionEnabled = true
        vYourOrder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.yourOderCall)))
        
        vShare.isUserInteractionEnabled = true
        vShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.share)))
        // Do any additional setup after loading the view.
    }
    @objc func imageTap() {
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
        {
            alertUIGuestUser()
        }
        else{
            performSegue(withIdentifier: "password", sender: nil)
        }
    
    }
    @objc func share() {
        if let name = URL(string: "https://apps.apple.com/in/app/xeat/id1610674856"), !name.absoluteString.isEmpty {
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.present(activityVC, animated: true, completion: nil)
        } else {
          // show alert for not available
        }
    }
    
    @objc func logoutCall() {
        alertUILogged()
    }
    
   
    
    
    @objc func walletCall() {
        
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
        {
            alertUIGuestUser()
        }
        else{
       performSegue(withIdentifier: "wallet", sender: nil)
        }
    }
    
    @objc func yourOderCall() {
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
        {
            alertUIGuestUser()
        }
        else{
            performSegue(withIdentifier: "orderhistory", sender: nil)
        }
      
    }
   
    @objc func preOderCall() {
        if(UserDefaults.standard.string(forKey: Constant.API_TOKEN) == "0")
        {
            alertUIGuestUser()
        }
        else{
           // performSegue(withIdentifier: "preorder", sender: nil)

        }
    }
    
    @objc func BookOderCall() {
        if(UserDefaults.standard.string(forKey: Constant.API_TOKEN) == "0")
        {
            alertUIGuestUser()
        }
        else{
           performSegue(withIdentifier: "promotion", sender: nil)
        }
     
    }
    
    @objc func supportCall() {
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
        {
            alertUIGuestUser()
        }
        else{
            performSegue(withIdentifier: "support", sender: nil)
        }
     
    }
    
    @objc func profileCall() {
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
        {
            alertUIGuestUser()
        }
        else{
            performSegue(withIdentifier: "update", sender: nil)
        }
      
    }
    
    
    //*******************************************Logout****************************************************//
    
    func alertUILogged() -> Void
    {
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout from the app? ", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
           self.logoutApi()
            UserDefaults.standard.set("0", forKey: Constant.IS_LOGGEDIN)
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            self.navigationController?.popToRootViewController(animated: true)
            
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func logoutApi()
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["accesstoken" : Constant.APITOKEN, "userid" : strUserId]

        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.logoutApi, method: .post, param: parameters, viewController: self) { (json) in
            print(json)

        }
    }
    
    
//
//    func logoutApi()
//    {
//        let strApiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)!
//        let headers: HTTPHeaders = [
//
//            "Authorization" : strApiToken,
//            "Accept" : "application/json"
//        ]
//        indicator.isHidden = false
//        indicator.startAnimating()
//
//
//        AF.request(Constant.baseURL + Constant.logoutApi, method: .get,headers: headers).validate().responseJSON { (response) in
//            debugPrint(response)
//            switch response.result {
//            case .success:
//                print("Validation Successful)")
//                self.indicator.isHidden = true
//                if let json = response.data {
//                    do{
//                        let data = try JSON(data: json)
//
//                        let status = data["code"]
//                        print("DATA PARSED email: \(status)")
//
//                        if("\(status)" != "200")
//                        {
//
//                            let message = data["message"]
//                            self.alertFailure(title: "Invalid", Message: "\(message)")
//                        }
//                        else
//                        {
//                            UserDefaults.standard.set("0", forKey: Constant.IS_LOGGEDIN)
//                        }
//                    }
//                    catch{
//
//                        self.indicator.isHidden = true
//                        print("JSON Error")
//                    }
//
//                }
//            case .failure(let error):
//                print(error)
//
//                self.indicator.isHidden = true
//            }
//        }
//    }
//
    //*******************************************Show alert track*****************************************//
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
   
 
    
}
