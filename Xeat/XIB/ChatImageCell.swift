//
//  ChatImageCell.swift
//  Xeat
//
//  Created by apple on 29/03/22.
//

import UIKit

class ChatImageCell: UITableViewCell {
    
//    @IBOutlet weak var viewImage: UIView!
//
//    @IBOutlet weak var txtImageDate: UILabel!
    @IBOutlet weak var imgSender: UIImageView!
//    @IBOutlet weak var imgRecevire: UIImageView!
    @IBOutlet weak var txtResceDate: UILabel!
    @IBOutlet weak var txtReceiveMessage: UILabel!
    @IBOutlet weak var viewReceiver: UIView!
    @IBOutlet weak var txtSenderDate: UILabel!
    @IBOutlet weak var txtSenderMessage: UILabel!
    @IBOutlet weak var viewSender: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSender.layer.borderWidth = 0.5
        viewSender.layer.masksToBounds = false
        viewSender.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        viewSender.layer.cornerRadius = 10
        
//        viewImage.layer.borderWidth = 0.5
//        viewImage.layer.masksToBounds = false
//        viewImage.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
//        viewImage.layer.cornerRadius = 10
        
//        viewReceiver.layer.borderWidth = 0.5
//        viewReceiver.layer.masksToBounds = false
//        viewReceiver.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//        viewReceiver.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
