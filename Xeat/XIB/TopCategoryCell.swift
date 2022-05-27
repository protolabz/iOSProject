//
//  TopCategoryCell.swift
//  Xeat
//
//  Created by apple on 21/12/21.
//

import UIKit

class TopCategoryCell: UICollectionViewCell {

    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var txtName: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 10
//        let url = URL(string: "http://phpstack-102119-2292222.cloudwaysapps.com/public/img/103163015.jpg")
//        imgCategory.loadurl(url: url!)
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//            super.setSelected(selected, animated: animated)
//
//            if selected {
//                self.contentView.backgroundColor = UIColor.red
//            } else {
//                self.contentView.backgroundColor = UIColor.white
//            }
//        }
    
//    override var isSelected: Bool {
////            didSet {
////                contentView.backgroundColor = isSelected ? .red : .none
////            }
//        }
}
