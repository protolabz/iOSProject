//
//  HelpOrderListController.swift
//  Xeat
//
//  Created by apple on 05/01/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class HelpOrderListController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBAction func back(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var imgBack: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewNoData: UIView!
    var selectedPosition = 0
 
    var arrOfTrans : [DatumHelpOrder] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
       
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
    
    let nib = UINib(nibName: "HelpRevertViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "HelpRevertViewCell")
   
   tableView.delegate = self
   tableView.dataSource = self
   self.tableView.separatorStyle = .none

        viewNoData.isHidden = true
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
          let cell2 = tableView.dequeueReusableCell(withIdentifier: "HelpRevertViewCell", for: indexPath) as! HelpRevertViewCell
        cell2.selectionStyle = .none

//
        cell2.txtDate.text =   arrOfTrans[indexPath.row].createdAt
        cell2.helpTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Order id #", comment: "") + self.arrOfTrans[indexPath.row].orderID
////
        cell2.helpDecr.text =  arrOfTrans[indexPath.row].comment
////        cell2.helpStatus.text =  arrOfTrans[indexPath.row].comment
//
        switch arrOfTrans[indexPath.row].status {
        case "2":
            cell2.helpStatus.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Status : Closed", comment: ""), for: .normal)
            cell2.helpStatus.setTitleColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: .normal)
            cell2.isUserInteractionEnabled = false
        case "1":
            cell2.helpStatus.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Status : Pending", comment: ""), for: .normal)
            cell2.helpStatus.setTitleColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), for: .normal)

            cell2.isUserInteractionEnabled = true
        default:
            cell2.helpStatus.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Refund successful", comment: ""), for: .normal)
            cell2.helpStatus.setTitleColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: .normal)
            cell2.isUserInteractionEnabled = false
        }
//
        
//        cell2.btnCall.tag = indexPath.row
       
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        selectedPosition = indexPath.row
        if(self.currentReachabilityStatus != .notReachable)
        {
            performSegue(withIdentifier: "orderchat", sender: nil)
        }
        else{
            alertInternet()
        }
       
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let secondViewController = segue.destination as! OrderChatController

        secondViewController.orderID = arrOfTrans[selectedPosition].orderID
        secondViewController.chatId = arrOfTrans[selectedPosition].id
    }

    func orderHistoryAPI()
    {
        let strId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
       
        indicator.isHidden = false
        indicator.startAnimating()
        let parameters = ["user_id": strId, "accesstoken" : Constant.APITOKEN]
        print(parameters)
        AF.request(Constant.baseURL + Constant.orderHelpChatListAPI, method: .post,parameters: parameters).validate().responseJSON { (response) in
            debugPrint(response)
            let status = response.response?.statusCode
            if(status == 401)
            {
//                self.indicator.isHidden = true
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
                            self.viewNoData.isHidden = true
                            self.tableView.isHidden = false

                            let arrdata =  try JSONDecoder().decode(HelpOrdertListResponse.self, from: response.data!)
                            self.arrOfTrans = arrdata.data
                           
                            self.tableView.reloadData()
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
