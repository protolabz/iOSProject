//
//  OrderRatingController.swift
//  Xeat
//
//  Created by apple on 27/01/22.
//

import UIKit
import SwiftyJSON
import Cosmos

class OrderRatingController: UIViewController {

    @IBOutlet weak var btnHeld: UIButton!
    @IBOutlet weak var driverRating: CosmosView!
    
    @IBOutlet weak var restRating: CosmosView!
    @IBAction func btnBack(_ sender: Any) {
        if(screenType == "1"){
        _ = self.navigationController?.popViewController(animated: true)
        }
        else{
            self.navigationController?.popToRootViewController(animated: true)

        }
    }
    @IBOutlet weak var txtRestName: UILabel!
    
    @IBOutlet weak var txtRestLocation: UILabel!
    
    @IBOutlet weak var txtUserLocation: UILabel!
    
    @IBAction func btnHelp(_ sender: Any) {
        performSegue(withIdentifier: "orderhelp", sender: nil)
    }
    
    @IBOutlet weak var txtHeading: UILabel!
    @IBOutlet weak var viewBill: UIView!
    @IBOutlet weak var txtItems: UILabel!
    @IBOutlet weak var txtOrderDate: UILabel!
    
    @IBOutlet weak var txtTotalBill: UILabel!
    @IBOutlet weak var txtVAT: UILabel!
    @IBOutlet weak var txtServiceCharges: UILabel!
    @IBOutlet weak var txtDiscount: UILabel!
    @IBOutlet weak var txtDeliveyCharges: UILabel!
    @IBOutlet weak var txtSubTotal: UILabel!
    
    @IBOutlet weak var txtHowDriver: UILabel!
    @IBAction func btnSubmit2(_ sender: Any) {
        if(strRestStar == "0" && strDriverStar == "0")
        {
          alertFailure(title: "Star unselect", Message: "Please select star for Driver and Restaurant")
        }
        else{
            btnSubmit2.isEnabled = false
            doRatingDetailAPI()
        }
       
    }
    
    @IBOutlet weak var btnSubmit2: UIButton!
    @IBAction func btnSubmit1(_ sender: Any) {
        if(strRestStar == "0")
        {
          alertFailure(title: "Star unselect", Message: "Please select star for Restaurant")
        }
        else{
            btnSubmit1.isEnabled = false
            doRatingDetailAPI()
        }
    }
    @IBOutlet weak var btnSubmit1: UIButton!
    @IBOutlet weak var txtRateDriverName: UILabel!
    @IBOutlet weak var txtRateTestname: UILabel!
    var strOrderId = ""
    var strRestId = ""
    var strDriverStar = "0"
    var strRestStar = "0"
    var strDriverId = ""
    var starSelect = ""
    var driverStar = ""
    var screenType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBill.layer.borderWidth = 0.5
        viewBill.layer.masksToBounds = false
        viewBill.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewBill.layer.cornerRadius = 10
        
        btnSubmit1.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btnSubmit1.layer.cornerRadius = 10
        
        btnHeld.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btnHeld.layer.cornerRadius = 10
       
        btnSubmit2.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btnSubmit2.layer.cornerRadius = 10
        
        btnSubmit1.isHidden = true
        btnSubmit2.isHidden = true
        txtHowDriver.isHidden = true
        txtRateDriverName.isHidden = true
        driverRating.isHidden = true
        
        orderDetailAPI()
        
        restRating.didFinishTouchingCosmos = { rating in
            print(rating)
            self.strRestStar = "\(rating)"
        }
        
        restRating.settings.fillMode = .precise
        restRating.settings.starSize = 40
        restRating.settings.starMargin = 5
        
        
        driverRating.settings.fillMode = .precise
        driverRating.settings.starSize = 40
        driverRating.settings.starMargin = 5
        
        
        driverRating.didFinishTouchingCosmos = { rating in
            print(rating)
            self.strDriverStar = "\(rating)"
        }
        
       if(screenType == "0")
       {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
       }
       else{
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
       }
        
       // orderCancelAPI()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let secondViewController = segue.destination as! HelpIssueListController

        secondViewController.strOrderId = strOrderId
        
    }
    func orderCancelAPI()
    {
        
        
        let parameters = ["accesstoken" : Constant.APITOKEN, "oid" : strOrderId]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.cancelRatingAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "201")
            {
                
            }
            else
            {
                UserDefaults.standard.set("0", forKey: Constant.ONGOING_ORDERAPIHIT)
                self.navigationController?.popToRootViewController(animated: true)

            }
            
        }
    }
    
    
    func orderDetailAPI()
    {
        let parameters = ["accesstoken" : Constant.APITOKEN, "oid" : strOrderId]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.orderRatingDetail, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "201")
            {
            }
            else
            {
                
                self.setDataViews(jsonData : json)
            }
            
        }
    }
    
    func setDataViews(jsonData : JSON)
    {
        
        strRestId = "\(jsonData["data"]["res_id"])"
        
        txtRateTestname.text = "Rate restaurant : " + "\(jsonData["data"]["res_name"])"

        txtHeading.text = "Order id #" + strOrderId
        
        txtRestName.text = "\(jsonData["data"]["res_name"])"
        txtRestLocation.text = "\(jsonData["data"]["res_location"])"
        txtUserLocation.text = "\(jsonData["data"]["userlocation"])"
        
        
        txtServiceCharges.text =  "£" + "\(jsonData["data"]["drop_f"])"
        
        let deliveryCharge = Double("\(jsonData["data"]["delivery_fees"])")
        txtDeliveyCharges.text =  "£" + "\(String(format: "%.2f", deliveryCharge!))"
//
//        let discountPrice = Double("\(jsonData["data"]["discount"])")
//        txtDiscount.text =  "-£" + "\(String(format: "%.2f", discountPrice!))"
        
        if("\(jsonData["data"]["applied_penny"])" != "0")
        {
            let discountPrice = Double("\(jsonData["data"]["applied_penny"])")
            txtDiscount.text =  "-£" + "\(String(format: "%.2f", discountPrice!))"
        }
        else{
            let discountPrice = Double("\(jsonData["data"]["coupon_discount"])")
            txtDiscount.text =  "-£" + "\(String(format: "%.2f", discountPrice!))"
        }
        

        let itemPrice = Double("\(jsonData["data"]["item_total_price"])")
        txtSubTotal.text =  "£" + "\(String(format: "%.2f", itemPrice!))"

        let totalPrice = Double("\(jsonData["data"]["total_amount"])")
        txtTotalBill.text =  "£" + "\(String(format: "%.2f", totalPrice!))"
        txtOrderDate.text = "Order Delivered on : " + ("\(jsonData["data"]["created_at"])")

        var itemData = ""
        for i in 0..<jsonData["data"]["items"].count
        {

            itemData +=  "\(jsonData["data"]["items"][i]["count"])" + " x " +  "\(jsonData["data"]["items"][i]["iname"])" + ","
            if(jsonData["data"]["items"][i]["withitems"].count == 0)
            {
                itemData += "\n"
            }
            for j in 0..<jsonData["data"]["items"][i]["withitems"].count
            {
                itemData += " (" + "Add-ons:" + "\(jsonData["data"]["items"][i]["withitems"][j]["name"])" + ") " + "\n"
            }
            //  print(itemData)
        }
        let itemData2 = itemData.trimmingCharacters(in: .whitespaces).dropLast(2)
        
        txtItems.text = "\(itemData2)"
        
        
        if("\(jsonData["data"]["order_type"])" == "1")
        {
            txtRateDriverName.isHidden = true
            btnSubmit2.isHidden = true
            txtHowDriver.isHidden = true
          btnSubmit1.isHidden = false
            driverRating.isHidden = true
        }
        else{
            if("\(jsonData["data"]["driver_id"])" != "")
            {
            btnSubmit1.isHidden = true
            txtHowDriver.isHidden = false
            txtRateDriverName.isHidden = false
            btnSubmit2.isHidden = false
            driverRating.isHidden = false
            strDriverId = "\(jsonData["data"]["driver_id"])"
            txtRateDriverName.text = "Rate driver :- " + "\(jsonData["data"]["drivername"])"
            }
            else{
                txtRateDriverName.isHidden = true
                btnSubmit2.isHidden = true
                txtHowDriver.isHidden = true
                btnSubmit1.isHidden = false
                driverRating.isHidden = true
            }
        }
        if(starSelect != "0")
        {
            restRating.settings.updateOnTouch = false
            restRating.rating = Double(starSelect)!
            
            driverRating.settings.updateOnTouch = false
            driverRating.rating = Double(driverStar)!
            btnSubmit2.isHidden = true
            btnSubmit1.isHidden = true
        }
        
    }
    
    func doRatingDetailAPI()
    {
        
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let strUserName = UserDefaults.standard.string(forKey: Constant.NAME)!
        let parameters = ["accesstoken" : Constant.APITOKEN, "oid" : strOrderId, "username" :  strUserName , "user_id" : strUserId , "restor_id"  : strRestId , "driver_id" : strDriverId , "driver_star" : strDriverStar , "Rest_rating_stars" : strRestStar]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.doRatingAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "200")
            {
            
            if(self.screenType == "1"){
                self.alertSucces(title: "Thanks for feedback", Message: "Thanks for sharing your feedback")
            }
            else{
                UserDefaults.standard.set("0", forKey: Constant.ONGOING_ORDERAPIHIT)
                self.alertRootRedirection(title: "Thanks for feedback", Message: "Thanks for sharing your feedback")

            }
            }
            else
            {
                self.btnSubmit1.isEnabled = true
                self.btnSubmit2.isEnabled = true
                self.alertSucces(title: "Wait", Message: "\(json["message"])")
               
            }
            
        }
    }
}
