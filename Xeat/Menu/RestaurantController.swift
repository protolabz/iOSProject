//
//  RestaurantController.swift
//  Xeat
//
//  Created by apple on 23/12/21.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage


class RestaurantController: UIViewController,  UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate,  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var edInstruction: UITextView!
    @IBAction func imgBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var txtRestHeading: UILabel!
    @IBAction func btnViewCart(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        screenFlag = 0
    
        performSegue(withIdentifier: "cart2", sender: nil)
        }
        else{
            alertInternet()
        }
    }
    var strSelectedSize = "R"
    var searchApplied = 0
    var arrOfTopCategory : [DatumCategory]  = []
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var txtAlertItemCount: UILabel!
    @IBOutlet weak var btnAlertCancel: UIButton!
    @IBOutlet weak var btnAlertUpdate: UIButton!
    @IBOutlet weak var txtAlertItemNAme: UILabel!
    @IBOutlet weak var imgMinus: UIImageView!
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var viewPlusMinus: UIView!
    var screenFlag = 0
    @IBOutlet weak var txtCartTotal: UILabel!
    @IBOutlet weak var viewCartTotal: UIView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    var arrOfMenu : [JSON] = []
    var arrOfALLMenu : [JSON] = []
    var arrOfSearchMenu  : [JSON] = []
    var strRestId = ""
    var strCommision = "0"
    var strPhonNumber = ""
    var strRestLatitude = ""
    var strRestLongitude = ""
    var strLatitude = ""
    var strLongitude = ""
    var strSelectedIndex = 0
    var arrOfAddToCartItem : [JSON] = []
    var strCellItemCount = ""
    var selectedPosition = 0
    var previousCount = 0
    var instructions = ""
    var restIDForCartItem = "0"
    
    @IBOutlet weak var viewInnerPlusMinus: UIView!
    
    @IBOutlet weak var edSearch: UITextField!
    @IBOutlet weak var viewhalal: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var imgRestaurant: UIImageView!
    
    @IBOutlet weak var txtHalal: UILabel!
    @IBOutlet weak var txtName: UILabel!
    
    @IBOutlet weak var txtRating: UITextField!
    @IBOutlet weak var txtOpenClose: UILabel!
    
    @IBOutlet weak var imgCall: UIImageView!
    @IBOutlet weak var imgDirection: UIImageView!
    @IBOutlet weak var txtDistance: UILabel!
    
    @IBOutlet weak var txtFoodRating: UILabel!
    @IBOutlet weak var txtDeliveryPickup: UILabel!
    
    @IBOutlet weak var txtMinimumOrder: UITextField!
    @IBOutlet weak var txtDeliveryTime: UILabel!
    @IBOutlet weak var txtPhone: UILabel!
    @IBOutlet weak var txtLocation: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        
        //restaurantDetail()
        if(currentReachabilityStatus != .notReachable)
        {
            restaurantDetail()
            menuList()
            categoryAPI()
        }
        else
        {
            alertInternet()
        }
        
    }
    
    
    func initViews()
    {
         
        viewPlusMinus.isHidden = true
        self.imgSearch.isHidden = true
        txtHalal.isHidden = true
        viewhalal.isHidden = true
        
        self.setupToHideKeyboardOnTapOnView()
        let nib = UINib(nibName: "MenuViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MenuViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        
        scrollView.delegate = self
        scrollView.bounces = false
        tableView.bounces = false
        tableView.isScrollEnabled = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.setCollectionViewLayout(layout, animated: true)

        self.collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "RestCategoryCell", bundle: nil), forCellWithReuseIdentifier: "RestCategoryCell")
        collectionView.clipsToBounds = true
        

      //  collectionFlowLayout.itemSize = CGSize(width: 145, height: 145)
    
        
        
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 20
        
        viewInnerPlusMinus.layer.borderWidth = 0.5
        viewInnerPlusMinus.layer.masksToBounds = false
        viewInnerPlusMinus.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewInnerPlusMinus.layer.cornerRadius = 10
        
        viewCartTotal.isHidden = true
        
        
        if(UserDefaults.standard.string(forKey: Constant.USERLATITUDE) != nil)
        {
            strLatitude = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
            strLongitude = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
            
        }
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(systemName: "star.fill")
        leftImageView.tintColor = UIColor.red
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView.frame = CGRect(x: 12, y: 8, width: 15, height: 12)
        txtRating.leftViewMode = .always
        txtRating.leftView = leftView
        
        btnAlertCancel.layer.cornerRadius=10
        btnAlertCancel.clipsToBounds=true
        
        btnAlertUpdate.layer.cornerRadius=10
        btnAlertUpdate.clipsToBounds=true
        
        
        txtOpenClose.layer.cornerRadius = 5
        txtOpenClose.layer.masksToBounds = true
        
        txtDeliveryPickup.layer.masksToBounds = true
        txtDeliveryPickup.layer.cornerRadius = 5
        
        txtDistance.layer.masksToBounds = true
        txtDistance.layer.cornerRadius = 5
        
        edInstruction.layer.masksToBounds = true
        edInstruction.layer.backgroundColor = #colorLiteral(red: 0.9488552213, green: 0.9487094283, blue: 0.9693081975, alpha: 1)
        edInstruction.tintColor = .black
        edInstruction.clipsToBounds = true
        edInstruction.layer.cornerRadius = 5
        edInstruction.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        edInstruction.layer.borderWidth = 0.3
        edInstruction.isScrollEnabled = false
        
        imgCall.isUserInteractionEnabled = true
        imgCall.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.makeCall)))
        
        imgDirection.isUserInteractionEnabled = true
        imgDirection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.redirectToMaps)))
        
        imgPlus.isUserInteractionEnabled = true
        imgPlus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnPlus)))
        
        imgMinus.isUserInteractionEnabled = true
        imgMinus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnMinus)))
        
        imgSearch.isUserInteractionEnabled = true
        imgSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchMenu)))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2.7 - lay.minimumInteritemSpacing

            return CGSize(width:widthPerItem, height:collectionView.frame.height-10 )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        if(UserDefaults.standard.string(forKey: Constant.USERLATITUDE) != nil)
        {
            strLatitude = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
            strLongitude = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
            
            //restaurantDistanceAPI()
        }
        else
        {
            
            self.alertSucces(title: "No address selected", Message: "You haven't select any address yet. Please select from delivery tab")
        }
        if(currentReachabilityStatus != .notReachable)
        {
            fetchCartDetail()
        }
        else{
            alertInternet()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"
        {
            if let newValue = change?[.newKey]
            {
                let newSize  = newValue as! CGSize
                self.tblHeight.constant = newSize.height
            }
            
        }
    }
    
    
    @objc func searchMenu()
    {
        if(self.currentReachabilityStatus != .notReachable)
        {
        self.screenFlag = 2
        performSegue(withIdentifier: "searchmenu", sender: nil)
        }
        else
        {
            alertInternet()
        }
        }
    
    @objc func makeCall()
    {
        guard let number = URL(string: "tel://" + strPhonNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    @objc func redirectToMaps()
    {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            UIApplication.shared.open(NSURL(string:
                                                "comgooglemaps://?saddr=\(strLatitude),\(strLongitude)&daddr=\(strRestLatitude),\(strRestLongitude))&directionsmode=driving")! as URL)
            
            
        } else
        {
            //        NSLog("Can't use com.google.maps://");
            //        let directionsURL = "http://maps.apple.com/?saddr=&daddr=\(Float(strRestLatitude)),\(Float(strRestLongitude))&directionsmode=driving"
            let directionsURL = "http://maps.apple.com/?saddr=\(strLatitude),\(strLongitude)&daddr=\(strRestLatitude),\(strRestLongitude)&directionsmode=driving"
            print(directionsURL)
            guard let url = URL(string: directionsURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    //    override func viewWillAppear(_ animated: Bool) {
    //        navigationController?.setNavigationBarHidden(false, animated: animated)
    //        }
    //
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrOfTopCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestCategoryCell", for: indexPath) as! RestCategoryCell
        cell.txtName.text = arrOfTopCategory[indexPath.row].cName
        //
        //        let urlYourURL = URL (string:"\(arrOfTopCategory[indexPath.row].image)" )
        //        cell.imgCategory.loadurl(url: urlYourURL!)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        screenFlag = 5
        strSelectedIndex = indexPath.row
        self.performSegue(withIdentifier: "categorymenu", sender: nil)
        }
        else
        {
            alertInternet()
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfMenu.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "MenuViewCell", for: indexPath) as! MenuViewCell
        cell2.txtName.text = "\(self.arrOfMenu[indexPath.row]["name"])"
        cell2.txtIngreden.text =  "\(self.arrOfMenu[indexPath.row]["Ingredients"])"
        let newPrice = ((Double("\(self.arrOfMenu[indexPath.row]["f_price"])"))!/100) * Double(strCommision)!
        
        // let newRoundPrice = newPrice.round(2)
        let itemPrice = newPrice + (Double("\(self.arrOfMenu[indexPath.row]["f_price"])")!)
        
        cell2.txtPrice.text = "£"  +  "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
        cell2.txtNumber.text = "0"
    
        
        if(arrOfMenu[indexPath.row]["is_popular_item"] == "1")
        {
            
            cell2.txtPopular.isHidden = false
        }
        else{
            cell2.txtPopular.isHidden = true
        }
        if(arrOfMenu[indexPath.row]["status"] != "1")
        {
            cell2.imgMinus.isHidden = true
            cell2.imgPlus.isHidden = true
            cell2.txtNumber.isHidden = true
            cell2.txtOutOfStock.isHidden = false
            //  cell2.btnExtra.isHidden = true
            
        }
        else
        {
            cell2.imgMinus.isHidden = false
            cell2.imgPlus.isHidden = false
            cell2.txtNumber.isHidden = false
            cell2.txtOutOfStock.isHidden = true
            //  cell2.btnExtra.isHidden = false
        }
        cell2.imgPlus.tag = indexPath.row
        cell2.imgPlus.addTarget(self, action: #selector(updatePlus(_:)), for: .touchUpInside)
        
        if("\(cell2.txtNumber.text)" != "0")
        {
            strCellItemCount = cell2.txtNumber.text!
            cell2.imgMinus.tag = indexPath.row
            cell2.imgMinus.addTarget(self, action: #selector(updateMinus(_:)), for: .touchUpInside)
        }
        
        let xs = "\(arrOfMenu[indexPath.row]["id"])"
        var count = 0
        for i in 0..<arrOfAddToCartItem.count
        {
            
            if(xs == "\(arrOfAddToCartItem[i]["menu_item_id"])")
            {
                let vala = "\(arrOfAddToCartItem[i]["count"])"
                
                count += Int(vala)!
            }
        }
        cell2.txtNumber.text = "\(count)"
        
        
        
        cell2.selectionStyle = .none
        return cell2
        
    }
    
    
    
    @objc func updatePlus(_ sender: UIButton) {
        instructions = ""
        print("plus clicked===============")
        // if(restIDForCartItem != "0")
        print(strRestId)
        print(restIDForCartItem)
        if( (restIDForCartItem != "0") && (strRestId != restIDForCartItem))
        {
            alertCartDelete()
        }
        else
        {
            let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
            if(strUserId == "2")
            {
                alertUIGuestUser()
            }
            else
            {
                if(self.currentReachabilityStatus != .notReachable)
                {
                    selectedPosition = sender.tag
                    let sizeAddOn  = ("\(self.arrOfMenu[selectedPosition]["is_size_available"])")
                    if((("\(self.arrOfMenu[selectedPosition]["is_submenu_exist"])")
                            == "1") ||  ( sizeAddOn  == "1") )
                    {
                        
                        editTap()
                        
                    }
                    else
                    {
                        viewPlusMinus.isHidden = false
                        
                        txtAlertItemNAme.text = "Update item :- \(self.arrOfMenu[sender.tag]["name"])"
                        var count = "0"
                        var countAddOn = 0
                        
                        let xs = "\(arrOfMenu[selectedPosition]["id"])"
                        for i in 0..<arrOfAddToCartItem.count
                        {
                            if(xs == "\(arrOfAddToCartItem[i]["menu_item_id"])")
                            {
                                
                                if("\(arrOfAddToCartItem[i]["is_add_on"])" != "1")
                                {
                                    count = "\(arrOfAddToCartItem[i]["count"])"
                                }
                                else{
                                    let newcount = Int("\(arrOfAddToCartItem[i]["count"])")
                                    countAddOn += newcount!
                                }
                                // instructions = ""
                                if( !"\(arrOfAddToCartItem[i]["instruction"])".isEmpty)
                                {
                                    
                                    instructions = "\(arrOfAddToCartItem[i]["instruction"])"
                                }
                                else
                                {
                                    instructions = ""
                                }
                                
                            }
                            
                        }
                        strSelectedSize = "R"
                        previousCount = countAddOn  + Int(count)!
                        
                        edInstruction.text = instructions
                        txtAlertItemCount.text = "\(count)"
                        txtAlertItemNAme.text = "Update item :- \(self.arrOfMenu[sender.tag]["name"])"
                    }
                    
                }
                
                else{
                    self.alertInternet()
                }
            }
            
        }
    }
    
    
    @objc func updateMinus(_ sender: UIButton)
    {
        instructions = ""
        print("minus clicked===============")
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        if(strUserId == "2")
        {
            alertUIGuestUser()
        }
        else
        {
            if(self.currentReachabilityStatus != .notReachable)
            {
                selectedPosition = sender.tag
                
                var count = "0"
                var flag = 0
                
                let xs = "\(arrOfMenu[selectedPosition]["id"])"
                var sizeItem : [String] = []
                for i in 0..<arrOfAddToCartItem.count
                {
                    
                    if(xs == "\(arrOfAddToCartItem[i]["menu_item_id"])")
                    {
                        
                        let size = "\(arrOfAddToCartItem[i]["menu_item_size"])"
                        sizeItem.append(size)
                        if("\(arrOfAddToCartItem[i]["is_add_on"])" == "1" )
                        {
                            flag = 1
                        }
                        else{
                            count = "\(arrOfAddToCartItem[i]["count"])"
                            
                        }
                        instructions = ""
                        if( !"\(arrOfAddToCartItem[i]["instruction"])".isEmpty)
                        {
                            instructions = "\(arrOfAddToCartItem[i]["instruction"])"
                        }
                        else
                        {
                            instructions = ""
                        }
                    }
                    
                }
                
                let unique = Array(Set(sizeItem))
                print(unique)
                if(unique.count > 0){
                    if(unique.count == 1)
                    {
                        
                    }
                    else{
                        flag = 1
                    }
                    
                    if(flag == 1)
                    {
                        self.alertFailure(title: "Customized items", Message: "There are customizated items in your cart, please go to cart to delete items")
                    }
                    else{
                        print("size")
                        print(unique)
                        
                        strSelectedSize = unique[0]
                        previousCount = Int(count)!
                        viewPlusMinus.isHidden = false
                        
                        //            viewPlusMinus.alpha = 0.9
                        txtAlertItemCount.text = count
                        txtAlertItemNAme.text = "Update item :- \(self.arrOfMenu[sender.tag]["name"])"
                        edInstruction.text = instructions
                        txtAlertItemCount.text = "\(count)"
                    }
                }
            }
            else{
                self.alertInternet()
            }
        }
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
    
    @IBAction func btnAlertCAncel(_ sender: Any) {
        viewPlusMinus.isHidden = true
    }
    @IBAction func btnAlertUpdate(_ sender: Any) {
        let strInstruction = edInstruction.text.trimmingCharacters(in: .whitespacesAndNewlines)
        print(instructions)
        let strText = txtAlertItemCount.text?.trimmingCharacters(in: .whitespaces)
        //        updateItemCountAPI(strCount : strText! )
        print(previousCount)
        print( Int(strText!) as Any)
        if((previousCount !=  Int(strText!)) )
        {
            let newPrice = (Double("\(self.arrOfMenu[selectedPosition]["f_price"])")!/100) * Double(strCommision)!
            let itemPrice = newPrice + (Double("\(self.arrOfMenu[selectedPosition]["f_price"])")!)
            let actualPrice = "\(self.arrOfMenu[selectedPosition]["f_price"])"
            //   let count = Int("\(self.arrOfMenu[indexPath.row]["count"])")
            let commissionPrice =   "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
            // updateCartProductAPI(position: sender.tag, count: "1")
            viewPlusMinus.isHidden = true
            if(self.currentReachabilityStatus != .notReachable)
            {
            addDeleteToCartAPI(position : selectedPosition, operation : "2", commissionPrice: commissionPrice ,count: strText!, actualPrice : actualPrice, strInstruction:  strInstruction)
            }
            else
            {
                alertInternet()
            }
            
        }
        else if((instructions != strInstruction) && (strText != "0") )
        {
            let newPrice = (Double("\(self.arrOfMenu[selectedPosition]["f_price"])")!/100) * Double(strCommision)!
            let itemPrice = newPrice + (Double("\(self.arrOfMenu[selectedPosition]["f_price"])")!)
            let actualPrice = "\(self.arrOfMenu[selectedPosition]["f_price"])"
            //   let count = Int("\(self.arrOfMenu[indexPath.row]["count"])")
            let commissionPrice =   "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
            // updateCartProductAPI(position: sender.tag, count: "1")
            viewPlusMinus.isHidden = true
            if(self.currentReachabilityStatus != .notReachable)
            {
            addDeleteToCartAPI(position : selectedPosition, operation : "2", commissionPrice: commissionPrice ,count: strText!, actualPrice : actualPrice, strInstruction:  strInstruction)
            }
            else{
                alertInternet()
            }
        }
        else{
            
            print("update else working, previous count ")
            print(previousCount)
            print(strText)
            
        }
    }
    
    
    func editTap()
    {
        if(self.currentReachabilityStatus != .notReachable)
        {
        strSelectedIndex = selectedPosition
        
        screenFlag = 1
        performSegue(withIdentifier: "msize", sender: nil)
        }
        else
        {
            alertInternet()
        }
        //        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(screenFlag == 1)
        {
            let secondViewController = segue.destination as! MenuSizeController
            let strMenuId =  "\(self.arrOfMenu[strSelectedIndex]["id"])"
            
            let newPrice = (Double("\(self.arrOfMenu[strSelectedIndex]["f_price"])")!/100) * Double(strCommision)!
            let itemPrice = newPrice + (Double("\(self.arrOfMenu[strSelectedIndex]["f_price"])")!)
            let actualPrice = "\(self.arrOfMenu[strSelectedIndex]["f_price"])"
            let commissionPrice =   "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
            let name = "\(self.arrOfMenu[strSelectedIndex]["name"])"
            let sizeAvailable = "\(self.arrOfMenu[selectedPosition]["is_size_available"])"
            
            
            secondViewController.strMenuId = strMenuId
            secondViewController.strActualPrice = actualPrice
            secondViewController.strCommissionPrice = commissionPrice
            secondViewController.strCommision = strCommision
            secondViewController.strItemName = name
            secondViewController.isSizeAvailable = Int(sizeAvailable)!
            secondViewController.strItemCommission = Double(strCommision)!
            screenFlag = 0
        }
        else if(screenFlag == 2){
            let secondViewController = segue.destination as! SearchMenuController
            secondViewController.strRestId = strRestId
            secondViewController.strCommision = strCommision
            secondViewController.screenType = 0
            secondViewController.searchId = "0"
            screenFlag = 0
        }
        else if(screenFlag == 5){
            let secondViewController = segue.destination as! CategoryMenuController
            secondViewController.strRestId = strRestId
            secondViewController.strCommision = strCommision
            secondViewController.strCategoryName = "\(arrOfTopCategory[strSelectedIndex].cName)"
            secondViewController.searchId = "\(arrOfTopCategory[strSelectedIndex].id)"
            secondViewController.screenType = 1
            screenFlag = 0
        }
        else{
            //            let secondViewController = segue.destination as! SizesAddOnController
            //            let strMenuId =  "\(self.arrOfMenu[strSelectedIndex]["id"])"
            //
            //            let newPrice = (Double("\(self.arrOfMenu[strSelectedIndex]["f_price"])")!/100) * Double(strCommision)!
            //            let itemPrice = newPrice + (Double("\(self.arrOfMenu[strSelectedIndex]["f_price"])")!)
            //            let actualPrice = "\(self.arrOfMenu[strSelectedIndex]["f_price"])"
            //            let commissionPrice =   "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
            //            let name = "\(self.arrOfMenu[strSelectedIndex]["name"])"
            //            let sizeAvailable = "\(self.arrOfMenu[selectedPosition]["is_size_available"])"
            //
            //            secondViewController.strMenuId = strMenuId
            //            secondViewController.strActualPrice = actualPrice
            //            secondViewController.strCommissionPrice = commissionPrice
            //            secondViewController.strCommision = strCommision
            //            secondViewController.strItemName = name
            //            secondViewController.isSizeAvailable = Int(sizeAvailable)!
            //            screenFlag = 0
        }
        
    }
    
    
    //*********************************SET JSON DATA IN VIEW **********************************************//
    
    func setDataInView(json : JSON)
    {
        
        strPhonNumber = "\(json["contact_number"])"
        strRestLatitude = "\(json["r_lat"])"
        strRestLongitude = "\(json["r_long"])"
        
        strCommision = "\(json["rest_commission"])"
        
        txtName.text = "\(json["name"])"
        txtRestHeading.text = "\(json["name"])"
        txtLocation.text = "\(json["location"])"
        
        txtPhone.text = "\(json["contact_number"])"
        txtLocation.text = "\(json["location"])"
        
        let urlYourURL = URL (string:"\(json["image"])" )
        imgRestaurant.loadurl(url: urlYourURL!)
        
        let str = Double("\(json["rating"])")
        txtRating.text = String(format: "%.1f", str!)
        
        let distance = Double("\(json["distance"])")
        txtDistance.text = "\(String(format: "%.2f", distance!))" + " mi"
        
        txtFoodRating.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Food Hygenic rating", comment: "") + " : " + "\(json["food_hygine"])"
        
        txtMinimumOrder.text = "£"  + "\(json["Minimum_Order"])" + " " + LocalizationSystem.sharedInstance.localizedStringForKey(key: "min order", comment: "")
        
        txtDeliveryTime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delivery in", comment: "") + " " + "\(json["preparing_t"])" + " " +  LocalizationSystem.sharedInstance.localizedStringForKey(key: "minutes", comment: "")
      
        if("\(json["hallal_certified"])" == "0")
        {
            txtHalal.isHidden = true
            viewhalal.isHidden = true
        
        }
        else{
            txtHalal.isHidden = false
            viewhalal.isHidden = false
            
        }
        if("\(json["status"])" != "2")
        {
        txtOpenClose.layer.masksToBounds = true
            
            txtOpenClose.text = (LocalizationSystem.sharedInstance.localizedStringForKey(key: "Close", comment: ""))
           txtOpenClose.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
          
          alertSucces(title: "Restaurant closed", Message: "This restaurant is not available to accept the orders for now")
        }
        
        else{
            txtOpenClose.text = (LocalizationSystem.sharedInstance.localizedStringForKey(key: "Open", comment: ""))
          txtOpenClose.backgroundColor = #colorLiteral(red: 0.3315239549, green: 0.8227620721, blue: 0.2893715203, alpha: 1)
         
        }
        
        
        if("\(json["rest_type"])" == "1")
        {
            txtDeliveryPickup.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Pickup", comment: "")
        }
        else
        {
            txtDeliveryPickup.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delivery", comment: "")
        }
        
        
        if("\(json["rest_type"])" == "1")
        {
            
        }
        else{
            if(UserDefaults.standard.string(forKey: Constant.USERLATITUDE) != nil)
            {
                strLatitude = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
                strLongitude = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
                print("============")
                print(strLatitude)
                restaurantDistanceAPI()
            }
            else
            {
                
                self.alertSucces(title: "No address selected", Message: "You haven't select any address yet. Please select from delivery tab")
            }
            
        }
        
        
    }
    
    
    
    
    //****************************************************API**********************************************//
    func restaurantDetail()
    {
        let param =
            ["accesstoken" : Constant.APITOKEN, "r_id" : strRestId , "src_lati": strLatitude , "src_long":strLongitude]
        print(param)
        APIsManager.shared.requestService(withURL: Constant.restaurantDeatil, method: .post, param: param, viewController: self) { (json) in
            print(json)
            
            
            if("\(json["code"])" == "201")
            {
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
            else
            {
                self.setDataInView(json: json["data"])
                self.imgSearch.isHidden = false
            }
            
        }
    }
    
    func restaurantDistanceAPI()
    {
        
        let param =
            ["accesstoken" : Constant.APITOKEN, "rest_id" : strRestId , "user_lat": strLatitude , "user_lng":strLongitude]
        print(param)
        APIsManager.shared.requestService(withURL: Constant.restaurantDistanceAPI, method: .post, param: param, viewController: self) { (json) in
            print(json)
            
            
            if("\(json["code"])" == "201")
            {
                self.alertSucces(title: "Wait for a moment", Message: "\(json["message"])")
            }
            else
            {
                // self.setDataInView(json: json["data"])
            }
            
        }
    }
    
    func menuList()
    {
        self.arrOfMenu.removeAll()
        let param =
            ["accesstoken" : Constant.APITOKEN,"rid": strRestId ]
        print(param)
        AF.request(Constant.baseURL + Constant.menuListAPI , method: .post, parameters: param).validate().responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
            case .success:
                print("Menu list success")
                // self.indicator.isHidden = true
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let status = data["code"]
                        print(json)
                        if(status == "200")
                        {
                            for i in 0..<data["data"].count
                            {
                                self.arrOfMenu.append(data["data"][i])
                            }
                            //  print(self.arrOfMenu.count)
                            self.arrOfALLMenu = self.arrOfMenu
                            self.tableView.reloadData()
                            //                            self.collectionView.reloadData()
                        }
                        else
                        {
                            self.imgSearch.isHidden = true
                            self.alertSucces(title: "No menu found", Message: "This restaurant doesn't add their menu yet")
                        }
                    }
                    catch{
                        
                        //                        self.indicator.isHidden = true
                        print(error)
                    }
                    
                }
            case .failure(let error):
                print(error)
                
            //                self.indicator.isHidden = true
            }
        }
    }
    func categoryAPI()
    {
        let param =
            ["accesstoken" : Constant.APITOKEN,"rest_id": strRestId ]
        print(param)
        AF.request(Constant.baseURL + Constant.categoryAPI , method: .post, parameters: param).validate().responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
            case .success:
                //  print("Validation Successful)")
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let status = data["code"]
                        if(status == "200")
                        {
                            let arrdata =  try JSONDecoder().decode(CategoryList.self, from: response.data!)
                            self.arrOfTopCategory = arrdata.data
                            self.collectionView.reloadData()
                        }
                        else
                        { }
                    }
                    catch{
                        print(error)
                    }
                    
                }
            case .failure(let error):
                print(error)
                
            //  self.indicator.isHidden = true
            }
        }
    }
    
    func addDeleteToCartAPI(position : Int, operation : String, commissionPrice : String, count : String, actualPrice : String, strInstruction : String)
    {
        
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "menu_item_id" : "\(arrOfMenu[position]["id"])", "price" : commissionPrice, "Add_on" : "0", "count": count, "operation" : operation, "actual_price" : actualPrice , "size" : strSelectedSize, "item_instruction": strInstruction]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.addDeleteItemToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            
            if("\(json["status"])" == "200")
            {
                self.arrOfAddToCartItem.removeAll()
                self.viewCartTotal.isHidden = false
                let itemPrice = Double("\(json["total_Item_amount"])")
                //    cell2.txtPrice.text = "£"  + "\(self.arrOfMenu[indexPath.row]["f_price"])"
                UserDefaults.standard.setValue( "\(json["data"][0]["cart_id"])", forKey: Constant.CART_ID)
                self.txtCartTotal.text = "\(json["cart_items"])" + " items" + " | " + "£" + "\(String(format: "%.2f", itemPrice!.rounded(digits: 2)))"
                for i in 0..<json["data"].count
                {
                    self.arrOfAddToCartItem.append(json["data"][i])
                }
                print(self.arrOfAddToCartItem.count)
                //
                self.tableView.reloadData()
                // self.alertCartDelete()
                
            }
            else if("\(json["status"])" == "202")
            {
                self.alertCartDelete()
            }
            else if("\(json["status"])" == "201")
            
            {
                self.viewCartTotal.isHidden = true
                self.arrOfAddToCartItem.removeAll()
                self.tableView.reloadData()
                //
                //
            }
            
        }
    }
    
    func fetchCartDetail()
    {
        arrOfAddToCartItem.removeAll()
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.cartDetailAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            
            if("\(json["status"])" == "200")
            {
                self.restIDForCartItem = "\(json["restaurant_detail"]["id"])"
                
                self.viewCartTotal.isHidden = false
                let itemPrice = Double("\(json["total_Item_amount"])")
                //    cell2.txtPrice.text = "£"  + "\(self.arrOfMenu[indexPath.row]["f_price"])"
                UserDefaults.standard.setValue( "\(json["data"][0]["cart_id"])", forKey: Constant.CART_ID)
                self.txtCartTotal.text = "\(json["cart_items"])" + " items" + " | " + "£" + "\(String(format: "%.2f", itemPrice!.rounded(digits: 2)))"
                //                if()
                for i in 0..<json["data"].count
                {
                    self.arrOfAddToCartItem.append(json["data"][i])
                }
                print(self.arrOfAddToCartItem.count)
                //
                self.tableView.reloadData()
                
            }
            
            else if("\(json["status"])" == "202")
            {
                self.alertCartDelete()
            }
            else if("\(json["status"])" == "204")
            {
                self.restIDForCartItem = "\(json["restaurant_detail"]["id"])"
                //  self.alertSucces(title: "Wait for a while", Message: "\(json["message"])" )
            }
            else if("\(json["status"])" == "201")
            {
                self.restIDForCartItem = "0"
                self.arrOfAddToCartItem.removeAll()
                self.tableView.reloadData()
                self.viewCartTotal.isHidden = true            }
            else
            {
                
                // self.alertSucces(title: "Wait for a while", Message: "It seems some technical error occured please wait for a while")
            }
            
        }
    }
    
    func addOnRepeatAPI(position : Int, commissionPrice : String, count : String, actualPrice : String)
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "menu_item_id" : "\(arrOfMenu[position]["id"])", "price" : commissionPrice, "Add_on" : "2", "count": "1", "operation" : "1", "actual_price" : actualPrice, "repeat_add_on" : "1" ]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.addDeleteItemToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            
            if("\(json["status"])" == "200")
            {
                
                self.viewCartTotal.isHidden = false
                let itemPrice = Double("\(json["total_Item_amount"])")
                //    cell2.txtPrice.text = "£"  + "\(self.arrOfMenu[indexPath.row]["f_price"])"
                
                self.txtCartTotal.text = "\(json["cart_items"])" + " items" + " | " + "£" + "\(String(format: "%.2f", itemPrice!.rounded(digits: 2)))"
                self.arrOfAddToCartItem.removeAll()
                for i in 0..<json["data"].count
                {
                    self.arrOfAddToCartItem.append(json["data"][i])
                }
                print(self.arrOfAddToCartItem.count)
                //
                self.tableView.reloadData()
            }
            else
            {
                self.tableView.reloadData()
                self.alertCartDelete()
                self.arrOfAddToCartItem.removeAll()
                self.tableView.reloadData()
                //
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
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
            else
            {
                self.viewCartTotal.isHidden = true
                self.restIDForCartItem = "0"
                self.alertFailure(title: "Enjoy!!!", Message: "You can enjoy the best meals offered by this restaurant")
            }
            
        }
    }
    
    
    func alertCartDelete() -> Void
    {
        let refreshAlert = UIAlertController(title: "Cart contains orders from another restaurant", message: "Do you want to clear your cart and order from this restaurant instead?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //            self.logoutApi()
            if(self.currentReachabilityStatus != .notReachable)
            {
            self.removeCartDataAPI()
            }
            else
            {
                self.alertInternet()
            }
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func alertRepeatAddOn(position : Int, commissionPrice : String, count : String, actualPrice : String) -> Void
    {
        let refreshAlert = UIAlertController(title: "Last customization", message: "Do you want to add your last selected add-ons for this", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { (action: UIAlertAction!) in
            self.addOnRepeatAPI(position : position, commissionPrice : commissionPrice, count : count, actualPrice : actualPrice)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Choose", style: .default, handler: { (action: UIAlertAction!) in
            //            self.logoutApi()
            self.screenFlag = 1
            self.performSegue(withIdentifier: "addon", sender: nil)
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}
