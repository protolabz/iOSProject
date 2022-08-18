//
//  GroceryViewCell.swift
//  Xeat
//
//  Created by apple on 04/03/22.
//

import UIKit

class GroceryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewUi: UIView!
    
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgGrocery: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewUi.layer.borderWidth = 0.8
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
        
//        imgGrocery.layer.borderWidth = 0.8
//        imgGrocery.layer.masksToBounds = false
        imgGrocery.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imgGrocery.layer.cornerRadius = 10
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgGrocery.image = nil
       // txtOpenClose.setTitle("Open", for: .normal)
    }
}
