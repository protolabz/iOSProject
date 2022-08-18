//
//  SelectModeController.swift
//  Xeat
//
//  Created by apple on 02/03/22.
//

import UIKit

class SelectModeController: UIViewController {

    @IBOutlet weak var txtGrocery: UILabel!
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var imgaGrocery: UIImageView!
    @IBOutlet weak var viewFood: UIView!
    @IBOutlet weak var viewGrocery: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewFood.layer.borderWidth = 0.5
        viewFood.layer.masksToBounds = false
        viewFood.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewFood.layer.cornerRadius = 10
        
        viewGrocery.layer.borderWidth = 0.5
        viewGrocery.layer.masksToBounds = false
        viewGrocery.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewGrocery.layer.cornerRadius = 10

        viewFood.isUserInteractionEnabled = true
        viewFood.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewF)))
        
        viewGrocery.isUserInteractionEnabled = true
        viewGrocery.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewG)))
    
       otpCall()
    }
    
@objc func viewG()
{
    let mode =   "\(UserDefaults.standard.string(forKey: Constant.SELECTION_MODE) ?? "0")"
    if(mode == "0")
    {
        removeCartDataAPI()
    }
    
    UserDefaults.standard.setValue("1", forKey: Constant.SELECTION_MODE)
    UserDefaults.standard.setValue("0", forKey: Constant.AGE_LIMIT)
    UserDefaults.standard.setValue( "0", forKey: Constant.CART_ID)


   performSegue(withIdentifier: "homeg", sender: nil)
    
}
   
    @objc func viewF()
    {
        let mode =   "\(UserDefaults.standard.string(forKey: Constant.SELECTION_MODE) ?? "0")"
          if(mode == "1")
          {
              removeCartDataAPI()
          }
          
        UserDefaults.standard.setValue("0", forKey: Constant.SELECTION_MODE)
        UserDefaults.standard.setValue("0", forKey: Constant.AGE_LIMIT)
        UserDefaults.standard.setValue( "0", forKey: Constant.CART_ID)


      performSegue(withIdentifier: "home", sender: nil)
    }
    
    func otpCall()
    {
        
        let parameters = ["accesstoken" : Constant.APITOKEN]
        
        APIsManager.shared.requestService(withURL: Constant.groceryFoodImageAPI, method: .post, param: parameters, viewController: self) { (json) in
         //print(json)
            if("\(json["code"])" == "200")
            {
                let strImageURL =
                    "\(json["data"][0]["grocery_image"])"
                
                if(strImageURL.count>2){
                    let urlYourURL = URL (string:strImageURL )
                    self.imgaGrocery.loadurl(url: urlYourURL!)
                }
                let strImageURL2 =
                    "\(json["data"][0]["food_image"])"
             
                if(strImageURL2.count>2){
                    let urlYourURL2 = URL (string:strImageURL2 )
                    self.imgFood.loadurl(url: urlYourURL2!)
                }
            }
            else
            {
                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
            
           
    }
    }
    func removeCartDataAPI()
    {
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.removeCartDataAPI, method: .post, param: parameters, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "201")
            {
//                self.alertFailure(title: "Invalid", Message: "\(json["message"])")
            }
            else
            {
               
//                self.alertFailure(title: "Enjoy!!!", Message: "You can enjoy the best meals offered by this restaurant")
            }
            
        }
    }
}
