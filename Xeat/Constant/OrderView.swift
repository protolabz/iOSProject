//
//  OrderView.swift
//  Xeat
//
//  Created by apple on 08/03/22.
//

import UIKit

class OrderView : UIView {
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 30
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

        return view
    }()

    lazy var addCardButton = ActionButton(backgroundColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), title: "Pay with card", image: nil)
    lazy var applePayButton = ActionButton(backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), title: nil, image: UIImage(systemName: "applelogo"))
    private lazy var headerView = HeaderView(title: "Place your order")

    var closeButton: UIButton {
        return headerView.closeButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
     //   backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)

        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(TableRowView(heading: "Ship to", title: "Lauren Nobel", subtitle: "1455 Market Street\nSan Francisco, CA, 94103"))
       // stackView.addArrangedSubview(HairlineView())
        stackView.addArrangedSubview(TableRowView(heading: "Total", title: "$1.00", subtitle: nil))
      //  stackView.addArrangedSubview(HairlineView())
       // stackView.addArrangedSubview(makeRefundLabel())

        let payStackView = UIStackView()
        payStackView.spacing = 12
        payStackView.distribution = .fillEqually
        payStackView.addArrangedSubview(addCardButton)
        payStackView.addArrangedSubview(applePayButton)
        stackView.addArrangedSubview(payStackView)

        addSubview(stackView)
        
        //stackView.pinToTop(ofView: self)
    }
}


