//
//  MenuViewCell.swift
//  Xeat
//
//  Created by apple on 23/12/21.
//

import UIKit

class MenuViewCell: UITableViewCell {

    @IBOutlet weak var txtOutOfStock: UIButton!
    @IBOutlet weak var imgMinus: UIButton!
    @IBOutlet weak var imgPlus: UIButton!
  
    
    @IBOutlet weak var txtPopular: UIButton!
    @IBOutlet weak var txtNumber: UILabel!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var txtIngreden: UILabel!
    @IBOutlet weak var txtName: UILabel!
   // @IBOutlet weak var btnExtra: UIButton!
   // @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var viewUi: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
        
//        let url = URL(string: "http://phpstack-102119-2292222.cloudwaysapps.com/public/img/103163015.jpg")
//        imgMenu.loadurl(url: url!)
        
     
//        btnExtra.layer.masksToBounds = false
//        btnExtra.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        btnExtra.layer.cornerRadius = 5
        
        txtOutOfStock.layer.masksToBounds = false
        txtOutOfStock.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        txtOutOfStock.layer.cornerRadius = 5
      
        txtPopular.layer.masksToBounds = false
        txtPopular.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        txtPopular.layer.cornerRadius = 2
      
      
//        imgMenu.layer.masksToBounds = false
//        imgMenu.layer.cornerRadius = 15
//        imgMenu.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
