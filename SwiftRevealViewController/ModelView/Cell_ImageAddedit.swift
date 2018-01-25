//
//  Cell_ImageAddedit.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 18/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class Cell_ImageAddedit: UICollectionViewCell {

    @IBOutlet weak var img_Main : UIImageView!
    @IBOutlet weak var img_Sub : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        img_Main.layer.cornerRadius = 4.0
        img_Main.clipsToBounds = true
        img_Main.layer.masksToBounds = true
        img_Main.layer.borderColor = UIColor.clear.cgColor
        img_Main.layer.borderWidth = 1.5
        // Initialization code
    }

}
