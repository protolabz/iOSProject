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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        if self.viewIfLoaded?.window != nil {
        //
        cell2.txtCardName.text = "\(arrOfTrans[indexPath.row]["restaurant_name"])"
        cell2.txtCardNumber.text = "\(self.arrOfTrans[indexPath.row]["title"])"
            cell2.txtExpiry.text = "\(self.arrOfTrans[indexPath.row]["description"])"
        
        //
        }
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "rest", sender: nil)
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
    
       
}


