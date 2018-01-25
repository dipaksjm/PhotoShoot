//
//  Cell_Main.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 03/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class Cell_Main: UITableViewCell {

    @IBOutlet weak var lbl_Name:UILabel!
    @IBOutlet weak var img_arrow : UIImageView!
    @IBOutlet weak var img_Name : UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
