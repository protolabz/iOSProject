//
//  HeaderCell.swift
//  Xeat
//
//  Created by apple on 05/05/22.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var txtRequired: UILabel!
    @IBOutlet weak var txtHeading: UILabel!
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

        // Configure the view for the selected state
    }
    
}
