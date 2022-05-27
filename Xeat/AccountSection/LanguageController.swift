//
//  LanguageController.swift
//  Xeat
//
//  Created by apple on 11/02/22.
//

import UIKit

class LanguageController: UIViewController {
    
    @IBOutlet weak var vPrivacy: UIView!
    @IBOutlet weak var vFaq: UIView!
    @IBOutlet weak var vOrderHelp: UIView!
    @IBOutlet weak var vHelp: UIView!
    @IBOutlet weak var imgBack: UIButton!
    
    
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        languageButtonAction()
        // Do any additional setup after loading the view.
    }
    
    func languageButtonAction() {
        // This is done so that network calls now have the Accept-Language as "hi" (Using Alamofire) Check if you can remove these
        UserDefaults.standard.set(["fr"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        // Update the language by swaping bundle
        Bundle.setLanguage("fr")

        // Done to reintantiate the storyboards instantly
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
