//
//  cell_Schduler.swift
//  SwiftRevealViewController
//
//  Created by Dips here... on 1/16/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class cell_Schduler: UITableViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lblStartDate : UILabel!
    @IBOutlet weak var lblEndDate : UILabel!
    @IBOutlet weak var lblDesc : UILabel!

    
    @IBOutlet weak var lblPilar : UILabel!
    @IBOutlet weak var lblBotum : UILabel!

    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var btnEdit : UIButton!
    
    

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
