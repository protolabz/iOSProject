//
//  TopCategoryController.swift
//  Xeat
//
//  Created by apple on 30/01/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class TopCategoryController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var indicator: UIView!
   
    @IBOutlet weak var txtHeading: UILabel!
    @IBAction func imgBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
   
    var arrOfNearByRest : [DatumTop] = []
    var searchTextFull = ""
    var strCuisineID = ""
    var selectedIndex = -1
    var strLatitude = ""
    var strLongitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "RestaurantViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RestaurantViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        
        if(UserDefaults.standard.string(forKey: Constant.USERLATITUDE) != nil)
        {
            strLatitude = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
            strLongitude = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
            
        }
        else
        {
            strLatitude = ""
            strLongitude = ""
            
        }
        
        txtHeading.text = searchTextFull
      
        if(currentReachabilityStatus != .notReachable)
        {
            if(strCuisineID == "")
            {
            nearByRestAPI()
            }
            else{
                cuisineRestAPI()
            }
        }
        else{
            alertInternet()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfNearByRest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "RestaurantViewCell", for: indexPath) as! RestaurantViewCell
        cell2.txtName.text = self.arrOfNearByRest[indexPath.row].restName
        cell2.txtLocation.text =  self.arrOfNearByRest[indexPath.row].location
        //
//        let str = Double(self.arrOfNearByRest[indexPath.row].rating)
//        cell2.txtRating.text = "\(String(format: "%.2f", str!))"
        cell2.txtRating.isHidden = true
        
        let urlYourURL = URL (string: arrOfNearByRest[indexPath.row].image )
        cell2.imgRest.loadurl(url: urlYourURL!)
        
        if(arrOfNearByRest[indexPath.row].restType == "1")
        {
            cell2.txtDeliveryPickup.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Pickup", comment: "")
        }
        else{
            cell2.txtDeliveryPickup.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delivery", comment: "")
        }
        
        if(arrOfNearByRest[indexPath.row].status != 2)
        {
            cell2.txtOpenClose.layer.masksToBounds = true
            
            cell2.txtOpenClose.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Close", comment: ""), for: .normal)
            cell2.txtOpenClose.layer.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        
        else{
            cell2.txtOpenClose.layer.backgroundColor = #colorLiteral(red: 0.3315239549, green: 0.8227620721, blue: 0.2893715203, alpha: 1)
        }
        
        cell2.selectionStyle = .none
        
        return cell2
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        
        performSegue(withIdentifier: "menu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let secondViewController = segue.destination as! RestaurantController
        secondViewController.strRestId = arrOfNearByRest[selectedIndex].id
        
        
        
    }
    func nearByRestAPI()
    {
        
        let param =
            ["accesstoken" : Constant.APITOKEN,"src_lati":strLatitude , "src_long": strLongitude, "c_name" : self.searchTextFull , "countryCode" : "+91"]
        print(param)
        AF.request(Constant.baseURL + Constant.topCategoryItemAPI , method: .post, parameters: param).validate().responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
            case .success:
                print("near by restor success")
                self.indicator.isHidden = true
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let status = data["code"]
                        if(status == "200")
                        {
                            let arrdata =  try JSONDecoder().decode(TopCategoryRESTResponse.self, from: response.data!)
                            
                            self.arrOfNearByRest = arrdata.data
                            self.tableView.reloadData()
                        }
                        else
                        {
                            
                            self.alertSucces(title: "No restaurant found", Message: "There is no restaurant for this category")
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
    
    
    func cuisineRestAPI()
    {
        
        let param =
            ["accesstoken" : Constant.APITOKEN,"src_lati":strLatitude , "src_long": strLongitude, "cuisine_id" : self.strCuisineID]
        print(param)
        AF.request(Constant.baseURL + Constant.cuisine_restdetail , method: .post, parameters: param).validate().responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
            case .success:
                print("near by restor success")
                self.indicator.isHidden = true
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let status = data["code"]
                        if(status == "200")
                        {
                            let arrdata =  try JSONDecoder().decode(TopCategoryRESTResponse.self, from: response.data!)
                            
                            self.arrOfNearByRest = arrdata.data
                            self.tableView.reloadData()
                        }
                        else
                        {
                            
                            self.alertSucces(title: "No restaurant found", Message: "There is no restaurant for this category")
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
