//
//  cell_AddSchduler_Dropdown.swift
//  SwiftRevealViewController
//
//  Created by Dips here... on 1/17/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class cell_AddSchduler_Dropdown: UITableViewCell {

    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var txtDropdown : UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.cornerRadius = 4.0
        viewMain.layer.borderColor = UIColor.lightGray.cgColor
        viewMain.layer.borderWidth = 1.0
        viewMain.clipsToBounds = true
        viewMain.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
