//
//  CouponCell.swift
//  Xeat
//
//  Created by apple on 18/01/22.
//

import UIKit

class CouponCell: UITableViewCell {

    @IBOutlet weak var viewUi: UIView!
    
    @IBOutlet weak var txtDesc: UILabel!
    @IBOutlet weak var txtName: UILabel!
   
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var txtAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
