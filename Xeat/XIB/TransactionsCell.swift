//
//  TransactionsCell.swift
//  Xeat
//
//  Created by apple on 03/01/22.
//

import UIKit

class TransactionsCell: UITableViewCell {
    
    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var txtDebitCredit: UILabel!
    @IBOutlet weak var txtOrderId: UILabel!
    
    @IBOutlet weak var txtPennyCount: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
       viewUi.frame = CGRect(x: 0, y: 0, width: self.viewUi.frame.width, height: 100)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    override func prepareForReuse() {
//        super.prepareForReuse();
//
//        // Do the minor cleanup that is needed to reuse the cell
//
//    }
    override func prepareForReuse() {
        super.prepareForReuse()
        txtDebitCredit.text = ""

        //        for view in subviews {
//            view.removeFromSuperview()
//        }
    }
}
