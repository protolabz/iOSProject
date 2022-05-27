//
//  AddSizeRadioCell.swift
//  Xeat
//
//  Created by apple on 28/04/22.
//

import UIKit

class AddSizeRadioCell: UITableViewCell {

    @IBOutlet weak var txtPrice: UILabel!
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var txtItemName: UILabel!
    
    @IBOutlet weak var txtNo: UILabel!
    @IBOutlet weak var viewUi: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
     
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 2
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
