//
//  EditAddressController.swift
//  Xeat
//
//  Created by apple on 30/12/21.
//

import UIKit
import GooglePlaces
import CountryPickerView
import libPhoneNumber_iOS
import GoogleMaps

class EditAddressController: UIViewController, GMSMapViewDelegate , CountryPickerViewDataSource,CountryPickerViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    let marker2 = GMSMarker()
    var strLatitude = ""
    var strLongitude = ""
    
    var strName = ""
//    var strPostalCode = ""
  var strHouseNumber = ""
    var strPhone = ""
    var strAddress = ""
    var strAddressID = ""
    var strDailCode = ""
    var strCountryCode = ""
    var mapLoaded = 0
    var strAdd = ""
    var strPrimaryAdress = ""
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var txtAdijustPin: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBAction func imgBack(_ sender: Any) {
        dismiss(animated: true, completion:nil)
        _ =  navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var edPhone: UITextField!
   @IBOutlet weak var txtHouseNumber: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var edPostalCode: UITextField!
    @IBOutlet weak var imgBack: UIButton!
    
    //    @IBOutlet weak var edCompleteAddress: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var edCity: UITextField!
    
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var edAddress: UITextView!
    
    @IBAction func btnSave(_ sender: Any) {
        userInputValue()
    }
    var locationManager = CLLocationManager()
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        if countryPickerView.tag == countryPicker.tag {
            switch 1 {
           
            case 1: return .hidden
            default: return .hidden
            }
        }
        return .tableViewHeader
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.isMyLocationEnabled = true
        self.setupToHideKeyboardOnTapOnView()
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        initView()
    }
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        ////        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        //        marker.isDraggable = true
        //        marker.map = mapView
        //        self.mapView.delegate = self
        //  marker.isDraggable = true
        
        //  marker.map = mapView
        //        mapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(countryPickerView.selectedCountry)
        
      strCountryCode =   countryPickerView.selectedCountry.code
        strDailCode = countryPickerView.selectedCountry.phoneCode
    }
    
    func initView()
    {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        edAddress.layer.masksToBounds = true
        edAddress.layer.backgroundColor = #colorLiteral(red: 0.9488552213, green: 0.9487094283, blue: 0.9693081975, alpha: 1)
        edAddress.contentInset = UIEdgeInsets.zero;
        edAddress.clipsToBounds = true
        edAddress.layer.cornerRadius = 5
        edAddress.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        edAddress.layer.borderWidth = 0.3
        edAddress.tintColor = .black
        
        txtName.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        txtName.layer.cornerRadius = 5
        txtName.layer.borderWidth = 0.3
        
        txtAdijustPin.backgroundColor = .red
        txtAdijustPin.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        txtAdijustPin.layer.cornerRadius = 10
        txtAdijustPin.layer.borderWidth = 0.3
//        edPostalCode.layer.cornerRadius = 5
//        edPostalCode.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        edPostalCode.layer.borderWidth = 0.3
//
//        txtHouseNumber.layer.cornerRadius = 5
//        txtHouseNumber.layer.borderWidth = 0.3
//        txtHouseNumber.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        
        //        edCompleteAddress.layer.masksToBounds = true
        //        edCompleteAddress.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //
        //        edCompleteAddress.clipsToBounds = true
        //        edCompleteAddress.layer.cornerRadius = 5
        //        edCompleteAddress.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //        edCompleteAddress.layer.borderWidth = 0.3
        
        txtName.text = strName
//        txtHouseNumber.text = strHouseNumber
        edAddress.text = strAddress
//        edPostalCode.text = strPostalCode
        countryPicker.setCountryByCode(strCountryCode)
        countryPicker.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.showCountryNameInView = false
        countryPicker.showCountryCodeInView = false
        edPhone.text = strPhone
      
//        self.edCity.delegate = self
        self.edPhone.delegate = self
        self.txtName.delegate = self
//        self.edAddress.delegate = self
//        self.edPostalCode.delegate = self
        
        self.txtName.tag = 0
//        self.txtHouseNumber.tag = 1
        self.edPhone.tag = 1
        self.edAddress.tag = 2
        
        txtName.attributedPlaceholder = NSAttributedString(string: "Name",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
       

//        txtHouseNumber.attributedPlaceholder = NSAttributedString(string: LocalizationSystem.sharedInstance.localizedStringForKey(key: "House number", comment: ""),
//                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
//
//        edPostalCode.attributedPlaceholder = NSAttributedString(string: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Postal code", comment: ""),
//                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        
        edPhone.attributedPlaceholder = NSAttributedString(string: LocalizationSystem.sharedInstance.localizedStringForKey(key: "XXXXXXXXXX", comment: ""),
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        
        print(strLatitude)
        print(strLongitude)
       // let marker = GMSMarker()
        marker2.icon = #imageLiteral(resourceName: "icons8-location-96.png")
        marker2.position = CLLocationCoordinate2D(latitude: Double(strLatitude)!, longitude: Double(strLongitude)!)
       // marker2.isDraggable = true
        marker2.map = mapView
        self.mapView.delegate = self
        
        let cor = CLLocationCoordinate2DMake(Double(strLatitude)!, Double(strLongitude)!)
        mapView.animate(toLocation: cor)
      // mapView.setMinZoom(14, maxZoom: 20)
        mapView.animate(toZoom: 14.0)
        
        viewPhone.layer.borderWidth = 0.2
        viewPhone.layer.masksToBounds = false
        viewPhone.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        // viewPhoneNumber.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewPhone.layer.cornerRadius = 5
        
        btnSave.layer.cornerRadius = 10
        
        //        edCompleteAddress.isUserInteractionEnabled = true
        //        edCompleteAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.autocompleteClicked)))
        if !hasLocationPermission() {
            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
      
        }
    }
    
    
      func hasLocationPermission() -> Bool {
          var hasPermission = false
          let manager = CLLocationManager()
          
          if CLLocationManager.locationServicesEnabled() {
              switch manager.authorizationStatus {
              case .notDetermined, .restricted, .denied:
                  hasPermission = false
              case .authorizedAlways, .authorizedWhenInUse:
                  hasPermission = true
              @unknown default:
                      break
              }
          } else {
              hasPermission = false
          }
          
          return hasPermission
      }
      
    
    
    //**********************************************MAP******************************************************//
    //Mark: Marker methods
//    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
//        print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
//        reverseGeocoding(marker: marker)
//        print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
//    }
//    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
//        print("didBeginDragging")
//    }
//    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
//        print("didDrag")
//    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("moving start===============================")
         mapLoaded = 1
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //    marker2.draggable = YES;
       // marker2.icon = GMSMarker.markerImage(with: UIColor.red)
      
        if(mapLoaded == 1){
            self.mapView.clear()
          
            marker2.position = CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude);
            marker2.icon = #imageLiteral(resourceName: "icons8-location-96.png")
           // marker2.map = self.mapView;
            marker2.title = strAddress
            marker2.map = self.mapView

        reverseGeocoding(marker: marker2)
        }
    }
    private func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        
        mapView.animate(toLocation: marker.position)
        mapView.selectedMarker = marker
        
        var point = mapView.projection.point(for: marker.position)
        point.y = point.y - 200
        
        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)
        
        return true
        
    }
    
    //Mark: Reverse GeoCoding
    
    func reverseGeocoding(marker: GMSMarker) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
               // let postalCode = address.postalCode!
                
                
                print("Response is = \(address)")
                print("Response is = \(lines)")
                
                currentAddress = lines.joined(separator: "\n")
                
                
                self.txtAddress.text = currentAddress
                self.edAddress.text = currentAddress
                self.strLatitude = "\(address.coordinate.latitude)"
                self.strLongitude = "\(address.coordinate.longitude)"
                
            }
            marker.title = currentAddress
            marker.map = self.mapView
        }
    }
    
    
    
    
    
    func userInputValue()
    {
        
        if(currentReachabilityStatus != .notReachable)
        {
           // let strPhoneNumber = edPhone.text?.trimmingCharacters(in: .whitespaces)
            
            var validNumber : Bool = false
            let strPhoneNumber = edPhone.text?.trimmingCharacters(in: .whitespaces)
            
            
            guard let phoneUtil = NBPhoneNumberUtil.sharedInstance() else {
                return
            }
            do {
                let phoneNumber: NBPhoneNumber = try phoneUtil.parse(strPhoneNumber, defaultRegion: strCountryCode)
                let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
                
                NSLog("[%@]", formattedString)
                validNumber =  phoneUtil.isValidNumber(phoneNumber)
                print(validNumber)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            if let text = txtName.text?.trimmingCharacters(in: .whitespaces), text.isEmpty
            {
                alertFailure(title: "Name empty", Message: "Please enter your name")
            }
            else  if let text2 = edPhone.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
                  alertFailure(title: "Mobile Number empty", Message: "Please enter your mobile number")
              }
//            else if let text2 = txtHouseNumber.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
//                alertFailure(title: "House Number empty", Message: "Please enter house number")
//            }
            else if(!validNumber)
            {
                alertFailure(title: "Mobile Number invalid", Message: "Please enter valid mobile number")
            }
            else if let address = edAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines), address.isEmpty
            {
                alertFailure(title: "Address empty", Message: "Please enter your address")
                
            }
            
//            else if let state = edPostalCode.text?.trimmingCharacters(in: .whitespaces), state.isEmpty
//            {
//                alertFailure(title: "Postal code empty", Message: "Please enter your postal code")
//
//            }
            //        else if let pincode = edCity.text?.trimmingCharacters(in: .whitespaces), pincode.isEmpty
            //        {
            //            alertFailure(title: "City empty", Message: "Please enter your city")
            //
            //        }
            else{
                btnSave.isEnabled = false
                let strMobile = edPhone.text!.trimmingCharacters(in: .whitespaces)
//                let strPincode = edPostalCode.text!.trimmingCharacters(in: .whitespaces)
                var   strAddress = edAddress.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let  strName = txtName.text!.trimmingCharacters(in: .whitespaces)
//                let  strHouse = txtHouseNumber.text!.trimmingCharacters(in: .whitespaces)
                strAddress = strAddress.replacingOccurrences(of: "\n", with: " ")
                print(strAddress)
                addAddressAPI(name: strName, houseNumber: "", address: strAddress, postal: "", phone: strMobile)
                
            }
        }
        else{
            alertInternet()
        }
    }
    
    func addAddressAPI(name : String , houseNumber : String , address: String, postal : String, phone : String)
    {
       strAdd = txtAddress.text!
        let strContact = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["location": address, "com_address":"", "accesstoken" : Constant.APITOKEN, "user_id" : strContact, "landmark" : "", "hte" :strDailCode  , "a_lat" : self.strLatitude , "a_long" : self.strLongitude, "house_number" : houseNumber , "building_number" : strCountryCode , "postal_code" : postal , "phone_number" : phone, "name" : name , "address" : address, "city" : "", "id" : strAddressID]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.editAddressAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            
            if("\(json["code"])" == "200")
            {
                if(self.strPrimaryAdress == "1")
                {
                    UserDefaults.standard.set(name + ", " + address
                                                + ", " + self.strDailCode  + " " +  phone, forKey: Constant.USERADDRESS)
                }
              //  self.btnSave.isEnabled = true
                self.alertSucces(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Success", comment: ""), Message:  "\(json["message"])")
                
            }
            else
            {
                self.btnSave.isEnabled = true
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
            
        }
    }
    
}

