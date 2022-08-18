//
//  SavedcardListControllerViewController.swift
//  Xeat
//
//  Created by apple on 21/04/22.
//

import UIKit
import SquareInAppPaymentsSDK
import SwiftyJSON


class SavedcardListControllerViewController: UIViewController,  UITableViewDelegate,UITableViewDataSource {
var strDeliveryType = ""
    var strOrderId = ""
    var flagScreen = 0
    var strCartId = ""
   // var strAmount = ""

    var arrOfTrans : [JSON] = []
    @IBAction func imgBack(_ sender: Any) {
       
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddNewCard(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        didRequestPayWithCard()
        }
        else{
            alertInternet()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SavedCardCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SavedCardCell")
       
       tableView.delegate = self
       tableView.dataSource = self
       self.tableView.separatorStyle = .none
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
    }
    override func viewWillAppear(_ animated: Bool) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        savedCardAPI()
        }
        else{
            alertInternet()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return arrOfTrans.count
       
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell2 = tableView.dequeueReusableCell(withIdentifier: "SavedCardCell", for: indexPath) as! SavedCardCell
        cell2.selectionStyle = .none
        cell2.txtCardName.text = "\(self.arrOfTrans[indexPath.row]["card_brand"])"
        cell2.txtCardNumber.text =  "xxxxxxxxxxxx" + "\(self.arrOfTrans[indexPath.row]["last_4"])"

        cell2.txtExpiry.text = "\(self.arrOfTrans[indexPath.row]["exp_month"])" + "/" + "\(self.arrOfTrans[indexPath.row]["exp_year"])"

//
//      print("\(self.arrOfTrans[indexPath.row])")
//        cell2.txtIssue.text = "\(self.arrOfTrans[indexPath.row]["issu_type"])"

        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        tableView.isUserInteractionEnabled = false
        if(self.currentReachabilityStatus != .notReachable)
        {
        chargeCard(strCardId: "\(self.arrOfTrans[indexPath.row]["id"])")
        }
        else{
            alertInternet()
        }
//        selectedIssueId = "\(arrOfTrans[indexPath.row]["issu_type"])"
//       if(apiHit == 0)
//       {
//        apiHit = 1
//        orderSubmitIssueAPI()
//       }
        
    }
    func didRequestPayWithCard() {
        dismiss(animated: true) {
            let vc = self.makeCardEntryViewController()
            vc.delegate = self
            
            let nc = UINavigationController(rootViewController: vc)
            self.present(nc, animated: true, completion: nil)
        }
    }
    
    func savedCardAPI()
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["accesstoken" : Constant.APITOKEN, "user_id" : strUserId]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.cardListingAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "201")
            {
              //  self.alertSucces(title: "Wait", Message: "\(json["message"])")
                self.alertNoCard()
            }
            else
            {
                self.arrOfTrans.removeAll()
                for i in 0..<json["data"].count
                {
                    self.arrOfTrans.append(json["data"][i])
                }
               
                self.tableView.reloadData()
                //self.setDataViews(jsonData : json)
            }
            
        }
    }
    
    func updateChargeAPI(_ nonce: String, completion: @escaping (String?, String?) -> Void) {
       // self.viewpayment.isHidden = true
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN,"card_nonce": nonce]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.createCardAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "200")
            {
               // self.alertFailure(title: "Card saved", Message: "\(json["data"]["message"])")
                completion("success", nil)
                self.dismiss(animated: true)
                self.savedCardAPI()
            }
            else
            {
                completion("success", nil)
                self.dismiss(animated: true)
                self.alertFailure(title: "Oh wait", Message: "\(json["data"]["code"])")
                // self.setDataViews(jsonData: json)
            }
            
        }
    }
    
    func chargeCard(strCardId : String) {
       // self.viewpayment.isHidden = true
       // let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["id": strCardId, "accesstoken" : Constant.APITOKEN,"cart_id": strCartId]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.cardPayment, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "1")
            {
               // self.alertFailure(title: "Card saved", Message: "\(json["data"]["message"])")
              //  completion("success", nil)
                self.dismiss(animated: true)
                if(self.currentReachabilityStatus != .notReachable)
                {
                self.placeOrderAPI()
                }
                else{
                    self.alertInternet()
                }
            }
            else
            {
                self.tableView.isUserInteractionEnabled = true
//                completion("success", nil)
                self.dismiss(animated: true)
                self.alertFailure(title: "Oh wait", Message: "\(json["data"][0]["code"])")
                // self.setDataViews(jsonData: json)
            }
            
        }
    }
    func placeOrderAPI()
    {
       
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let strLat = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
        let strLong = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
        let strAddressId = UserDefaults.standard.string(forKey: Constant.USERADDRESSID)!
        var param : [ String : String ] = [:]
        if(strDeliveryType == "1")
        {
            param = ["user_id": "\(strUserId)", "accesstoken" : Constant.APITOKEN, "address_id" : "\(strAddressId)",
                     "lat" : "\(strLat)", "long" : "\(strLong)" ,"cart_id" : "\(strCartId)" ]
            print(param)
        }
        else{
            param = ["user_id": "\(strUserId)", "accesstoken" : Constant.APITOKEN , "cart_id" : "\(strCartId)"]
            print(param)
        }
        
        APIsManager.shared.requestService(withURL: Constant.placeOrderAPI, method: .post, param: param, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "200")
            {
                
                UserDefaults.standard.set("1", forKey: Constant.ONGOING_ORDERAPIHIT)
                self.dismiss(animated: true)
               
                self.alertOrderPlaced2(str : "\(json["data"])")

                
            }
            else
            {
                self.dismiss(animated: true)
                self.alertFailure(title: "Order failed", Message: "\(json["message"])")
              //  self.btnPlaceOrder.isEnabled = true
            }
            
        }
    }
    
    func alertNoCard() -> Void {
        let alert = UIAlertController(title: "No card saved yet", message: "There is no card saved in your card list save a new card", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(cancelAction)
        alert.addAction(UIAlertAction(title: "Add card", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            self.didRequestPayWithCard()
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
    func alertOrderPlaced2(str : String) -> Void
    {
        let refreshAlert = UIAlertController(title: "Order Placed", message: "Order has been placed successfully. \n Your order id is \(str)", preferredStyle: UIAlertController.Style.alert)
       
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //            self.logoutApi()
            self.flagScreen = 2
            self.strOrderId = str
          //  _ = self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "order", sender: "")
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if(flagScreen == 2)
         {
          let secondViewController = segue.destination as! OrderStatusController
            secondViewController.backScreen = "1"
          secondViewController.strOrderId = strOrderId
         }
         else
         {
//             let secondViewController = segue.destination as! RestaurantController
//             secondViewController.strRestId = strRestId
         }
         
     }
}

extension SavedcardListControllerViewController: UINavigationControllerDelegate {
    func navigationControllerSupportedInterfaceOrientations(
        _: UINavigationController
    ) -> UIInterfaceOrientationMask {
        return .portrait
    }

}
extension SavedcardListControllerViewController {
    func makeCardEntryViewController() -> SQIPCardEntryViewController {
        let theme = SQIPTheme()
        theme.tintColor = .red
        theme.saveButtonTitle = "Save card"
        let cardEntry = SQIPCardEntryViewController(theme: theme)
        cardEntry.collectPostalCode = false
        cardEntry.delegate = self
        
        return cardEntry
    }
}

//Handle the card entry success or failure from the card entry form
extension SavedcardListControllerViewController:SQIPCardEntryViewControllerDelegate {
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
        // Note: If you pushed the card entry form onto an existing navigation controller,
        // use UINavigationController.popViewController(animated:) instead
        dismiss(animated: true) {
            print(status)
            switch status {
            case .canceled:
//                self.btnPlaceOrder.isEnabled = true
//                self.strPaymentType = 0
//
//                self.btnCard.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
//                self.btnCash.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
                self.dismiss(animated: true, completion: nil)
                break
            case .success:
                print("success")
            //                guard self.serverHostSet else {
            //                    self.showCurlInformation()
            //                    return
            //                }
            //
            //                self.didChargeSuccessfully()
            }
        }
    }
    
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didObtain cardDetails: SQIPCardDetails, completionHandler: @escaping (Error?) -> Void) {
        
        print(cardDetails.nonce)
        // completionHandler(nil)
        
        updateChargeAPI(cardDetails.nonce){ (transactionID, errorDescription) in
            guard let errorDescription = errorDescription else {
                //                // No error occured, we successfully charged

                //  self.navigationController!.popViewController(animated:true)
                return
            }
            return
        }
    }
}
