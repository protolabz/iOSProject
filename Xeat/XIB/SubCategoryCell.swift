//
//  SubCategoryCell.swift
//  Xeat
//
//  Created by apple on 01/06/22.
//

import UIKit

class SubCategoryCell: UICollectionViewCell {

    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var viewUi: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewUi.layer.cornerRadius = 10
        // Initialization code
    }
    override var isSelected: Bool {
               didSet {
                   contentView.backgroundColor = isSelected ? .red : .none
               }
           }
}
