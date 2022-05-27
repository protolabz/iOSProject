//
//  MenuSizeController.swift
//  Xeat
//
//  Created by apple on 03/05/22.
//

import UIKit
import SwiftyJSON
import Alamofire
class MenuSizeController: UIViewController ,  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
   
    @IBOutlet weak var txtInstructions: UILabel!
    
    
    @IBOutlet weak var txtSize: UILabel!
  //  @IBOutlet weak var txtAddOn: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //  @IBOutlet weak var imgCancel: UIImageView!
    //@IBOutlet weak var viewSize: UIView!
    @IBOutlet weak var txtNumber: UILabel!
    @IBOutlet weak var imgMinus: UIImageView!
    @IBOutlet weak var imgPlus: UIImageView!
    
  

    @IBOutlet weak var txtHeading: UILabel!
   
    @IBAction func btnAdd(_ sender: Any) {

        print(arrOfSelectedSection)
        print(arrOfRequired)
        print("array1 == array2? \(Set(arrOfRequired) == Set(arrOfSelectedSection))")
        print("array1 subset to array2? \(Set(arrOfRequired).isSubset(of: Set(arrOfSelectedSection)))")
        if(Set(arrOfRequired).isSubset(of: Set(arrOfSelectedSection)))
        {
      //  btnAdd.isEnabled = false
                print(arrOfRadioData)
                print(arrOfsectionRadio)
               
        
        let jsonString2 = convertIntoJSONString(arrayObject: arrOfRadioData)
            for i in 0..<arrOfRadioData.count
        {
            arrOfAddOnData2.append(arrOfRadioData[i])
        }
        var jsonString = convertIntoJSONString(arrayObject: arrOfAddOnData2)
      
                let ggg = jsonString!.replacingOccurrences(of: "\\", with: "")
        //
            print(ggg)
          
            if(ggg.count>2)
            {
                isAddOnSelected = 1
            }
            else
            {
                isAddOnSelected = 0
            }
           
            addDeleteToCartAPI(str : ggg)
        //
        }
        else{
            alertFailure(title: "Select required items", Message: "Select atleast one item from the required items")
        }
    }
    
    var arrOfMainSize : [JSON] = []
    var arrOfSize : [SizeAddon] = []
    var arrOfID : [String] = []
  var arrOfSelectedID : [String] = []
  var selectedSizeForAddOn = "R"
    var isSizeAvailable = 0
    var strSelectedPosition = 0
    var isAddOnSelected = 0
var strInstrctions = ""
    
    var strOpertaion = "1"
    var strMenuId = ""
    var strCommissionPrice = ""
    var strSize = "R"
    var strCommision = ""
    var strItemName = ""
    var strActualPrice = ""
    
    var extraAddonSize = 0
    
    
    var arrOfHeadings : [String] = []
    var arrOfListing : [[Selection]] =  []
    var arrOfData : [DatumAddon] = []
   
    var arrOfSelectedID2 : [String] = []
    var arrOfMainSelectedId2 : [IndexPath] = []
    var arrOfRadio : [Int] = []
    var arrOfRadioData  : [[String: Any]] = []
    var arrOfsectionRadio : [Int] = []
    var arrOfRequired : [Int] = []
    var arrOfSelectedSection : [Int] = []
    var arrOfAddOnData2 : [[String: Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        txtHeading.text = strItemName
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TopCategoryCell", bundle: nil), forCellWithReuseIdentifier: "TopCategoryCell")
        collectionView.clipsToBounds = true
        
        let nib = UINib(nibName: "AddOnCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddOnCell")
        
        let nib2 = UINib(nibName: "AddSizeRadioCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "AddSizeRadioCell")
        
        let nib3 = UINib(nibName: "HeaderCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "HeaderCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        self.btnAdd.setTitle("Add item to basket", for: .normal)
        
        imgPlus.isUserInteractionEnabled = true
        imgPlus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnPlus)))
        
        imgMinus.isUserInteractionEnabled = true
        imgMinus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnMinus)))
        
        txtInstructions.isUserInteractionEnabled = true
        txtInstructions.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.instCall)))
        btnAdd.isEnabled = false
        btnAdd.layer.masksToBounds = true
        btnAdd.layer.cornerRadius = 5
        
        aaddonNewAPI()
        
        
    }
    
    @objc func btnPlus() {
        var count =  Int(txtNumber.text!)
        count! += 1
        txtNumber.text = count?.description
        
    }
    @objc func btnMinus() {
        
        var count =  Int(txtNumber.text!)
        if(count! > 1)
        {
            count! -= 1
            txtNumber.text = count?.description
        }
    }
    
    @objc func instCall() {
      
        showAlertInstructions()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrOfMainSize.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print(arr)
        self.txtSize.text = "Variants"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCategoryCell", for: indexPath) as! TopCategoryCell
      
        let deliveryCharge = (Double("\(self.arrOfMainSize[0][indexPath.row]["menu_price"])")!/100) * Double(strCommision)!
        let newPrice = deliveryCharge + (Double("\(self.arrOfMainSize[0][indexPath.row]["menu_price"])")!)
        let price =  "£" + "\(String(format: "%.2f", newPrice.rounded(digits: 2)))"
       
       // arrOfJsonAddon.removeAll()
        cell.txtName.text = "\(self.arrOfMainSize[0][indexPath.row]["menu_full_size"])" + " (" + price + ") "
  
//
        if(strSelectedPosition == indexPath.row)
        {
            cell.backgroundColor = .red
            self.strSize = "\(self.arrOfMainSize[0][indexPath.row]["menu_size"])"
            strActualPrice = "\(self.arrOfMainSize[0][indexPath.row]["menu_price"])"
            strCommissionPrice = "\(newPrice)"
            selectedSizeForAddOn = "\(self.arrOfMainSize[0][indexPath.row]["menu_size"])"
           
            self.addOnDataAPI(strSize:  selectedSizeForAddOn)
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
       // self.arrOfAddOnData.removeAll()
        self.arrOfMainSelectedId2.removeAll()
        self.arrOfSelectedID.removeAll()
       // tableView.reloadData()
      //  arrOfJsonAddon.removeAll()
        arrOfRadio.removeAll()
        arrOfSelectedSection.removeAll()
        arrOfRadioData.removeAll()
        arrOfsectionRadio.removeAll()
        let deliveryCharge = (Double("\("\(self.arrOfMainSize[0][indexPath.row]["menu_price"])")")!/100) * Double(strCommision)!
        let newPrice = deliveryCharge + (Double("\(self.arrOfMainSize[0][indexPath.row]["menu_price"])")!)
    
        strActualPrice = "\(self.arrOfMainSize[0][indexPath.row]["menu_price"])"
        strCommissionPrice = "\(newPrice.rounded(digits: 2))"
        selectedSizeForAddOn = "\(self.arrOfMainSize[0][indexPath.row]["menu_size"])"
       
      print(selectedSizeForAddOn)

        self.strSize = "\(self.arrOfMainSize[0][indexPath.row]["menu_size"])"
        self.strOpertaion = "1"
        self.addOnDataAPI(strSize:  selectedSizeForAddOn)
        self.tableView.reloadData()
        collectionView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = Bundle.main.loadNibNamed("HeaderCell", owner: self, options: nil)?.first as! HeaderCell
        
        if(section < arrOfHeadings.count)
        {
            if(arrOfData[section].isRequired == "1")
            {
                headerCell.txtHeading.text = arrOfHeadings[section]
                headerCell.txtRequired.text = "Required"
                self.arrOfRequired.append(section)
            }
            else
            {
                headerCell.txtRequired.isHidden = true
                headerCell.txtHeading.text = arrOfHeadings[section]
            }

      }
 
           return headerCell
       }
       
       func numberOfSections(in tableView: UITableView) -> Int {

            return arrOfHeadings.count

       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return arrOfListing[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {           
                if(arrOfData[indexPath.section].isSize == "1")
            {
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "AddOnCell", for: indexPath) as! AddOnCell
                cell2.selectionStyle = .none
                cell2.txtNo.text = "\(indexPath.row + 1)"
                
                cell2.txtItemName.text = arrOfListing[indexPath.section][indexPath.row].name
                let price =
                    Double("\(arrOfListing[indexPath.section][indexPath.row].variantPrice)")?.rounded(digits: 2)
                cell2.txtPrice.text =
                    "£" +  "\(price!)"

                cell2.btnSelect.tag = (indexPath.section*100)+indexPath.row
               cell2.btnSelect.addTarget(self, action: #selector(addToCategory(_:)), for: .touchUpInside)
                if(arrOfMainSelectedId2.contains(indexPath))
                {
                   
                 
                    cell2.btnSelect.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    cell2.btnSelect.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    if !arrOfSelectedID2.contains(where: { $0 == "\(arrOfListing[indexPath.section][indexPath.row].id)"}) {
                        arrOfSelectedID2.append("\(arrOfListing[indexPath.section][indexPath.row].id)")

                       
                        arrOfAddOnData2.append(["id" : "\(arrOfListing[indexPath.section][indexPath.row].id)", "price" : "\(price!)", "name" :  arrOfListing[indexPath.section][indexPath.row].name
                        ])

                    }
                    
                }
                else{
                  
                   // print(arrOfMainSelectedId2)
                  ///  selectedSection = indexPath.section
                    cell2.btnSelect.setBackgroundImage(UIImage(systemName: "square"), for: .normal)

                    cell2.btnSelect.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
                return cell2
                
            }
            else
            {
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "AddSizeRadioCell", for: indexPath) as! AddSizeRadioCell
                cell2.selectionStyle = .none
                cell2.txtNo.text = "\(indexPath.row + 1)"
                
                cell2.txtItemName.text = arrOfListing[indexPath.section][indexPath.row].name
                let price =
                    Double("\(arrOfListing[indexPath.section][indexPath.row].variantPrice)")?.rounded(digits: 2)
                cell2.txtPrice.text =
                    "£" +  "\(price!)"
                
                cell2.btnSelect.tag = (arrOfListing[indexPath.section][indexPath.row]).id
                cell2.btnSelect.tag = (indexPath.section*100)+indexPath.row
                 cell2.btnSelect.addTarget(self, action: #selector(addToRadio(_:)), for: .touchUpInside)
                if(arrOfRadio.contains(arrOfListing[indexPath.section][indexPath.row].id))
                {
                    cell2.btnSelect.setBackgroundImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
                        cell2.btnSelect.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
                else{

                  ///  selectedSection = indexPath.section
                    cell2.btnSelect.setBackgroundImage(UIImage(systemName: "circlebadge"), for: .normal)
                    cell2.btnSelect.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
             }
           
                return cell2
        }
        }
        
    
    @objc func addToRadio(_ sender: UIButton) {
        
        let section = sender.tag / 100
             let row = sender.tag % 100
        let indexPath = NSIndexPath(row: row, section: section)
      
        if(!arrOfsectionRadio.contains(section))
        {
            print("selected")
            print(arrOfRadioData)
            arrOfSelectedSection.append(section)
            arrOfsectionRadio.append(section)
            arrOfRadio.append(arrOfListing[indexPath.section][indexPath.row].id)
            arrOfRadioData.append(["id" : "\(arrOfListing[indexPath.section][indexPath.row].id)", "price" :   "\(arrOfListing[indexPath.section][indexPath.row].variantPrice)", "name" :  "\(arrOfListing[indexPath.section][indexPath.row].name)"])
            print("booked product position")

        }
        else{
            print("already selected")
            print(arrOfRadioData)
            let index = arrOfsectionRadio.firstIndex{ $0 == section }
            arrOfRadio.remove(at: index!)
            arrOfRadio.insert(arrOfListing[indexPath.section][indexPath.row].id, at: index!)
            arrOfRadioData.remove(at: index!)
            arrOfRadioData.insert(["id" : "\(arrOfListing[indexPath.section][indexPath.row].id)", "price" :   "\(arrOfListing[indexPath.section][indexPath.row].variantPrice)", "name" :  "\(arrOfListing[indexPath.section][indexPath.row].name)"], at: index!)
            print("already selected")
            print(arrOfRadioData)
      }
        
        
        arrOfRequired.removeAll()
        tableView.reloadData()
        //addtoCartProductAPI(position: sender.tag)
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
    
//    
//
    @objc func addToCategory(_ sender: UIButton) {
        let section = sender.tag / 100
             let row = sender.tag % 100
        let indexPath = NSIndexPath(row: row, section: section)

            print("extra items ")
            if(!arrOfMainSelectedId2.contains(indexPath as IndexPath))
            {
                arrOfSelectedSection.append(section)
                arrOfMainSelectedId2.append(indexPath as IndexPath)
                print("booked product position")
                print(sender.tag)
                
            }
            else{
                arrOfMainSelectedId2.removeAll(where: { $0 == indexPath as IndexPath })
                print("already selected")
                let index = arrOfSelectedID2.firstIndex{ $0 == "\(arrOfListing[indexPath.section][indexPath.row].id)" }
                arrOfSelectedID2.removeAll(where: { $0 == "\(arrOfListing[indexPath.section][indexPath.row].id)" })
                arrOfAddOnData2.remove(at: index!)
                arrOfSelectedSection.remove(at: index!)
            }

        arrOfRequired.removeAll()
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

                        self.arrOfMainSize.append(json["menu_sizes"])
                        self.collectionView.isHidden = false
                        self.txtSize.isHidden = false
                        self.collectionView.reloadData()
                        self.btnAdd.isEnabled = true
                    
                    }
                    for i in 0..<json["menu_addon_with_sizes"].count
                    {
                        self.arrOfID.append("\(json["menu_addon_with_sizes"][i]["id"])")
                        if(self.arrOfMainSize.count > 0)
                        {
                            self.collectionView.isHidden = false
                            self.txtSize.isHidden = false
                            self.tableView.reloadData()
                        }
                        else{
                            //  self.btnSelectSize.isHidden = true
                            //  self.btnAdd.isEnabled = false
                        }
//
//                        for j in 0..<json["menu_addon_with_sizes"][i]["sizes"].count
//                        {
//                            self.arrOfAddOn.append("\(json["menu_addon_with_sizes"][i]["name"])" + "**"  +  "\(json["menu_addon_with_sizes"][i]["sizes"][j]["item_size"])" + "**" +  "\(json["menu_addon_with_sizes"][i]["sizes"][j]["item_price"])")
//                        }
                        self.btnAdd.isEnabled = true
                    }
//                    for i in 0..<self.arrOfAddOn.count
//                    {
//
//                        let strName = "\(self.arrOfAddOn[i])".components(separatedBy: "**")
//
//                        let str1 = strName[1]
//
//                        if("\(json["menu_sizes"][i]["menu_size"])".count == 1)
//                        {
//                            self.selectedSizeForAddOn = "\(json["menu_sizes"][0]["menu_size"])"
//                        }
//                        if(self.selectedSizeForAddOn == str1 )
//                        {
//                            self.arrOfJsonAddon.append(self.arrOfAddOn[i])
//                            print("arrOfJsonAddon")
//                            print(self.arrOfJsonAddon)
//                        }
//                        self.isAddOnExist = 1
//                    }
                    self.selectedSizeForAddOn = "\(json["menu_sizes"][0]["menu_size"])"
                   
                    self.addOnDataAPI(strSize:  self.selectedSizeForAddOn)
                }
                else{
                  
                    print("else works")
                    self.collectionView.isHidden = true
                    self.txtSize.isHidden = true
//                    self.arrOfJsonAddon.removeAll()
                    for i in 0..<json["menu_addon_with_sizes"].count
                    {
                        self.arrOfID.append("\(json["menu_addon_with_sizes"][i]["id"])")
                        if(self.arrOfMainSize.count > 0)
                        {
                            self.collectionView.isHidden = false
                            self.txtSize.isHidden = false
                            self.tableView.reloadData()
                        }
                        else{
                            // self.btnSelectSize.isHidden = true
                            //  self.btnAdd.isEnabled = false
                        }
                        
//                        for j in 0..<json["menu_addon_with_sizes"][i]["sizes"].count
//                        {
//                            self.arrOfAddOn.append("\(json["menu_addon_with_sizes"][i]["name"])" + "**"  +  "\(json["menu_addon_with_sizes"][i]["sizes"][j]["item_size"])" + "**" +  "\(json["menu_addon_with_sizes"][i]["sizes"][j]["item_price"])")
//                            self.isAddOnExist = 1
//                        }
                    }
                    
//                    self.arrOfJsonAddon = self.arrOfAddOn
                  
//                    print(self.arrOfJsonAddon)
                    self.tableView.reloadData()
                    self.addOnDataAPI(strSize:  "R")
                    self.btnAdd.isEnabled = true
                }
            }
            
        }
    }
    
    func addOnDataAPI(strSize : String)
    {
        
       
        let param =
            ["accesstoken" : Constant.APITOKEN, "menu_id" : strMenuId, "size" : strSize ]
        print(param)
        AF.request(Constant.baseURL + Constant.addOnExtraAPI , method: .post, parameters: param).validate().responseJSON { (response) in
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
                            self.arrOfData.removeAll()
                            let arrdata =  try JSONDecoder().decode(SizeAddOnResponse.self, from: response.data!)
                            self.arrOfData = arrdata.data
                            
                            self.arrOfHeadings.removeAll()
                            self.arrOfListing.removeAll()
                          
                            for i in 0..<arrdata.data.count
                            {
                                self.arrOfListing.append(arrdata.data[i].selection)
                                self.arrOfHeadings.append(arrdata.data[i].title)
                            }
                            print(self.arrOfListing)
                            self.tableView.reloadData()
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
    
    
    func addDeleteToCartAPI(str : String)
    {
        print(str)
        let count = "\(self.txtNumber.text!.trimmingCharacters(in: .whitespaces))"
        btnAdd.isEnabled = false
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "menu_item_id" : strMenuId, "price" : strCommissionPrice, "Add_on" : self.isAddOnSelected, "count": count, "operation" : strOpertaion, "actual_price" : strActualPrice , "add_on_items" : str , "repeat_add_on" : "0" , "size" : strSize, "item_instruction": strInstrctions] as [String : Any]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.addDeleteItemToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "200")
            {
                self.dismiss(animated: true, completion:nil)
                _ = self.navigationController?.popViewController(animated: true)
            }
            else if("\(json["status"])" == "202")
            {
                self.alertCartDeletew()
            }
            else
            {
                self.btnAdd.isEnabled = true
            }
            
        }
    }
    
    
    func removeCartDataAPI2()
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
    
    func alertCartDeletew() -> Void
    {
        let refreshAlert = UIAlertController(title: "Cart contains orders from another restaurant", message: "Do you want to clear your cart and order from this restaurant instead?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //            self.logoutApi()
            self.removeCartDataAPI2()
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    private func showAlertInstructions()
    {
        
        let alertController = UIAlertController(title: "Instructions/Allergic", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Close", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
//            var str = eventNameTextField.text!.trimmingCharacters(in: .whitespaces)
//
//            print(str)
            
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
                    
                    self.strInstrctions = str
                    
                    // loginAPICall(email : strEmail, password : strPassword)
                }
                else{
                    self.alertInternet()
                }
                
            }
            
        })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Instructions/Allergic"
            textField.text = self.strInstrctions
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        //        saveAction.setValue(UIColor.black, forKey: "titleTextColor")
        //        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
