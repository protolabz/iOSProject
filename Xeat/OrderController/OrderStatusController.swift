//
//  OrderStatusController.swift
//  Xeat
//
//  Created by apple on 25/01/22.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import SwiftGifOrigin
import Firebase

class OrderStatusController: UIViewController {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBAction func btnOrderReceived(_ sender: Any) {
        orderPickupAPI()
    }
    @IBOutlet weak var btnOrderReceived: UIButton!
    @IBOutlet weak var txtMessageReceived: UILabel!
    @IBOutlet weak var btnWayTo: UIButton!
    @IBOutlet weak var txtOrderId: UILabel!
    var strOrderId = ""
    var restLat = ""
    var restLong = ""
    var screenType = 0
    var backScreen = ""
    var strPhonNumber = ""
    var driverAPIHit = 0
    @IBAction func btnDetails(_ sender: Any) {
        screenType = 0
        performSegue(withIdentifier: "detail", sender: nil)
    }
    var driverDeviceToken = ""
     var driverDeviceType = ""
    var strModeType = ""
    var timer = Timer()
    
    @IBAction func btnWayToRest(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            let str = "comgooglemaps://?saddr=&daddr=\(restLat),\(restLong)&directionsmode=driving"
            print(str)
            UIApplication.shared.open(NSURL(string:
                                               str )! as URL)
           
        } else
        {
    //        NSLog("Can't use com.google.maps://");
    //        let directionsURL = "http://maps.apple.com/?saddr=&daddr=\(Float(strRestLatitude)),\(Float(strRestLongitude))&directionsmode=driving"
            let directionsURL = "http://maps.apple.com/?saddr=&daddr=\(restLat),\(restLong)&directionsmode=driving"
            print(directionsURL)
            guard let url = URL(string: directionsURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBAction func btnCancel(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        btnCancel.isEnabled = false
        
        cancelOrderAlert()
        }
        else{
            alertInternet()
        }
    }
    
    @IBOutlet weak var viewMapDriver: UIView!
    @IBOutlet weak var txtLine3: UILabel!
    @IBOutlet weak var txtLine2: UILabel!
    @IBOutlet weak var txtLine1: UILabel!
    
    @IBOutlet weak var viewDriver: UIView!
    @IBOutlet weak var imgDriver: UIImageView!
    
    @IBOutlet weak var txtDriverName: UILabel!
    
    @IBOutlet weak var txtDriverStatus: UILabel!
    
    @IBOutlet weak var txtVehicleNumber: UILabel!
    
    @IBAction func btnMessage(_ sender: Any) {
        screenType = 3
        if(self.currentReachabilityStatus != .notReachable)
        {
        performSegue(withIdentifier: "chat", sender: "")
        }
        else{
            alertInternet()
        }
    }
    @IBAction func btnCall(_ sender: Any) {
        guard let number = URL(string: "tel://" + strPhonNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBOutlet weak var imgOrderStatus2: UIImageView!
    @IBOutlet weak var imgOrderStatus: UIImageView!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var btnMessage: UIButton!
    
    @IBOutlet weak var btnCall: UIButton!
    
    @IBOutlet weak var txtVmodel: UILabel!
    @IBAction func imgBack(_ sender: Any) {
        if(backScreen == "1")
        {
//            _ = self.navigationController?.popViewController(animated: true)
//            _ = self.navigationController?.popViewController(animated: true)
//
            if strModeType == "0"
            {
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 4])!, animated: true)
            }
            else{
                self.navigationController?.popToViewController((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3])!, animated: true)
            }

        }
        else
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    
    @IBOutlet weak var btnPickup: UIButton!
    @IBAction func btnPickup(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        btnPickup.isEnabled = false
        
        orderPickupAPI()
        }
        else
        {
            alertInternet()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        driverAPIHit = 0
        txtMessageReceived.isHidden = true
        if(backScreen == "1")
        {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        }
        else{
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        }
        
        btnPickup.isHidden = true
        btnPickup.layer.cornerRadius=10
        btnPickup.clipsToBounds=true
        
        btnOrderReceived.isHidden = true
        btnOrderReceived.layer.cornerRadius=10
        btnOrderReceived.clipsToBounds=true
        
        
        btnWayTo.isHidden = true
        btnWayTo.layer.cornerRadius=10
        btnWayTo.clipsToBounds=true
        
        viewMapDriver.isHidden = true
        txtLine1.isHidden = true
        txtLine2.isHidden = true
        txtLine3.isHidden = true
        btnCancel.isHidden = true
        
        viewDriver.layer.borderWidth = 0.5
        viewDriver.layer.masksToBounds = false
        viewDriver.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        viewDriver.layer.cornerRadius = 10
        
        txtOrderId.text = "Order id #" + strOrderId
        UserDefaults.standard.setValue(strOrderId, forKey: Constant.ORDER_ID)
        //orderCurrentStatusAPI()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        nc.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    @objc func appMovedToBackground() {
    }

    @objc func appMovedToForeground() {
        if(self.currentReachabilityStatus != .notReachable)
        {
        orderCurrentStatusAPI()
        
      //  loadMapData()
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [self] _ in
           let timeAPI = UserDefaults.standard.string(forKey: Constant.RUN_ORDERSTATUS)
            if(timeAPI == "1")
            {
                if(self.currentReachabilityStatus != .notReachable)
                {
                orderCurrentStatusAPI()
                }
                else
                {
                    alertInternet()
                }
            }
           
           })
        }
        else
        {
        alertInternet()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if(self.currentReachabilityStatus != .notReachable)
        {
        orderCurrentStatusAPI()
        
      //  loadMapData()
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [self] _ in
           let timeAPI = UserDefaults.standard.string(forKey: Constant.RUN_ORDERSTATUS)
            if(timeAPI == "1")
            {
               
                if(self.currentReachabilityStatus != .notReachable)
                {
                orderCurrentStatusAPI()
                }
                else
                {
                    alertInternet()
                }
            }
           
           })
        }
        else
        {
            alertInternet()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(screenType == 0)
        {
            let secondViewController = segue.destination as! OrderDetailController
            secondViewController.strOrderId = strOrderId
        }
        else if(screenType == 3)
        {
            let secondViewController = segue.destination as! ChatController
            secondViewController.videoId = strOrderId
            secondViewController.driverDeviceToken = driverDeviceToken
            secondViewController.driverDeviceType = driverDeviceType
        }
        else{
            let secondViewController = segue.destination as! OrderRatingController
            secondViewController.strOrderId = strOrderId
            secondViewController.starSelect = "0"
            secondViewController.driverStar = "0"
            secondViewController.screenType = "0"
        }
        
        
    }
    
    func orderCurrentStatusAPI()
    {
        let parameters = ["accesstoken" : Constant.APITOKEN, "oid" : strOrderId]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.orderCurrentStatusAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "200")
            {
                UserDefaults.standard.setValue("0", forKey: Constant.RUN_ORDERSTATUS)
                self.setOrderStatus(json: json)
            }
            else
            {
                
            }
            
        }
    }
    
    func orderPickupAPI()
    {
        let parameters = ["accesstoken" : Constant.APITOKEN, "oid" : strOrderId]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.orderPickUpAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "200")
            {
                self.screenType = 1
                
                self.performSegue(withIdentifier: "rating", sender: nil)
               
            }
            
            else
            {
                self.btnPickup.isEnabled = true
            }
            
        }
    }
    
    func driverDetailAPI()
    {
        let parameters = ["accesstoken" : Constant.APITOKEN, "oid" : strOrderId]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.driverDetailAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "200")
            {
                self.screenType = 1
                self.setDriverData(json : json)
            }
            else
            {
               
            }
            
        }
    }
    
    func cancelOrderAPI()
    {
        let strId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["accesstoken" : Constant.APITOKEN, "oid" : strOrderId , "user_id" : strId]
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.cancelOrderAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["code"])" == "200")
            {
                self.btnCancel.isEnabled = true
                UserDefaults.standard.setValue("0", forKey: Constant.ORDER_ID)
                self.alertRootRedirection(title: "Order cancelled ", Message: "Order cancelled by you successfully")
              
            }
            else
            {
                self.btnCancel.isEnabled = true
                self.alertFailure(title: "Wait for a moment", Message: "\(json["message"])")
            }
            
        }
    }
    
    
    func setDriverData(json : JSON)
    {
        
        driverAPIHit = 1
      
       driverDeviceType = "\(json["data"]["device_type"])"
        driverDeviceToken = "\(json["data"]["device_token"])"
        strPhonNumber = "\(json["data"]["contact"])"
        txtDriverName.text = "\(json["data"]["name"])"
        txtVehicleNumber.text = "Vehicle : " + "\(json["data"]["vehicle_name"])"
        txtVmodel.text =  "Vehicle No : " + "\(json["data"]["vehicle_number"])"
        let urlYourURL =  "\(json["data"]["image"])"
      //  imgDriver.loadurl(url: urlYourURL!)
        if(urlYourURL.count>2){
            let urlYourURL = URL (string:urlYourURL )
            if(urlYourURL != nil)
            {
            imgDriver.loadurl(url: urlYourURL!)
            }
            else{
                imgDriver.image = #imageLiteral(resourceName: "xeat")
            }
            //            DLImageLoader.shared.image(from: urlYourURL, into: imgProfile)
        }
        
        
    }
    func setOrderStatus(json : JSON)
    {
       
        restLat = "\(json["data"]["r_lat"])"
        restLong = "\(json["data"]["r_long"])"
        strModeType = "\(json["data"]["type"])"
        
        switch "\(json["data"]["status"])" {
        
        case "1":
            
            imgOrderStatus.loadGif(asset: "waiting")
            txtLine1.isHidden = true
            txtLine2.isHidden = false
            txtLine3.isHidden = false
            btnCancel.isHidden = false
            btnCall.isHidden = false
            btnMessage.isHidden = false
            viewMapDriver.isHidden = true
            
        case "2":
            if strModeType == "0"
            {
            self.alertRootRedirection(title: "Order rejected", Message: "Your order has been rejected by restaurant. Good food always cooks. You can reorder from another restaurant")
            }
            else{
                self.alertRootRedirection(title: "Order rejected", Message: "Your order has been rejected by grocery store. We wish to continue serving you with our best quality products. You may reorder.")
            }
            UserDefaults.standard.setValue("0", forKey: Constant.ORDER_ID)
        case "5" :
            viewMap.isHidden = true
            viewMapDriver.isHidden = false
          
            if("\(json["data"]["type"])" == "1")
            {
                imgOrderStatus2.loadGif(asset: "grocery")
               
            }
            else
            {
                imgOrderStatus2.loadGif(asset: "foodprepared1")
            }
            btnCall.isHidden = true
            btnMessage.isHidden = true
            if("\(json["data"]["inDriver"])" != "2")
            {
                if(self.currentReachabilityStatus != .notReachable)
                {
                if(driverAPIHit == 0)
                    {
                        self.driverDetailAPI()
                        txtDriverStatus.text = "Order is getting ready"
                    }
                }
                else
                {
                    alertInternet()
                }
            }
            else{
     
                txtDriverStatus.text = "Order is getting ready"
                restData(json: json)
            }
        case "7":
            if("\(json["data"]["order_type"])" == "1")
            {
                viewMapDriver.isHidden = true
                btnWayTo.isHidden = false
                self.txtLine1.isHidden = false
                self.txtLine1.text = "Your order will be ready in few minutes"
                if("\(json["data"]["type"])" == "1")
                {
                    imgOrderStatus.loadGif(asset: "grocery")
                    btnWayTo.setTitle("Way to store", for: .normal)
                }
                else
                {
                imgOrderStatus.loadGif(asset: "foodprepared1")
                    btnWayTo.setTitle("Way to restaurant", for: .normal)
                }
                self.txtLine3.isHidden = true
                self.txtLine2.isHidden = true
                btnCancel.isHidden = true
            }
            else{
                viewMap.isHidden = true
                viewMapDriver.isHidden = false
                if("\(json["data"]["type"])" == "1")
                {
                    imgOrderStatus2.loadGif(asset: "grocery")
                }
                else
                {
                imgOrderStatus2.loadGif(asset: "foodprepared1")
                }
                if("\(json["data"]["inDriver"])" != "2")
                {
                    if(self.currentReachabilityStatus != .notReachable)
                    {
                    if(driverAPIHit == 0)
                    {
                        self.driverDetailAPI()
                       
                        txtDriverStatus.text = "Order is getting ready"
                        
                    }
                    }
                    else{
                        alertInternet()
                    }
                    btnMessage.isHidden = false
                    btnCall.isHidden = false
            }
                else{
                   restData(json: json)
                }
            }
        case "8" :
            if("\(json["data"]["inDriver"])" != "2")
            {
            self.txtLine1.text = "Your order is on the way"
            self.txtLine3.isHidden = true
            self.txtLine2.isHidden = true
            btnCancel.isHidden = true
            
            viewMapDriver.isHidden = false
            txtDriverStatus.text = "Your order is on the way"
            viewMap.isHidden = false
            
//            if(driverAPIHit == 0)
//            {
                btnMessage.isHidden = false
                btnCall.isHidden = false
                if(self.currentReachabilityStatus != .notReachable)
                {
                driverDetailAPI()
                loadMapData()
                }
                else{
                    alertInternet()
                }
            }
            else{
                btnOrderReceived.isHidden = false
               
                restData(json: json)
             //   btnPickup.isHidden = false
                viewMap.isHidden = true
                viewMapDriver.isHidden = false
                imgOrderStatus2.loadGif(asset: "driverdoorstep")
                txtDriverStatus.text = "Driver is at your doorstep"
            }
            
        case "9" :
            if("\(json["data"]["order_type"])" == "1")
            {
                txtLine1.isHidden = false
                btnWayTo.isHidden = false
               // imgOrderStatus.loadGif(asset: "foodprepared1")
                if("\(json["data"]["type"])" == "1")
                {
                    imgOrderStatus.loadGif(asset: "grocery")
                    btnWayTo.setTitle("Way to store", for: .normal)
                }
                else
                {
                imgOrderStatus.loadGif(asset: "foodprepared1")
                    btnWayTo.setTitle("Way to restaurant", for: .normal)
                }
                self.txtLine1.text = "Your order is ready to collect"
                self.txtLine3.isHidden = true
                self.txtLine2.isHidden = true
                btnCancel.isHidden = true
                btnPickup.isHidden = false
            }
            else{
                viewMap.isHidden = true
                viewMapDriver.isHidden = false
                imgOrderStatus2.loadGif(asset: "driverdoorstep")
                txtDriverStatus.text = "Driver is at your doorstep"
                self.ref.child("TRACKING/\(strOrderId)/\(strOrderId)").removeAllObservers()
                if(driverAPIHit == 0)
                {
                    btnMessage.isHidden = false
                    btnCall.isHidden = false
                    if(self.currentReachabilityStatus != .notReachable)
                    {
                    driverDetailAPI()
                    }
                    else{
                        alertInternet()
                    }
                }
            } 
            
        case "10" :
            screenType = 1
            if(self.currentReachabilityStatus != .notReachable)
            {
            self.performSegue(withIdentifier: "rating", sender: nil)
            }
            else{
                alertInternet()
            }
            
            
        case "12" :
            viewMap.isHidden = true
            viewMapDriver.isHidden = false
           // imgOrderStatus2.loadGif(asset: "foodprepared1")
            if("\(json["data"]["type"])" == "1")
            {
                imgOrderStatus2.loadGif(asset: "grocery")
            }
            else
            {
            imgOrderStatus2.loadGif(asset: "foodprepared1")
            }
            self.txtLine1.text = "Order is ready to collect"
            self.txtLine3.isHidden = true
            self.txtLine2.isHidden = true
            btnCancel.isHidden = true
            
               self.ref.child("MESSAGE_READ/\(strOrderId)/USER").observe(DataEventType.value, with: { (snapshot) in
                            let results = snapshot.value as? [String : AnyObject]
                    if(snapshot.exists())
                   {
                            let text = (results?["READ"]) as! String
                       if(text == "1")
                       {
                           self.txtMessageReceived.isHidden = false
                       }
                       else
                       {
                           self.txtMessageReceived.isHidden = true
                       }
                  
                   }
               })
            if("\(json["data"]["inDriver"])" != "2")
            {
                if(self.currentReachabilityStatus != .notReachable)
                {
                if(driverAPIHit == 0)
                {
                    self.driverDetailAPI()

                }
                }
                else{
                    alertInternet()
                }
                btnMessage.isHidden = false
                btnCall.isHidden = false
                txtDriverStatus.text = "Order is ready to collect"
        }
            else{
                txtDriverStatus.text = "Order is ready to collect"
                restData(json: json)
            }
        case "14" :
            if strModeType == "0"
            {
            self.alertRootRedirection(title: "Order not accepted", Message: "Your order is not accepted by restaurant. Order amount will be added in your wallet in few minutes. Explore the food from another restaurant")
            }
            else{
                self.alertRootRedirection(title: "Order not accepted", Message: "Your order is not accepted by grocery store. We wish to continue serving you with our best quality products. You may reorder.")
            }
            UserDefaults.standard.setValue("0", forKey: Constant.ORDER_ID)
        default:
            print("default")
        }
        
    }
    
    func restData(json : JSON)  {
        viewDriver.isHidden = false
        txtVmodel.text = "\(json["data"]["contact_number"])"
        txtVehicleNumber.text = "\(json["data"]["location"])"
        txtDriverName.text = "\(json["data"]["rest_name"])"
        strPhonNumber =  "\(json["data"]["contact_number"])"
        btnMessage.isHidden = true
        btnCall.isHidden = false
        let url = "\(json["data"]["image"])"
        let urlYourURL = URL (string:url)
        if(urlYourURL != nil)
        {
        imgDriver.loadurl(url: urlYourURL!)
        }
    }
    func loadMapData() {

        self.ref.child("TRACKING/\(strOrderId)/\(strOrderId)").observe(DataEventType.value, with: { (snapshot) in
                    let results = snapshot.value as? [String : AnyObject]
     
            if(snapshot.exists())
            {
                
                      let strLatitude : Double = Double(results?["latitude"] as! Substring)!
            
            let strLongitude : Double =  Double(results?["longitutde"] as! Substring)!
            print("firebase works....." + "\(results)")
            print(strLatitude)
        
            let cor = CLLocationCoordinate2DMake(strLatitude, strLongitude)
        self.viewMap.animate(toLocation: cor)
        self.viewMap.setMinZoom(14, maxZoom: 20)
        
                self.viewMap.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: strLatitude, longitude:strLongitude)
        marker.map = self.viewMap
           // let array = Comments(id: id, text: text, createdAt: createdAt, userName: userName)
                    
                DispatchQueue.main.async {
               
                   
                }
            }
        
            })
        
    }
    
    
    func cancelOrderAlert() -> Void
    {
        let refreshAlert = UIAlertController(title: "Order cancel", message: "Are you sure you want to cancel the order?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
            self.btnCancel.isEnabled = true
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //            self.logoutApi()
            self.cancelOrderAPI()
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
}
