//
//  DelievryController.swift
//  Xeat
//
//  Created by apple on 26/12/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class DelievryController: UIViewController,  UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate  {
    
    @IBOutlet weak var txtEmpty: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var txtCurrentAddress: UILabel!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var btnSaveAddress: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
   // var selectedPosition = ""
    @IBAction func btnSaveAddress(_ sender: Any) {
        btnSaveAddress.isEnabled = false
        savePrimaryAPI(position : selectedndex)
    }
    var screenType = false
    var selectedndex = 0
    
    @IBOutlet weak var imgAddAddress: UIImageView!
    var jsonAddress : [DatumAddressList] = []
    
    @IBAction func btnNewAddress(_ sender: Any) {
        addAddressTap()
    }
    @IBOutlet weak var btnNew: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnSaveAddress.isHidden = true
        if(UserDefaults.standard.string(forKey: Constant.USERADDRESSID) != nil)
        {

        if(!UserDefaults.standard.string(forKey: Constant.USERADDRESSID)!.isEmpty)
        {
            self.txtCurrentAddress.text =  UserDefaults.standard.string(forKey: Constant.USERADDRESS)
        }
        }
        getAddressListAPI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)

        }
    }
    func initView()
    {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        btnSaveAddress.isHidden = true
        imgAddAddress.isHidden = true
        self.txtEmpty.isHidden = true
        
        let nib = UINib(nibName: "ManageAddressCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ManageAddressCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        btnSaveAddress.layer.cornerRadius = 10
        btnNew.layer.cornerRadius = 10

        viewAddress.layer.borderWidth = 0.5
        viewAddress.layer.masksToBounds = false
        viewAddress.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewAddress.layer.cornerRadius = 10
        
//        imgAddAddress.isUserInteractionEnabled = true
//        imgAddAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addAddressTap)))
        
        if(UserDefaults.standard.string(forKey: Constant.USERADDRESSID) != nil)
        {

        if(!UserDefaults.standard.string(forKey: Constant.USERADDRESSID)!.isEmpty)
        {
            self.txtCurrentAddress.text =  UserDefaults.standard.string(forKey: Constant.USERADDRESS)
        }
        }
       // getAddressListAPI()
    }
    
    func addAddressTap()
    {
        
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
        {
            alertUIGuestUser()
        }
        else{
            screenType = false
            performSegue(withIdentifier: "addaddress", sender: nil)
        }
       
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jsonAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "ManageAddressCell", for: indexPath) as! ManageAddressCell
        cell2.txtAddress.text = jsonAddress[indexPath.row].name + ", " + jsonAddress[indexPath.row].address
         //   + ", " + jsonAddress[indexPath.row].comAddress
            + ", " + jsonAddress[indexPath.row].hte
            + " " + jsonAddress[indexPath.row].phoneNumber
        cell2.selectionStyle = .none
        cell2.btnEdit.tag = indexPath.row
        cell2.btnEdit.addTarget(self, action: #selector(editTap(_:)), for: .touchUpInside)
        
        cell2.btnDelete.tag = indexPath.row
        cell2.btnDelete.addTarget(self, action: #selector(deleteTap(_:)), for: .touchUpInside)
      //  cell2.selectionStyle = UITableViewCell.SelectionStyle.blue
        return cell2
        
    }
    
    @objc func deleteTap(_ sender: UIButton) {
        if(UserDefaults.standard.string(forKey: Constant.USERADDRESSID) != nil)
        {

            if(UserDefaults.standard.string(forKey: Constant.USERADDRESSID) != nil &&  UserDefaults.standard.string(forKey: Constant.USERADDRESSID) != jsonAddress[sender.tag].id)
        {
            print(sender.tag)
            alertDelete(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete", comment: ""), Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Are you sure you want to delete this?", comment: ""), position: sender.tag)
           
        }
            else{
                alertFailure(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "Wait", comment: ""), Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "This address saved as primary address.", comment: ""))
            }
        }
       
    }
    
    @objc func editTap(_ sender: UIButton)
    {
        
        selectedndex = sender.tag
        screenType = true
        performSegue(withIdentifier: "editaddress", sender: nil)
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedndex = indexPath.row
        btnSaveAddress.isHidden = false
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(screenType)
        {
            
            let secondViewController = segue.destination as! EditAddressController
            secondViewController.strName = jsonAddress[selectedndex].name
            secondViewController.strPhone = jsonAddress[selectedndex].phoneNumber
            secondViewController.strAddress = jsonAddress[selectedndex].address
            secondViewController.strLatitude = jsonAddress[selectedndex].aLat
          // secondViewController.strHouseNumber = jsonAddress[selectedndex].comAddress
            secondViewController.strLongitude = jsonAddress[selectedndex].aLong
            secondViewController.strPrimaryAdress = jsonAddress[selectedndex].isPrimary
            secondViewController.strAddressID = jsonAddress[selectedndex].id
            
            secondViewController.strDailCode = jsonAddress[selectedndex].hte
            secondViewController.strCountryCode = jsonAddress[selectedndex].buildingNumber
            
        }
        
        else{
           
        }
    }
    
    func savePrimaryAPI(position : Int)
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let param =
            ["accesstoken" : Constant.APITOKEN, "user_id" : strUserId, "address_id" : "\(self.jsonAddress[position].id)"]
        print(param)
        APIsManager.shared.requestService(withURL: Constant.savePrimaryAddressAPI, method: .post, param: param, viewController: self) { (json) in
            print(json)
            self.btnSaveAddress.isHidden = true
            if("\(json["code"])" == "201")
            {
                self.btnSaveAddress.isEnabled = true
                self.alertSucces(title: "Wait for a moment", Message: "\(json["message"])")
            }
            else
            {
                self.btnSaveAddress.isEnabled = true
                UserDefaults.standard.set(self.jsonAddress[position].name + ", " + self.jsonAddress[position].address
                                            + ", " + self.jsonAddress[position].hte  + " " +  self.jsonAddress[position].phoneNumber, forKey: Constant.USERADDRESS)
                UserDefaults.standard.set(self.jsonAddress[position].aLat, forKey: Constant.USERLATITUDE)
                UserDefaults.standard.set(self.jsonAddress[position].id, forKey: Constant.USERADDRESSID)

                UserDefaults.standard.set(self.jsonAddress[position].aLong, forKey: Constant.USERLONGITUDE)
                self.txtCurrentAddress.text = self.jsonAddress[position].name + ", " + self.jsonAddress[position].address
                    + ", " + self.jsonAddress[position].hte  + " " +  self.jsonAddress[position].phoneNumber
                self.tableView.reloadData()
            }
            
        }
    }
    func deleteAddressListAPI(position : Int)
    {
        // let strContact = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["id": jsonAddress[position].id, "accesstoken" : Constant.APITOKEN ]
        
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.deleteAddressAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            if("\(json["code"])" == "201")
            {
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
            else
            {
                print("get address")
                self.jsonAddress.remove(at: position)
                if(self.jsonAddress.count>0)
                {
                    self.txtEmpty.isHidden = true
                }
                else
                {
                    self.txtEmpty.isHidden = false
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    func getAddressListAPI()
    {
        let strContact = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strContact, "accesstoken" : Constant.APITOKEN ]
    print(parameters)
        AF.request(Constant.baseURL + Constant.getAddressListApi , method: .post, parameters: parameters).validate().responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
            case .success:
                print("Validation Successful)")
                self.indicator.isHidden = true
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let status = data["code"]
                        if(status == "200")
                        {
                            let arrdata =  try JSONDecoder().decode(AddressListResponse.self, from: response.data!)
                            
                            self.jsonAddress = arrdata.data
                            
                            if(self.jsonAddress.count>0)
                            {
                                self.txtEmpty.isHidden = true
                                self.tableView.isHidden = false
                                
                            }
                            else
                            {
                                self.txtEmpty.isHidden = false
                                self.tableView.isHidden = true
                            }
                            
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.txtEmpty.isHidden = false
                            
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
    
    func alertDelete(title: String,Message : String, position : Int) -> Void {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            print("default")
                                            if(self.currentReachabilityStatus != .notReachable)
                                            {
                                            self.deleteAddressListAPI(position: position)
                                            }
                                            else{
                                                self.alertInternet()
                                            }
                                        case .cancel:
                                            print("cancel")
                                            
                                        case .destructive:
                                            print("destructive")
                                            
                                        @unknown default:
                                            break;
                                        }}))
        //   alert.setBackgroundColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
//func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//    let actionProvider: UIContextMenuActionProvider = { _ in
//
//        return UIMenu(title: "", children: [
//            UIAction(title: "Delete", image:  UIImage(systemName: "trash")) { _ in
//                print("shardce selected")
//            },
//            UIAction(title: "Edit" , image: UIImage(systemName: "square.and.pencil")) { _ in
//                print("sharcdcdce selected")
//            },
//            UIAction(title: "Mark as default address", image: UIImage(systemName: "location.circle"), attributes: .destructive) { _ in
//                print("shardcdcde selected")
//            },
//        ])
//    }
//
//    return UIContextMenuConfiguration(identifier: "unique-ID" as NSCopying, previewProvider: nil, actionProvider: actionProvider)
//}
