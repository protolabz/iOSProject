//
//  APIManagers.swift
//  Xeat
//
//  Created by apple on 16/12/21.
//

import Foundation
import Alamofire
import SwiftyJSON


class APIsManager: NSObject {
    
    static let shared = APIsManager()
    
//    var APIHeader: HTTPHeaders {
//        let header : HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.currentUser?.token ?? "")"]
//        return header
//    }
   
    func requestService(withURL: String,method: HTTPMethod,param: [String:Any], header: HTTPHeaders? = nil , viewController:UIViewController, completionHandler: @escaping (_ result: JSON) -> Void) {
        viewController.view.endEditing(true)
        if(currentReachabilityStatus != .notReachable)
        {
        viewController.showProgressLoader()
        let url = Constant.baseURL + withURL
        AF.request(url, method: method, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
//debugPrint(response)
            switch response.result {
            case .success(_):
                let jsonData = JSON(response.data)
                //print(jsonData)
                viewController.hideProgressLoader()
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        completionHandler(jsonData)
                    } else if statusCode == 204 {
                        completionHandler(jsonData)
                    } else {
                        var error = jsonData["errors"].arrayValue.first?.stringValue ?? ""
                        if error.isEmpty {
                            error = jsonData["message"].stringValue
                            if error.isEmpty {
                                error = jsonData["error"].stringValue
                            }
                        }
//                        if statusCode == 401 {
//                            let alert = UIAlertController(title: localizedString.session_expired.key.localized(), message: nil, preferredStyle: UIAlertController.Style.alert)
//                            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (okeyButton) in
//                                
//                                    let domain = Bundle.main.bundleIdentifier ?? ""
//                                    UserDefaults.standard.removePersistentDomain(forName: domain)
//                                    UserDefaults.standard.synchronize()
//                                
//                              
//                                viewController.navigationController?.popToRootViewController(animated: true)
//
//                            }
//                            alert.addAction(ok)
//                            viewController.present(alert, animated: true, completion: nil)
//                        } else {
//                            viewController.showAlertView(with: error)
//                        }
                    }
                }
            case .failure(_):
                viewController.hideProgressLoader()
                print(response.error!.localizedDescription)
                break
            }
        }
        }
        else{
            viewController.alertInternet()
    }
    
    }
}
    

