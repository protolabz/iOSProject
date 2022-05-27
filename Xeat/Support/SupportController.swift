//
//  SupportController.swift
//  Xeat
//
//  Created by apple on 26/12/21.
//

import UIKit
import SafariServices


class SupportController: UIViewController , SFSafariViewControllerDelegate{
    
    @IBOutlet weak var vPrivacy: UIView!
    @IBOutlet weak var vFaq: UIView!
    @IBOutlet weak var vOrderHelp: UIView!
    @IBOutlet weak var vHelp: UIView!
    @IBOutlet weak var imgBack: UIButton!
    
    
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    
    
//        override func viewDidDisappear(_ animated: Bool) {
//            navigationController?.setNavigationBarHidden(true, animated: animated)
//        }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        vFaq.isUserInteractionEnabled = true
        vFaq.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.faqTap)))
        
        
        vPrivacy.isUserInteractionEnabled = true
        vPrivacy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.privacyTap)))
        
        
        vOrderHelp.isUserInteractionEnabled = true
        vOrderHelp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.orderHelpTap)))
        
        
        vHelp.isUserInteractionEnabled = true
        vHelp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.helpTap)))
        //
        //
        //        vOrderHelp.isUserInteractionEnabled = true
        //        vOrderHelp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileCall)))
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @objc func helpTap()
    {
        performSegue(withIdentifier: "help", sender: nil)
    }
    
    @objc func orderHelpTap()
    {
        performSegue(withIdentifier: "orderhelp", sender: nil)
    }
    
    @objc func privacyTap()
    {
        if(currentReachabilityStatus != .notReachable)
        {
            let url = URL(string: Constant.baseURL + "API/Privacy_Policy.php")!
            let controller = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
            controller.delegate = self
        }
        else
        {
            alertInternet()
        }
    }
    
    @objc func faqTap()
    {
        if(currentReachabilityStatus != .notReachable)
        {
            let url = URL(string: Constant.baseURL + "/API/user_faq.php")!
            let controller = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
            controller.delegate = self
        }
        else{
            alertInternet()
        }
    }
}
