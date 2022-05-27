//
//  HelpRevertViewCell.swift
//  Xeat
//
//  Created by apple on 31/12/21.
//

import UIKit

class HelpRevertViewCell: UITableViewCell {

    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var helpDecr: UILabel!
    @IBOutlet weak var helpStatus: UIButton!
    @IBOutlet weak var helpTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
