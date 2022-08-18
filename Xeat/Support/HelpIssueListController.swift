//
//  HelpIssueListController.swift
//  Xeat
//
//  Created by apple on 31/01/22.
//

import UIKit
import SwiftyJSON

class HelpIssueListController: UIViewController,  UITableViewDelegate,UITableViewDataSource {
    var arrOfTrans : [JSON] = []
  
    var apiHit = 0
    var selectedIssueId = ""
    var selectedChatId = ""
    @IBOutlet weak var txtHeading: UILabel!
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
    var strOrderId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let nib = UINib(nibName: "HelpIssueCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HelpIssueCell")
       
       tableView.delegate = self
       tableView.dataSource = self
       self.tableView.separatorStyle = .none
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        if(self.currentReachabilityStatus != .notReachable)
        {
        orderIssueAPI()
        }
        else{
            alertInternet()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return arrOfTrans.count
       
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell2 = tableView.dequeueReusableCell(withIdentifier: "HelpIssueCell", for: indexPath) as! HelpIssueCell
        cell2.selectionStyle = .none
//
      print("\(self.arrOfTrans[indexPath.row])")
        cell2.txtIssue.text = "\(self.arrOfTrans[indexPath.row]["issu_type"])"

        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        selectedIssueId = "\(arrOfTrans[indexPath.row]["issu_type"])"
       if(apiHit == 0)
       {
        apiHit = 1
        orderSubmitIssueAPI()
       }
        }
        else{
            alertInternet()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let secondViewController = segue.destination as! OrderChatController

        secondViewController.orderID = strOrderId
        secondViewController.chatId = selectedChatId
    }

    
    func orderIssueAPI()
    {
        let parameters = ["accesstoken" : Constant.APITOKEN]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.helpIssueListAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "201")
            {
                self.alertSucces(title: "Wait", Message: "\(json["message"])")
            }
            else
            {
                for i in 0..<json["data"].count
                {
                    self.arrOfTrans.append(json["data"][i])
                }
               
                self.tableView.reloadData()
                //self.setDataViews(jsonData : json)
            }
            
        }
    }
        
        func orderSubmitIssueAPI()
        {
            let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
            let parameters = ["accesstoken" : Constant.APITOKEN, "user_id" : strUserId, "order_id" : strOrderId , "comment" : selectedIssueId ]
            print("parameters",parameters)
            APIsManager.shared.requestService(withURL: Constant.helpSubmitAPI, method: .post, param: parameters, viewController: self) { (json) in
                print(json)
                
                if("\(json["code"])" == "200")
                {
                    self.apiHit = 0
                    self.selectedChatId = "\(json["data"]["order_help_id"])"
                    self.performSegue(withIdentifier: "orderchat", sender: nil)
                  
                }
                else
                {
                    self.apiHit = 0
                    self.alertFailure(title: "Wait for a moment", Message: "\(json["message"])")
                    //self.setDataViews(jsonData : json)
                }
                
            }
    }

}
