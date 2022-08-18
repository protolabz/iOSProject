//
//  OrderDetailController.swift
//  Xeat
//
//  Created by apple on 26/01/22.
//

import UIKit
import SwiftyJSON


class OrderDetailController: UIViewController {
    var strOrderId = ""
  
    @IBOutlet weak var txtRestName: UILabel!
    
   
    @IBOutlet weak var txtLocation: UILabel!
    
    @IBOutlet weak var txtDeliveryCharges: UILabel!
    
    @IBOutlet weak var txtTotalBill: UILabel!
    @IBOutlet weak var txtServiceCharges: UILabel!
    @IBOutlet weak var txtDiscount: UILabel!
    @IBOutlet weak var txtSubtotal: UILabel!
    @IBOutlet weak var txtOrderedItems: UILabel!
  
    @IBOutlet weak var viewBill: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewBill.layer.borderWidth = 0.5
        viewBill.layer.masksToBounds = false
        viewBill.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewBill.layer.cornerRadius = 10
        if(self.currentReachabilityStatus != .notReachable)
        {
        ongoingOrderDetailAPI()
        }
        else{
            alertInternet()
        }
       
    }
    
    func ongoingOrderDetailAPI()
    {
        
        let parameters = ["accesstoken" : Constant.APITOKEN, "oid" : strOrderId]
        
        print("parameters",parameters)
        
        APIsManager.shared.requestService(withURL: Constant.ongoingOrderDetailAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "1")
            {
                self.setDataViews(jsonData: json)
            }
            else
            {
               
            }
            
        }
    }
    
    
    func setDataViews(jsonData : JSON)
    {
        
        txtRestName.text = "\(jsonData["data"]["res_name"])"
        txtLocation.text = "\(jsonData["data"]["res_location"])"
        
        txtServiceCharges.text =  "£" + "\(jsonData["data"]["drop_f"])"
        
        let deliveryCharge = Double("\(jsonData["data"]["delivery_f"])")
        txtDeliveryCharges.text =  "£" + "\(String(format: "%.2f", deliveryCharge!))"
        
        if("\(jsonData["data"]["penny_applied"])" != "0")
        {
            let discountPrice = Double("\(jsonData["data"]["penny_applied"])")
            txtDiscount.text =  "-£" + "\(String(format: "%.2f", discountPrice!))"
        }
        else{
            let discountPrice = Double("\(jsonData["data"]["discount_amount"])")
            txtDiscount.text =  "-£" + "\(String(format: "%.2f", discountPrice!))"
        }
        
      

        let itemPrice = Double("\(jsonData["data"]["item_total"])")
        txtSubtotal.text =  "£" + "\(String(format: "%.2f", itemPrice!))"

        let totalPrice = Double("\(jsonData["data"]["total_user_pad"])")
        txtTotalBill.text =  "£" + "\(String(format: "%.2f", totalPrice!))"

        var itemData = ""
        for i in 0..<jsonData["data"]["items"].count
        {

            itemData +=  "\(jsonData["data"]["items"][i]["count"])" + " x " +  "\(jsonData["data"]["items"][i]["Iname"])" + ","
            if(jsonData["data"]["items"][i]["withitems"].count == 0)
            {
                itemData += "\n"
            }
            for j in 0..<jsonData["data"]["items"][i]["withitems"].count
            {
                itemData += " (" + "Add-ons:" + "\(jsonData["data"]["items"][i]["withitems"][j]["name"])" + ")" + "\n "
            }
            //  print(itemData)
        }
        let itemData2 = itemData.trimmingCharacters(in: .whitespaces).dropLast(2)
        
        txtOrderedItems.text = "\(itemData2)"
        
    }
    

}
