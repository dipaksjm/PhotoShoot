//
//  Cell_Catalogue.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 05/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class Cell_Catalogue: UICollectionViewCell {

    @IBOutlet weak var viewMain_catalogue : UIView!
    @IBOutlet weak var img_catalogue : UIImageView!
    @IBOutlet weak var lbl_catalogueName : UILabel!
    @IBOutlet weak var view_catalogue : UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMain_catalogue.layer.cornerRadius = 4.0
        viewMain_catalogue.clipsToBounds = true
        viewMain_catalogue.layer.masksToBounds = true
        viewMain_catalogue.layer.borderColor = UIColor.clear.cgColor
        viewMain_catalogue.layer.borderWidth = 1.5
        
        
      //  view_catalogue?.backgroundColor =  UIColor(red: 123.0/255.0, green: 222.0/255.0, blue: 165.0/255.0, alpha: 1)

        // Initialization code
    }

}
