//
//  Cell_Access.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 11/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class Cell_Access: UITableViewCell {

    @IBOutlet weak var img_Acc : UIImageView!
    @IBOutlet weak var lbl_AccName : UILabel!
    @IBOutlet weak var lbl_AccDes : UILabel!
    @IBOutlet weak var btn_AccCU : UIButton!

    @IBOutlet weak var layout_btnW: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        img_Acc.layer.cornerRadius = 4.0
        img_Acc.clipsToBounds = true
        img_Acc.layer.masksToBounds = true
        img_Acc.layer.borderColor = UIColor.lightGray.cgColor
        img_Acc.layer.borderWidth = 1.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
