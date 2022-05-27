//
//  SelectionController.swift
//  Xeat
//
//  Created by apple on 16/12/21.
//

import UIKit

class SelectionController: UIViewController {

    @IBOutlet weak var viewManin: UIView!
   
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var btnGuestUser: UIButton!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    
    @IBAction func btnGuestUser(_ sender: Any) {
        UserDefaults.standard.set("guestuser@gmail.com", forKey: Constant.EMAIL)
        UserDefaults.standard.set("Guest User", forKey: Constant.NAME)
        UserDefaults.standard.set("",forKey: Constant.PROFILE_PICTURE)

        UserDefaults.standard.set("1", forKey: Constant.IS_LOGGEDIN)
        UserDefaults.standard.set("+0000000000", forKey: Constant.CONTACT_NO)
        UserDefaults.standard.set("2", forKey: Constant.USER_UNIQUE_ID)
        
            UserDefaults.standard.set(nil, forKey: Constant.USERADDRESS)
            UserDefaults.standard.set(nil, forKey: Constant.USERLATITUDE)
            UserDefaults.standard.set(nil, forKey: Constant.USERADDRESSID)
            UserDefaults.standard.set(nil, forKey: Constant.USERLONGITUDE)
        
        performSegue(withIdentifier: "select", sender: nil)
    }
    
   
    @IBAction func btnLogin(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    
    @IBAction func btnSignUp(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       initView()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
    }
    func initView()
    {
        
        btnLogin.layer.cornerRadius=20
        btnLogin.clipsToBounds=true
        btnLogin.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        btnLogin.layer.borderWidth = 0.5
        btnLogin.layer.borderColor = #colorLiteral(red: 0.8666666667, green: 0.1176470588, blue: 0.06666666667, alpha: 1)
        
        btnSignUp.layer.borderWidth = 0.5
        btnSignUp.layer.borderColor = #colorLiteral(red: 0.8666666667, green: 0.1176470588, blue: 0.06666666667, alpha: 1)
        btnSignUp.layer.cornerRadius=20
        btnSignUp.clipsToBounds=true
        btnSignUp.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        
        
        btnGuestUser.layer.cornerRadius=20
        btnGuestUser.clipsToBounds=true
        
        btnGuestUser.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(UserDefaults.standard.string(forKey: Constant.IS_LOGGEDIN) == "1")
        {
        performSegue(withIdentifier: "home", sender: nil)
        }
        else{
//           viewLoginSignUp.isHidden = false
    //                 performSegue(withIdentifier: "login", sender: nil)
        }
        
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
   

    
}
