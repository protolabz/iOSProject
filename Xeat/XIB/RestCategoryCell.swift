//
//  RestCategoryCell.swift
//  Xeat
//
//  Created by apple on 30/05/22.
//

import UIKit

class RestCategoryCell: UICollectionViewCell {

    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var txtName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
        // Initialization code
    }

}
