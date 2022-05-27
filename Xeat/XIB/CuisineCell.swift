//
//  CuisineCell.swift
//  Xeat
//
//  Created by apple on 08/04/22.
//

import UIKit

class CuisineCell: UICollectionViewCell {

    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var imgCuisine: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewUi.layer.borderWidth = 0.5
        viewUi.layer.masksToBounds = false
        viewUi.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewUi.layer.cornerRadius = 3
//        let url = URL(string: "http://phpstack-102119-2292222.cloudwaysapps.com/public/img/103163015.jpg")
//        imgCuisine.loadurl(url: url!)
        
        imgCuisine.layer.cornerRadius = 5
        // Initialization code
    }
    
    override var isSelected: Bool {
            didSet {
                contentView.backgroundColor = isSelected ? .red : .none
            }
        }

    override func prepareForReuse() {
        super.prepareForReuse()
        imgCuisine.image = nil
       // txtOpenClose.setTitle("Open", for: .normal)
    }
}
