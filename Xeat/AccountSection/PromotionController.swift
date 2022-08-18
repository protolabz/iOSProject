//
//  PromotionController.swift
//  Xeat
//
//  Created by apple on 27/04/22.
//
import SwiftyJSON
import UIKit

class PromotionController: UIViewController,  UITableViewDelegate,UITableViewDataSource {

    @IBAction func imgBack(_ sender: Any) {
        _ =  navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tableView: UITableView!
    var arrOfTrans : [JSON] = []
    var selectedIndex = 0
    var strMode = "-1"
    var strScreenType = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        
        indicator.isHidden = true
        viewNoData.isHidden = true
        
        let nib = UINib(nibName: "SavedCardCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SavedCardCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        if("\(UserDefaults.standard.string(forKey: Constant.SELECTION_MODE) ?? "1")" == "1")
            {
            strMode = "1"
        }
        else{
            strMode = "0"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if("\(UserDefaults.standard.string(forKey: Constant.SELECTION_MODE) ?? "1")" == "1")
            {
            strMode = "1"
        }
        else{
            strMode = "0"
        }
        if(currentReachabilityStatus != .notReachable)
        {
           promotionListAPI()
        }
        else{
            alertInternet()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfTrans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "SavedCardCell", for: indexPath) as! SavedCardCell
        if self.viewIfLoaded?.window != nil
        {
        //
        cell2.txtCardName.text = "\(arrOfTrans[indexPath.row]["restaurant_name"])"
        cell2.txtCardNumber.text = "\(self.arrOfTrans[indexPath.row]["title"])"
        cell2.txtExpiry.text = "\(self.arrOfTrans[indexPath.row]["description"])"
        }
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.currentReachabilityStatus != .notReachable)
        {
       if strMode == "\(arrOfTrans[indexPath.row]["type"])"
       {
        if strMode == "0"
        {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "rest", sender: nil)
        }
        else{
            selectedIndex = indexPath.row
            self.navigationController?.popToRootViewController(animated: true)
        }
       }
       else
       {
        
            profileCall2()
       }
        }
        else
        {
            alertInternet()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let secondViewController = segue.destination as! RestaurantController
            secondViewController.strRestId = "\(arrOfTrans[selectedIndex]["r_id"])"
    }
    
   
    func promotionListAPI()
    {
        arrOfTrans.removeAll()
        let parameters = ["accesstoken" : Constant.APITOKEN]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.promotionList, method: .post, param: parameters, viewController: self) { (json) in
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
    
    func profileCall2()
    {
       
       
        var str1 =   ""
        var str2 = ""
        var strNewMode = ""
    
        
        if strMode == "1"
    
        {
        str1 = "Grocery"
        str2 = "Food ordering"
            strNewMode = "0"
        }
        else
        {
            str2 = "Grocery"
            str1 = "Food ordering"
            strNewMode = "1"
        }
        let refreshAlert = UIAlertController(title: "Switch mode", message: "This offer is available in \(str2) mode. Please switch mode to use this offer", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Switch", style: .default, handler: { (action: UIAlertAction!) in

            UserDefaults.standard.set(strNewMode, forKey: Constant.SELECTION_MODE)
            if(self.currentReachabilityStatus != .notReachable)
            {
            self.deleteCartApi()
            if strNewMode == "0"
            {
                self.performSegue(withIdentifier: "rest", sender: nil)
            }
            else{
                self.navigationController?.popToRootViewController(animated: true)
            }
            }
            else
            {
                self.alertInternet()
            }
           //
            
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func deleteCartApi()
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.CART_ID)!
        let parameters = ["accesstoken" : Constant.APITOKEN, "cart_id" : strUserId]

        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.cartDeleteModeChange, method: .post, param: parameters, viewController: self) { (json) in
            print(json)

        }
    }
}


