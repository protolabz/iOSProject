//
//  OrderHistoryController.swift
//  Xeat
//
//  Created by apple on 31/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class OrderHistoryController: UIViewController ,  UITableViewDelegate,UITableViewDataSource {
    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedOrderID = ""
    var selectedPosition = -1
    
    var arrOfTrans : [JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        
        viewNoData.isHidden = true
        
        let nib = UINib(nibName: "HistoryViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(currentReachabilityStatus != .notReachable)
        {
            
            orderHistoryAPI()
        }
        else{
            alertInternet()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfTrans.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "HistoryViewCell", for: indexPath) as! HistoryViewCell
        if self.viewIfLoaded?.window != nil {
        //
        cell2.txtDate.text = "Ordered on " +   "\(arrOfTrans[indexPath.row]["created_at"])"
        cell2.txtRestName.text = "\(self.arrOfTrans[indexPath.row]["res_name"])"
        //
        cell2.txtPName.text =  "Order Id : " + "\(arrOfTrans[indexPath.row]["id"])"
        let value = Double("\(arrOfTrans[indexPath.row]["total_user_pad"])")
        cell2.txtPrice.text = "£" + (String(format: "%.2f", value!))
        ////        print(strImageURL)
        //        if(arrOfTrans[indexPath.row].itemData[0].image.count>2){
//        let urlYourURL = URL (string:"\(arrOfTrans[indexPath.row]["res_image"])" )
//        cell2.imgProduct.loadurl(url: urlYourURL!)
        //
        //        }
        var itemData : String = ""
        for i in 0..<arrOfTrans[indexPath.row]["items"].count
        {
            
            itemData +=  "\(arrOfTrans[indexPath.row]["items"][i]["count"])" + " x " +  "\(arrOfTrans[indexPath.row]["items"][i]["Iname"])" + ","
            if(arrOfTrans[indexPath.row]["items"][i]["withitems"].count == 0)
            {
                itemData += "\n"
            }
            for j in 0..<arrOfTrans[indexPath.row]["items"][i]["withitems"].count
            {
                itemData += " (" + "Add-ons:" + "\(arrOfTrans[indexPath.row]["items"][i]["withitems"][j]["name"])" + ") " + "\n"
            }
            //  print(itemData)
        }
        let itemData2 = itemData.trimmingCharacters(in: .whitespaces).dropLast(2)
        cell2.txtProductCountNAme.text = "\(itemData2)"
        //
        
        switch "\(arrOfTrans[indexPath.row]["status"])" {
        case "2":
            cell2.txtStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancelled", comment: "")
            cell2.isUserInteractionEnabled = false
        case "11":
            cell2.txtStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancelled", comment: "")
            cell2.isUserInteractionEnabled = false
        case "10" :
            print("\(arrOfTrans[indexPath.row]["res_star"])")
            if("\(arrOfTrans[indexPath.row]["res_star"])" !=  "0")
            {
                cell2.txtStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Rated", comment: "")
                cell2.isUserInteractionEnabled = true
            }
            else{
                cell2.txtStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Rate", comment: "")
                cell2.isUserInteractionEnabled = true
            }
        default:
            cell2.txtStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Rate", comment: "")
            cell2.isUserInteractionEnabled = true
        }
        if("\(arrOfTrans[indexPath.row]["order_type"])" == "1")
        {
            cell2.btnCall.isHidden = true
        }
        else{
            cell2.btnCall.isHidden = false
        }
        
        cell2.btnCall.tag = indexPath.row
        cell2.btnCall.addTarget(self, action: #selector(callUser(_:)), for: .touchUpInside)
        
        cell2.selectionStyle = .none
       
    }
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewIfLoaded?.window != nil {
        selectedPosition = indexPath.row
            if(self.currentReachabilityStatus != .notReachable)
            {
          selectedOrderID = "\(arrOfTrans[indexPath.row]["driverContact"])"
            self.tableView.isUserInteractionEnabled = false
          performSegue(withIdentifier: "rating", sender: nil)
            }
            else
            {
                alertInternet()
            }
    }
    }
    
    @objc func callUser(_ sender: UIButton)
    {
        let strNumber  = "\(arrOfTrans[sender.tag]["driverContact"])"
        guard let number = URL(string: "tel://" + strNumber)
        else { return }
        UIApplication.shared.open(number)
    }
    
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
            var ratingStar = ""
            var ratingDriver = ""
            let starSellect = "\(arrOfTrans[selectedPosition]["res_star"])"
             if(starSellect == "0")
             {
                ratingStar = "0"
                ratingDriver = "0"
             }
             else{
                ratingDriver = "\(arrOfTrans[selectedPosition]["driver_star"])"
                ratingStar = starSellect
             }
            let secondViewController = segue.destination as! OrderRatingController
    
            secondViewController.strOrderId = "\(arrOfTrans[selectedPosition]["id"])"
            secondViewController.starSelect = starSellect
            secondViewController.driverStar = ratingDriver
            secondViewController.screenType = "1"
        }
    
    func orderHistoryAPI()
    {
        self.tableView.isUserInteractionEnabled = false
        arrOfTrans.removeAll()
        let strId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        
        indicator.isHidden = false
        indicator.startAnimating()
        let parameters = ["user_id": strId, "accesstoken" : Constant.APITOKEN]
        print(parameters)
        AF.request(Constant.baseURL + Constant.orderHistoryApi, method: .post,parameters: parameters).validate().responseJSON { (response) in
            debugPrint(response)
            let status = response.response?.statusCode
            if(status == 401)
            {
                self.indicator.isHidden = true
                self.alertUIUnauthorised()
                
            }
            else{
                switch response.result {
                case .success:
                    print("Validation Successful)")
                    self.indicator.isHidden = true
                    if let json = response.data {
                        do{
                            let data = try JSON(data: json)
                            
                            let status = data["data"]
                            print("data : \(status)")
                            
                            if(status.count == 0)
                            {
                                self.viewNoData.isHidden = false
                                self.tableView.isHidden = true
                                
                            }
                            else
                            {
                                
                                self.arrOfTrans.removeAll()
                                self.viewNoData.isHidden = true
                                self.tableView.isHidden = false
                                
                                for i in 0..<data["data"].count
                                {
                                    self.arrOfTrans.append(data["data"][i])
                                }
                                
                                self.tableView.reloadData()
                                self.tableView.isUserInteractionEnabled = true
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
    }
}
