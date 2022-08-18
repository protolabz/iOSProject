//
//  SearchGroceryController.swift
//  Xeat
//
//  Created by apple on 21/06/22.
//

import UIKit
import SwiftyJSON
import Alamofire

class SearchGroceryController: UIViewController, UISearchBarDelegate,   UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextFieldDelegate   {
    
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var txtCartTotal: UILabel!
    @IBOutlet weak var viewCartTotal: UIView!
    
    
    @IBAction func viewCart(_ sender: Any) {
        strScreenType = 0
        performSegue(withIdentifier: "cart2", sender: nil)
    }
    var arrOfGroceryItem : [JSON] = []
    var strSelectedSize = ""
    var arrOfAddToCartItem : [JSON] = []
    var strScreenType = 0
    var selectedPosition = 0
    var strCommission = ""
    var previousCount = 0
    var strLatitude = ""
    var strLongitude = ""
    var dataEmpty = 0
    
    var strAgeLimit = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        setupToHideKeyboardOnTapOnView()
        searchBar.delegate = self
        searchBar.layer.borderWidth = 0
        searchBar.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        searchBar.tintColor = .black
        //  edSearch.delegate = self
        viewNoData.isHidden = false
        self.viewCartTotal.isHidden = true
        
        if(UserDefaults.standard.string(forKey: Constant.USERLATITUDE) != nil)
        {
            strLatitude = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
            strLongitude = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.minimumLineSpacing = 5
        layout2.minimumInteritemSpacing = 5
        
        layout2.scrollDirection = .vertical
        //        layout2.estimatedItemSize = .zero
        //        layout2.itemSize = CGSize(collectionView.contentSize.width/2, 175)
        collectionView.setCollectionViewLayout(layout2, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GroceryItemCell", bundle: nil), forCellWithReuseIdentifier: "GroceryItemCell")
        collectionView.clipsToBounds = true
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
        let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces)
        if searchText!.count < 2 {
            arrOfGroceryItem.removeAll()
            //                        sizeArray = 0
            dataEmpty = 0
            collectionView.reloadData()
            viewNoData.isHidden = false
            collectionView.isHidden = true
        }
        else
        {
            dataEmpty = 1
            if(currentReachabilityStatus != .notReachable)
            {
            groceryAPI(strSearch : searchText!)
            }
            else
            {
                alertInternet()
            }
        }
            return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        arrOfGroceryItem.removeAll()
        //sizeArray = 0
        viewNoData.isHidden = false
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if(currentReachabilityStatus != .notReachable)
        {
        fetchCartDetail()
        }
        else{
            alertInternet()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.count < 2 {
            arrOfGroceryItem.removeAll()
            //                        sizeArray = 0
            dataEmpty = 0
            collectionView.reloadData()
            viewNoData.isHidden = false
            collectionView.isHidden = true
        }
        else
        {
            dataEmpty = 1
            if(currentReachabilityStatus != .notReachable)
            {
            groceryAPI(strSearch : searchText)
            }
            else
            {
                alertInternet()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrOfGroceryItem.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroceryItemCell", for: indexPath) as! GroceryItemCell
        
        cell.imgCold.isHidden = true
        cell.imgCold.isHidden = true
        cell.btnMinus.isHidden = true
        cell.txtCount.isHidden = true
        cell.txtNormalPrice.isHidden = true
        cell.viewUi.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.viewUi.layer.borderWidth = 0
        cell.tctProductName.text = "\(arrOfGroceryItem[indexPath.row]["item_name"])"
        cell.txtWeight.text = "\(arrOfGroceryItem[indexPath.row]["quantity"])" + "\(arrOfGroceryItem[indexPath.row]["item_type"])"
        let strCommission = "\(self.arrOfGroceryItem[indexPath.row]["commission"])"
        strAgeLimit = "\(self.arrOfGroceryItem[indexPath.row]["age_limit"])"
        let newPrice = (((Double("\(self.arrOfGroceryItem[indexPath.row]["full_price"])"))!/100) * Double(strCommission)!)
       
        let itemPrice = newPrice + (Double("\(self.arrOfGroceryItem[indexPath.row]["full_price"])")!)
       
        cell.txtNormalPrice.text = "£"  +  "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
        
        if ("\(self.arrOfGroceryItem[indexPath.row]["discount_price"])" != "0")
        {
            if ("\(self.arrOfGroceryItem[indexPath.row]["discount_type"])" == "Fixed")
            {
                print("\(self.arrOfGroceryItem[indexPath.row]["discount_price"])")
                cell.txtDiscountPrice.isHidden  = false
                cell.txtNormalPrice.isHidden = false
                let price = itemPrice.rounded(digits: 2)
                cell.txtNormalPrice.attributedText =  NSAttributedString(string: "£" + "\(price)").withStrikeThrough(1)
                
                let discountedPrice = itemPrice - Double("\(self.arrOfGroceryItem[indexPath.row]["discount_price"])")!
                cell.txtDiscountPrice.text = "£"  +  "\(String(format: "%.2f", discountedPrice.rounded(digits: 2)))"
                
            }
            else{
                print("\(self.arrOfGroceryItem[indexPath.row]["discount_price"])")
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
            //  cell.txtNormalPrice.text = "£"  +  "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
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
        
        
        let urlYourURL = URL (string:  "\(arrOfGroceryItem[indexPath.row]["item_image"])" )
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
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(updatePlus(_:)), for: .touchUpInside)
        
        cell.btnMinus.tag = indexPath.row
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
                cell.viewUi.layer.borderWidth = 4
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
        
        return cell
    }
    
    ////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    ////        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    ////    }
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let heightPerItem = collectionView.frame.height
        
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        return CGSize(width: widthPerItem
                      , height: 190)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //            self.strTopName = arrOfCuisine[indexPath.row].cuisine
        selectedPosition = indexPath.row
        strScreenType = 1
        if(currentReachabilityStatus != .notReachable)
        {
        self.performSegue(withIdentifier: "product", sender: nil)
        }
        else
        {
            alertInternet()
        }
        
    }
    
//    @objc func updatePlus(_ sender: UIButton) {
//        selectedPosition = sender.tag
//        print("btnclikc")
//        addDeleteCount(type: 1)
//
//        //        txtAlertItemCount.text = count?.description
//    }
    
    @objc func updatePlus(_ sender: UIButton) {
        strAgeLimit = "\(self.arrOfGroceryItem[sender.tag]["age_limit"])"

       // print(strAgeLimit)
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
            if(currentReachabilityStatus != .notReachable)
            {
                addDeleteCount(type: 1)
            }
            else
            {
                alertInternet()
            }
        }
        else{
            selectedPosition = sender.tag
            if(currentReachabilityStatus != .notReachable)
            {
            print("\(UserDefaults.standard.string(forKey: Constant.AGE_LIMIT)!)")
            if("\(UserDefaults.standard.string(forKey: Constant.AGE_LIMIT)!)" == "0")
            {
            
            alertAgeLimit(position: 1)
            }
            else{
                selectedPosition = sender.tag
                addDeleteCount(type: 1)
            }
        }
            else
            {
                alertInternet()
            }
        }
            
        }
        else{
            selectedPosition = sender.tag
            if(currentReachabilityStatus != .notReachable)
            {
           
            addDeleteCount(type: 1)
            }
            else{
                alertInternet()
            }
        }
        
        
        //        txtAlertItemCount.text = count?.description
    }
    @objc func updateMinus(_ sender: UIButton) {
        selectedPosition = sender.tag
        if(currentReachabilityStatus != .notReachable)
        {
        addDeleteCount(type: 0)
        }
        else{
            alertInternet()
        }
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
            
            let newPrice = (Double("\(self.arrOfGroceryItem[selectedPosition]["full_price"])")!/100) * Double("\(self.arrOfGroceryItem[selectedPosition]["commission"])")!
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
                            addDeleteToCartAPIS(position : selectedPosition, operation : "2", commissionPrice: commissionPrice ,count: "\(countt)", actualPrice : actualPrice, strInstruction:  "")
                        }
                   }
                   else{
                    addDeleteToCartAPIS(position : selectedPosition, operation : "2", commissionPrice: commissionPrice ,count: "\(countt)", actualPrice : actualPrice, strInstruction:  "")
                   }
                }
                else{
                 addDeleteToCartAPIS(position : selectedPosition, operation : "2", commissionPrice: commissionPrice ,count: "\(countt)", actualPrice : actualPrice, strInstruction:  "")
                }
           
            }
            else{
                alertInternet()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if strScreenType == 1
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
        else{
            
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
                
                self.txtCartTotal.text = "\(json["cart_items"])" + " items" + " | " + "£" + "\(String(format: "%.2f", itemPrice!.rounded(digits: 2)))"
                //                if()
                for i in 0..<json["data"].count
                {
                    self.arrOfAddToCartItem.append(json["data"][i])
                }
                print(self.arrOfAddToCartItem.count)
                //
                self.collectionView.reloadData()
                
            }
            
            
            else if("\(json["status"])" == "204")
            {
                
                //  self.alertSucces(title: "Wait for a while", Message: "\(json["message"])" )
            }
            else if("\(json["status"])" == "201")
            {
                
                self.arrOfAddToCartItem.removeAll()
                self.collectionView.reloadData()
                self.viewCartTotal.isHidden = true            }
            
        }
    }
    func groceryAPI(strSearch : String)
    {
        //
        self.collectionView.isHidden = true
        
        let parameters = [ "accesstoken" : Constant.APITOKEN,"search" : strSearch,"long" : strLongitude, "lat" : strLatitude ]
        
        print("parameters",parameters)
        AF.request(Constant.baseURL + Constant.searchGrocery , method: .post, parameters: parameters).validate().responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
            case .success:
                //  print("Validation Successful)")
                self.indicator.isHidden = true
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let status = data["code"]
                        if(status == "200")
                        {
                            self.viewNoData.isHidden = true
                            //                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
                            self.arrOfGroceryItem.removeAll()
                            // let data = try JSON(data: json)
                            let aa = data["data"]
                            // print(aa.count)
                            for i in  0..<aa.count
                            {
                                //  print(aa[i]["amount"])
                                self.arrOfGroceryItem.append(aa[i])
                            }
                            self.collectionView.isHidden = false
                            if self.dataEmpty != 0
                            {
                                self.collectionView.reloadData()
                            }
                            else{
                                self.viewNoData.isHidden = true
                            }
                        }
                        else
                        {
                            self.viewNoData.isHidden = false
                            
                        }
                    }
                    catch{
                        
                        self.indicator.isHidden = true
                        print(error)
                    }
                    
                }
            case .failure(let error):
                print(error)
                
                self.indicator.isHidden = true
            }
        }
    }
    
    
    //    func groceryAPI(strSearch : String)
    //    {
    //        //
    //        self.collectionView.isHidden = true
    //        let parameters = [ "accesstoken" : Constant.APITOKEN,"search" : strSearch,"long" : strLongitude, "lat" : strLatitude ]
    //
    //        print("parameters",parameters)
    //        APIsManager.shared.requestService(withURL: Constant.searchGrocery, method: .post, param: parameters, viewController: self) { (json) in
    //            print("json\(json)" )
    //            print(json)
    //
    //
    //
    //        }
    //    }
    func addDeleteToCartAPIS(position : Int, operation : String, commissionPrice : String, count : String, actualPrice : String, strInstruction : String)
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
                // self.collectionView.reloadData()
                let indexPath = IndexPath(item: self.selectedPosition, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
                // self.alertCartDelete()
                
            }
            
            else if("\(json["status"])" == "201")
            {
                self.viewCartTotal.isHidden = true
                self.arrOfAddToCartItem.removeAll()
                self.collectionView.reloadData()
                //
                //
            }
            
        }
    }
    func alertAgeLimit(position : Int) -> Void
    {
        let refreshAlert = UIAlertController(title: "18+ ?", message: "If Yes! You'll need to verify using Id at delivery time.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.setValue("1", forKey: Constant.AGE_LIMIT)
            self.addDeleteCount(type: 1)
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
}
