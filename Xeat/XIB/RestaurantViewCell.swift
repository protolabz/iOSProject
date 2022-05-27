//
//  RestaurantViewCell.swift
//  Xeat
//
//  Created by apple on 21/12/21.
//

import UIKit

class RestaurantViewCell: UITableViewCell {

    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var txtDeliveryPickup: UILabel!
    @IBOutlet weak var txtOpenClose: UIButton!
    @IBOutlet weak var txtRating: UITextField!
    @IBOutlet weak var txtLocation: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgRest: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
        
        txtOpenClose.layer.cornerRadius = 10
        txtOpenClose.layer.masksToBounds = true
       
        txtDeliveryPickup.layer.masksToBounds = true
        txtDeliveryPickup.layer.cornerRadius = 10
        
        imgRest.layer.masksToBounds = false
        imgRest.layer.cornerRadius = 15
        imgRest.clipsToBounds = true
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(systemName: "star.fill")
        leftImageView.tintColor = UIColor.red
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView.frame = CGRect(x: 12, y: 8, width: 15, height: 12)
        txtRating.leftViewMode = .always
        txtRating.leftView = leftView
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imgRest.image = nil
        txtOpenClose.setTitle("Open", for: .normal)
    }
    
}
