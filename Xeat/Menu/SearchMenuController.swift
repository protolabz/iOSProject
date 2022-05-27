//
//  SearchMenuController.swift
//  Xeat
//
//  Created by apple on 07/02/22.
//

import UIKit
import SwiftyJSON
import Alamofire

class SearchMenuController: UIViewController,  UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var edInstruction: UITextView!
    var sizeArray = 0
    var screenType = 0
    var searchId = ""
    var timer = Timer()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtAlertItemCount: UILabel!
    @IBOutlet weak var btnAlertCancel: UIButton!
    @IBOutlet weak var btnAlertUpdate: UIButton!
    @IBOutlet weak var txtAlertItemNAme: UILabel!
    @IBOutlet weak var imgMinus: UIImageView!
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var viewPlusMinus: UIView!
    @IBOutlet weak var viewInnerPlusMinus: UIView!
    
    var restIDForCartItem = "0"
 //   @IBOutlet weak var edSearch: UITextField!
    var arrOfMenu : [JSON] = []
    var arrOfALLMenu : [JSON] = []
    var searchTextFull = ""
    var selectedPosition = 0
    var strCommision = ""
    var selectedIndex = -1
    var strLatitude = ""
    var strLongitude = ""
    var instructions = ""
     var strMenuId = ""
     var strCommissionPrice = ""
    var arrOfAddToCartItem : [JSON] = []
    var strCellItemCount = ""
    var previousCount = 0
var strRestId = ""
     var strActualPrice = ""
    @IBAction func imgBack(_ sender: Any) {
        
        _ =  navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // searchBar.text = ""
        fetchCartDetailSearch()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToHideKeyboardOnTapOnView()
        viewPlusMinus.isHidden = true
        searchBar.delegate = self
        searchBar.layer.borderWidth = 0
        searchBar.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        searchBar.tintColor = .black
      //  edSearch.delegate = self
        viewNoData.isHidden = true
        let nib = UINib(nibName: "MenuViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MenuViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        if(UserDefaults.standard.string(forKey: Constant.USERLATITUDE) != nil)
        {
            strLatitude = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
            strLongitude = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
           
        }
        else
        {
            strLatitude = "30.712321"
            strLongitude = "76.70232"
           
    }
        btnAlertCancel.layer.cornerRadius=10
        btnAlertCancel.clipsToBounds=true

        btnAlertUpdate.layer.cornerRadius=10
        btnAlertUpdate.clipsToBounds=true
        
        viewInnerPlusMinus.layer.borderWidth = 0.5
        viewInnerPlusMinus.layer.masksToBounds = false
        viewInnerPlusMinus.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewInnerPlusMinus.layer.cornerRadius = 10
        
        imgPlus.isUserInteractionEnabled = true
        imgPlus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnPlus)))

        imgMinus.isUserInteractionEnabled = true
        imgMinus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnMinus)))
        viewNoData.isHidden = false
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [self] _ in
            let timeAPI = searchBar.text?.trimmingCharacters(in: .whitespaces)
            if(timeAPI!.count < 2)
            {
                indicator.isHidden = true
                viewNoData.isHidden = false
                tableView.isHidden = true
            }
           
           })
        if(searchId == "0")
        {
            
        }
        else{
            print("else works")
            print(searchId)
            menuSearch()
        }
      
        
     //  menuList()
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.searchBar.showsCancelButton = false
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
        arrOfMenu.removeAll()
        sizeArray = 0
        tableView.reloadData()
            searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.count < 2 {
            arrOfMenu.removeAll()
            sizeArray = 0
            tableView.reloadData()
            viewNoData.isHidden = false
            tableView.isHidden = true
        }
        else
        {
        menuSearchList(strSearch : searchText)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sizeArray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell2 = tableView.dequeueReusableCell(withIdentifier: "MenuViewCell", for: indexPath) as! MenuViewCell
        
                cell2.txtName.text = "\(self.arrOfMenu[indexPath.row]["name"])"
        if( "\(self.arrOfMenu[indexPath.row]["Ingredients"])" != "null")
        {
        cell2.txtIngreden.text =  "\(self.arrOfMenu[indexPath.row]["Ingredients"])"
        }
        print("price")
        print("\(self.arrOfMenu[indexPath.row]["f_price"])")
        let newPrice = (Double("\(self.arrOfMenu[indexPath.row]["f_price"])")!/100) * Double("10")!
        let itemPrice = newPrice + (Double("\(self.arrOfMenu[indexPath.row]["f_price"])")!)

        cell2.txtPrice.text = "£"  +  "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
        cell2.txtNumber.text = "0"
//        if(Int("\(self.arrOfMenu[indexPath.row]["submenu"].count)")! > 0 )
//        {
//            cell2.btnExtra.isHidden = true
//        }
//        else
//        {
//            cell2.btnExtra.isHidden = true
//        }
        
        if(arrOfMenu[indexPath.row]["is_popular_item"] == 1)
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
           // cell2.btnExtra.isHidden = true
            
        }
        else
        {
            cell2.imgMinus.isHidden = false
            cell2.imgPlus.isHidden = false
            cell2.txtNumber.isHidden = false
            cell2.txtOutOfStock.isHidden = true
          //  cell2.btnExtra.isHidden = false
        }
        
        
//        cell2.btnExtra.tag = indexPath.row
//        cell2.btnExtra.addTarget(self, action: #selector(editTap(_:)), for: .touchUpInside)


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
      //  print(count)
       // print(ys) // [0, 2]

       
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
                    previousCount = countAddOn  + Int(count)!
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
                instructions = ""
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
                if(unique.count > 1)
                {
                flag = 1
                }
                
                if(flag == 1)
                {
                    self.alertFailure(title: "Customized items", Message: "There are customizated items in your cart, please go to cart to delete items")
                }
                else{
                    previousCount = Int(count)!
                    viewPlusMinus.isHidden = false
                    //            viewPlusMinus.alpha = 0.9
                    txtAlertItemCount.text = count
                    txtAlertItemNAme.text = "Update item :- \(self.arrOfMenu[sender.tag]["name"])"
                    
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
        viewPlusMinus.isHidden = true
        print(txtAlertItemCount.text)
        let strText = txtAlertItemCount.text
//        updateItemCountAPI(strCount : strText! )
        if((previousCount !=  Int(strText!)) )
        {
            let newPrice = (Double("\(self.arrOfMenu[selectedPosition]["f_price"])")!/100) * Double(strCommision)!
            let itemPrice = newPrice + (Double("\(self.arrOfMenu[selectedPosition]["f_price"])")!)
            let actualPrice = "\(self.arrOfMenu[selectedPosition]["f_price"])"
            //   let count = Int("\(self.arrOfMenu[indexPath.row]["count"])")
            let commissionPrice =   "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
            // updateCartProductAPI(position: sender.tag, count: "1")
            viewPlusMinus.isHidden = true
            addDeleteToCartAPI(position : selectedPosition, operation : "2", commissionPrice: commissionPrice ,count: strText!, actualPrice : actualPrice, strInstruction:  strInstruction)
            
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
            addDeleteToCartAPI(position : selectedPosition, operation : "2", commissionPrice: commissionPrice ,count: strText!, actualPrice : actualPrice, strInstruction:  strInstruction)
        }
        else{
           
            print("update else working, previous count ")
            print(previousCount)
            print(strText)
            
        }
    }
    
    
    func editTap()
       {
//           var flag = 0
//           let newPrice = (Double("\(self.arrOfMenu[selectedPosition]["f_price"])")!/100) * Double(strCommision)!
//           let itemPrice = newPrice + (Double("\(self.arrOfMenu[selectedPosition]["f_price"])")!)
//           let actualPrice = "\(self.arrOfMenu[selectedPosition]["f_price"])"
//           let count = Int("\(self.strCellItemCount)")! - 1
//           let commissionPrice =   "\(String(format: "%.2f", itemPrice))"
//          // strSelectedIndex = selectedPosition
//           for i in 0..<arrOfAddToCartItem.count
//           {
//               if("\(arrOfMenu[selectedPosition]["id"])" == "\(arrOfAddToCartItem[i]["menu_item_id"])")
//               {
//                   if("\(arrOfAddToCartItem[i]["is_add_on"])" == "1")
//                   {
//                       flag = 1
//                   }
//               }
//               else
//               {
//                   flag = 0
//               }
//           }
//           if(flag == 1)
//           {
//               alertRepeatAddOn(position : selectedPosition, commissionPrice: commissionPrice ,count: "\(count)", actualPrice : actualPrice)
//           }
//           else{
              // screenFlag = 1
               performSegue(withIdentifier: "addon", sender: nil)
//           }
           
       }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedIndex = indexPath.row
//
//
//        performSegue(withIdentifier: "menu", sender: nil)
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        let secondViewController = segue.destination as! MenuSizeController

    
        let strMenuId =  "\(self.arrOfMenu[selectedPosition]["id"])"
        
        let newPrice = (Double("\(self.arrOfMenu[selectedPosition]["f_price"])")!/100) * Double(strCommision)!
        let itemPrice = newPrice + (Double("\(self.arrOfMenu[selectedPosition]["f_price"])")!)
        let actualPrice = "\(self.arrOfMenu[selectedPosition]["f_price"])"
        let commissionPrice =   "\(String(format: "%.2f", itemPrice.rounded(digits: 2)))"
        let name = "\(self.arrOfMenu[selectedPosition]["name"])"
        let sizeAvailable = "\(self.arrOfMenu[selectedPosition]["is_size_available"])"
        
        
        secondViewController.strMenuId = strMenuId
        secondViewController.strActualPrice = actualPrice
        secondViewController.strCommissionPrice = commissionPrice
        secondViewController.strCommision = strCommision
        secondViewController.strItemName = name
        secondViewController.isSizeAvailable = Int(sizeAvailable)!
       
         
    }
    func menuList()
    {
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
                        if(status == "200")
                        {
//                            let arrdata =  try JSONDecoder().decode(TopCategoryResponse.self, from: response.data!)
                           
                            for i in 0..<data["data"].count
                            {
                                self.arrOfMenu.append(data["data"][i])
                            }
                            print(self.arrOfMenu.count)
                            self.arrOfALLMenu = self.arrOfMenu
                          //  self.tableView.reloadData()
//                            self.collectionView.reloadData()
                        }
                        else
                        {
                          
                           
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
    
    
    func menuSearchList(strSearch : String)
    {
        sizeArray = 0
        arrOfMenu.removeAll()
        let param =
            ["accesstoken" : Constant.APITOKEN,"res_id": strRestId , "search_menu" : strSearch]
        print(param)
        AF.request(Constant.baseURL + Constant.searchMenuAPI , method: .post, parameters: param).validate().responseJSON { (response) in
            debugPrint(response)
          
            switch response.result {
            case .success:
                print("Menu list success")
           self.indicator.isHidden = true
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let status = data["code"]
                        if(status == "200")
                        {
                            self.arrOfMenu.removeAll()
                            self.sizeArray = data["data"].count
                            for i in 0..<data["data"].count
                            {
                                self.arrOfMenu.append(data["data"][i])
                            }
                            self.viewNoData.isHidden = true
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
//                            self.collectionView.reloadData()
                        }
                        else
                        {
//                            self.alertFailure(title: "No data found", Message: "We didn't get any match item name")
//                            self.arrOfMenu = self.arrOfALLMenu
//                            self.tableView.reloadData()
                            self.viewNoData.isHidden = false
                            self.tableView.isHidden = true
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
    
    
    func menuSearch()
    {
        
        sizeArray = 0
        arrOfMenu.removeAll()
        let param =
            ["accesstoken" : Constant.APITOKEN, "id" : searchId]
        print(param)
        AF.request(Constant.baseURL + Constant.categoryMenuListAPI , method: .post, parameters: param).validate().responseJSON { (response) in
            debugPrint(response)
          
            switch response.result {
            case .success:
                print("Menu list success")
           self.indicator.isHidden = true
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let status = data["code"]
                        if(status == "200")
                        {
                            self.arrOfMenu.removeAll()
                            self.sizeArray = data["data"].count
                            for i in 0..<data["data"].count
                            {
                                self.arrOfMenu.append(data["data"][i])
                            }
                            self.viewNoData.isHidden = true
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
//                            self.collectionView.reloadData()
                        }
                        else
                        {
//                            self.alertFailure(title: "No data found", Message: "We didn't get any match item name")
//                            self.arrOfMenu = self.arrOfALLMenu
//                            self.tableView.reloadData()
                            self.viewNoData.isHidden = false
                            self.tableView.isHidden = true
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
    func fetchCartDetailSearch()
    {
        arrOfAddToCartItem.removeAll()
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.cartDetailAPI, method: .post, param: parameters, viewController: self) { (json) in
//         print(json)
            
            
            if("\(json["status"])" == "201")
            {
                self.arrOfAddToCartItem.removeAll()
                self.tableView.reloadData()
               
            }
            
            else
            {
                
                self.restIDForCartItem = "\(json["restaurant_detail"]["id"])"
                for i in 0..<json["data"].count
                {
                    self.arrOfAddToCartItem.append(json["data"][i])
                }
//                print(self.arrOfAddToCartItem.count)
//
                self.tableView.reloadData()
//
            }
           
        }
    }
    func addDeleteToCartAPI(position : Int, operation : String, commissionPrice : String, count : String, actualPrice : String, strInstruction : String)
    {

        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "menu_item_id" : "\(arrOfMenu[position]["id"])", "price" : commissionPrice, "Add_on" : "0", "count": count, "operation" : operation, "actual_price" : actualPrice , "size" : "R",  "item_instruction": strInstruction]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.addDeleteItemToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
//         print(json)
            
            
            if("\(json["status"])" == "201")
            {
                self.alertCartDelete()
               // self.viewCartTotal.isHidden = true
                self.arrOfAddToCartItem.removeAll()
                self.tableView.reloadData()
            }
          
            else

            {
//                self.arrOfAddToCartItem.removeAll()
//                self.viewCartTotal.isHidden = false
//                let itemPrice = Double("\(json["total_amount"])")
//                           //    cell2.txtPrice.text = "£"  + "\(self.arrOfMenu[indexPath.row]["f_price"])"
//
//                self.txtCartTotal.text = "\(json["cart_items"])" + " items" + " | " + "£" + "\(String(format: "%.2f", itemPrice!))"
                self.arrOfAddToCartItem.removeAll()
                for i in 0..<json["data"].count
                {
                    self.arrOfAddToCartItem.append(json["data"][i])
                }
                print(self.arrOfAddToCartItem.count)
//
                self.tableView.reloadData()
//
//
            }
           
        }
    }
    func alertRepeatAddOn(position : Int, commissionPrice : String, count : String, actualPrice : String) -> Void
    {
        let refreshAlert = UIAlertController(title: "Last customization", message: "Do you want to add your last selected add-ons for this", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { (action: UIAlertAction!) in
            self.addOnRepeatAPI(position : position, commissionPrice : commissionPrice, count : count, actualPrice : actualPrice)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Choose", style: .default, handler: { (action: UIAlertAction!) in
//            self.logoutApi()
          //  self.screenFlag = 1
            self.performSegue(withIdentifier: "addon", sender: nil)
           
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
   
    func addOnRepeatAPI(position : Int, commissionPrice : String, count : String, actualPrice : String)
    {
  let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "menu_item_id" : "\(arrOfMenu[position]["id"])", "price" : commissionPrice, "Add_on" : "2", "count": "1", "operation" : "1", "actual_price" : actualPrice, "repeat_add_on" : "1" ]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.addDeleteItemToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
         print(json)
            
            
            if("\(json["status"])" == "201")
            {
               // self.alertCartDelete()
                self.arrOfAddToCartItem.removeAll()
                self.tableView.reloadData()
            }
            else
            {
               // self.viewCartTotal.isHidden = false
                self.arrOfAddToCartItem.removeAll()
                for i in 0..<json["data"].count
                {
                    self.arrOfAddToCartItem.append(json["data"][i])
                }
                print(self.arrOfAddToCartItem.count)
//
                self.tableView.reloadData()
//
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
            self.removeCartDataAPI()
           
        }))
        
        present(refreshAlert, animated: true, completion: nil)
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
               // self.viewCartTotal.isHidden = true
                self.alertFailure(title: "Enjoy!!!", Message: "You can enjoy the best meals offered by this restaurant")
            }
           
        }
    }
}
