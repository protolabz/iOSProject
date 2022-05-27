//
//  ManageAddressCell.swift
//  Xeat
//
//  Created by apple on 26/12/21.
//

import UIKit

class ManageAddressCell: UITableViewCell {

//    @IBOutlet weak var viewEdit: UIImageView!
//    @IBOutlet weak var viewDelete: UIImageView!
    
   
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var viewUi: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            if selected {
                self.contentView.backgroundColor = UIColor.red
            } else {
                self.contentView.backgroundColor = UIColor.white
            }
        }
    
}
