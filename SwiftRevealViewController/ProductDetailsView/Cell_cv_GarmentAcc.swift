//
//  Cell_cv_GarmentAcc.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 05/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class Cell_cv_GarmentAcc: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btn_image : UIButton!
    @IBOutlet weak var imgType : UIImageView!

    @IBOutlet weak var layout_btnW: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        viewMain.layer.cornerRadius = 4.0
        viewMain.layer.borderColor = UIColor.lightGray.cgColor
        viewMain.layer.borderWidth = 1.0
        viewMain.clipsToBounds = true
        viewMain.layer.masksToBounds = true
        

    }

}
