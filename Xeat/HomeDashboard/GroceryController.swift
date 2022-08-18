//
//  GroceryController.swift
//  Xeat
//
//  Created by apple on 02/03/22.
//

import UIKit
import SwiftyJSON
import ImageSlideshow

class GroceryController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    var arrOfMainDepartment : [JSON] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var txtOrderID: UILabel!
    @IBOutlet weak var txtNoDataMessage: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var search: UIImageView!
    @IBOutlet weak var viewAddress: UIView!
    var timer = Timer()
    
    var strOrderId2 = ""
    var strOrderId = ""
    var strLatitude = ""
    var strLongitude = ""
    var screenType = 0
    var selectedIndex = 0
    
    @IBAction func btnTrackOrder(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
            let OrderCount = UserDefaults.standard.string(forKey: Constant.ORDER_COUNT)
            if OrderCount == "2"
            {
                alertTwoOrder()
                
            }
            else{
            screenType = 2
            performSegue(withIdentifier: "orderstatus", sender: nil)
            }
        }
        else{
            alertInternet()
        }
    }
    @IBOutlet weak var txtOrderStatus: UILabel!
    @IBOutlet weak var viewTrackOrder: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgSlider: ImageSlideshow!
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("NewFunctionName"), object: nil)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        viewNoData.isHidden = true
        indicator.isHidden = true
        if(UserDefaults.standard.string(forKey: Constant.USERLATITUDE) != nil)
        {
            strLatitude = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
            strLongitude = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
        }
        else
        {
            if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
            {
                strLatitude = "51.8786707"
                strLongitude = "-0.4200255000000652"
                if(currentReachabilityStatus != .notReachable)
                {
                    mainDepartmentAPI()
                }
            }
            else{
                noAddressAlert()
                viewNoData.isHidden = false
            }
           
        }
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GroceryViewCell", bundle: nil), forCellWithReuseIdentifier: "GroceryViewCell")
        collectionView.clipsToBounds = true
        imgSlider.slideshowInterval = 2
        
        imgSlider.contentScaleMode = .scaleToFill
        
        viewAddress.layer.cornerRadius = 10
        //        imgSlider.layer.masksToBounds = false
        imgSlider.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
//        imgSlider.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        imgSlider.layer.cornerRadius = 30
        
        viewAddress.isUserInteractionEnabled = true
        viewAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addressCall)))
        
        search.isUserInteractionEnabled = true
        search.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchCall)))
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.orange
        pageIndicator.pageIndicatorTintColor = UIColor.gray
        imgSlider.pageIndicator = pageIndicator
        //mainDepartmentAPI()
        viewTrackOrder.isHidden = true
        if(self.currentReachabilityStatus != .notReachable)
        {
            flashAPI()
            ongoingOrderAPI()
        }
        else{
            alertInternet()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        if(UserDefaults.standard.string(forKey: Constant.USERADDRESSID) != nil)
        {
            if(!UserDefaults.standard.string(forKey: Constant.USERADDRESSID)!.isEmpty)
            {
                self.txtAddress.text =  UserDefaults.standard.string(forKey: Constant.USERADDRESS)
            }
        }
        if(UserDefaults.standard.string(forKey: Constant.USERLATITUDE) != nil)
        {
            strLatitude = UserDefaults.standard.string(forKey: Constant.USERLATITUDE)!
            strLongitude = UserDefaults.standard.string(forKey: Constant.USERLONGITUDE)!
            if(currentReachabilityStatus != .notReachable)
            {
                mainDepartmentAPI()
            }
            else
            {
                alertInternet()
            }
        }
        else
        {
            //            strLatitude = ""
            //            strLongitude = "" if()
            if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
            {
                strLatitude = "51.8786707"
                strLongitude = "-0.4200255000000652"
                if(currentReachabilityStatus != .notReachable)
                {
                    mainDepartmentAPI()
                }
            }
            else{
                noAddressAlert()
                viewNoData.isHidden = false
            }
            
        }
        
        if(currentReachabilityStatus != .notReachable)
        {
            if( UserDefaults.standard.string(forKey: Constant.ORDER_ID) != "0")
            {
                ongoingOrderAPI()
            }
        }
        else
        {
            alertInternet()
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [self] _ in
            let ongoingorder = UserDefaults.standard.string(forKey: Constant.ONGOING_ORDERAPIHIT)
            if(ongoingorder == "1")
            {
                let timeAPI = UserDefaults.standard.string(forKey: Constant.RUN_ORDERSTATUS)
                if(timeAPI == "1")
                {
                    if(self.currentReachabilityStatus != .notReachable)
                    {
                        if( UserDefaults.standard.string(forKey: Constant.ORDER_ID) != "0")
                        {
                            orderCurrentStatusAPI()
                        }
                    }
                    else{
                        alertInternet()
                    }
                }
            }
            
        })
        
       
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.collectionView.removeObserver(self, forKeyPath: "contentSize")
        timer.invalidate()
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //  if(collectionView == self.collectionView){
        return  arrOfMainDepartment.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroceryViewCell", for: indexPath) as! GroceryViewCell
        
        cell.txtName.text = "\(arrOfMainDepartment[indexPath.row]["category_name"])"
        //        let urlYourURL = URL (string: self.arrOfCuisine[indexPath.row].cuisineImage )
        //        cell.imgGrocery.image = #imageLiteral(resourceName: "icons8-grocery-100")
        
        let urlYourURL = URL (string: "\(self.arrOfMainDepartment[indexPath.row]["category_image"])" )
        //        cell.imgGrocery.loadurl(url: urlYourURL!)
        cell.imgGrocery.af_setImage(
            withURL:  urlYourURL!,
            placeholderImage: UIImage(named: "greybg"),
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0
        {
            selectedIndex = indexPath.row
            //
            //            self.strTopName = arrOfTopCategory[indexPath.row].cName
            if(currentReachabilityStatus != .notReachable)
            {
                screenType = 0
                self.performSegue(withIdentifier: "items", sender: nil)
            }
            else{
                alertInternet()
            }
        }
        else{
            selectedIndex = indexPath.row
            //
            //            self.strTopName = arrOfTopCategory[indexPath.row].cName
            if(currentReachabilityStatus != .notReachable)
            {
                screenType = 5
                self.performSegue(withIdentifier: "offer", sender: nil)
            }
            else{
                alertInternet()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let heightPerItem = collectionView.frame.height / 2 - lay.minimumInteritemSpacing
        
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        return CGSize(width: widthPerItem
                      , height: 130)
        
    }
    func mainDepartmentAPI()
    {
        self.arrOfMainDepartment.removeAll()
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "user_lat" : strLatitude, "user_long" : strLongitude]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.mainDepartment, method: .post, param: parameters, viewController: self) { (json) in
          //  print(json)
            
            if("\(json["code"])" == "200")
            {
                let aa = json["data"]
                // print(aa.count)
                for i in  0..<aa.count
                {
                    //  print(aa[i]["amount"])
                    self.arrOfMainDepartment.append(aa[i])
                }
                self.viewNoData.isHidden = true
                self.collectionView.reloadData()
                
            }
            else if ("\(json["code"])" == "201")
            {
                self.viewNoData.isHidden = false
                //                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
                self.noDeliveryAlert(strMessage: "\(json["message"])")
            }
            else if ("\(json["code"])" == "202")
            {
                //                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
                self.viewNoData.isHidden = false
                self.txtNoDataMessage.text = "\(json["message"])"
            }
            //            else if ("\(json["code"])" == "203")
            //            {
            //                self.viewNoData.isHidden = false
            ////                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            //                self.noDeliveryAlert(strMessage: "\(json["message"])")
            //            }
            
        }
    }
    
    
    func flashAPI()
    {
        var arrOfUrl : [URL] = []
        
        let parameters = ["accesstoken" : Constant.APITOKEN]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.sliderImagesAPI, method: .post, param: parameters, viewController: self) { (json) in
            // print(json)
            
            
            if("\(json["code"])" == "200")
            {
                let data = json["data"]
                // print(data.count)
                var arrOfImageType : [AFURLSource] = []
                for i in 0..<data.count
                
                {
                    let urlYourURL = URL (string: "\(data[i]["image"])" )!
                    arrOfUrl.append(urlYourURL)
                    //  print(arrOfUrl)
                    arrOfImageType.append(AFURLSource.init(url: urlYourURL))
                }
                
                self.imgSlider.setImageInputs(arrOfImageType)
            }
            else
            {
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
                
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(screenType == 0)
        {
            let secondViewController = segue.destination as! GroceryItemController
            secondViewController.strRestId = "\(arrOfMainDepartment[selectedIndex]["id"])"
            secondViewController.strMainCategoryName = "\(arrOfMainDepartment[selectedIndex]["category_name"])"
            secondViewController.strCommission = "\(arrOfMainDepartment[selectedIndex]["commission"])"
            secondViewController.strAgeLimit = "\(arrOfMainDepartment[selectedIndex]["age_limit"])"
        }
        else if(screenType == 2)
        {
            let secondViewController = segue.destination as! OrderStatusController
            secondViewController.backScreen = "0"
            secondViewController.strOrderId = strOrderId
        }
        else if(screenType == 3)
        {
            let secondViewController = segue.destination as! OrderRatingController
            secondViewController.strOrderId = strOrderId
            secondViewController.starSelect = "0"
            secondViewController.driverStar = "0"
            secondViewController.screenType = "0"
        }
        if(screenType == 5)
        {
            let secondViewController = segue.destination as! SpecialOfferController
            secondViewController.strRestId = "\(arrOfMainDepartment[selectedIndex]["id"])"
            secondViewController.strMainCategoryName = "\(arrOfMainDepartment[selectedIndex]["category_name"])"
            secondViewController.strCommission = "\(arrOfMainDepartment[selectedIndex]["commission"])"
            secondViewController.strAgeLimit = "\(arrOfMainDepartment[selectedIndex]["age_limit"])"
        }
        
    }
    
    
    @objc func addressCall()
    {
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
        {
            alertUIGuestUser()
        }
        else{
            screenType = 1
            tabBarController?.selectedIndex = 1
            //        performSegue(withIdentifier: "address", sender: nil)
        }
    }
    
    @objc func searchCall()
    {
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
        {
            alertUIGuestUser()
        }
        else{
            screenType = 1
            performSegue(withIdentifier: "search", sender: nil)
        }
    }
    
    func noDeliveryAlert(strMessage : String) -> Void
    {
        let refreshAlert = UIAlertController(title: "No delivery here", message: strMessage, preferredStyle: UIAlertController.Style.alert)
        
        
        
        refreshAlert.addAction(UIAlertAction(title: "Change address", style: .default, handler: { (action: UIAlertAction!) in
            self.screenType = 1
            self.tabBarController?.selectedIndex = 1
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func noAddressAlert() -> Void
    {
        let refreshAlert = UIAlertController(title: "No address added", message: "You haven't add any address yet. Please add from delivery tab" , preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Add address", style: .default, handler: { (action: UIAlertAction!) in
            self.screenType = 1
            self.tabBarController?.selectedIndex = 1
        }))
        
        present(refreshAlert, animated: true, completion: nil)
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
                UserDefaults.standard.setValue("0", forKey: Constant.ORDER_ID)
            }
            else
            {
                UserDefaults.standard.set("1", forKey: Constant.ONGOING_ORDERAPIHIT)
                UserDefaults.standard.setValue("0", forKey: Constant.RUN_ORDERSTATUS)
                self.viewTrackOrder.isHidden = false
                UserDefaults.standard.setValue("\(json["data"][0]["oid"])", forKey: Constant.ORDER_ID)
                self.strOrderId = "\(json["data"][0]["oid"])"
                let orderStatus = "\(json["data"][0]["status"])"
                let OrderCount = "\(json["data"].count)"
                self.txtOrderID.text = "Order Id : " + self.strOrderId
                UserDefaults.standard.setValue("\(json["data"].count)", forKey: Constant.ORDER_COUNT)
                if OrderCount == "2"
                {
                    self.strOrderId2 = "\(json["data"][1]["oid"])"
                }
                print("orderCount")
                print(OrderCount)
                switch orderStatus {
                case "1":
                    self.txtOrderStatus.text = "Waiting for confirmation"
                case "5":
                    if("\(json["data"][0]["inDriver"])" == "2")
                    {
                        self.txtOrderStatus.text = "Order is getting ready"
                    }
                    else{
                        self.txtOrderStatus.text = "Driver assigned"
                    }
                case "7":
                    self.txtOrderStatus.text = "Order is getting ready"
                case "8":
                    self.txtOrderStatus.text = "Picked by driver"
                    
                case "9":
                    self.txtOrderStatus.text = "Order is ready to collect"
                case "10":
                    self.screenType = 3
                    self.performSegue(withIdentifier: "rating", sender: nil)
                case "12":
                    self.txtOrderStatus.text = "Order is ready"
                case "2":
                    
                    self.alertFailure(title: "Order rejected", Message: "Your order has been rejected. Please try again")
                    self.viewTrackOrder.isHidden = true
                    UserDefaults.standard.setValue("0", forKey: Constant.ORDER_ID)
                case "14" :
                    
                    if("\(json["data"][0]["order_type"])" == "0")
                    {
                    self.alertFailure(title: "Order not accepted", Message: "Your order is not accepted by restaurant. Order amount will be added in your wallet in few minutes. Explore the food from another restaurant")
                    }
                    else{
                        self.alertFailure(title: "Order not accepted", Message: "Your order is not accepted by grocery store. Order amount will be added in your wallet in few minutes")
                    }
                    self.viewTrackOrder.isHidden = true
                    UserDefaults.standard.setValue("0", forKey: Constant.ORDER_ID)
                default:
                    self.txtOrderStatus.text = "Wait for a while"
                }
                //  if("\(json["data"]["oid"])")
                
            }
            
        }
    }
    
    func orderCurrentStatusAPI()
    {
        let oid = UserDefaults.standard.string(forKey: Constant.ORDER_ID)!
        let parameters = ["accesstoken" : Constant.APITOKEN, "oid" : oid]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.orderCurrentStatusAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "200")
            {
                UserDefaults.standard.setValue("0", forKey: Constant.RUN_ORDERSTATUS)
                
                let orderStatus = "\(json["data"]["status"])"
                self.txtOrderID.text = "Order Id : " +  oid
                switch orderStatus {
                case "1":
                    self.txtOrderStatus.text = "Waiting for confirmation"
                case "5":
                    if("\(json["data"]["inDriver"])" == "2")
                    {
                        self.txtOrderStatus.text = "Order is getting ready"
                    }
                    else{
                        self.txtOrderStatus.text = "Driver assigned"
                    }
                case "7":
                    self.txtOrderStatus.text = "Order is getting ready"
                case "8":
                    self.txtOrderStatus.text = "Picked by driver"
                    
                case "9":
                    self.txtOrderStatus.text = "Order is ready to collect"
                case "10":
                    self.screenType = 3
                    self.performSegue(withIdentifier: "rating", sender: nil)
                    
                case "12":
                    self.txtOrderStatus.text = "Order is ready"
                case "2":
                    
                    self.alertFailure(title: "Order rejected", Message: "Your order has been rejected. Please try again")
                    self.viewTrackOrder.isHidden = true
                    UserDefaults.standard.setValue("0", forKey: Constant.ORDER_ID)
                case "14" :
                    if("\(json["data"]["order_type"])" == "0")
                    {
                    self.alertFailure(title: "Order not accepted", Message: "Your order is not accepted by restaurant. Order amount will be added in your wallet in few minutes. Explore the food from another restaurant")
                    }
                    else{
                        self.alertFailure(title: "Order not accepted", Message: "Your order is not accepted by grocery store. Order amount will be added in your wallet in few minutes")
                    }
                    self.viewTrackOrder.isHidden = true
                    UserDefaults.standard.setValue("0", forKey: Constant.ORDER_ID)
                default:
                    self.txtOrderStatus.text = "Wait for a while"
                }
            }
            else
            {
                
            }
            
        }
    }
    
    func alertTwoOrder() -> Void {
        let alert = UIAlertController(title: "Multiple Order", message: "Which order Id status you want to track?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Order Id " + strOrderId, style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            print("default")
                                            self.screenType = 2
                                            
                                            self.performSegue(withIdentifier: "orderstatus", sender: nil)
                                        case .cancel:
                                            print("cancel")
                                            
                                        case .destructive:
                                            print("destructive")
                                            
                                        @unknown default:
                                            break;
                                        }}))
        alert.addAction(UIAlertAction(title: "Order Id " + strOrderId2, style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            print("default")
                                            self.screenType = 2
                                            self.strOrderId = self.strOrderId2
                                            self.performSegue(withIdentifier: "orderstatus", sender: nil)
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
