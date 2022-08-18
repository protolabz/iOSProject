//
//  CartCell.swift
//  Xeat
//
//  Created by apple on 19/01/22.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var imgMinus: UIButton!
    @IBOutlet weak var imgPlus: UIButton!
  
    
    @IBOutlet weak var txtInstruction: UILabel!
    @IBOutlet weak var viewPlusMinus: UIView!
    @IBOutlet weak var txtNumber: UILabel!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var txtIngreden: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
   
    @IBOutlet weak var viewUi: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewUi.isUserInteractionEnabled = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
       
     
        // Configure the view for the selected state
        
        viewPlusMinus.layer.borderWidth = 0.1
        viewPlusMinus.layer.masksToBounds = false
        viewPlusMinus.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewPlusMinus.layer.cornerRadius = 10
    }
    
}
