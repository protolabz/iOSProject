//
//  ViewHideShowController.swift
//  Xeat
//
//  Created by apple on 15/03/22.
//

import UIKit

class ViewHideShowController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labl1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isHidden = true
  
    }


}
