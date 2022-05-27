//
//  SavedCardCell.swift
//  Xeat
//
//  Created by apple on 20/04/22.
//

import UIKit

class SavedCardCell: UITableViewCell {

    @IBOutlet weak var txtExpiry: UILabel!
    @IBOutlet weak var txtCardNumber: UILabel!
    @IBOutlet weak var txtCardName: UILabel!
    @IBOutlet weak var viewUi: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
        // Configure the view for the selected state
    }
    
}
