//
//  CartCell2.swift
//  Xeat
//
//  Created by apple on 27/07/22.
//

import UIKit

class CartCell2: UITableViewCell {

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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
