//
//  Cell_AddGarment.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 09/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class Cell_AddGarment: UICollectionViewCell {

    @IBOutlet weak var viewMain_Garment : UIView!
    @IBOutlet weak var img_Garment : UIImageView!
    @IBOutlet weak var btn_GarmentAdd : UIButton!
    @IBOutlet weak var view_Garment : UIView!
    @IBOutlet weak var lblName : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewMain_Garment.layer.cornerRadius = 4.0
        viewMain_Garment.clipsToBounds = true
        viewMain_Garment.layer.masksToBounds = true
        viewMain_Garment.layer.borderColor = UIColor.clear.cgColor
        viewMain_Garment.layer.borderWidth = 1.5
        
        btn_GarmentAdd.imageView?.contentMode = .scaleAspectFit // ALTERNATIVE:  .ScaleAspectFit

    }

}
