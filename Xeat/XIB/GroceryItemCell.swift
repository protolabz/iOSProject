//
//  GroceryItemCell.swift
//  Xeat
//
//  Created by apple on 31/05/22.
//

import UIKit

class GroceryItemCell: UICollectionViewCell {

    @IBOutlet weak var viewMian: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var txtBackSoon: UIButton!
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var imgNew: UIImageView!
    @IBOutlet weak var stackPlusMinus: UIStackView!
    @IBOutlet weak var viewUi: UIView!
    
    @IBOutlet weak var txtWeight: UILabel!
    @IBOutlet weak var txtDiscountPrice: UILabel!
    
    @IBOutlet weak var txtCount: UILabel!
    
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var imgCold: UIImageView!
    @IBOutlet weak var tctProductName: UILabel!
    
    @IBOutlet weak var txtNormalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        viewUi.layer.masksToBounds = false
       
        viewUi.layer.cornerRadius = 10
//        viewUi.layer.borderWidth = 0.2
//        viewUi.layer.borderColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        
        // shadow
        viewUi.layer.shadowColor = UIColor.gray.cgColor
        viewUi.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewUi.layer.shadowOpacity = 0.4
        viewUi.layer.shadowRadius = 4.0
        
        
        stackView.layer.borderWidth = 0.2
//        stackView.layer.masksToBounds = false
        stackView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        stackView.layer.cornerRadius = 5

        // shadow
        stackView.layer.shadowColor = UIColor.gray.cgColor
        stackView.layer.shadowOffset = CGSize(width: 3, height: 3)
        stackView.layer.shadowOpacity = 0.4
        stackView.layer.shadowRadius = 3.0

        imgCold.isHidden = true
        txtBackSoon.isHidden = true
        txtBackSoon.layer.cornerRadius = 10
        

        btnAdd.contentVerticalAlignment = .fill
        btnAdd.contentHorizontalAlignment = .fill
        btnMinus.contentVerticalAlignment = .fill
        btnMinus.contentHorizontalAlignment = .fill
       // imgProduct.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imgProduct.layer.cornerRadius = 10
        
       // let url = URL(string: "http://phpstack-102119-2292222.cloudwaysapps.com/public/img/103163015.jpg")
//               imgProduct.loadurl(url: url!)
        
    }
//    override var isSelected: Bool {
//            didSet {
//        
//            let storkeLayer = CAShapeLayer()
//               storkeLayer.fillColor = UIColor.clear.cgColor
//               storkeLayer.strokeColor = UIColor.red.cgColor
//               storkeLayer.lineWidth = 2
//
//               // Create a rounded rect path using button's bounds.
//               storkeLayer.path = CGPath.init(roundedRect: viewUi.bounds, cornerWidth: 5, cornerHeight: 5, transform: nil) // same path like the empty one ...
//               // Add layer to the button
//            viewUi.layer.addSublayer(storkeLayer)
//
//               // Create animation layer and add it to the stroke layer.
//               let animation = CABasicAnimation(keyPath: "strokeEnd")
//               animation.fromValue = CGFloat(0.0)
//               animation.toValue = CGFloat(1.0)
//               animation.duration = 1
//                animation.fillMode = CAMediaTimingFillMode.backwards
//            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//               storkeLayer.add(animation, forKey: "circleAnimation")
//        }
//    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imgProduct.image = nil
       // txtOpenClose.setTitle("Open", for: .normal)
    }
}
