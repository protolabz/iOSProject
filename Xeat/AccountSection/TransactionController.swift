//
//  TransactionController.swift
//  Xeat
//
//  Created by apple on 03/01/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class TransactionController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var balance : String = ""
    
    @IBOutlet weak var txtBalance: UILabel!
    var arrOfTrans : [String] = []
    var arrOfDate : [String] = []
    var arrOfTransactionType : [String] = []
    var arrOfDebitCredit : [String] = []
    var arrOfPenny : [String] = []
    var arrOfStatus : [String] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TransactionsCell", bundle: nil)
       tableView.register(nib, forCellReuseIdentifier: "TransactionsCell")
       
       tableView.delegate = self
       tableView.dataSource = self
       self.tableView.separatorStyle = .none
        
        txtBalance.text = balance
        print(balance)
        if(currentReachabilityStatus != .notReachable)
        {
        walletBalanceAPI()
        }
        else{
            alertInternet()
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return self.arrOfTrans.count
        }
    
//    private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:IndexPath) -> UITableViewCell {
//
//        let cell2 = tableView.dequeueReusableCell(withIdentifier: "TransactionsCell", for: indexPath ) as! TransactionsCell
//        if(self.arrOfStatus[indexPath.row] == "0")
//        {
//            let value = Double(self.arrOfDebitCredit[indexPath.row])
//            cell2.txtDebitCredit.text =  "-£" + (String(format: "%.2f", value!))
//        }
//        else{
//            let value = Double(self.arrOfDebitCredit[indexPath.row])
//            cell2.txtDebitCredit.text =  "-£" + (String(format: "%.2f", value!))
//
//        }
//      return cell2
//     }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
          let cell2 = tableView.dequeueReusableCell(withIdentifier: "TransactionsCell", for: indexPath) as! TransactionsCell
        cell2.txtDate.text = self.arrOfDate[indexPath.row]
        cell2.txtOrderId.text = "Order id #" + self.arrOfTrans[indexPath.row]
        
        if(arrOfTransactionType[indexPath.row] == "3")
        {
            
            cell2.txtPennyCount.text = ""
           // let value = Double(self.arrOfDebitCredit[indexPath.row])
            cell2.txtDebitCredit.text = self.arrOfDebitCredit[indexPath.row] + " penny credits"
        }
        else
        {
        cell2.txtPennyCount.text =  "+ " + self.arrOfPenny[indexPath.row]  + LocalizationSystem.sharedInstance.localizedStringForKey(key: " Reward penny credits", comment: "")


        if(self.arrOfStatus[indexPath.row] == "0")
        {
            let value = Double(self.arrOfDebitCredit[indexPath.row])
            cell2.txtDebitCredit.text = "+ £" + (String(format: "%.2f", value!))
            
        }
        else{
            let value = Double(self.arrOfDebitCredit[indexPath.row])
            cell2.txtDebitCredit.text = "- £" + (String(format: "%.2f", value!))
            cell2.txtDebitCredit.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        }

            cell2.selectionStyle = .none
            return cell2
        
    }
    
    
    func walletBalanceAPI()
    {
      
        indicator.isHidden = false
        indicator.startAnimating()
        
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN]
        
//        AF.request(Constant.baseURL + Constant.transactionAPI, method: .post, parameters: parameters).validate().responseJSON { (response) in
        
        AF.request(Constant.baseURL + Constant.transactionAPI, method: .post, parameters: parameters).validate().responseJSON { (response) in
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
                        
                        let status = data["status"]
                        print("data parased wallet balanece: \(status)")
                        
                        if("\(status)" != "1")
                        {
                            self.alertSucces(title: "No transaction found", Message: "It seems you don't have any wallet transacton yet")
                        }
                        else
                        {
                          let aa = data["data"]
                           // print(aa.count)
                            for i in  0..<aa.count
                            {
                            //  print(aa[i]["amount"])
                                self.arrOfTrans.append("\(aa[i]["order_id"])")
                                self.arrOfStatus.append("\(aa[i]["status"])")
                                self.arrOfDate.append("\(aa[i]["created_at"])")
                                self.arrOfDebitCredit.append("\(aa[i]["amount"])")
                                self.arrOfPenny.append("\(aa[i]["rewards"])")
                                self.arrOfTransactionType.append("\(aa[i]["transaction_type"])")
                            }
                            
                            
//                            let arrdata =  try JSONDecoder().decode(TransactionsResponse.self, from: response.data!)
//                            self.arrOfTrans = arrdata.amount
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


