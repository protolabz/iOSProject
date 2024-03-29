//
//  CartController.swift
//  Xeat
//
//  Created by apple on 12/01/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import SquareInAppPaymentsSDK

class CartController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var edInstruction: UITextView!
    @IBOutlet weak var txtPreviousOrder: UILabel!
    
    @IBOutlet weak var viewPayment: UIView!
    @IBAction func btnCardPayment(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        viewpayment.isHidden = true
        print("card call")
        flagScreen = 3
        performSegue(withIdentifier: "card", sender: nil)
        }
        else{
            alertInternet()
        }
        //didRequestPayWithCard()
    }
    @IBAction func btnApplePay(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        print("apple call")
        viewpayment.isHidden = true
        requestApplePayAuthorization()
        }
        else{
            alertInternet()
        }
    }
    @IBOutlet weak var txtTotalPay: UILabel!
    @IBOutlet weak var btnApplepay: UIButton!
    @IBOutlet weak var btnCardPayment: UIButton!
    @IBAction func btnCancelPayment(_ sender: Any) {
        self.viewpayment.isHidden = true
        self.btnPlaceOrder.isEnabled = true
        self.strPaymentType = 0
        self.btnCard.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
        self.btnCash.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
        self.dismiss(animated: true, completion : nil)
       // placeOrderAPI()
    }
    @IBOutlet weak var btnCancelPayment: UIButton!
    @IBOutlet weak var viewpayment: UIView!
    
    @IBOutlet weak var viewNoOrder: UIView!
    var arrOfAddToCartItem : [JSON] = []
    var strRestId = ""
    var strDeliveryType = "-1"
    var strRestLat = ""
    var strRestLong = ""
    var strRestType = ""
    var selectedPosition = 0
    var strOrderId = ""
    var observerAdded = 0
    
    
    var flagScreen = 0
    var intCouponApplied = "0"
    var pennyChecked = 0
    var intPennyApplied = "0"
    var strPennyCount = 0
    var strPaymentType = 0
    var strAmount  = ""
    var strMinMumOrder = "0"
    var sizeArray = 0
    var strSubTotal = ""
    var modeType = "0"
    var strCartId = "0"
    var strPreviousOrder = 0
    @IBOutlet weak var txtRestLocation: UILabel!
    
    
    @IBOutlet weak var btnPennyApplied: UIButton!
    @IBOutlet weak var viewPlusMinus: UIView!
    
    @IBOutlet weak var btnAlertCancel: UIButton!
    @IBOutlet weak var btnAlertUpdate: UIButton!
    @IBOutlet weak var txtAlertItemNAme: UILabel!
    @IBOutlet weak var imgMinus: UIImageView!
    @IBOutlet weak var imgPlus: UIImageView!
    
    @IBOutlet weak var txtAlertItemCount: UILabel!
    @IBOutlet weak var txtAlertItemCount1: UILabel!
    @IBOutlet weak var viewPlusMinus1: UIView!
    
    @IBOutlet weak var btnAlertCancel1: UIButton!
    @IBOutlet weak var btnAlertUpdate1: UIButton!
    @IBOutlet weak var txtAlertItemNAme1: UILabel!
    @IBOutlet weak var imgMinus1: UIImageView!
    @IBOutlet weak var imgPlus1: UIImageView!
    @IBOutlet weak var viewInnerPlusMinus1: UIView!

    
    @IBOutlet weak var txtSpecialInstructions: UILabel!
    @IBOutlet weak var viewInnerPlusMinus: UIView!
    @IBOutlet weak var txtDeliveryLocation: UILabel!
    @IBOutlet weak var txtRestName: UILabel!
    @IBOutlet weak var restInage: UIImageView!
    
    @IBOutlet weak var viewAddItems: UIView!
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewMainContent: UIView!
    @IBOutlet weak var btnLocationChange: UIButton!
    
    @IBOutlet weak var viewApplyCoupon: UIView!
    @IBOutlet weak var txtApplyCoupon: UILabel!
    @IBOutlet weak var txtInstructions: UILabel!
    
    @IBOutlet weak var txtVAT: UILabel!
    @IBOutlet weak var txtServiceCharges: UILabel!
    @IBOutlet weak var viewDelivery: UIView!
    @IBOutlet weak var txtDelivery: UILabel!
    @IBOutlet weak var txtPennyDediction: UILabel!
    @IBOutlet weak var btnCard: UIButton!
    
    @IBOutlet weak var txtPenny: UILabel!
    @IBOutlet weak var txtTotalBill: UILabel!
    @IBOutlet weak var txtDiscount: UILabel!
    @IBOutlet weak var txtDeliveryCharges: UILabel!
    @IBOutlet weak var txtSubTotal: UILabel!
    
    @IBOutlet weak var viewBill: UIView!
    
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initViews()
        
        // fetchCartDetail()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func initViews()
    {
        self.viewNoOrder.isHidden = false
        self.viewpayment.isHidden = true
        txtPreviousOrder.isHidden = true
        viewPayment.isHidden = true
        let nib = UINib(nibName: "CartCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CartCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        viewBill.layer.borderWidth = 0.5
        viewBill.layer.masksToBounds = false
        viewBill.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewBill.layer.cornerRadius = 5
        
        viewApplyCoupon.layer.borderWidth = 0.1
        viewApplyCoupon.layer.masksToBounds = false
        viewApplyCoupon.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewApplyCoupon.layer.cornerRadius = 10
        
        viewDelivery.layer.borderWidth = 0.5
        viewDelivery.layer.masksToBounds = false
        viewDelivery.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewDelivery.layer.cornerRadius = 5
        
        viewAddItems.layer.borderWidth = 0.1
        viewAddItems.layer.masksToBounds = false
        viewAddItems.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewAddItems.layer.cornerRadius = 10
        
        viewInnerPlusMinus.layer.borderWidth = 0.5
        viewInnerPlusMinus.layer.masksToBounds = false
        viewInnerPlusMinus.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewInnerPlusMinus.layer.cornerRadius = 10
        
        edInstruction.layer.masksToBounds = true
        edInstruction.layer.backgroundColor = #colorLiteral(red: 0.9488552213, green: 0.9487094283, blue: 0.9693081975, alpha: 1)
        edInstruction.tintColor = .black
        edInstruction.clipsToBounds = true
        edInstruction.layer.cornerRadius = 5
        edInstruction.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        edInstruction.layer.borderWidth = 0.3
        
        
        viewInnerPlusMinus1.layer.borderWidth = 0.5
        viewInnerPlusMinus1.layer.masksToBounds = false
        viewInnerPlusMinus1.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewInnerPlusMinus1.layer.cornerRadius = 10
        
        viewPlusMinus1.isHidden = true
        
        btnApplepay.layer.cornerRadius=10
        btnApplepay.clipsToBounds=true
        
        restInage.layer.cornerRadius=10
        restInage.clipsToBounds=true
        
        btnCancelPayment.layer.cornerRadius=10
        btnCancelPayment.clipsToBounds=true
        btnAlertCancel1.layer.cornerRadius=10
        btnAlertCancel1.clipsToBounds=true
        
        btnPlaceOrder.layer.cornerRadius=10
        btnPlaceOrder.clipsToBounds=true
        
        btnCardPayment.layer.cornerRadius=10
        btnCardPayment.clipsToBounds=true
        viewPlusMinus.isHidden = true
        
        btnAlertCancel.layer.cornerRadius=10
        btnAlertCancel.clipsToBounds=true
        
        btnPlaceOrder.layer.cornerRadius=10
        btnPlaceOrder.clipsToBounds=true
        
        btnAlertUpdate.layer.cornerRadius=10
        btnAlertUpdate.clipsToBounds=true
        btnAlertUpdate1.layer.cornerRadius=10
        btnAlertUpdate1.clipsToBounds=true
        
        viewApplyCoupon.isUserInteractionEnabled = true
        viewApplyCoupon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.couponCall)))
        
        viewAddItems.isUserInteractionEnabled = true
        viewAddItems.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.restCall)))
        
        txtInstructions.isUserInteractionEnabled = true
        txtInstructions.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.instCall)))
        // Do any additional setup after loading the view.
        
        imgPlus.isUserInteractionEnabled = true
        imgPlus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnPlus)))
        
        imgMinus.isUserInteractionEnabled = true
        imgMinus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnMinus)))
     
        imgPlus1.isUserInteractionEnabled = true
        imgPlus1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnPlus1)))
        
        imgMinus1.isUserInteractionEnabled = true
        imgMinus1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnMinus1)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewpayment.isHidden = true
        observerAdded = 0
        if(currentReachabilityStatus != .notReachable)
        {
            
            self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            arrOfAddToCartItem.removeAll()
            modeType =  "\(UserDefaults.standard.string(forKey: Constant.SELECTION_MODE) ?? "2")"
            if("\(UserDefaults.standard.string(forKey: Constant.SELECTION_MODE) ?? "1")" == "1")
                {
                fetchCartDetail(type : "1")
//                edInstruction.isHidden = true
//                txtSpecialInstructions.isHidden = true
            }
            else{
                fetchCartDetail(type : "0")
            }
           
        }
        else{
            alertInternet()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if(observerAdded == 1)
        {
            self.tableView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    
    
    func didRequestPayWithCard() {
        dismiss(animated: true) {
            let vc = self.makeCardEntryViewController()
            vc.delegate = self
            
            let nc = UINavigationController(rootViewController: vc)
            self.present(nc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnPennyApplied(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        viewpayment.isHidden = true
        if(pennyChecked != 1)
        {
            if(strPennyCount > 499)
            {
                
                if(intCouponApplied == "0" )
                {
                    btnPennyApplied.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    btnPennyApplied.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    updatePennyAppliedAPI(strApplied: "1", flag: 0)
                    // self.arrOfSelectedID.append()
                    
                }
                else{
                    alertCouponAlready()
                }
            }
            else
            {
                alertFailure(title: "Penny count", Message: "You must have 500 pennies to apply on order")
            }
        }
        else{
            btnPennyApplied.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            btnPennyApplied.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            updatePennyAppliedAPI(strApplied: "0", flag:  0)
        }
        }
        else
        {
            alertInternet()
        }
    }
    @objc func btnPlus1() {
        viewpayment.isHidden = true
        var count =  Int(txtAlertItemCount1.text!)
        count! += 1
        txtAlertItemCount1.text = count?.description
        //  calculateNewPrice()
        
        
    }
    @objc func btnMinus1() {
        viewpayment.isHidden = true
        var count =  Int(txtAlertItemCount1.text!)
        if(count! > 0)
        {
            count! -= 1
            txtAlertItemCount1.text = count?.description
        }
    }
    @IBAction func btnAlertCAncel1(_ sender: Any) {
        viewPlusMinus1.isHidden = true
    }
    @IBAction func btnAlertUpdate1(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        viewPlusMinus1.isHidden = true
        print(txtAlertItemCount1.text)
            print("update button pressd")
            
        let strText = txtAlertItemCount1.text
      
        
            if("\(arrOfAddToCartItem[selectedPosition]["special_offer"])" == "1")
            {
              let strMaxQty = Int("\(arrOfAddToCartItem[selectedPosition]["max_qty"])")
                if(strMaxQty != 0)
               {
                 
                    if(strMaxQty! < Int(strText!)!)
                    {
                        alertFailure(title: "Limit reached", Message: "For this special offer product you may only order for \(strMaxQty!) items ")
                    }
                    else{
                        updateItemCountAPI(strCount : strText! , strInstruction:  "" )
                    }
               }
               else{
                updateItemCountAPI(strCount : strText! , strInstruction:  "" )
               }
            }
            else{
                updateItemCountAPI(strCount : strText! , strInstruction:  "" )
            }
        }
        else
        {
            alertInternet()
        }
    }
    @IBAction func btnAlertCAncel(_ sender: Any) {
        viewPlusMinus.isHidden = true
    }
    @IBAction func btnAlertUpdate(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        viewPlusMinus.isHidden = true
       
            
        let strText = txtAlertItemCount.text
        let instructions = edInstruction.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
            if("\(arrOfAddToCartItem[selectedPosition]["special_offer"])" == "1")
            {
              let strMaxQty = Int("\(arrOfAddToCartItem[selectedPosition]["max_qty"])")
                if(strMaxQty != 0)
               {
                 
                    if(strMaxQty! < Int(strText!)!)
                    {
                        alertFailure(title: "Limit reached", Message: "For this special offer product you may only order for \(strMaxQty!) items ")
                    }
                    else{
                        updateItemCountAPI(strCount : strText! , strInstruction:  instructions )
                    }
               }
               else{
                updateItemCountAPI(strCount : strText! , strInstruction:  instructions )
               }
            }
            else{
                updateItemCountAPI(strCount : strText! , strInstruction:  instructions )
            }
        }
        else
        {
            alertInternet()
        }
    }
    
    @IBAction func btnPlaceOrder(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        if(strDeliveryType == "-1")
        {
            alertFailure(title: "Delivery Options", Message: "Please select delivery option type before proceeding")
        }
        else  if((Double(strSubTotal)! < Double(strMinMumOrder)!) && (strDeliveryType == "1") )
        {
         
              alertFailure(title: "Minimum order amount", Message: "Please add or update items to reach minimum order placed limit. \n Minimum order amount is £" + strMinMumOrder)
         
        }
        else if(strPreviousOrder == 1)
        {
            btnPlaceOrder.isEnabled = false
            btnPlaceOrder.alpha = 0.5
            alertFailure(title: "Already ongoing order", Message: "It seems you are having one onging order. Please wait until the previous order will not be completed")
        }
        else{
//            if(strPaymentType != 0)
//            {
//                btnPlaceOrder.isEnabled = true
//                btnPlaceOrder.alpha = 1
//                if(strPaymentType != 0)
//                {
//                    btnPlaceOrder.isEnabled = true
//                    btnPlaceOrder.alpha = 1
//                if(strPaymentType == 1)
//                {
//                    btnPlaceOrder.isEnabled = false
//                    placeOrderAPI()
//                }
////                if(strPaymentType == 1)
//                {
//                    btnPlaceOrder.isEnabled = false
//                    placeOrderAPI()
//                }
//                else{
                    //  didRequestPayWithCard()
                
                  
                       alertOrderPlaced()
                   // requestApplePayAuthorization()
                }
//            }
//            else
//            {
//                alertFailure(title: "Payment type", Message: "Please select payment type before proceeding")
//            }
        }
        else
        {
            alertInternet()
        }
    }
    
    @IBAction func btnCash(_ sender: Any) {
       
//        if(strPaymentType != 1)
//        {
//      //  updatePaymentOptionAPI(strOption:  "1")
//        }
    }
    @IBAction func btnCard(_ sender: Any) {
//        btnCash.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
//        btnCard.setBackgroundImage(UIImage(systemName: "record.circle"), for: UIControl.State.normal)
        if(strPaymentType != 2){
      //  updatePaymentOptionAPI(strOption: "2")
        }
    }
    @IBAction func btnDeliveyOption(_ sender: Any) {
        viewpayment.isHidden = true
        alertDelivery()
    }
    
    @objc func btnPlus() {
        viewpayment.isHidden = true
        var count =  Int(txtAlertItemCount.text!)
        count! += 1
        txtAlertItemCount.text = count?.description
        //  calculateNewPrice()
    }
    @objc func btnMinus() {
        viewpayment.isHidden = true
        var count =  Int(txtAlertItemCount.text!)
        if(count! > 0)
        {
            count! -= 1
            txtAlertItemCount.text = count?.description
        }
    }
    
    @objc func instCall() {
        viewpayment.isHidden = true
        showAlertInstructions()
        
    }
    @objc func couponCall() {
        if(self.currentReachabilityStatus != .notReachable)
        {
        viewpayment.isHidden = true
        flagScreen = 0
        if(pennyChecked != 1)
        {
            performSegue(withIdentifier: "coupon", sender: nil)
        }
        else{
            alertPennyAlready()
        }
        }
        else{
            alertInternet()
        }
    }
    @objc func restCall() {
        self.tabBarController?.selectedIndex = 0
//        flagScreen = 1
//        performSegue(withIdentifier: "menu", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(flagScreen == 0)
        {
            print(strRestId)
            let secondViewController = segue.destination as! CouponController
            secondViewController.strRestId = strRestId
        }
        else if(flagScreen == 2)
        {
            let secondViewController = segue.destination as! OrderStatusController
            secondViewController.strOrderId = strOrderId
        }
        else if(flagScreen == 3)
        {
            let secondViewController = segue.destination as! SavedcardListControllerViewController
          secondViewController.strCartId = strCartId
            secondViewController.strDeliveryType = strDeliveryType
        }
        else if(flagScreen == 5)
         {
           
             let secondViewController = segue.destination as! ProductDetailGrocery
            secondViewController.strId = "\(arrOfAddToCartItem[selectedPosition]["menu_item_id"])"
            secondViewController.strCount = Int("\(arrOfAddToCartItem[selectedPosition]["count"])")!
                          
//                     let vala = "\(arrOfAddToCartItem[i]["count"])"
//                     count += Int(vala)!
      }
        else
        {
            let secondViewController = segue.destination as! RestaurantController
            secondViewController.strRestId = strRestId
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"
        {
            if let newValue = change?[.newKey]
            {
                switch arrOfAddToCartItem.count {
                case 1 :
                    let newSize  = newValue as! CGSize
                    self.tblHeight.constant = 110
                case 2:
                    let newSize  = newValue as! CGSize
                    self.tblHeight.constant = 160
                case 3 :
                    let newSize  = newValue as! CGSize
                    self.tblHeight.constant = 230
                case 4 :
                    let newSize  = newValue as! CGSize
                    self.tblHeight.constant = 280
                case 5 :
                    let newSize  = newValue as! CGSize
                    self.tblHeight.constant = 380
                case 6 :
                    let newSize  = newValue as! CGSize
                    self.tblHeight.constant = 610
                default:
                    let newSize  = newValue as! CGSize
                    self.tblHeight.constant = 600
                }
                
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfAddToCartItem.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // viewController is visible
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        if self.viewIfLoaded?.window != nil {
            print("\(self.arrOfAddToCartItem[indexPath.row]["menu_item_id"])")
            cell2.txtName.text = "\(self.arrOfAddToCartItem[indexPath.row]["item_name"])"
            
            strCartId = "\(arrOfAddToCartItem[indexPath.row]["cart_id"])"
          //  cell2.txtIngreden.text =  "\(self.arrOfAddToCartItem[indexPath.row]["item_Ingredients"])"
            //        let newPrice = (Double("\(self.arrOfAddToCartItem[indexPath.row]["f_price"])")!/100) * Double(strCommision)!
            let itemPrice = (Double("\(self.arrOfAddToCartItem[indexPath.row]["total_price"])")!)
            if( "\(self.arrOfAddToCartItem[indexPath.row]["instruction"])".count>1)
            {
                if("\(self.arrOfAddToCartItem[indexPath.row]["instruction"])" != "null")
                {
            cell2.txtInstruction.text = "Instructions : "  + " " + "\(self.arrOfAddToCartItem[indexPath.row]["instruction"])"
            }
            }
            else
            {
                cell2.txtInstruction.text = ""
            }
            cell2.txtPrice.text = "£"  +  "\(String(format: "%.2f", itemPrice))"
            
            cell2.txtNumber.text = "\(self.arrOfAddToCartItem[indexPath.row]["count"])"
            
            if("\(self.arrOfAddToCartItem[indexPath.row]["is_add_on"])" == "1")
            {
                let addOnItems = "\(self.arrOfAddToCartItem[indexPath.row]["add_on_items"])"
                var strAddon = ""
                if let dataFromString = addOnItems.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    
                    do{
                        let json = try JSON(data: dataFromString)
                        print(json.count)
                        print(json[0]["name"])
                        
                        for i in 0..<json.count
                        {
                            strAddon = strAddon + "\(json[i]["name"])" + ","
                        }
                        
                    }
                    catch
                    {
                        
                    }
                }
                let finalAddOn = strAddon.dropLast()
                cell2.txtIngreden.text = "\(finalAddOn)"
                
            }
    
            else
            {
                cell2.txtIngreden.text = ""
                cell2.txtIngreden.numberOfLines = 1
            }
            
            
            cell2.imgPlus.tag = indexPath.row
            cell2.imgPlus.addTarget(self, action: #selector(updatePlus(_:)), for: .touchUpInside)
            
            cell2.btnDelete.tag = indexPath.row
            cell2.btnDelete.addTarget(self, action: #selector(updateDelete(_:)), for: .touchUpInside)
            
            if("\(cell2.txtNumber.text)" != "0")
            {
                
                cell2.imgMinus.tag = indexPath.row
                cell2.imgMinus.addTarget(self, action: #selector(updateMinus(_:)), for: .touchUpInside)
            }
            cell2.selectionStyle = .none
        }
        return cell2
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if(modeType == "1" )
       {
        if(self.currentReachabilityStatus != .notReachable)
        {
            selectedPosition = indexPath.row
            print("\(arrOfAddToCartItem[selectedPosition]["menu_item_id"])")
       
       flagScreen = 5
        performSegue(withIdentifier: "product", sender: nil)
        }else
        {
            alertInternet()
        }
    }
    }
    
    @objc func updatePlus(_ sender: UIButton) {
        
        viewpayment.isHidden = true
        if(self.currentReachabilityStatus != .notReachable)
        {
            selectedPosition = sender.tag
            if modeType == "0"
            {
            viewPlusMinus.isHidden = false
            txtAlertItemCount.text = "\(self.arrOfAddToCartItem[sender.tag]["count"])"
            edInstruction.text = "\(self.arrOfAddToCartItem[sender.tag]["instruction"])"
            txtAlertItemNAme.text = "\(self.arrOfAddToCartItem[sender.tag]["item_name"])"
            }
            else{
                viewPlusMinus1.isHidden = false
                txtAlertItemCount1.text = "\(self.arrOfAddToCartItem[sender.tag]["count"])"
               
                txtAlertItemNAme1.text = "\(self.arrOfAddToCartItem[sender.tag]["item_name"])"
            }
        }
        else{
            self.alertInternet()
        }
        
    }
    
    @objc func updateDelete(_ sender: UIButton) {
        viewpayment.isHidden = true
        if(self.currentReachabilityStatus != .notReachable)
        {
            selectedPosition = sender.tag
            
          //  let instructions = edInstruction.text.trimmingCharacters(in: .whitespacesAndNewlines)
            updateItemCountAPI(strCount : "0" , strInstruction: "" )
        }
        else{
            self.alertInternet()
        }
        
    }
    
    @objc func updateMinus(_ sender: UIButton) {
        viewpayment.isHidden = true
        if(self.currentReachabilityStatus != .notReachable)
        {
            selectedPosition = sender.tag
             if modeType == "0"
             {
            viewPlusMinus.isHidden = false
            edInstruction.text = "\(self.arrOfAddToCartItem[sender.tag]["instruction"])"
            txtAlertItemCount.text = "\(self.arrOfAddToCartItem[sender.tag]["count"])"
            txtAlertItemNAme.text = "\(self.arrOfAddToCartItem[sender.tag]["item_name"])"
             }
             else{
                viewPlusMinus1.isHidden = false
               
                txtAlertItemCount1.text = "\(self.arrOfAddToCartItem[sender.tag]["count"])"
                txtAlertItemNAme1.text = "\(self.arrOfAddToCartItem[sender.tag]["item_name"])"
             }
        }
        else{
            self.alertInternet()
        }
    }
    func fetchCartDetail(type : String)
    {
        arrOfAddToCartItem.removeAll()
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN , "type" : type]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.cartDetailAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            self.observerAdded = 1
            if("\(json["status"])" == "200")
            {
                self.viewNoOrder.isHidden = true
                self.setDataViews(jsonData: json)
                self.arrOfAddToCartItem.removeAll()
                self.sizeArray = json["data"].count
                for i in 0..<json["data"].count
                {
                    self.arrOfAddToCartItem.append(json["data"][i])
                }
                print(self.arrOfAddToCartItem.count)
                //
                if self.viewIfLoaded?.window != nil {
                    self.tableView.reloadData()
                }
                
            }
            else if("\(json["status"])" == "204")
            {
                if self.modeType == "0"
                {
                self.alertAddressOutReach(title: "Address out of reach", Message: "On the selected delivery address, we can't deliver order. Please select any other restaurant")
                }
                else{
                    self.alertAddressOutReach(title: "Address out of reach", Message: "On the selected delivery address, we can't deliver order. Please select any other address")
                }
                self.viewNoOrder.isHidden = true
                self.setDataViews(jsonData: json)
                self.arrOfAddToCartItem.removeAll()
                self.sizeArray = json["data"].count
                for i in 0..<json["data"].count
                {
                    self.arrOfAddToCartItem.append(json["data"][i])
                }
                print(self.arrOfAddToCartItem.count)
                //
                if self.viewIfLoaded?.window != nil {
                    self.tableView.reloadData()
                }
            }
            
            else
            {
                self.arrOfAddToCartItem.removeAll()
                self.viewNoOrder.isHidden = false
                //
            }
            
        }
    }
    
    func setDataViews(jsonData : JSON)
    {
        
        
        strPreviousOrder = Int("\(jsonData["previous_order"])")!
        
        if(strPreviousOrder == 1)
        {
            btnPlaceOrder.isEnabled = false
            btnPlaceOrder.alpha = 0.5
            txtPreviousOrder.isHidden = false
        }
        else{
            btnPlaceOrder.isEnabled = true
            btnPlaceOrder.alpha = 1
            txtPreviousOrder.isHidden = true
        }
        
        if(!"\(jsonData["instruction"])".isEmpty)
        {
            txtInstructions.text = "\(jsonData["instruction"])"
        }
        txtRestName.text = "\(jsonData["restaurant_detail"]["rest_name"])"
        txtRestLocation.text = "\(jsonData["restaurant_detail"]["location"])"
        strRestLat = "\(jsonData["restaurant_detail"]["r_lat"])"
        strRestLong = "\(jsonData["restaurant_detail"]["r_long"])"
        strRestType = "\(jsonData["restaurant_detail"]["rest_type"])"
        strMinMumOrder = "\(jsonData["restaurant_detail"]["Minimum_Order"])"
        
//        if modeType == "0"
//        {
        let urlYourURL = URL (string: "\(jsonData["restaurant_detail"]["image"])")
        restInage.loadurl(url: urlYourURL!)
//        }
//        else{
//            restInage.image = #imageLiteral(resourceName: "xeat")
//        }
        
        
        strRestId = "\(jsonData["restaurant_detail"]["id"])"
        
        let address = UserDefaults.standard.string(forKey: Constant.USERADDRESS)
        txtDeliveryLocation.text = "Delivery address:- " + address!
        
        
        self.setBillDetails(jsonData : jsonData)
        
        if("\(jsonData["address"])" == "0")
        {
            self.txtDeliveryLocation.text = "Pick up"
            txtDelivery.text = "Pick up"
            strDeliveryType = "0"
            btnLocationChange.setTitle("CHANGE", for: .normal)
        }
        else if("\(jsonData["address"])" == "1")
        {
            txtDelivery.text = "Delivery"
            strDeliveryType = "1"
            btnLocationChange.setTitle("CHANGE", for: .normal)
        }
        else{
            txtDelivery.text = "Not selected"
            strDeliveryType = "-1"
            btnLocationChange.setTitle("SELECT", for: .normal)
            btnLocationChange.isHidden = false
        }
        
        //        switch strRestType {
        //        case "1":
        //            txtDelivery.text = "Pick up"
        //            btnLocationChange.isHidden = true
        //
        //        case "2":
        //            txtDelivery.text = "Delivery"
        //            btnLocationChange.isHidden = true
        //
        //        case "3":
        //            btnLocationChange.isHidden = false
        //
        //        default:
        //           print("vcd")
        //        }
        
        intCouponApplied = "\(jsonData["coupon_applied"])"
        intPennyApplied = "\(jsonData["applied_penny"])"
        if(intPennyApplied != "0")
        {
            btnPennyApplied.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
            btnPennyApplied.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            pennyChecked = 1
        }
        else{
            btnPennyApplied.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            btnPennyApplied.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            pennyChecked = 0
        }
        
        
        if("\(jsonData["coupon_applied"])" == "1")
        {
            txtApplyCoupon.text = "\(jsonData["coupon_name"])"
        }
        else{
            txtApplyCoupon.text = "Apply coupon"
        }
    }
    
    
    func setBillDetails(jsonData : JSON)
    {
        //bill
        let itemTotalPrice = Double("\(jsonData["total_amount"])")
        txtTotalBill.text =  "£" + "\(String(format: "%.2f", itemTotalPrice!))"
        
        strAmount = "\(String(format: "%.2f", itemTotalPrice!))"
        
        let itemPrice = Double("\(jsonData["total_Item_amount"])")
        txtSubTotal.text =  "£" + "\(String(format: "%.2f", itemPrice!))"
         strSubTotal = "\(String(format: "%.2f", itemPrice!))"
        
        let serviceCharges = Double("\(jsonData["service_charges"])")
        txtServiceCharges.text =  "£" + "\(String(format: "%.2f", serviceCharges!))"
        
        let deliveryPrice = Double("\(jsonData["delivery_charges"])")
        txtDeliveryCharges.text =  "£" + "\(String(format: "%.2f", deliveryPrice!))"
        
        
        txtPenny.text = "Xeat Penny(" + "\(jsonData["user_penny"])" + " penny)"
        strPennyCount = Int("\(jsonData["user_penny"])")!
        
        let appliedPenny = Double("\(jsonData["applied_penny"])")
        txtPennyDediction.text =  "-£" + "\(String(format: "%.2f", appliedPenny!))"
        
        let discountCharge = Double("\(jsonData["coupon_discount"])")
        txtDiscount.text = "-£" + "\(String(format: "%.2f", discountCharge!))"
    }
    func updatePickupOptionAPI()
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN,"payment_type" : "2", "address_type" : strDeliveryType]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.updateAddToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "200")
            {
                self.strPaymentType = 2
                self.txtDeliveryLocation.text = "Pick up"
                
                self.btnLocationChange.setTitle("CHANGE", for: .normal)
                self.setBillDetails(jsonData: json)
                if(self.strRestType == "1")
                {
                    self.btnLocationChange.isHidden = true
                }
            }
            else
            {
               
            }
            
        }
    }
    
    

    
    func updatePennyAppliedAPI(strApplied : String, flag : Int)
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "add_penny" : strApplied, "type" : modeType]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.updateAddToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "201")
            {
                
            }
            else
            {
                if(flag == 1)
                {
                    self.performSegue(withIdentifier: "coupon", sender: nil)
                }
                else{
                    self.setDataViews(jsonData: json)
                }
                
            }
            
        }
    }
    
    func updateInstructionAPI(strOption : String)
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "instruction" : strOption, "type" : modeType]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.updateAddToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "201")
            {
                
            }
            else
            {
                //  self.setDataViews(jsonData: json)
            }
            
        }
    }
    
    
//    func updatePaymentOptionAPI(strOption : String)
//    {
//        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
//        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "payment_type" : strOption]
//
//        print("parameters",parameters)
//        APIsManager.shared.requestService(withURL: Constant.updateAddToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
//            print(json)
//
//            if("\(json["status"])" == "200")
//            {
//                self.strPaymentType = Int(strOption)!
//               if(strOption == "1")
//               {
//                self.btnCard.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
//                self.btnCash.setBackgroundImage(UIImage(systemName: "record.circle"), for: UIControl.State.normal)
//               }
//               else{
//                self.btnCash.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
//                self.btnCard.setBackgroundImage(UIImage(systemName: "record.circle"), for: UIControl.State.normal)
//               }
//            }
//            else
//            {
//        }
//
//        }
//    }
    
    func updateItemCountAPI(strCount : String , strInstruction : String )
    {
        let actialPrice = "\(arrOfAddToCartItem[selectedPosition]["price_without_commision"])"
        let cartItemId = "\(arrOfAddToCartItem[selectedPosition]["id"])"
        let price = "\(arrOfAddToCartItem[selectedPosition]["price_add_commision"])"
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "cart_item_id" : cartItemId,
                          "actual_price" : actialPrice, "count" : strCount ,"price" : price, "item_instruction" : strInstruction , "type" : modeType ]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.updateAddToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "201")
            {
                self.viewNoOrder.isHidden = false
                if let tabItems = self.tabBarController!.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    let tabItem = tabItems[2]
                    tabItem.badgeValue = nil
                    
                }
            }
            else
            {
                self.arrOfAddToCartItem.removeAll()
                
                self.setDataViews(jsonData: json)
                
                for i in 0..<json["data"].count
                {
                    self.arrOfAddToCartItem.append(json["data"][i])
                }
                print(self.arrOfAddToCartItem.count)
                if let tabItems = self.tabBarController!.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    let tabItem = tabItems[2]
                    tabItem.badgeValue = "\(json["cart_items"])"
                    
                }                //
                self.tableView.reloadData()
                
            }
            
        }
    }
    
    func updateDeliveyOptionAPI()
    {
        
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let strLat = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
        let strLong = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "address_type" : strDeliveryType,
                          "customer_lat" : strLat, "customer_lng" : strLong ,"order_lat" : strRestLat , "order_lng" : strRestLong, "payment_type" : "2", "type" : modeType]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.updateAddToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "200")
            {
                let address = UserDefaults.standard.string(forKey: Constant.USERADDRESS)
                self.txtDeliveryLocation.text = "Delivery address:- " + address!
                self.strPaymentType = 2
                self.setBillDetails(jsonData: json)
                if(self.strRestType == "2")
                {
                    
                    self.btnLocationChange.isHidden = true
                }

                
            }
            else if("\(json["status"])" == "204")
            {
                if self.modeType == "0"
                {
                self.alertAddressOutReach(title: "Address out of reach", Message: "On the selected delivery address, we can't deliver order. Please select any other restaurant")
                }
                else{
                    self.alertAddressOutReach(title: "Address out of reach", Message: "On the selected delivery address, we can't deliver order. Please select any other address")
                }
//                self.viewNoOrder.isHidden = true
//              //  self.setDataViews(jsonData: json)
//                self.arrOfAddToCartItem.removeAll()
//              //  self.sizeArray = json["data"].count
//                for i in 0..<json["data"].count
//                {
//                    self.arrOfAddToCartItem.append(json["data"][i])
//                }
//                print(self.arrOfAddToCartItem.count)
//                //
////                if self.viewIfLoaded?.window != nil {
//                    self.tableView.reloadData()
//                }
            }
            else
            {
               
            }
            
        }
    }
    
    func placeOrderAPI()
    {
        self.viewpayment.isHidden = true
        self.btnPlaceOrder.isEnabled = false
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
                self.viewNoOrder.isHidden = false
                self.alertOrderPlaced(str : "\(json["data"])")
                
            }
            else
            {
                self.dismiss(animated: true)
                self.alertFailure(title: "Order failed", Message: "\(json["message"])")
                self.btnPlaceOrder.isEnabled = true
            }
            
        }
    }
    
    func updateChargeAPI(_ nonce: String, completion: @escaping (String?, String?) -> Void) {
        self.viewpayment.isHidden = true
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN,"card_nonce": nonce, "amount" : strAmount, "currency" : "GBP" , "cart_id" : strCartId]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.chargeAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "1")
            {
                self.placeOrderAPI()
                
                completion("success", nil)
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
    func alertDelivery() -> Void
    {
        let refreshAlert = UIAlertController(title: "Delivery Option", message: "Select your delivery option", preferredStyle: UIAlertController.Style.alert)
        if(strRestType == "1" )
        {
            refreshAlert.addAction(UIAlertAction(title: "Pick up", style: .default, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
                self.txtDelivery.text = "Pick up"
                self.strDeliveryType = "0"
                if(self.currentReachabilityStatus != .notReachable)
                {
                self.updatePickupOptionAPI()
                }
                else{
                    self.alertInternet()
                }
            }))
        }
        else if(strRestType == "2")
        {
            refreshAlert.addAction(UIAlertAction(title: "Delivery", style: .default, handler: { (action: UIAlertAction!) in
                //            self.logoutApi()
                
                self.dismiss(animated: true, completion: nil)
                self.txtDelivery.text = "Delivery"
                self.strDeliveryType = "1"
                if(self.currentReachabilityStatus != .notReachable)
                {
                self.updateDeliveyOptionAPI()
                }
                else{
                    self.alertInternet()
                }
                
            }))
        }
        else {
            refreshAlert.addAction(UIAlertAction(title: "Pick up", style: .default, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
                self.txtDelivery.text = "Pick up"
                self.strDeliveryType = "0"
                if(self.currentReachabilityStatus != .notReachable)
                {
                self.updatePickupOptionAPI()
                }
                else{
                    self.alertInternet()
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Delivery", style: .default, handler: { (action: UIAlertAction!) in
                //            self.logoutApi()
                
                self.dismiss(animated: true, completion: nil)
                self.txtDelivery.text = "Delivery"
                self.strDeliveryType = "1"
                if(self.currentReachabilityStatus != .notReachable)
                {
                self.updateDeliveyOptionAPI()
                }
                else
                {
                    self.alertInternet()
                }
                
            }))
        }
        present(refreshAlert, animated: true, completion: nil)
    }
    
    private func showAlertInstructions()
    {
        
        let alertController = UIAlertController(title: "Instructions/Allergic", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let eventNameTextField = alertController.textFields![0] as UITextField
            eventNameTextField.autocapitalizationType = .words
            
            print("firstName \(String(describing: eventNameTextField.text))")
            
            let strName = eventNameTextField.text?.trimmingCharacters(in: .whitespaces)
            if  ((strName) != "") {
                var str = eventNameTextField.text!.trimmingCharacters(in: .whitespaces)
                print(str)
                
                if(self.currentReachabilityStatus != .notReachable)
                {
                    self.updateInstructionAPI(strOption: str)
                    self.txtInstructions.text = str
                    
                    // loginAPICall(email : strEmail, password : strPassword)
                }
                else{
                    self.alertInternet()
                }
                
            }
            
        })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Instructions/Allergic"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        //        saveAction.setValue(UIColor.black, forKey: "titleTextColor")
        //        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func alertAddressOutReach(title : String, Message : String) -> Void
    {
        
        let refreshAlert = UIAlertController(title: title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        
//        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
//            self.dismiss(animated: true, completion: nil)
//        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Change address", style: .default, handler: { (action: UIAlertAction!) in
            //            self.logoutApi()
            self.tabBarController?.selectedIndex = 1
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func alertCouponAlready() -> Void
    {
        let refreshAlert = UIAlertController(title: "Coupon already applied", message: "If you want to apply pennies then applied coupon would be deleted", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //            self.logoutApi()
            if(self.currentReachabilityStatus != .notReachable)
            {
            self.updatePennyAppliedAPI(strApplied: "1", flag: 0)
            }
            else
            {
                self.alertInternet()
            }
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func alertPennyAlready() -> Void
    {
        let refreshAlert = UIAlertController(title: "Penny already applied", message: "If you want to apply coupon then applied pennies would be deleted", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //            self.logoutApi()
            if(self.currentReachabilityStatus != .notReachable)
            {
            self.updatePennyAppliedAPI(strApplied: "0", flag: 1)
            }
            else
            {
                self.alertInternet()
            }
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func alertOrderPlaced(str : String) -> Void
    {
        let refreshAlert = UIAlertController(title: "Order Placed", message: "Order has been placed successfully. \n Your order id is \(str)", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            //            self.logoutApi()
            self.flagScreen = 2
            self.strOrderId = str
            
            self.performSegue(withIdentifier: "orderstatus", sender: "")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func alertOnlinePayment() -> Void
    {
        let refreshAlert = UIAlertController(title: "Pay via", message: "Select the payment method to pay and place your order", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Pay with card", style: .default, handler: { (action: UIAlertAction!) in
            if(self.currentReachabilityStatus != .notReachable)
            {
            self.didRequestPayWithCard()
            }
            else
            {
                self.alertInternet()
            }
        }))
       
        
        refreshAlert.addAction(UIAlertAction(title: "Apple pay", style: .default, handler: { (action: UIAlertAction!) in
//            self.logoutApi()
            self.requestApplePayAuthorization()
           
        }))

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            self.btnPlaceOrder.isEnabled = true
            self.btnCard.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
            self.btnCash.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
            self.dismiss(animated: true, completion : nil)
        })
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        refreshAlert.addAction(cancelAction)
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func alertOrderPlaced() -> Void
    {
        let refreshAlert = UIAlertController(title: "Confirm your order", message: "Are you sure you want to place the order with these items", preferredStyle: UIAlertController.Style.alert)
        
       
       
        
        refreshAlert.addAction(UIAlertAction(title: "Pay & Place Order", style: .default, handler: { (action: UIAlertAction!) in
//            self.logoutApi()
            self.dismiss(animated: true, completion : nil)
            self.txtTotalPay.text =  "£" + self.strAmount
            self.viewpayment.isHidden = false
           // self.placeOrderAPI()
           
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            self.btnPlaceOrder.isEnabled = true
            self.btnCard.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
            self.btnCash.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
            self.dismiss(animated: true, completion : nil)
        })
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        refreshAlert.addAction(cancelAction)

   //     refreshAlert.addAction(cancelAction)
        
        present(refreshAlert, animated: true, completion: nil)
    }
}






extension CartController: UINavigationControllerDelegate {
    func navigationControllerSupportedInterfaceOrientations(
        _: UINavigationController
    ) -> UIInterfaceOrientationMask {
        return .portrait
    }

}

extension CartController {
    func makeCardEntryViewController() -> SQIPCardEntryViewController {
        let theme = SQIPTheme()
        theme.tintColor = .red
        theme.saveButtonTitle = "Pay with card"
        let cardEntry = SQIPCardEntryViewController(theme: theme)
        cardEntry.collectPostalCode = false
        cardEntry.delegate = self
        
        return cardEntry
    }
}

//Handle the card entry success or failure from the card entry form
extension CartController:SQIPCardEntryViewControllerDelegate {
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
        // Note: If you pushed the card entry form onto an existing navigation controller,
        // use UINavigationController.popViewController(animated:) instead
        dismiss(animated: true) {
            print(status)
            switch status {
            case .canceled:
                self.btnPlaceOrder.isEnabled = true
                self.strPaymentType = 0

                self.btnCard.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
                self.btnCash.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
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
        
//        updateChargeAPI(cardDetails.nonce){ (transactionID, errorDescription) in
//            guard let errorDescription = errorDescription else {
//                //                // No error occured, we successfully charged
//
//                //  self.navigationController!.popViewController(animated:true)
//                return
//            }
//            return
//        }
    }
}


extension CartController {
    func requestApplePayAuthorization() {
        guard SQIPInAppPaymentsSDK.canUseApplePay else {
            return
        }
        let paymentRequest = PKPaymentRequest.squarePaymentRequest(
            // Set to your Apple merchant ID
            merchantIdentifier: "merchant.com.food.xeat.Xeat",
            countryCode: "GB",
            currencyCode: "GBP"
        )
        
        // Payment summary information will be displayed on the Apple Pay sheet.
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Pay for order", amount: NSDecimalNumber(string: "1")),

           // PKPaymentSummaryItem(label: "Pay for order", amount: NSDecimalNumber(string: strAmount)),
        ]
        
        let paymentAuthorizationViewController =
            PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        
        paymentAuthorizationViewController!.delegate = self
        
        present(paymentAuthorizationViewController!, animated: true, completion: nil)
    }
}

extension CartController : PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(
        _: PKPaymentAuthorizationViewController
    ) {
        self.btnPlaceOrder.isEnabled = true
        self.strPaymentType = 0

        dismiss(animated: true, completion: nil)
    }
    
    
    func paymentAuthorizationViewController(
        _: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (
            PKPaymentAuthorizationResult) -> Void
    ) {
        // Exchange the authorized PKPayment for a nonce.
        let nonceRequest = SQIPApplePayNonceRequest(payment: payment)
        nonceRequest.perform { [self] cardDetails, error in
            if let cardDetails = cardDetails {
//                print(payment)
//                print(cardDetails)
                // Send the card nonce to your server to charge the card or store
                // the card on file.
                
                self.updateChargeAPI(cardDetails.nonce){ (transactionID, errorDescription) in
                    guard let errorDescription = errorDescription else {
                        //                // No error occured, we successfully charged
                        
                        //  self.navigationController!.popViewController(animated:true)
                        return
                    }
                    return
                }
                 
                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                } else if let error = error {
                    print(error)
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
                }
            }
        }
        
    }

