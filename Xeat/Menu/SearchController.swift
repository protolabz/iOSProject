//
//  SearchController.swift
//  Xeat
//
//  Created by apple on 28/01/22.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class SearchController: UIViewController,  UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    var queue = DispatchQueue(label: "search")
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var edSearch: UITextField!
    var arrOfNearByRest : [DatumSearch] = []
    var searchTextFull = ""
    var timer = Timer()
    @IBOutlet weak var txtNoData: UILabel!
    var selectedIndex = -1
    var strLatitude = ""
    var strLongitude = ""
    
    @IBAction func imgBack(_ sender: Any) {
        
        _ =  navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        edSearch.delegate = self
        let nib = UINib(nibName: "RestaurantViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RestaurantViewCell")
        self.setupToHideKeyboardOnTapOnView()
        indicator.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        edSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        edSearch.attributedPlaceholder = NSAttributedString(string: "Search by restaurant or menu item",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        
        self.tableView.separatorStyle = .none
        
        if(UserDefaults.standard.string(forKey: Constant.USERLATITUDE) != nil)
        {
            strLatitude = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
            strLongitude = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
          
        }
        else
        {
            
            self.alertSucces(title: "No address selected", Message: "You haven't select any address yet. Please select from delivery tab")
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [self] _ in
            let timeAPI = edSearch.text?.trimmingCharacters(in: .whitespaces)
            if(timeAPI!.count < 2)
            {
                indicator.isHidden = true
                viewNoData.isHidden = false
                tableView.isHidden = true
            }
            
        })

        // Do any additional setup after loading the view.
    }
   
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText  = edSearch.text!.trimmingCharacters(in: .whitespaces)
        
        print(searchText)
        print(searchText.count)
        
        searchTextFull = searchText
        if(searchText.count>=2){
         
            if(currentReachabilityStatus != .notReachable)
            {
                self.arrOfNearByRest .removeAll()
                self.tableView.reloadData()
                self.tableView.isHidden = true
               // queue.async {
              //  sleep(1)
                    self.nearByRestAPI(searchText: searchText)
               // }
               
            }
            else{
                alertInternet()
            }
        }
        else{
            indicator.isHidden = true
                        viewNoData.isHidden = false
                        self.tableView.isHidden = true
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfNearByRest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "RestaurantViewCell", for: indexPath) as! RestaurantViewCell
        cell2.txtName.text = self.arrOfNearByRest[indexPath.row].restName
        cell2.txtLocation.text =  self.arrOfNearByRest[indexPath.row].location
        //
        let str = Double(self.arrOfNearByRest[indexPath.row].rating)
        cell2.txtRating.text = "\(String(format: "%.2f", str))"
        
        
//        let urlYourURL = URL (string: arrOfNearByRest[indexPath.row].image )
//        cell2.imgRest.loadurl(url: urlYourURL!)
        
        let downloadURL = NSURL(string: arrOfNearByRest[indexPath.row].image)!
        cell2.imgRest.af.setImage(withURL: downloadURL as URL)
        
        
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
            cell2.isUserInteractionEnabled = false
        }
        
        else{
            cell2.txtOpenClose.layer.backgroundColor = #colorLiteral(red: 0.3315239549, green: 0.8227620721, blue: 0.2893715203, alpha: 1)
            cell2.isUserInteractionEnabled = true
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
    func nearByRestAPI(searchText : String)
    {
        self.arrOfNearByRest .removeAll()
       
            self.tableView.isHidden = true
     
        
        let param =
            ["accesstoken" : Constant.APITOKEN,"src_lati": strLatitude , "src_long":strLongitude, "search" : searchText]
        print(param)
        AF.request(Constant.baseURL + Constant.searchAPI , method: .post, parameters: param).validate().responseJSON { (response) in
            debugPrint(response)
            DispatchQueue.main.async {
                self.indicator.isHidden = true
            }
           
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
                            self.arrOfNearByRest .removeAll()
                            self.tableView.reloadData()
                            self.viewNoData.isHidden = true
                            let arrdata =  try JSONDecoder().decode(SearchResponse.self, from: response.data!)

                            DispatchQueue.main.async {
                                self.indicator.isHidden = true
                                self.indicator.startAnimating()
                              
                                self.txtNoData.text = "No restaurant found"
                                self.arrOfNearByRest = arrdata.data
                                self.tableView.isHidden = false
                            self.tableView.reloadData()
                            }
                           
                        }
                        else
                        {
                            self.tableView.isHidden = true
                            self.viewNoData.isHidden = false
                            self.txtNoData.text = "No restaurant found"
                            
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
