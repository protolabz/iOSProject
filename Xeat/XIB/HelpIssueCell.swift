//
//  HelpIssueCell.swift
//  Xeat
//
//  Created by apple on 31/01/22.
//

import UIKit

class HelpIssueCell: UITableViewCell {

    @IBOutlet weak var txtIssue: UILabel!
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

        // Configure the view for the selected state
    }
    
}
