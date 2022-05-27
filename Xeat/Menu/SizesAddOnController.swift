//
//  SizesAddOnController.swift
//  Xeat
//
//  Created by apple on 26/04/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class SizesAddOnController: UIViewController  ,  UITableViewDelegate,UITableViewDataSource {
    
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
    @IBOutlet weak var txtHeading: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var arrOfSelectedID2 : [String] = []
    var arrOfMainSelectedId2 : [Int] = []
    var arrOfRadio : [Int] = []
    var arrOfRadioData  : [[String: Any]] = []
    var arrOfsectionRadio : [Int] = []
    var arrOfRequired : [Int] = []
    var arrOfSelectedSection : [Int] = []
    var arrOfIndex : [Int] = []
     //   var arrOfID : [String] = []
    var arrOfAddOnData2 : [[String: Any]] = []
    var strActualPrice = ""
    var isAddOnSelected = 0

  
    @IBAction func btnAdd(_ sender: Any) {
        print(arrOfSelectedSection)
        print(arrOfRequired)
        print("array1 == array2? \(Set(arrOfRequired) == Set(arrOfSelectedSection))")
        print("array1 subset to array2? \(Set(arrOfRequired).isSubset(of: Set(arrOfSelectedSection)))")
        if(Set(arrOfRequired).isSubset(of: Set(arrOfSelectedSection)))
        {
        btnAdd.isEnabled = false
                print(arrOfRadio)
                print(arrOfsectionRadio)
               
        
        let jsonString2 = convertIntoJSONString(arrayObject: arrOfRadioData)
            for i in 0..<arrOfRadioData.count
        {
            arrOfAddOnData2.append(arrOfRadioData[i])
        }
        var jsonString = convertIntoJSONString(arrayObject: arrOfAddOnData2)
      
                let ggg = jsonString!.replacingOccurrences(of: "\\", with: "")
        //
                addDeleteToCartAPI(str : ggg)
        
        }
        else{
            alertFailure(title: "Select required items", Message: "Select atleat one item from the required items")
        }
    }
    
    var selectedSizeForAddOn = "r"
    var selectedSection = 0
    
    var arrOfHeadings : [String] = []
    var arrOfListing : [[Selection]] =  []
    var arrOfData : [DatumAddon] = []
    var strOpertaion = "1"
    var strMenuId = ""
    var strCommissionPrice = ""
    var strSize = ""
    var strCommision = ""
    var strItemName = ""
    var isSizeAvailable = 0
    var strSelectedPosition = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AddOnCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddOnCell")
        
        
        let nib2 = UINib(nibName: "AddSizeRadioCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "AddSizeRadioCell")
        
        //  viewSize.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
        //        collectionView.delegate = self
        //        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TopCategoryCell", bundle: nil), forCellWithReuseIdentifier: "TopCategoryCell")
        collectionView.clipsToBounds = true
        
        imgPlus.isUserInteractionEnabled = true
        imgPlus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnPlus)))
        
        imgMinus.isUserInteractionEnabled = true
        imgMinus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnMinus)))
        
        addOnDataAPI()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewContainer = UIView()
        viewContainer.backgroundColor = UIColor.gray
        let labelHeader = UILabel()
        labelHeader.textColor = UIColor.white
        viewContainer.addSubview(labelHeader)
   
        labelHeader.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        labelHeader.frame = viewContainer.frame
        
        if(arrOfData[section].isRequired == "1")
        {
            print("required section area")
            print(section)
            labelHeader.text =  "   " + arrOfHeadings[section] + "(Required)"
            self.arrOfRequired.append(section)
        }
        else
        {
            labelHeader.text =  "   " + arrOfHeadings[section]
        }
        return viewContainer
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrOfHeadings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  let brand = brandNames[section]
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
            
            cell2.btnSelect.tag =
                (indexPath.section*100)+indexPath.row
           cell2.btnSelect.addTarget(self, action: #selector(addToCategory(_:)), for: .touchUpInside)
            if(arrOfMainSelectedId2.contains(arrOfListing[indexPath.section][indexPath.row].id))
            {
                print("arrOfMainSelectedId2")
                print(arrOfMainSelectedId2)
               
                if !arrOfSelectedID2.contains(where: { $0 == "\(arrOfListing[indexPath.section][indexPath.row].id)"}) {
                    arrOfSelectedID2.append("\(arrOfListing[indexPath.section][indexPath.row].id)")
                   
                    cell2.btnSelect.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    cell2.btnSelect.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    arrOfAddOnData2.append(["id" : "\(arrOfListing[indexPath.section][indexPath.row].id)", "price" : "\(price!)", "name" :  arrOfListing[indexPath.section][indexPath.row].name
                    ])
                    
                }
                
            }
            else{
                print("arrOfMainSelectedId2 else")
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
            
           // cell2.btnSelect.tag = (arrOfListing[indexPath.section][indexPath.row]).id
            cell2.btnSelect.tag = (indexPath.section*100)+indexPath.row
             cell2.btnSelect.addTarget(self, action: #selector(addToRadio(_:)), for: .touchUpInside)
            if(arrOfRadio.contains(arrOfListing[indexPath.section][indexPath.row].id))
            {
                cell2.btnSelect.setBackgroundImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
                    cell2.btnSelect.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                   
//                }
                // self.arrOfSelectedID2.append()
                
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
            print(sender.tag)
            arrOfSelectedSection.append(section)
            arrOfsectionRadio.append(section)
            arrOfRadio.append(arrOfListing[indexPath.section][indexPath.row].id)
            arrOfRadioData.append(["id" : "\(arrOfListing[indexPath.section][indexPath.row].id)", "price" :   "\(arrOfListing[indexPath.section][indexPath.row].variantPrice)", "name" :  "\(arrOfListing[indexPath.section][indexPath.row].name)"])
            print("booked product position")

        }
        else{
            print("already selected")
            let index = arrOfsectionRadio.firstIndex{ $0 == section }
            arrOfRadio.remove(at: index!)
            arrOfRadio.insert(arrOfListing[indexPath.section][indexPath.row].id, at: index!)
            arrOfRadioData.remove(at: index!)
            arrOfRadioData.insert(["id" : "\(arrOfListing[indexPath.section][indexPath.row].id)", "price" :   "\(arrOfListing[indexPath.section][indexPath.row].variantPrice)", "name" :  "\(arrOfListing[indexPath.section][indexPath.row].name)"], at: index!)
      }
        
        if(arrOfMainSelectedId2.count>0)
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
        arrOfRequired.removeAll()
        tableView.reloadData()
        //addtoCartProductAPI(position: sender.tag)
    }
    
    @objc func addToCategory(_ sender: UIButton) {
       
        let section = sender.tag / 100
             let row = sender.tag % 100
        let indexPath = NSIndexPath(row: row, section: section)
        print(section)
        print(row)
        let id =  (arrOfListing[indexPath.section][indexPath.row]).id
        if(!arrOfMainSelectedId2.contains(id))
        {
            print(sender.tag)
          //  print(arrOfListing[sender.tag])
            arrOfMainSelectedId2.append(id)
            arrOfSelectedSection.append(section)
            print("booked product position")

        }
        else{
            arrOfMainSelectedId2.removeAll(where: { $0 == id })
            print("already selected")
            let index = arrOfSelectedID2.firstIndex{ $0 == "\(id)" }
            arrOfSelectedID2.removeAll(where: { $0 == "\(id)" })
            arrOfAddOnData2.remove(at: index!)
            arrOfSelectedSection.remove(at: index!)
            // print("\(index)" + "dfghjk")
        }
        
        if(arrOfMainSelectedId2.count>0)
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
    
    func addOnDataAPI()
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
                            let arrdata =  try JSONDecoder().decode(SizeAddOnResponse.self, from: response.data!)
                            self.arrOfData = arrdata.data
                            
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
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "menu_item_id" : strMenuId, "price" : strCommissionPrice, "Add_on" : self.isAddOnSelected, "count": count, "operation" : strOpertaion, "actual_price" : strActualPrice , "add_on_items" : str , "repeat_add_on" : "0" , "size" : strSize] as [String : Any]
        
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
    
    
}
