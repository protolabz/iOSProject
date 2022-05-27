//
//  ViewController.swift
//  Xeat
//
//  Created by apple on 15/12/21.
//

import UIKit
import AVKit
import SystemConfiguration

class ViewController: UIViewController {

    var viewLoad = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view load")
        setupAVPlayer()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
      }

    
   
        override func viewWillAppear(_ animated: Bool) {
            print("view appear")
            
            if(viewLoad == 1)
            {
            if(UserDefaults.standard.string(forKey: Constant.IS_LOGGEDIN) == "1")
            {
                if(currentReachabilityStatus != .notReachable)
                {

                    performSegue(withIdentifier: "home", sender: nil)
                }
                else{
                    alertInternetMain()
                }
            }
            else{
    //           viewLoginSignUp.isHidden = false
                         performSegue(withIdentifier: "selection", sender: nil)
            }

            
           
        }
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    
    
    func setupAVPlayer() {
        
        let videoURL = Bundle.main.url(forResource: "video1", withExtension: ".mp4") // Get video url
        let avAssets = AVAsset(url: videoURL!) // Create assets to get duration of video.
        let avPlayer = AVPlayer(url: videoURL!) // Create avPlayer instance
        let avPlayerLayer = AVPlayerLayer(player: avPlayer) // Create avPlayerLayer instance
        avPlayerLayer.frame = self.view.bounds // Set bounds of avPlayerLayer
        self.view.layer.addSublayer(avPlayerLayer) // Add avPlayerLayer to view's layer.
        avPlayer.play()
        // Play video
        
        
        // Add observer for every second to check video completed or not,
        // If video play is completed then redirect to desire view controller.
        avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1) , queue: .main) { [weak self] time in
            
            if time == avAssets.duration {
                print(UserDefaults.standard.string(forKey: Constant.IS_LOGGEDIN) )
                if(UserDefaults.standard.string(forKey: Constant.IS_LOGGEDIN) == "1")
                {
                    if(self!.currentReachabilityStatus != .notReachable)
                    {
                        self!.viewLoad = 1
                        self!.performSegue(withIdentifier: "home", sender: nil)
                    }
                    else{
                        self!.viewLoad = 1
                        self!.alertInternetMain()
                    }
                }
                else{
                    self!.viewLoad = 1
        //           viewLoginSignUp.isHidden = false
                    self!.performSegue(withIdentifier: "selection", sender: nil)
                }
               
                //                   let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                //                   self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}



extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func alertInternetMain() -> Void {
        let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Internet connection", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "It seems your internet connection lost. Please connect and try again", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            print("default")
                                            if(self.currentReachabilityStatus != .notReachable)
                                            {
                                               
                                                self.performSegue(withIdentifier: "home", sender: nil)
                                            }
                                            else{
                                                self.alertInternetMain()
                                            }
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

extension UIViewController
{
    var isNetworkConnected: Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
  
    func alertUIUnauthorised() {
        let viewController = UIApplication.shared.windows.first!.rootViewController

            let alert = UIAlertController(title: "Unauthorized", message: "It seems you are logged in another device. To access this feature please re-login", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                                            switch action.style{
                                            case .default:
                                           //UserDefaults.standard.set("0", forKey: Constant.IS_LOGGEDIN)
//                                                viewController!.navigationController?.popToRootViewController(animated: true)
                                                self.navigationController?.popToRootViewController(animated: true)

                                                print("default")
                                            case .cancel:
                                                print("cancel")
                                                
                                            case .destructive:
                                                print("destructive")
                                                
                                            @unknown default:
                                                break;
                                            }}))
        viewController!.present(alert, animated: true, completion: nil)
            
        }
    
    func alertRootRedirection(title: String,Message : String) -> Void {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            print("default")
                                            self.navigationController?.popToRootViewController(animated: true)
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
    
    func alertSucces(title: String,Message : String) -> Void {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            print("default")
                                            _ = self.navigationController?.popViewController(animated: true)
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
    
    func alertInternet() -> Void {
        let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Internet connection", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "It seems your internet connection is lost. Please connect and try again", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            print("default")
                                           
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
    
    func alertUIGuestUser() -> Void {
        let alert = UIAlertController(title: "Guest user", message: "It seems you are logged in as guest user. To access this feature please do login/signup", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            UserDefaults.standard.set("0", forKey: Constant.IS_LOGGEDIN)
                                         
                                            UserDefaults.standard.set(nil, forKey: Constant.USERADDRESS)
                                            UserDefaults.standard.set(nil, forKey: Constant.USERLATITUDE)
                                            UserDefaults.standard.set(nil, forKey: Constant.USERLONGITUDE)
                                            self.navigationController?.popToRootViewController(animated: true)
                                            print("default")
                                        case .cancel:
                                            print("cancel")
                                            
                                        case .destructive:
                                            print("destructive")
                                            
                                        @unknown default:
                                            break;
                                        }}))
      
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func alertFailure(title: String,Message : String) -> Void {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
       
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            print("default")
                                            
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
    
    func showProgressLoader() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 55, height: 55))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        let ViewCenter = self.view.center
        let ViewHeight = self.view.frame.height
        let ScreenHeight = UIScreen.main.bounds.height
        var ScreenCenter = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        if ViewHeight < ScreenHeight {
            ScreenCenter.y -= 10.0
        }
        //activityIndicator.center = ViewHeight < ScreenHeight ? ScreenCenter : ViewCenter
        activityIndicator.center = ViewCenter
        activityIndicator.tag = 1000
        activityIndicator.hidesWhenStopped = false
        activityIndicator.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        activityIndicator.layer.cornerRadius = 5
        activityIndicator.layer.masksToBounds = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func hideProgressLoader() {
        let array = self.view.subviews.filter({$0.isKind(of: UIActivityIndicatorView.self)})
        print(array)
        
        for activity in array {
            if let activityIndicator = activity as? UIActivityIndicatorView {
                if activityIndicator.tag == 1000 {
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    activityIndicator.removeFromSuperview()
                }
            }
        }
        if array.count > 0 {
            if let activityIndicator = array[0] as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                activityIndicator.removeFromSuperview()
            }
        }
        if let activityIndicator = self.view.subviews.filter(
            { $0.tag == 1000}).first as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            activityIndicator.removeFromSuperview()
        }
    }
    func showAlertView(with message:String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: UIAlertAction.Style.cancel) { (okeyButton) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension String {
    
    func isValidateEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
   
    
}

protocol Utilities { }

extension NSObject:Utilities{


enum ReachabilityStatus {
case notReachable
case reachableViaWWAN
case reachableViaWiFi
}

var currentReachabilityStatus: ReachabilityStatus {

var zeroAddress = sockaddr_in()
zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
zeroAddress.sin_family = sa_family_t(AF_INET)

guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
SCNetworkReachabilityCreateWithAddress(nil, $0)
}
}) else {
return .notReachable
}

var flags: SCNetworkReachabilityFlags = []
if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
return .notReachable
}

if flags.contains(.reachable) == false {
// The target host is not reachable.
return .notReachable
}
else if flags.contains(.isWWAN) == true {
// WWAN connections are OK if the calling application is using the CFNetwork APIs.
return .reachableViaWWAN
}
else if flags.contains(.connectionRequired) == false {
// If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
return .reachableViaWiFi
}
else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
// The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
return .reachableViaWiFi
}
else {
return .notReachable
}
}

}


extension UIImageView {
    func loadurl(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}
extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}
