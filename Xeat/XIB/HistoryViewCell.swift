//
//  HistoryViewCell.swift
//  Xeat
//
//  Created by apple on 31/12/21.
//

import UIKit

class HistoryViewCell: UITableViewCell {

    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var txtPName: UILabel!
  //  @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var txtRestName: UILabel!
    @IBOutlet weak var txtStatus: UILabel!
    @IBOutlet weak var txtProductCountNAme: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
        
//        btnCall.layer.cornerRadius = 10
//        btnCall.clipsToBounds=true
//        btnCall.layer.borderWidth = 0.5
//        btnCall.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
      //  btnCall.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
