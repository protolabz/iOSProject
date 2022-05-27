//
//  HomeGroceryController.swift
//  Xeat
//
//  Created by apple on 02/03/22.
//

import UIKit

class HomeGroceryController: UITabBarController, UITabBarControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.barTintColor  = UIColor.white
        self.delegate = self
        self.tabBarController?.delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
      //  self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
       
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) != "2")
        {
        fetchCartDetail()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.3, 0.9, 1.0]
        bounceAnimation.duration = TimeInterval(0.5)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

    func myFunctionToCallFromAnywhere() {
        if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) != "2")
        {
            fetchCartDetail()
        }
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
       
//        if(tabBarController.selectedIndex == 2)
//        {
//
//            UserDefaults.standard.setValue("0111", forKey: Constant.CARTSCREEN)
//        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       
       
        guard let idx = tabBar.items?.firstIndex(of: item),
            tabBar.subviews.count > idx + 1,
            
            let imageView = tabBar.subviews[idx + 1].subviews.compactMap({ $0 as? UIImageView }).first else {
            return
        }
        
        imageView.layer.add(bounceAnimation, forKey: nil)
 }
    
    
    func fetchCartDetail()
    {
       
        let strUserId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let parameters = ["user_id": strUserId, "accesstoken" : Constant.APITOKEN]
        
        print("parameters",parameters)
        APIsManager.shared.requestService(withURL: Constant.cartDetailAPI, method: .post, param: parameters, viewController: self) { (json) in
         print(json)
            
            
            if("\(json["status"])" == "201")
            {
                if let tabItems = self.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    let tabItem = tabItems[2]
                    tabItem.badgeValue = nil
                }
            }
          
            else
            {
//
                if let tabItems = self.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    let tabItem = tabItems[2]
                    tabItem.badgeValue = "\(json["cart_items"])"
                }
            }
           
        }
    }
    
  

}
