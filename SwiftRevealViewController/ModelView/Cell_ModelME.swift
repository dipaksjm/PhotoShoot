//
//  Cell_ModelME.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 18/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class Cell_ModelME: UITableViewCell {

    @IBOutlet weak var txtField : UITextField!
    @IBOutlet weak var lblName : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.txtField.layer.cornerRadius = 4.0
        self.txtField.clipsToBounds = true
        self.txtField.layer.masksToBounds = true
        self.txtField.layer.borderColor = UIColor.lightGray.cgColor
        self.txtField.layer.borderWidth = 1
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtField.frame.size.height))
        txtField.leftView = paddingView
        txtField.leftViewMode = .always
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
