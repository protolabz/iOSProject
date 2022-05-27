//
//  AddOnController.swift
//  Xeat
//
//  Created by apple on 10/01/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddOnController: UIViewController,  UITableViewDelegate,UITableViewDataSource , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBAction func imgBack(_ sender: Any) {
        
        _ =  navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var txtSize: UILabel!
    @IBOutlet weak var txtAddOn: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //  @IBOutlet weak var imgCancel: UIImageView!
    //@IBOutlet weak var viewSize: UIView!
    @IBOutlet weak var txtNumber: UILabel!
    @IBOutlet weak var imgMinus: UIImageView!
    @IBOutlet weak var imgPlus: UIImageView!
    //  @IBOutlet weak var btnSelectSize: UIButton!
    //    @IBAction func btnSelectSize(_ sender: Any) {
    //       // alertSize()
    //       // viewSize.isHidden = false
    //        self.arrOfJsonAddon.removeAll()
    //        self.arrOfAddOnData.removeAll()
    //        self.arrOfMainSelectedId.removeAll()
    //        self.arrOfSelectedID.removeAll()
    //        tableView.reloadData()
    //    }
    var selectedSizeForAddOn = "r"
    var arrOfAddOn : [String] = []
    var arrOdAddOnPrice : [String] = []
    var arrOfSize : [SizeAddon] = []
    var arrOfNewSizePrice : [String] = []
    var arrOfID : [String] = []
    var arrOfNewSize : [String] = []
    var arrOfShortFormSize : [String] = []
    var arrOfSelectedID : [String] = []
    var arrOfMainSelectedId : [Int] = []
    
    var arrOfSelectedName : [String] = []
    var arrOfSelectedPrice : [String] = []
    var arrOfAddOnData : [[String: Any]] = []
    var arrOfJsonAddon : [String] = []
    var strOpertaion = "1"
    var strMenuId = ""
    var strCommissionPrice = ""
    var strSize = "R"
    var strCommision = ""
    var strItemName = ""
    var isAddOnSelected = 0
    var isSizeAvailable = 0
    var strSelectedPosition = 0
    var menuSelectionSize = 0
    var strActualPrice = ""
    
    @IBOutlet weak var txtHeading: UILabel!
   
    @IBAction func btnAdd(_ sender: Any) {
        if(btnAdd.tag == 1)
        {
       // btnAdd.isEnabled = false
           
        performSegue(withIdentifier: "size", sender: nil)
        }
        else{
            let jsonString = convertIntoJSONString(arrayObject: arrOfAddOnData)
          //        print(jsonString)
          //
                  let ggg = jsonString!.replacingOccurrences(of: "\\", with: "")
          
                  addDeleteToCartAPI(str : ggg)
        }
        //        print(arrOfSelectedID)
//        //        print(arrOfAddOnData)
//
        
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.btnAdd.setTitle("Loading...", for: .normal)
        
        let nib = UINib(nibName: "AddOnCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddOnCell")
        
        //  viewSize.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        //        viewSize.layer.borderWidth = 0.5
        //        viewSize.layer.masksToBounds = false
        //        viewSize.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //        viewSize.layer.cornerRadius = 10
        //        viewSize.isHidden = true
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TopCategoryCell", bundle: nil), forCellWithReuseIdentifier: "TopCategoryCell")
        collectionView.clipsToBounds = true
        
        imgPlus.isHidden = true
        imgMinus.isHidden = true
        txtNumber.isHidden = true
        
        btnAdd.isEnabled = false
        btnAdd.layer.masksToBounds = true
        btnAdd.layer.cornerRadius = 5
        
        //  btnSelectSize.isHidden = true
        txtHeading.text = strItemName
        
        imgPlus.isUserInteractionEnabled = true
        imgPlus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnPlus)))
        
        imgMinus.isUserInteractionEnabled = true
        imgMinus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnMinus)))
        
        //        imgCancel.isUserInteractionEnabled = true
        //        imgCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeViewSize)))
        //  addOnAPI()
        aaddonNewAPI()
    }
    @objc func btnPlus() {
        var count =  Int(txtNumber.text!)
        count! += 1
        txtNumber.text = count?.description
        
    }
    
    @objc func closeViewSize() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @objc func btnMinus() {
        
        var count =  Int(txtNumber.text!)
        if(count! > 1)
        {
            count! -= 1
            txtNumber.text = count?.description
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrOfNewSize.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        self.txtSize.text = "Sizes"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCategoryCell", for: indexPath) as! TopCategoryCell
        let deliveryCharge = (Double("\(self.arrOfNewSizePrice[indexPath.row])")!/100) * Double(strCommision)!
        let newPrice = deliveryCharge + (Double("\(self.arrOfNewSizePrice[indexPath.row])")!)
        let price =  "£" + "\(String(format: "%.2f", newPrice.rounded(digits: 2)))"
       
        arrOfJsonAddon.removeAll()
        cell.txtName.text = "\(self.arrOfNewSize[indexPath.row])" + " (" + price + ") "
        
      //  selectedSizeForAddOn =  "\(self.arrOfShortFormSize[indexPath.row])"
       
       
        for i in 0..<self.arrOfAddOn.count
        {
            let strName = "\(self.arrOfAddOn[i])".components(separatedBy: "**")
            
            let str1 = strName[1]
            
            if(self.arrOfShortFormSize.count == 1)
            {
                selectedSizeForAddOn = "\(self.arrOfShortFormSize[0])"
            }
            if(selectedSizeForAddOn == str1 )
            {
                arrOfJsonAddon.append(arrOfAddOn[i])
            }
        }
        
        if(strSelectedPosition == indexPath.row)
        {
            cell.backgroundColor = .red
            self.strSize = "\(self.arrOfShortFormSize[indexPath.row])"
            strActualPrice = "\(self.arrOfNewSizePrice[indexPath.row])"
            strCommissionPrice = "\(newPrice)"
            selectedSizeForAddOn = "\(self.arrOfShortFormSize[indexPath.row])"
            
        }
        else{
            cell.backgroundColor = .none
        }
        self.strOpertaion = "1"
        
        self.tableView.reloadData()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        // let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        
        return CGSize(width:110, height:80)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        strSelectedPosition = indexPath.row
        self.arrOfJsonAddon.removeAll()
        self.arrOfAddOnData.removeAll()
        self.arrOfMainSelectedId.removeAll()
        self.arrOfSelectedID.removeAll()
       // tableView.reloadData()
        arrOfJsonAddon.removeAll()
        let deliveryCharge = (Double("\(self.arrOfNewSizePrice[indexPath.row])")!/100) * Double(strCommision)!
        let newPrice = deliveryCharge + (Double("\(self.arrOfNewSizePrice[indexPath.row])")!)
    
        strActualPrice = "\(self.arrOfNewSizePrice[indexPath.row])"
        strCommissionPrice = "\(newPrice.rounded(digits: 2))"
        selectedSizeForAddOn =  "\(self.arrOfShortFormSize[indexPath.row])"
       
        //  viewSize.isHidden = true
        //  btnSelectSize.setTitle(  "\(self.arrOfNewSize[indexPath.row])" + " (" + price + ") ", for: .normal)
        
        for i in 0..<self.arrOfAddOn.count
        {
            let strName = "\(self.arrOfAddOn[i])".components(separatedBy: "**")
            
            let str1 = strName[1]
            
            if(selectedSizeForAddOn == str1 )
            {
                arrOfJsonAddon.append(arrOfAddOn[i])
            }
        }
        self.strSize = "\(self.arrOfShortFormSize[indexPath.row])"
        self.strOpertaion = "1"
        self.tableView.reloadData()
        collectionView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfJsonAddon.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        self.txtAddOn.text = "Add ons" + " (" + "\(arrOfJsonAddon.count)" + ")"
        //        if tableView == self.tableView
        //        {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "AddOnCell", for: indexPath) as! AddOnCell
        
        cell2.selectionStyle = .none
        cell2.txtNo.text = "\(indexPath.row + 1)"
        cell2.txtItemName.text = self.arrOfJsonAddon[indexPath.row]
        let strName = "\(self.arrOfJsonAddon[indexPath.row])".components(separatedBy: "**")
        let str1 = strName[1]
        let strFinalename = str1
        if(selectedSizeForAddOn == str1)
        {
            cell2.txtItemName.text = strName[0]
            cell2.txtPrice.text = "£" + "\(Double("\(strName[2])")!.rounded(digits: 2))"
        }
        
        cell2.btnSelect.tag = indexPath.row
        cell2.btnSelect.addTarget(self, action: #selector(addToCategory(_:)), for: .touchUpInside)
        if(arrOfMainSelectedId.contains(indexPath.row))
        {
            let strName = "\(self.arrOfJsonAddon[indexPath.row])".components(separatedBy: "**")
            let str1 = strName[1]
            let strFinalename = str1
            cell2.btnSelect.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
            cell2.btnSelect.tintColor =  #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            if !arrOfSelectedID.contains(where: { $0 == "\(arrOfID[indexPath.row])"}) {
                arrOfSelectedID.append("\(arrOfID[indexPath.row])")
                
                arrOfAddOnData.append(["id" : "\(arrOfID[indexPath.row])", "price" : strName[2], "name" : strName[0]])
            }
           }
        else{
            cell2.btnSelect.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            cell2.btnSelect.tintColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        return cell2
        
        
        
    }
    
    func convertIntoJSONString(arrayObject: [Any]) -> String? {
        
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    //
    @objc func addToCategory(_ sender: UIButton) {
        if(!arrOfMainSelectedId.contains(sender.tag))
        {
            
            arrOfMainSelectedId.append(sender.tag)
            print("booked product position")
            print(sender.tag)
            
        }
        else{
            arrOfMainSelectedId.removeAll(where: { $0 == sender.tag })
            print("already selected")
            let index = arrOfSelectedID.firstIndex{ $0 == "\(arrOfID[sender.tag])" }
            arrOfSelectedID.removeAll(where: { $0 == "\(arrOfID[sender.tag])" })
            arrOfAddOnData.remove(at: index!)
            print("\(index)" + "dfghjk")
        }
        
        if(arrOfMainSelectedId.count>0)
        {
            isAddOnSelected = 1
            self.strOpertaion = "1"
            btnAdd.isEnabled = true
        }
        else{
            isAddOnSelected = 0
            // self.strOpertaion = "1"
            //            btnAdd.isEnabled = false
        }
        tableView.reloadData()
        //addtoCartProductAPI(position: sender.tag)
    }
    
    
    func aaddonNewAPI()
    {
        
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["subitem_id": strMenuId, "accesstoken" : Constant.APITOKEN]
        print(parameters)
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL:  Constant.addonListAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "200")
            {
                if(self.isSizeAvailable == 1)
                {
                    for i in 0..<json["menu_sizes"].count
                    {
                        self.arrOfNewSize.append("\(json["menu_sizes"][i]["menu_full_size"])")
                        self.arrOfShortFormSize.append("\(json["menu_sizes"][i]["menu_size"])")
                        
                        self.arrOfNewSizePrice.append("\(json["menu_sizes"][i]["menu_price"])")
                   
                        self.collectionView.isHidden = false
                        self.txtSize.isHidden = false
                        self.collectionView.reloadData()
                        self.btnAdd.isEnabled = true
                    
                    }
                    for i in 0..<json["menu_addon_with_sizes"].count
                    {
                        self.arrOfID.append("\(json["menu_addon_with_sizes"][i]["id"])")
                        if(self.arrOfNewSize.count > 0)
                        {
                            self.collectionView.isHidden = false
                            self.txtSize.isHidden = false
                            self.tableView.reloadData()
                        }
                        else{
                            //  self.btnSelectSize.isHidden = true
                            //  self.btnAdd.isEnabled = false
                        }
                        
                        for j in 0..<json["menu_addon_with_sizes"][i]["sizes"].count
                        {
                            self.arrOfAddOn.append("\(json["menu_addon_with_sizes"][i]["name"])" + "**"  +  "\(json["menu_addon_with_sizes"][i]["sizes"][j]["item_size"])" + "**" +  "\(json["menu_addon_with_sizes"][i]["sizes"][j]["item_price"])")
                        }
                        self.btnAdd.isEnabled = true
                    }
                }
                else{
                    
                    self.collectionView.isHidden = true
                    self.txtSize.isHidden = true
                    self.arrOfJsonAddon.removeAll()
                    for i in 0..<json["menu_addon_with_sizes"].count
                    {
                        self.arrOfID.append("\(json["menu_addon_with_sizes"][i]["id"])")
                        if(self.arrOfNewSize.count > 0)
                        {
                            self.collectionView.isHidden = false
                            self.txtSize.isHidden = false
                            self.tableView.reloadData()
                        }
                        else{
                            // self.btnSelectSize.isHidden = true
                            //  self.btnAdd.isEnabled = false
                        }
                        
                        for j in 0..<json["menu_addon_with_sizes"][i]["sizes"].count
                        {
                            self.arrOfAddOn.append("\(json["menu_addon_with_sizes"][i]["name"])" + "**"  +  "\(json["menu_addon_with_sizes"][i]["sizes"][j]["item_size"])" + "**" +  "\(json["menu_addon_with_sizes"][i]["sizes"][j]["item_price"])")
                        }
                    }
                    
                    self.arrOfJsonAddon = self.arrOfAddOn
                  
                    print(self.arrOfJsonAddon)
                    self.tableView.reloadData()
                    self.btnAdd.isEnabled = true
                }
             print(json["menu_selection"].count)
                self.menuSelectionSize = json["menu_selection"].count
                if(self.menuSelectionSize > 0)
                {
                    self.btnAdd.setTitle("Next", for: .normal)
                    self.btnAdd.tag = 1
                    self.imgPlus.isHidden = true
                    self.imgMinus.isHidden = true
                    self.txtNumber.isHidden = true
                }
                else{
                    self.btnAdd.setTitle("Add", for: .normal)
                    self.btnAdd.tag = 0
                    self.imgPlus.isHidden = false
                    self.imgMinus.isHidden = false
                    self.txtNumber.isHidden = false
                }
                
            }
            
        }
    }
    
    func addDeleteToCartAPI(str : String)
    {
        print(str)
        let count = "\(self.txtNumber.text!.trimmingCharacters(in: .whitespaces))"
        btnAdd.isEnabled = false
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "menu_item_id" : strMenuId, "price" : strCommissionPrice, "Add_on" : self.isAddOnSelected, "count": count, "operation" : strOpertaion, "actual_price" : strActualPrice , "add_on_items" : str , "repeat_add_on" : "0" , "size" : strSize] as [String : Any]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.addDeleteItemToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "200")
            {
                _ = self.navigationController?.popViewController(animated: true)
            }
            else if("\(json["status"])" == "202")
            {
                self.alertCartDelete()
            }
            else
            {
                self.btnAdd.isEnabled = true
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
                //self.viewCartTotal.isHidden = true
                self.alertFailure(title: "Enjoy!!!", Message: "You can enjoy the best meals offered by this restaurant")
            }
            
        }
    }
    
    //[{"id":"140","name":"cheese","price":"2"},{"id":"139","name":"Pizzavizza","price":"10"}]
    func addDeleteToCartAPI2(str : String)
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "menu_item_id" : strMenuId, "price" : strCommissionPrice, "Add_on" : "1", "count": "1", "operation" : "2", "actual_price" : strActualPrice , "add_on_items" : str , "repeat_add_on" : "0"] as [String: Any]
        print(parameters)
        AF.request(Constant.baseURL + Constant.addDeleteItemToCartAPI , method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { (response) in
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let secondViewController = segue.destination as! SizesAddOnController
            
            secondViewController.strMenuId = strMenuId
            secondViewController.strActualPrice = strActualPrice
            secondViewController.strCommissionPrice = strCommissionPrice
            secondViewController.strCommision = strCommision
            secondViewController.strItemName = strItemName
            secondViewController.isSizeAvailable = isSizeAvailable
            secondViewController.strSize = strSize
        
        }
  
}
