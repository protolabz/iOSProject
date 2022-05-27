//
//  WalletController.swift
//  Xeat
//
//  Created by apple on 03/01/22.
//

import UIKit

class WalletController: UIViewController {
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
   
    var btnTapped = 0
    var strBalance = ""
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var txtBalance: UILabel!
    
    @IBOutlet weak var txtBalanceLine: UILabel!
    
    @IBOutlet weak var btnTransactions: UIButton!
   
  
    @IBAction func btnTransactionACtion(_ sender: Any) {
        btnTapped  = 1
        if(currentReachabilityStatus != .notReachable)
        {
            performSegue(withIdentifier: "transaction", sender: nil)
        }
        else{
            alertInternet()
        }
       
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        intilizeView()
        
       
        if(currentReachabilityStatus != .notReachable)
        {
            walletBalanceAPI()
        }
        else{
           alertInternet()
        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
//
    func intilizeView()
    {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        indicator.isHidden = true
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
      
        btnTransactions.layer.cornerRadius=20
        btnTransactions.clipsToBounds=true
        btnTransactions.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(btnTapped == 1)
        {
        let secondViewController = segue.destination as! TransactionController
        strBalance = txtBalance.text ?? ""
        secondViewController.balance = strBalance
          btnTapped = 0
        }
           
    }
    
//    let myURL = URL(string : paymentUrl)
//    let myRequest = URLRequest(url: myURL!)
//    webVie.load(myRequest)
//    self.indicator.isHidden = true
    
    // func webView(_ webView: WKWebView,
//    didFinish navigation: WKNavigation!){
//    self.indicator.isHidden = true
//    print("loaded")
//    }
    
    
   
    //*********************************GET Wallet balance ***************************//
    
    func walletBalanceAPI()
    {
        
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.walletAPI, method: .post, param: parameters, viewController: self) { (json) in
         print(json)
            
            
            if("\(json["status"])" == "0")
            {
              //  self.alertFailure(title: "Invalid", Message: "\(json["message"])")
                self.txtBalance.text = "0 Penny"
      //
                      self.txtBalanceLine.text = "Your total penny balance is 0 penny"
            }
            else
            {
              
//                let newPrice = Double("\(json["amount"])")!
          self.txtBalance.text = "\(json["data"]["total_rewards"]) Penny"
//
                self.txtBalanceLine.text = "Your total penny balance is " +  "\(json["data"]["total_rewards"]) penny"
           
            }
           
        }
    }
 
    
 
    func alertUIWallet(title: String,Message : String) -> Void {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            print("default")
                                            if(self.currentReachabilityStatus != .notReachable)
                                            {
                                                self.walletBalanceAPI()
                                            }
                                            else{
                                                self.alertUIWallet (title: "No Internet Connection", Message: "It seems your internet connection lost. Please reconnect it and try again")
                                            }
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
