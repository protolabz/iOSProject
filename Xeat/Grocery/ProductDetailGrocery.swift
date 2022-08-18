//
//  ProductDetailGrocery.swift
//  Xeat
//
//  Created by apple on 01/06/22.
//

import UIKit
import ImageSlideshow
import SwiftyJSON

class ProductDetailGrocery: UIViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imgBack: UIButton!
    @IBOutlet weak var imgBackAction: UIButton!
    @IBOutlet weak var imageSlide: ImageSlideshow!
    @IBOutlet weak var viewNamePrice: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtBackSoon: UIButton!
    @IBOutlet weak var viewQuality: UIStackView!
    @IBOutlet weak var viewFabric: UIView!
    
    @IBOutlet weak var txtPRODUCTDETAIL: UILabel!
    @IBOutlet weak var btnAdd : UIButton!
    
    @IBOutlet weak var txtPdescr: UILabel!
    
    @IBOutlet weak var imgMinus: UIImageView!
    
    @IBOutlet weak var txtAlertItemCount: UILabel!
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var txtQuantity: UILabel!
    @IBOutlet weak var txtOutOfStock: UILabel!
    @IBOutlet weak var txtProductName: UILabel!
    @IBOutlet weak var txtDiscountedPrice: UILabel!
    @IBOutlet weak var txtPrice: UILabel!
    
    
    @IBOutlet weak var txtNutrional: UILabel!
    @IBOutlet weak var txtAlergy: UILabel!
    @IBOutlet weak var viewNutri: UIView!
    @IBOutlet weak var txtDelivered: UIButton!
    
    @IBOutlet weak var txtSepicalOffer: UILabel!
    var strMaxQty = 0
    var strSpecialOffer = "0"
    @IBAction func btnAdd(_ sender: Any) {
        print("btn ptessed")
        let strText = txtAlertItemCount.text?.trimmingCharacters(in: .whitespaces)
        if strText != strCount.description
        {
        if(strAgeLimit == "0")
        {
            
            addItem(strText : strText!)
        }
        else{
            if self.strCount > 1
            {
                addItem(strText : strText!)
            }
            else{
                
            if("\(UserDefaults.standard.string(forKey: Constant.AGE_LIMIT)!)" == "0")
            {
                
            alertAgeLimit(position: strText!)
            }
            else{
            
                addItem(strText : strText!)
            }
            }
        }
        }
        else{
            
        }
        
    }
    func addItem(strText : String) {
       
        print("btn pootessed")
        if(strSpecialOffer == "1")
        {
            if(strMaxQty != 0)
           {
             
                if(strMaxQty < Int(strText)!)
                {
                    alertFailure(title: "Limit reached", Message: "For this special offer product you may only order for \(strMaxQty) items ")
                }
                else{
                    print("else in")
                    addDeleteToCartAPI(count: strText)
                }
           }
           else{
            print("max quantity 0")
                addDeleteToCartAPI(count: strText)
           }
        }
        else{
            if(strMaxQty != 0)
           {
             
                if(strMaxQty < Int(strText)!)
                {
                    alertFailure(title: "Limit reached", Message: "For this special offer product you may only order for \(strMaxQty) items ")
                }
                else{
                    print("else in")
                    addDeleteToCartAPI(count: strText)
                }
           }
           else{
            print("max quantity 0")
                addDeleteToCartAPI(count: strText)
           }
        }
    }
    
    //    @IBOutlet weak var viewDescrip: UIView!
    
    @IBOutlet weak var stack: UIStackView!
    var strSelectedPosition = 0
    
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    //
    
    var strName = ""
    var strPrice = ""
    var strDiscount = ""
    var strDescription = ""
    var strQuanity = ""
    var strSize = ""
    var strImage = ""
    var strActualPrice = ""
    var strId = ""
    var strOutStock = ""
   // var txtCount = 0
    var strCount = 0
    var strDiscountType = ""
    var strAgeLimit = ""
    var strCold = ""
//    var strAllergy = ""
//    var strNutri = ""
    
    @IBOutlet weak var btnCart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        //        viewDescrip.layer.borderWidth = 0.8
        //        viewDescrip.layer.masksToBounds = false
        //        viewDescrip.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                btnAdd.layer.cornerRadius = 8
        
        txtDelivered.isHidden = true
        txtBackSoon.isHidden = true
        
        //        viewDescrip.layer.shadowColor = UIColor.gray.cgColor
        //        viewDescrip.layer.shadowOffset = CGSize(width: 3, height: 3)
        //        viewDescrip.layer.shadowOpacity = 0.3
        //        viewDescrip.layer.shadowRadius = 4.0
        
        imgPlus.isUserInteractionEnabled = true
        imgPlus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnPlus)))
        
        imgMinus.isUserInteractionEnabled = true
        imgMinus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnMinus)))
       
        txtAlertItemCount.text = strCount.description
        
        imageSlide.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageSlide.layer.cornerRadius = 10
        
        // stack.isHidden = true
        viewQuality.layer.borderWidth = 0.8
        viewQuality.layer.masksToBounds = false
        viewQuality.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewQuality.layer.cornerRadius = 8
        
        viewQuality.layer.shadowColor = UIColor.gray.cgColor
        viewQuality.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewQuality.layer.shadowOpacity = 0.3
        viewQuality.layer.shadowRadius = 4.0
        
        viewFabric.layer.borderWidth = 0.8
        viewFabric.layer.masksToBounds = false
        viewFabric.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewFabric.layer.cornerRadius = 8
        
        viewFabric.layer.shadowColor = UIColor.gray.cgColor
        viewFabric.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewFabric.layer.shadowOpacity = 0.3
        viewFabric.layer.shadowRadius = 4.0
        
        viewNamePrice.layer.borderWidth = 0.8
        viewNamePrice.layer.masksToBounds = false
        viewNamePrice.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewNamePrice.layer.cornerRadius = 8
        
        viewNamePrice.layer.shadowColor = UIColor.gray.cgColor
        viewNamePrice.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewNamePrice.layer.shadowOpacity = 0.3
        viewNamePrice.layer.shadowRadius = 4.0
        
        viewNutri.layer.borderWidth = 0.8
        viewNutri.layer.masksToBounds = false
        viewNutri.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewNutri.layer.cornerRadius = 8
        
        viewNutri.layer.shadowColor = UIColor.gray.cgColor
        viewNutri.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewNutri.layer.shadowOpacity = 0.3
        viewNutri.layer.shadowRadius = 4.0
       
       
        txtSepicalOffer.isHidden = true
        
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
        {
            btnAdd.isEnabled = false
            btnAdd.alpha = 0.5
        }
        
        getProductDetail()
    }
    
    @objc func btnPlus() {
        var count =  Int(txtAlertItemCount.text!)
        count! += 1
        txtAlertItemCount.text = count?.description
        
    }
    @objc func btnMinus() {
        
        var count =  Int(txtAlertItemCount.text!)
        if(count! > 0)
        {
            count! -= 1
            txtAlertItemCount.text = count?.description
        }
    }
    
    func  setDataJson(json : JSON)
    {
        txtProductName.text = "\(json["data"]["item_name"])"
                       txtPdescr.attributedText = "\(json["data"]["description"])".htmlToAttributedString
               //
        
        strMaxQty = Int("\(json["data"]["max_qty"])")!
        strSpecialOffer = "\(json["data"]["special_offer"])"
        if strSpecialOffer == "1"
        {
            txtSepicalOffer.isHidden = false
        }
                       txtQuantity.text = "\(json["data"]["quantity"])" + "\(json["data"]["item_type"])"
                    strSize = "\(json["data"]["quantity"])" + "\(json["data"]["item_type"])"
                       txtBackSoon.isHidden = true
                       if "\(json["data"]["in_stock"])" == "0"
                       {
                           txtBackSoon.isHidden = false
                           btnAdd.alpha = 0.5
                           btnAdd.isEnabled = false
                           imgPlus.isUserInteractionEnabled = false
                           imgMinus.isUserInteractionEnabled = false
                       }
                       if "\(json["data"]["deliver_cold"])" == "0"
                       {
                           txtDelivered.isHidden = true
                       }
                        var arrOfImageType : [AFURLSource] = []

                       let urlYourURL = URL (string: "\(json["data"]["item_image"])" )!
                       //arrOfUrl.append(urlYourURL)
                       arrOfImageType.append(AFURLSource.init(url: urlYourURL))

                       self.imageSlide.setImageInputs(arrOfImageType)
        
        let strCommission = "\(json["data"]["commission"])"
        strAgeLimit = "\(json["data"]["age_limit"])"
        let newPrice = (((Double("\(json["data"]["full_price"])"))!/100) * Double(strCommission)!)
       
        let itemPrice = newPrice + (Double("\(json["data"]["full_price"])")!)
        strActualPrice = "\(json["data"]["full_price"])"
        txtPrice.text = "£"  +  "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
        strPrice =  "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
        if ("\(json["data"]["discount_price"])" != "0")
        {
            if ("\(json["data"]["discount_type"])" == "Fixed")
            {
              
                txtDiscountedPrice.isHidden  = false
                txtPrice.isHidden = false
                let price = itemPrice.rounded(digits: 2)
                txtPrice.attributedText =  NSAttributedString(string: "£" + "\(price)").withStrikeThrough(1)
                
                let discountedPrice = itemPrice - Double("\(json["data"]["discount_price"])")!
                txtDiscountedPrice.text = "£"  +  "\(String(format: "%.2f", discountedPrice.rounded(digits: 2)))"
    
                strDiscount = "\(String(format: "%.2f", discountedPrice.rounded(digits: 2)))"
            }
            else{
               
                txtDiscountedPrice.isHidden  = false
                txtPrice.isHidden = false
                let price = itemPrice.rounded(digits: 2)
                txtPrice.attributedText =  NSAttributedString(string: "£" + "\(price)").withStrikeThrough(1)
                
                let dis = (Double("\(json["data"]["discount_price"])")! / 100) * itemPrice
                let discountedPrice = itemPrice - dis
                txtDiscountedPrice.text = "£"  +  "\(String(format: "%.2f", discountedPrice.rounded(digits: 2)))"
                strDiscount = "\(String(format: "%.2f", discountedPrice.rounded(digits: 2)))"

                
            }
        }
        else
        {
            strDiscount = "0"
           
            txtPrice.isHidden = false
            txtDiscountedPrice.isHidden  = true
            let itemPrice = newPrice + (Double("\(json["data"]["full_price"])")!)
            txtPrice.attributedText =  NSAttributedString(string: "£" + "\(itemPrice)").withStrikeThrough(0)
            //  cell.txtNormalPrice.text = "£"  +  "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
        }
        
        
    }
    
    func addDeleteToCartAPI( count : String)
    {
        var priccee = ""
        if(strDiscount == "0")
        {
            priccee = strPrice
        }
        else
        {
            priccee = strDiscount
        }
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "menu_item_id" : "\(strId)", "price" : priccee, "Add_on" : "0", "count": count, "operation" : "2", "actual_price" : strActualPrice , "size" : strSize, "item_instruction": "", "type" : "1"]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.addDeleteItemToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "200")
            {
               
                self.alertSucces(title: "Product added!!!", Message: "Product added to your cart successfully")
                // self.alertCartDelete()
                
            }
                        else if("\(json["status"])" == "202")
                        {
                            self.alertCartDelete()
                        }
            else if("\(json["status"])" == "201")
            {
                self.alertSucces(title: "Product removed!!!", Message: "Product removed from your cart successfully")
                //
                //
            }
            
        }
    }
    
    
    func getProductDetail()
    {
        
        let parameters = [ "accesstoken" : Constant.APITOKEN, "product_id" : "\(strId)", ]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.singleProduct, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "200")
            {
               
//                self.alertSucces(title: "Product added!!!", Message: "Product added to your cart successfully")
                // self.alertCartDelete()
                self.setDataJson(json : json)
            }
        }
    }

    func removeCartDataAPI()
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.removeCartDataAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "201")
            {
                self.alertFailure(title: "Failed!", Message: "\(json["message"])")
            }
            else
            {
              //  self.viewCartTotal.isHidden = true
               // self.restIDForCartItem = "0"
//                self.alertFailure(title: "Enjoy!!!", Message: "You can purchase the best products offered by Grocery store")
            }
            
        }
    }
    func alertCartDelete() -> Void
    {
        let refreshAlert = UIAlertController(title: "Cart contains products", message: "Do you want to clear your cart and add this product?", preferredStyle: UIAlertController.Style.alert)
        
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //            self.logoutApi()
            if(self.currentReachabilityStatus != .notReachable)
            {
            self.removeCartDataAPI()
            }
            else{
                self.alertInternet()
            }
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    func alertAgeLimit(position : String) -> Void
    {
        let refreshAlert = UIAlertController(title: "18+ ?", message: "If Yes! You'll need to verify using Id at delivery time.", preferredStyle: UIAlertController.Style.alert)
       
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.setValue("1", forKey: Constant.AGE_LIMIT)
            if(self.currentReachabilityStatus != .notReachable)
            {
                
            self.addDeleteToCartAPI(count: position)
            }
            else
            {
                self.alertInternet()
            }
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}
