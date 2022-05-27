//
//  CouponController.swift
//  Xeat
//
//  Created by apple on 18/01/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class CouponController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    var arrOfCoupon : [JSON] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewNoDataCoupon: UIView!
    @IBOutlet weak var viewCoupon: UIView!
    
    var strRestId = ""
    var position = 0
    
    @IBAction func imgBack(_ sender: Any) {
        
        _ =  navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        viewNoDataCoupon.isHidden = true
        let nib = UINib(nibName: "CouponCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CouponCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        if(currentReachabilityStatus != .notReachable)
        {
            DispatchQueue.main.async {
                self.couponDetailAPI()
            }
        }
        else{
            alertInternet()
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfCoupon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! CouponCell
        //  cell2.txtExpiry.text = "Expiry : " +  "\(self.arrOfCoupon[indexPath.row]["expiry_date"])"
        cell2.txtName.text =   "\(self.arrOfCoupon[indexPath.row]["c_name"])"
        //
       
        if(arrOfCoupon[indexPath.row]["c_type"] == "Fixed")
        {
            cell2.txtAmount.text =  "£" + "\(self.arrOfCoupon[indexPath.row]["discount"])" + " off"
            cell2.txtDesc.text = "This coupon is " + "£" + "\(self.arrOfCoupon[indexPath.row]["discount"])" + " off"
        }
        else
        {
            cell2.txtAmount.text =  "\(self.arrOfCoupon[indexPath.row]["discount"])" + " % off"
            cell2.txtDesc.text =  "This coupon is " + "\(self.arrOfCoupon[indexPath.row]["discount"])" + " % off"
        }
        cell2.btnApply.tag = indexPath.row
        cell2.btnApply.addTarget(self, action: #selector(updatePlus(_:)), for: .touchUpInside)
        cell2.selectionStyle = .none
        return cell2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        position = indexPath.row
        print(position)
        // updateCartProductAPI()
    }
    
    
    @objc func updatePlus(_ sender: UIButton) {
        if(self.currentReachabilityStatus != .notReachable)
        {
            let couponId = "\(arrOfCoupon[sender.tag]["id"])"
            updateCouponAPI(strCouponId: couponId)
            
            
        }
        else{
            self.alertInternet()
        }
        
    }
    
    func couponDetailAPI()
    {
        
        indicator.isHidden = false
        indicator.startAnimating()
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "r_id" : strRestId]
        print(parameters)
        AF.request(Constant.baseURL + Constant.couponListAPI, method: .post, parameters: parameters).validate().responseJSON { (response) in
            debugPrint(response)
            let status = response.response?.statusCode
            if(status == 401)
            {
                self.indicator.isHidden = true
                
                
            }
            else{
                switch response.result {
                case .success:
                    print("Validation Successful)")
                    self.indicator.isHidden = true
                    if let json = response.data {
                        do{
                            let data = try JSON(data: json)
                            
                            let status = data["data"]
                            //  print("data : \(status)")
                            
                            if(status.count == 0)
                            {
                                self.viewNoDataCoupon.isHidden = false
                                self.tableView.isHidden = true
                            }
                            else
                            {
                                self.viewNoDataCoupon.isHidden = true
                                self.tableView.isHidden = false
                                //
                                // let arrdata =  try JSONDecoder().decode(CouponResponse.self, from: response.data!)
                                //  let data = data["data"]
                                //  print(data)
                                for i in 0..<status.count
                                {
                                    print(i)
                                    self.arrOfCoupon.append(status[i])
                                    print(self.arrOfCoupon.count)
                                }
                                self.tableView.reloadData()
                            }
                            //                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            //                        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
                            
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
    
    // @Field("coupon_applied") String coupon_applied,
    // @Field("coupon_id") String coupon_id
    
    
    func updateCouponAPI(strCouponId : String)
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN, "coupon_applied" : "1","coupon_id" : strCouponId ]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.updateAddToCartAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "201")
            {
                
            }
            else
            {
                self.alertSucces(title: "Coupon applied", Message: "Coupon applied on your cart. Enjoy the discount offered by restaurant")
            }
            
        }
    }
    
    
    //    func updateCartProductAPI()
    //    {
    //
    ////        @Field("coupon") coupon: String,
    ////               @Field("address_type") address_type: String,
    //       let variantId = "\(arrOfCoupon[position]["id"])"
    //        let strApiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)!
    //        let headers: HTTPHeaders = [
    //
    //            "Authorization" : strApiToken,
    //            "Accept" : "application/json"
    //        ]
    //
    //        let parameters = ["coupon" :  variantId, "address_type" : "0"]
    //        print(parameters)
    //        indicator.isHidden = false
    //        indicator.startAnimating()
    //
    //        AF.request(Constant.baseURL + Constant.updateCart , method: .post,parameters: parameters,headers: headers).validate().responseJSON { (response) in
    //            debugPrint(response)
    //            switch response.result {
    //            case .success:
    //                print("Validation Successful)")
    //                self.indicator.isHidden = true
    //                if let json = response.data {
    //                    do{
    //                        let data = try JSON(data: json)
    //
    //                        let status = data["code"]
    //                       // print("data parsed add to cart wishlist: \(status)")
    //
    //                        if(status == 200)
    //                        {
    //                            _ =  self.navigationController?.popViewController(animated: true)
    //                        }
    //                        else
    //                        {
    //                            self.alertUICoupon(title: "Coupon Applied", Message: "\(data["message"])")
    //                        }
    //                    }
    //                    catch{
    //
    //                        self.indicator.isHidden = true
    //                        print(error)
    //                    }
    //
    //                }
    //            case .failure(let error):
    //                print(error)
    //
    //                self.indicator.isHidden = true
    //            }
    //        }
    //    }
    
    
    
    
}
