//
//  GroceryItemController.swift
//  Xeat
//
//  Created by apple on 31/05/22.
//

import UIKit
import SwiftyJSON

class GroceryItemController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btnSeacrh: UIImageView!

    
    @IBOutlet weak var viewNoDataFound: UIView!
 
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    
   
    
    @IBOutlet weak var txtCartTotal: UILabel!
    @IBOutlet weak var viewCartTotal: UIView!
    @IBOutlet weak var txtHeading: UILabel!
    @IBOutlet weak var imgBack: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionItem: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func btnViewCart(_ sender: Any) {
      
        if(currentReachabilityStatus != .notReachable)
        {
            strScreenType = 1
        performSegue(withIdentifier: "cart2", sender: nil)
        }
        else{
            
            alertInternet()
        }
    }
    
    var previousCount = 0
    var strRestId = ""
    var strMainCategoryName = ""
    var txtCount = 0
    var strSelectedSubCat = ""
    var selectedPosition = 0
    var strCommission = ""
    var arrOfSubCategory : [JSON] = []
    var arrOfGroceryItem : [JSON] = []
    var strLatitude = ""
    var strLongitude = ""
    var strSelectedSize = ""
    var arrOfAddToCartItem : [JSON] = []
    var strScreenType = 0
    var strAgeLimit = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//    }
    
    func initView()
    {
        
        viewNoDataFound.isHidden = true
        if(UserDefaults.standard.string(forKey: Constant.USERLATITUDE) != nil)
        {
            strLatitude = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
            strLongitude = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        txtHeading.text = strMainCategoryName
       
        btnSeacrh.isUserInteractionEnabled = true
        btnSeacrh.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchCall)))
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SubCategoryCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCell")
        collectionView.clipsToBounds = true
        //        collectionView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        let layout2 = UICollectionViewFlowLayout()
        layout2.minimumLineSpacing = 5
        layout2.minimumInteritemSpacing = 5
        
        layout2.scrollDirection = .vertical
        //        layout2.estimatedItemSize = .zero
        //        layout2.itemSize = CGSize(collectionView.contentSize.width/2, 175)
        collectionItem.setCollectionViewLayout(layout2, animated: true)
        collectionItem.delegate = self
        collectionItem.dataSource = self
        collectionItem.register(UINib(nibName: "GroceryItemCell", bundle: nil), forCellWithReuseIdentifier: "GroceryItemCell")
        collectionItem.clipsToBounds = true
        //        imgPlus.isUserInteractionEnabled = true
        //        imgPlus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnPlus)))
        //
        //        imgMinus.isUserInteractionEnabled = true
        //        imgMinus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnMinus)))
        if(currentReachabilityStatus != .notReachable)
        {
        subCategoryAPI()
        }
        else{
            alertInternet()
        }
    }
    @objc func searchCall()
    {
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
        {
            alertUIGuestUser()
        }
        else{
            strScreenType = 1
            performSegue(withIdentifier: "search", sender: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if(UserDefaults.standard.string(forKey: Constant.USERLATITUDE) != nil)
        {
            strLatitude = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
            strLongitude = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
            
            //restaurantDistanceAPI()
        }
        else
        {
            
            if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
            {
                strLatitude = "51.8786707"
                strLongitude = "-0.4200255000000652"
               
            }
            else{
                self.alertSucces(title: "No address selected", Message: "You haven't select any address yet. Please select from delivery tab")
            }
           
        }
        if(currentReachabilityStatus != .notReachable)
        {
            fetchCartDetail()
        }
        else{
            alertInternet()
        }
    }
    //
    //    @objc func btnPlus() {
    //        var count =  Int(txtAlertItemCount.text!)
    //        count! += 1
    //        txtAlertItemCount.text = count?.description
    //
    //    }
    //    @objc func btnMinus() {
    //
    //        var count =  Int(txtAlertItemCount.text!)
    //        if(count! > 0)
    //        {
    //            count! -= 1
    //            txtAlertItemCount.text = count?.description
    //        }
    //    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.collectionView){
            return arrOfSubCategory.count
        }
        else{
            return arrOfGroceryItem.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        print("collection reload")
        if(collectionView == self.collectionView)
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
            if selectedPosition == indexPath.row
            {
                cell.viewUi.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.txtName.textColor = #colorLiteral(red: 0.9254901961, green: 0.1019607843, blue: 0.1411764706, alpha: 1)
 }
            else{
                cell.viewUi.backgroundColor =  #colorLiteral(red: 0.9254901961, green: 0.1019607843, blue: 0.1411764706, alpha: 1)
                cell.txtName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            cell.txtName.text = "\(arrOfSubCategory[indexPath.row]["subcategory_name"])"
            //  cell.txtName.text = "test long nane"
            
            return cell
        }
        else{
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroceryItemCell", for: indexPath) as! GroceryItemCell
            
            cell.imgCold.isHidden = true
            cell.imgCold.isHidden = true
            cell.btnMinus.isHidden = true
            cell.txtCount.isHidden = true
            cell.viewUi.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.viewUi.layer.borderWidth = 0
            cell.tctProductName.text = "\(arrOfGroceryItem[indexPath.row]["item_name"])"
            cell.txtWeight.text = "\(arrOfGroceryItem[indexPath.row]["quantity"])" + "\(arrOfGroceryItem[indexPath.row]["item_type"])"
            
            let newPrice = ((Double("\(self.arrOfGroceryItem[indexPath.row]["full_price"])"))!/100) * Double(strCommission)!
            
            // let newRoundPrice = newPrice.round(2)
            let itemPrice = newPrice + (Double("\(self.arrOfGroceryItem[indexPath.row]["full_price"])")!)
            
            cell.txtNormalPrice.text = "£"  +  "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
            
            if ("\(self.arrOfGroceryItem[indexPath.row]["discount_price"])" != "0")
            {
                if ("\(self.arrOfGroceryItem[indexPath.row]["discount_type"])" == "Fixed")
                {
                    cell.txtDiscountPrice.isHidden  = false
                    cell.txtNormalPrice.isHidden = false
                    let price = itemPrice.rounded(digits: 2)
                    cell.txtNormalPrice.attributedText =  NSAttributedString(string: "£" + "\(price)").withStrikeThrough(1)
                    
                    let discountedPrice = itemPrice - Double("\(self.arrOfGroceryItem[indexPath.row]["discount_price"])")!
                    cell.txtDiscountPrice.text = "£"  +  "\(String(format: "%.2f", discountedPrice.rounded(digits: 2)))"
                    
                }
                else{
                    cell.txtDiscountPrice.isHidden  = false
                    cell.txtNormalPrice.isHidden = false
                    let price = itemPrice.rounded(digits: 2)
                    cell.txtNormalPrice.attributedText =  NSAttributedString(string: "£" + "\(price)").withStrikeThrough(1)
                    
                    let dis = (Double("\(self.arrOfGroceryItem[indexPath.row]["discount_price"])")! / 100) * itemPrice
                    let discountedPrice = itemPrice - dis
                    cell.txtDiscountPrice.text = "£"  +  "\(String(format: "%.2f", discountedPrice.rounded(digits: 2)))"
                    
                }
            }
            else
            {
                cell.txtNormalPrice.isHidden = false
                cell.txtDiscountPrice.isHidden  = true
                let itemPrice = newPrice + (Double("\(self.arrOfGroceryItem[indexPath.row]["full_price"])")!)
                cell.txtNormalPrice.attributedText =  NSAttributedString(string: "£" + "\(itemPrice)").withStrikeThrough(0)
            }
            
            if("\(self.arrOfGroceryItem[indexPath.row]["in_stock"])" != "1")
            {
                cell.stackPlusMinus.isHidden = true
                cell.txtBackSoon.isHidden = false
                cell.imgNew.isHidden = true

               
            }
            else{
                cell.stackPlusMinus.isHidden = false
                cell.txtBackSoon.isHidden = true
               
                if("\(arrOfGroceryItem[indexPath.row]["special_offer"])" == "1")
                {
                    cell.imgNew.isHidden = false
                }
                else{
                    cell.imgNew.isHidden = true
                    if("\(arrOfGroceryItem[indexPath.row]["deliver_cold"])" == "1")
                    {
                        cell.imgCold.isHidden = false
                    }
                  
                }

            }
            
            
            //            if cell.tag == indexPath.row {
            let urlYourURL = URL (string:  "\(arrOfGroceryItem[indexPath.row]["item_image"])" )
            //            cell.imgProduct.loadurl(url: urlYourURL!)
            
            cell.imgProduct.af_setImage(
                withURL:  urlYourURL!,
                placeholderImage: UIImage(named: "greybg"),
                filter: nil,
                imageTransition: UIImageView.ImageTransition.crossDissolve(0.5),
                runImageTransitionIfCached: false) {
                // Completion closure
                response in
                if response.response != nil {
                    // Force the cell update
                    //                                   self.collectionView.beginUpdates()
                    //                                   self.collectionView.endUpdates()
                }
            }
            
//            if("\(arrOfGroceryItem[indexPath.row]["special_offer"])" == "1")
//            {
//                cell.imgNew.isHidden = false
//            }
//            else{
//                cell.imgNew.isHidden = true
//            }
            
            cell.btnAdd.tag = indexPath.row
            cell.btnAdd.addTarget(self, action: #selector(updatePlus(_:)), for: .touchUpInside)
            
            cell.btnMinus.tag =  indexPath.row
            cell.btnMinus.addTarget(self, action: #selector(updateMinus(_:)), for: .touchUpInside)
            let xs = "\(arrOfGroceryItem[indexPath.row]["id"])"
            var count = 0
            cell.btnMinus.isHidden = true
            cell.txtCount.isHidden = true
            for i in 0..<arrOfAddToCartItem.count
            {
                
                
                if(xs == "\(arrOfAddToCartItem[i]["menu_item_id"])")
                {
                    
                    
                    let vala = "\(arrOfAddToCartItem[i]["count"])"
                    count += Int(vala)!
                    
                    cell.btnMinus.isHidden = false
                    cell.txtCount.isHidden = false
                    let color = CABasicAnimation(keyPath: "borderColor");
                    color.fromValue = UIColor.white.cgColor;
                    color.toValue = UIColor.red.cgColor;
                    color.duration = 3;
                    color.repeatCount = 1;
                    cell.viewUi.layer.borderWidth = 3
                    cell.viewUi.layer.add(color, forKey: "color and width");
                    cell.viewUi.layer.borderColor =  UIColor.red.cgColor;
                    if count == 0
                    {
                        
                        cell.btnMinus.isHidden = true
                        cell.txtCount.isHidden = true
                    }
                }
                
            }
            
            cell.txtCount.text = "\(count)"
            
            if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
            {
                cell.stackPlusMinus.isHidden = true
            }
            
            return cell
        }
    }
    ////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    ////        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    ////    }
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 0.5, bottom: 1.0, right: 0.5)//here your custom value for spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = collectionView.frame.width / 3 - 5
        
        if(collectionView == self.collectionItem)
        {
            let lay = collectionViewLayout as! UICollectionViewFlowLayout
            let heightPerItem = collectionView.frame.height
            
            let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
            
            return CGSize(width: widthPerItem
                          , height: 190)
            //        let lay = collectionViewLayout as! UICollectionViewFlowLayout
            //        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
            ////
            //            return CGSize(width:widthPerItem, height:30)
        }
        //        else{
        //            let lay = collectionViewLayout as! UICollectionViewFlowLayout
        //            let heightPerItem = collectionView.frame.height
        //
        //            let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        //
        //            return CGSize(width: widthPerItem
        //                          , height: 100)
        //        }
        return  CGSize(width: widthPerItem
                       , height: 200)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.collectionView){
            selectedPosition = indexPath.row
            if(strSelectedSubCat !=   "\(arrOfSubCategory[indexPath.row]["id"])")
            {
                strSelectedSubCat = "\(arrOfSubCategory[indexPath.row]["id"])"
               collectionView.reloadData()
                
//                let indexPath = IndexPath(item: indexPath.row, section: 0)
//                self.collectionView.reloadItems(at: [indexPath])
                //        self.strTopName = arrOfTopCategory[indexPath.row].cName
                groceryAPI()
            }
            //        screenType = 4
            //        self.performSegue(withIdentifier: "top", sender: nil)
        }
        else{
            //            self.strTopName = arrOfCuisine[indexPath.row].cuisine
            selectedPosition = indexPath.row
            strScreenType = 0
            if(currentReachabilityStatus != .notReachable)
            {
            self.performSegue(withIdentifier: "product", sender: nil)
            }
            else{
                alertInternet()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    
    {
        collectionItem.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if strScreenType == 0
        {
            let secondViewController = segue.destination as! ProductDetailGrocery
 secondViewController.strId = "\(arrOfGroceryItem[selectedPosition]["id"])"

            let xs = "\(arrOfGroceryItem[selectedPosition]["id"])"
            var count = 0
            
            for i in 0..<arrOfAddToCartItem.count
            {
                if(xs == "\(arrOfAddToCartItem[i]["menu_item_id"])")
                {
                    let vala = "\(arrOfAddToCartItem[i]["count"])"
                    count += Int(vala)!
                    
                }
                
            }
            if(count == 0)
            {
                secondViewController.strCount = 0
            }
            else{
                secondViewController.strCount = count
            }
            
        }
    }
    
    @objc func updatePlus(_ sender: UIButton) {
        print(strAgeLimit)
        var plusWorks = 1
        

        let xs = "\(arrOfGroceryItem[sender.tag]["id"])"
        var count = 0
        for i in 0..<arrOfAddToCartItem.count
        {
            if(xs == "\(arrOfAddToCartItem[i]["menu_item_id"])")
            {
                count = Int("\(arrOfAddToCartItem[i]["count"])")!
               
            }
            
        }
        if(count == 0)
        {
        if(strAgeLimit == "0")
        {
        selectedPosition = sender.tag
        addDeleteCount(type: 1)
        }
        else{
            print("\(UserDefaults.standard.string(forKey: Constant.AGE_LIMIT)!)")
            if("\(UserDefaults.standard.string(forKey: Constant.AGE_LIMIT)!)" == "0")
            {
            selectedPosition = sender.tag
            alertAgeLimit(position: 1)
            }
            else{
                selectedPosition = sender.tag
                addDeleteCount(type: 1)
            }
        }
        }
        else{
            selectedPosition = sender.tag
            addDeleteCount(type: 1)
        }
        
        
        //        txtAlertItemCount.text = count?.description
    }
    @objc func updateMinus(_ sender: UIButton) {
        
        selectedPosition = sender.tag
        
        addDeleteCount(type: 0)
    }
    func addDeleteCount(type : Int) {
        var count = 0
        let xs = "\(arrOfGroceryItem[selectedPosition]["id"])"
        for i in 0..<arrOfAddToCartItem.count
        {
            if(xs == "\(arrOfAddToCartItem[i]["menu_item_id"])")
            {
                count = Int("\(arrOfAddToCartItem[i]["count"])")!
                print("fffff")
                print(count)
            }
            
        }
        strSelectedSize = "\(arrOfGroceryItem[selectedPosition]["quantity"])" + "\(arrOfGroceryItem[selectedPosition]["item_type"])"
        previousCount = count
        var countt =  Int(count)
        if type == 1
        {
            countt += 1
        }
        else{
            if(countt > 0)
            {
                countt -= 1
            }
        }
        
        
        if((previousCount !=  countt))
        {
            
            let newPrice = (Double("\(self.arrOfGroceryItem[selectedPosition]["full_price"])")!/100) * Double(strCommission)!
            let itemPrice = newPrice + (Double("\(self.arrOfGroceryItem[selectedPosition]["full_price"])")!)
            
            var commissionPrice =  ""
            
//            let aPrice = Double("\(self.arrOfGroceryItem[selectedPosition]["full_price"])")! - Double("\(self.arrOfGroceryItem[selectedPosition]["discount_price"])")!
            
            var actualPrice = ""
            if ("\(self.arrOfGroceryItem[selectedPosition]["discount_price"])" != "0")
            {
                if ("\(self.arrOfGroceryItem[selectedPosition]["discount_type"])" == "Fixed")
                {
                    print("\(self.arrOfGroceryItem[selectedPosition]["discount_price"])")
                   
                    let price = itemPrice.rounded(digits: 2)
                   actualPrice =  "\(self.arrOfGroceryItem[selectedPosition]["full_price"])"
                    
                     commissionPrice = "\(itemPrice - Double("\(self.arrOfGroceryItem[selectedPosition]["discount_price"])")!)"

                    
                }
                else{
                    print("\(self.arrOfGroceryItem[selectedPosition]["discount_price"])")
                   
                    let price = itemPrice.rounded(digits: 2)
                    actualPrice =  "\(self.arrOfGroceryItem[selectedPosition]["full_price"])"
                    
                    let dis = (Double("\(self.arrOfGroceryItem[selectedPosition]["discount_price"])")! / 100) * itemPrice
                    let discountedPrice = itemPrice - dis
                    commissionPrice = "\(discountedPrice.rounded(digits: 2))"
                    
                }
            }
            else{
            actualPrice =  "\(self.arrOfGroceryItem[selectedPosition]["full_price"])"
                commissionPrice = "\(itemPrice)"
            }
            if(currentReachabilityStatus != .notReachable)
            {
                if("\(arrOfGroceryItem[selectedPosition]["special_offer"])" == "1")
                {
                  let strMaxQty = Int("\(arrOfGroceryItem[selectedPosition]["max_qty"])")
                    if(strMaxQty != 0)
                   {
                     
                        if(strMaxQty! < countt)
                        {
                            alertFailure(title: "Limit reached", Message: "For this special offer product you may only order for \(strMaxQty!) items ")
                        }
                        else{
                            addDeleteToCartAPI(position : selectedPosition, operation : "2", commissionPrice: commissionPrice ,count: "\(countt)", actualPrice : actualPrice, strInstruction:  "")
                        }
                   }
                   else{
                    addDeleteToCartAPI(position : selectedPosition, operation : "2", commissionPrice: commissionPrice ,count: "\(countt)", actualPrice : actualPrice, strInstruction:  "")
                   }
                }
                else{
                 addDeleteToCartAPI(position : selectedPosition, operation : "2", commissionPrice: commissionPrice ,count: "\(countt)", actualPrice : actualPrice, strInstruction:  "")
                }
           
            }
            else{
                alertInternet()
            }
        }
    }
    
    func subCategoryAPI()
    {
        
        let parameters = ["main_cat_id": strRestId, "accesstoken" : Constant.APITOKEN]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.subCategoryAPI, method: .post, param: parameters, viewController: self) { (json) in
            if("\(json["code"])" == "200")
            {
             
                let aa = json["data"]
                // print(aa.count)
                for i in  0..<aa.count
                {
                    //  print(aa[i]["amount"])
                    self.arrOfSubCategory.append(aa[i])
                }
                self.collectionView.reloadData()
                if(self.arrOfSubCategory.count > 0)
                {
                    self.strSelectedSubCat = "\(self.arrOfSubCategory[0]["id"])"
                    self.collectionView.isHidden = false
                    self.groceryAPI()
                    
                }
            }
            else
            {
                self.collectionView.isHidden = true
                // let data = try JSON(data: json)
                //                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
                self.viewNoDataFound.isHidden = false
                
            }
            
        }
    }
    
    
    func groceryAPI()
    {
        self.collectionItem.isHidden = true
        let parameters = ["sub_id": strSelectedSubCat, "accesstoken" : Constant.APITOKEN, "user_long" : strLongitude, "user_lat" : strLatitude]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.groceryProductsAPI, method: .post, param: parameters, viewController: self) { (json) in
            print("json\(json)" )
            print(json)
            
            if("\(json["code"])" == "200")
            {
                self.viewNoDataFound.isHidden = true
                //                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
                self.arrOfGroceryItem.removeAll()
                // let data = try JSON(data: json)
                let aa = json["data"]
                // print(aa.count)
                for i in  0..<aa.count
                {
                    //  print(aa[i]["amount"])
                    self.arrOfGroceryItem.append(aa[i])
                }
                self.collectionItem.isHidden = false
                self.collectionItem.reloadData()
            }
            else
            {
                
                self.viewNoDataFound.isHidden = false
            }
            
        }
    }
    
    func addDeleteToCartAPI(position : Int, operation : String, commissionPrice : String, count : String, actualPrice : String, strInstruction : String)
    {
        // self.collectionItem.isHidden = true
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "menu_item_id" : "\(arrOfGroceryItem[position]["id"])", "price" : commissionPrice, "Add_on" : "0", "count": count, "operation" : operation, "actual_price" : actualPrice , "size" : strSelectedSize, "item_instruction": "", "type" : "1"]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.addDeleteItemToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "200")
            {
                self.arrOfAddToCartItem.removeAll()
                self.viewCartTotal.isHidden = false
                UserDefaults.standard.setValue( "\(json["data"][0]["cart_id"])", forKey: Constant.CART_ID)
                let itemPrice = Double("\(json["total_Item_amount"])")
                //                //    cell2.txtPrice.text = "£"  + "\(self.arrOfGroceryItem[indexPath.row]["f_price"])"
                //
                self.txtCartTotal.text = "\(json["cart_items"])" + " items" + " | " + "£" + "\(String(format: "%.2f", itemPrice!.rounded(digits: 2)))"
                for i in 0..<json["data"].count
                {
                    self.arrOfAddToCartItem.append(json["data"][i])
                }
                print(self.arrOfAddToCartItem.count)
                //
                //  self.collectionItem.isHidden = false
                //                self.collectionItem.reloadData()
                let indexPath = IndexPath(item: self.selectedPosition, section: 0)
                self.collectionItem.reloadItems(at: [indexPath])
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
                self.collectionItem.reloadData()
                //
                //
            }
            
        }
    }    
    func fetchCartDetail()
    {
        arrOfAddToCartItem.removeAll()
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "type" : "1"]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.cartDetailAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            
            if("\(json["status"])" == "200")
            {
                
                
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
                self.collectionItem.reloadData()
                
            }
            
            else if("\(json["status"])" == "202")
            {
                self.alertCartDelete()
            }
            else if("\(json["status"])" == "204")
            {
                
                //  self.alertSucces(title: "Wait for a while", Message: "\(json["message"])" )
            }
            else if("\(json["status"])" == "201")
            {
                
                self.arrOfAddToCartItem.removeAll()
                self.collectionItem.reloadData()
                self.viewCartTotal.isHidden = true            }
            
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
                // self.restIDForCartItem = "0"
                self.alertFailure(title: "Enjoy!!!", Message: "You can enjoy the best meals offered by this restaurant")
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
    func alertAgeLimit(position : Int) -> Void
    {
        let refreshAlert = UIAlertController(title: "18+ ?", message: "If Yes! You'll need to verify using Id at delivery time.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.setValue("1", forKey: Constant.AGE_LIMIT)
            if(self.currentReachabilityStatus != .notReachable)
            {
            self.addDeleteCount(type: 1)
            }
            else{
                self.alertInternet()
            }
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
}


