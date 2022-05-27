//
//  DiscoveryController.swift
//  Xeat
//
//  Created by apple on 21/12/21.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class DiscoveryController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,  UITableViewDelegate,UITableViewDataSource , UIScrollViewDelegate , UIGestureRecognizerDelegate{
    
    var selectedIndex = -1
    var screenType = 0
    var strOrderId = ""
    var strLatitude = ""
    var strLongitude = ""
    var strTopName = ""
    var timer = Timer()
    @IBOutlet weak var collectionCuisine: UICollectionView!
    @IBOutlet weak var viewNoData: UIView!
    var refreshControl : UIRefreshControl!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBAction func btnTrackOrder(_ sender: Any) {
        screenType = 2
        performSegue(withIdentifier: "track", sender: nil)
    }
    @IBOutlet weak var txtOrderStatus: UILabel!
    @IBOutlet weak var viewTrackOrder: UIView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var arrOfTopCategory : [DatumTopCategory]  = []
    var arrOfNearByRest : [DatumNearBy] = []
    var arrOfCuisine : [DatumCuisine] = []
    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var txtDeliveryAddress: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("NewFunctionName"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    //    func myDiscoveryToCallFromAnywhere() {
    //        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) != "2")
    //        {
    //            sleep(2)
    //            nearByRestAPI()
    //        }
    //    }
    
    func askForNotification()
    {
    let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        print(isRegisteredForRemoteNotifications)
    if !isRegisteredForRemoteNotifications {
    let alert = UIAlertController(title: "Allow notification Access", message: "Allow notification access in your device settings.", preferredStyle: UIAlertController.Style.alert)

    // Button to Open Settings
    alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                    return
                                }
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                        print("Settings opened: \(success)")
                                    })
                                }
                            }))
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    }
                        
    func initViews()
    {
       // askForNotification()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TopCategoryCell", bundle: nil), forCellWithReuseIdentifier: "TopCategoryCell")
        collectionView.clipsToBounds = true
        scrollView.delegate = self
        viewNoData.isHidden = true
        viewTrackOrder.isHidden = true
        
        //        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        //        layout?.minimumLineSpacing = 2
        
        
        
        let collectionFlowLayout = UICollectionViewFlowLayout()

        collectionFlowLayout.scrollDirection = .horizontal
      //  collectionFlowLayout.itemSize = CGSize(width: 145, height: 145)
        collectionCuisine.setCollectionViewLayout(collectionFlowLayout, animated: true)
        collectionCuisine.delegate = self
        collectionCuisine.dataSource = self
        collectionCuisine.register(UINib(nibName: "CuisineCell", bundle: nil), forCellWithReuseIdentifier: "CuisineCell")
        
        collectionCuisine.clipsToBounds = true
        
        let nib = UINib(nibName: "RestaurantViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RestaurantViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
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
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor.clear
        self.refreshControl.tintColor = UIColor.black
        scrollView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        //        if(currentReachabilityStatus != .notReachable)
        //        {
        //            topCategoryAPI()
        //
        //         //   nearByRestAPI()
        //        }
        //        else{
        //            alertInternet()
        //        }
        //
        viewAddress.isUserInteractionEnabled = true
        viewAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addressCall)))
        
        imgSearch.isUserInteractionEnabled = true
        imgSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchCall)))
        viewAddress.layer.cornerRadius = 10
        
        cuisineAPI()
    }
    
    @objc func functionName (notification: NSNotification){
        if(UserDefaults.standard.string(forKey: Constant.USERADDRESSID) != nil)
        {
            
            if(!UserDefaults.standard.string(forKey: Constant.USERADDRESSID)!.isEmpty)
            {
                self.txtDeliveryAddress.text =  UserDefaults.standard.string(forKey: Constant.USERADDRESS)
            }
        }
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
        nearByRestAPI()
        //topCategoryAPI()
    }
    override func viewWillDisappear(_ animated: Bool) {
       
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
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
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        if(UserDefaults.standard.string(forKey: Constant.USERADDRESSID) != nil)
        {
            
            if(!UserDefaults.standard.string(forKey: Constant.USERADDRESSID)!.isEmpty)
            {
                self.txtDeliveryAddress.text =  UserDefaults.standard.string(forKey: Constant.USERADDRESS)
            }
        }
        
        if(currentReachabilityStatus != .notReachable)
        {
            //           let apiHit = UserDefaults.standard.string(forKey: Constant.ONGOING_ORDERAPIHIT)
            //
            //            if(apiHit == "1")
            //            {
            nearByRestAPI()
           // topCategoryAPI()
            ongoingOrderAPI()
           // cuisineAPI()
            //            }
        }
        else{
            alertInternet()
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [self] _ in
            let ongoingorder = UserDefaults.standard.string(forKey: Constant.ONGOING_ORDERAPIHIT)
            if(ongoingorder == "1")
            {
           let timeAPI = UserDefaults.standard.string(forKey: Constant.RUN_ORDERSTATUS)
            if(timeAPI == "1")
            {
               
                ongoingOrderAPI()
            }
            }
           
           })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    @objc func refresh(_ sender: Any) {
        nearByRestAPI()
        cuisineAPI()
      //  topCategoryAPI()
    }
    
    @objc func addressCall()
    {
        screenType = 1
        performSegue(withIdentifier: "address", sender: nil)
    }
    
    @objc func searchCall()
    {
        screenType = 3
        performSegue(withIdentifier: "search", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.collectionView){
        return  arrOfTopCategory.count
        }
        else{
            return arrOfCuisine.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       

        if(collectionView == self.collectionView)
        {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCategoryCell", for: indexPath) as! TopCategoryCell
          
        cell.txtName.text = arrOfTopCategory[indexPath.row].cName
       
        return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisineCell", for: indexPath) as! CuisineCell
          
//            if indexPath.row % 2 == 0 {
//                       cell.contentView.backgroundColor = UIColor.red
//                   } else {
//                       cell.contentView.backgroundColor = UIColor.green
//                   }
            cell.txtName.text = arrOfCuisine[indexPath.row].cuisine
//            DispatchQueue.main.async(execute: {() -> Void in
                
//                if cell.tag == indexPath.row {
                    let urlYourURL = URL (string: self.arrOfCuisine[indexPath.row].cuisineImage )
                    cell.imgCuisine.loadurl(url: urlYourURL!)
                    
            cell.imgCuisine.af_setImage(
                withURL:  urlYourURL!,
                placeholderImage: UIImage(named: "xeat"),
                filter: nil,
                imageTransition: UIImageView.ImageTransition.crossDissolve(0.5),
                runImageTransitionIfCached: false) {
                // Completion closure
                response in
                if response.response != nil {
                    // Force the cell update
                    //                                   self.collectionView.beginUpdates()
                    //                                   self.collectionView.endUpdates()
                }
            }
//                }
//            })
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == self.collectionView)
        {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        
            return CGSize(width:widthPerItem, height:30)
        }
        else{
            let lay = collectionViewLayout as! UICollectionViewFlowLayout
            let heightPerItem = collectionView.frame.height / 2 - lay.minimumInteritemSpacing
            
            let widthPerItem = collectionView.frame.width / 2.2 - lay.minimumInteritemSpacing
            
            return CGSize(width: widthPerItem
                          , height: heightPerItem)
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.collectionView){
            selectedIndex = indexPath.row

        self.strTopName = arrOfTopCategory[indexPath.row].cName
        screenType = 4
        self.performSegue(withIdentifier: "top", sender: nil)
        }
        else{
            self.strTopName = arrOfCuisine[indexPath.row].cuisine
            selectedIndex = indexPath.row
            screenType = 5
            self.performSegue(withIdentifier: "top", sender: nil)
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
        let str = Double(self.arrOfNearByRest[indexPath.row].rating)
        cell2.txtRating.text = "\(String(format: "%.2f", str!))"
        cell2.tag = indexPath.row
        DispatchQueue.main.async(execute: {() -> Void in
            
            if cell2.tag == indexPath.row {
                let urlYourURL = URL (string: self.arrOfNearByRest[indexPath.row].image )
                cell2.imgRest.loadurl(url: urlYourURL!)
                
            }
        })
        
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
            cell2.txtOpenClose.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Open", comment: ""), for: .normal) 
            cell2.txtOpenClose.layer.backgroundColor = #colorLiteral(red: 0.3315239549, green: 0.8227620721, blue: 0.2893715203, alpha: 1)
            cell2.isUserInteractionEnabled = true
        }
        
        cell2.selectionStyle = .none
        
        return cell2
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        screenType = 0
        performSegue(withIdentifier: "menu", sender: nil)
    }
    
    
    
    func topCategoryAPI()
    {
        let param =
            ["accesstoken" : Constant.APITOKEN,"src_lati": strLatitude, "src_long":strLongitude , "countryCode" : "+91"]
        print(param)
        AF.request(Constant.baseURL + Constant.topCategoryAPI , method: .post, parameters: param).validate().responseJSON { (response) in
           //// debugPrint(response)
            
            switch response.result {
            case .success:
                //  print("Validation Successful)")
                self.indicator.isHidden = true
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let status = data["code"]
                        if(status == "200")
                        {
                            let arrdata =  try JSONDecoder().decode(TopCategoryResponse.self, from: response.data!)
                            
                            self.arrOfTopCategory = arrdata.data
                            self.collectionView.reloadData()
                        }
                        else
                        {
                            
                            
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
    
    
    
    func nearByRestAPI()
    {
        self.tableView.isHidden  = true
        UserDefaults.standard.set("0", forKey: Constant.LOCATIONSCREEN)
        let param =
            ["accesstoken" : Constant.APITOKEN,"src_lati": strLatitude , "src_long": strLongitude]
        print(param)
        AF.request(Constant.baseURL + Constant.nearByRestarantAPI , method: .post, parameters: param).validate().responseJSON { (response) in
        debugPrint(response)
//            if(self.refreshControl != nil)
//            {
//                self.refreshControl.endRefreshing()
//            }
            self.refreshControl.endRefreshing()
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
                            self.arrOfNearByRest.removeAll()
                            let arrdata =  try JSONDecoder().decode(NearbyRestaurantResponse.self, from: response.data!)
                            
                            self.arrOfNearByRest = arrdata.data
                            self.tableView.isHidden = false
                            self.viewNoData.isHidden = true
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.tableView.isHidden = true
                            self.viewNoData.isHidden = false
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
    
    func cuisineAPI()
    {
        let param =
            ["accesstoken" : Constant.APITOKEN ]
        print(param)
        AF.request(Constant.baseURL + Constant.cuisineList , method: .post, parameters: param).validate().responseJSON { (response) in
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
                            let arrdata =  try JSONDecoder().decode(CuisineListResponse.self, from: response.data!)
                            self.arrOfCuisine = arrdata.data
                            self.collectionCuisine.reloadData()
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

    func ongoingOrderAPI()
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.ongoingOrderAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "201")
            {
                self.viewTrackOrder.isHidden = true
                UserDefaults.standard.set("0", forKey: Constant.ONGOING_ORDERAPIHIT)
            }
            else
            {
                UserDefaults.standard.set("1", forKey: Constant.ONGOING_ORDERAPIHIT)
                UserDefaults.standard.setValue("0", forKey: Constant.RUN_ORDERSTATUS)
                self.viewTrackOrder.isHidden = false
                self.strOrderId = "\(json["data"]["oid"])"
                let orderStatus = "\(json["data"]["status"])"
                switch orderStatus {
                case "1":
                    self.txtOrderStatus.text = "Waiting for confirmation"
                case "5":
                    if("\(json["data"]["inDriver"])" == "2")
                    {
                    self.txtOrderStatus.text = "Food is being prepared"
                    }
                    else{
                        self.txtOrderStatus.text = "Driver assigned"
                    }
                case "7":
                    self.txtOrderStatus.text = "Food is being prepared"
                case "8":
                    self.txtOrderStatus.text = "Picked by driver"
                    
                case "9":
                    self.txtOrderStatus.text = "Order is ready to collect"
                    
                case "12":
                    self.txtOrderStatus.text = "Order is ready"
                    
                default:
                    self.txtOrderStatus.text = "Wait for a while"
                }
                //  if("\(json["data"]["oid"])")
                
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(screenType == 0)
        {
            let secondViewController = segue.destination as! RestaurantController
            secondViewController.strRestId = arrOfNearByRest[selectedIndex].id
        }
        else if(screenType == 2)
        {
            let secondViewController = segue.destination as! OrderStatusController
            secondViewController.backScreen = "0"
            secondViewController.strOrderId = strOrderId
        }
        else if(screenType == 4)
        {
            self.collectionView.reloadData()

            let seconVC = segue.destination as! TopCategoryController
            seconVC.searchTextFull = strTopName
           seconVC.strCuisineID = ""
        }
        else if(screenType == 5)
        {
            self.collectionCuisine.reloadData()
            let seconVC = segue.destination as! TopCategoryController
            seconVC.searchTextFull = strTopName
            seconVC.strCuisineID = "\(arrOfCuisine[selectedIndex].id)"
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"
        {
            if let newValue = change?[.newKey]
            {
                let newSize  = newValue as! CGSize
                self.tblHeight.constant = newSize.height
            }
            
        }
    }
    
}

