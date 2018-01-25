//
//  Cell_AddessModel.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 11/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class Cell_AddessModel: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var txtaddress : UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtaddress.layer.cornerRadius = 4.0
        self.txtaddress.clipsToBounds = true
        self.txtaddress.layer.masksToBounds = true
        self.txtaddress.layer.borderColor = UIColor.lightGray.cgColor
        self.txtaddress.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
