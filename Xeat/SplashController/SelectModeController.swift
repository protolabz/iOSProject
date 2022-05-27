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
 //   performSegue(withIdentifier: "homeg", sender: nil)
}
   
    @objc func viewF()
    {
        performSegue(withIdentifier: "home", sender: nil)
    }
    
    func otpCall()
    {
        
        let parameters = ["accesstoken" : Constant.APITOKEN]
        
        APIsManager.shared.requestService(withURL: Constant.groceryFoodImageAPI, method: .post, param: parameters, viewController: self) { (json) in
         print(json)
            if("\(json["code"])" == "200")
            {
                let strImageURL =
                    "\(json["data"][0]["grocery_image"])"
                print(strImageURL)
                if(strImageURL.count>2){
                    let urlYourURL = URL (string:strImageURL )
                    self.imgaGrocery.loadurl(url: urlYourURL!)
                }
                let strImageURL2 =
                    "\(json["data"][0]["food_image"])"
                print(strImageURL2)
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
}
