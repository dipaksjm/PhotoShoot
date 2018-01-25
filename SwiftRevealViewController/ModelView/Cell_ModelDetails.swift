//
//  Cell_ModelDetails.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 11/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class Cell_ModelDetails: UITableViewCell {

    @IBOutlet weak var txtHeight : UITextField!
    @IBOutlet weak var txtAge : UITextField!
    @IBOutlet weak var txtWeight : UITextField!
    @IBOutlet weak var txtComplex : UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.txtAge.layer.cornerRadius = 4.0
        self.txtAge.clipsToBounds = true
        self.txtAge.layer.masksToBounds = true
        self.txtAge.layer.borderColor = UIColor.lightGray.cgColor
        self.txtAge.layer.borderWidth = 1.5
        
        self.txtHeight.layer.cornerRadius = 4.0
        self.txtHeight.clipsToBounds = true
        self.txtHeight.layer.masksToBounds = true
        self.txtHeight.layer.borderColor = UIColor.lightGray.cgColor
        self.txtHeight.layer.borderWidth = 1.5
        
        
        self.txtWeight.layer.cornerRadius = 4.0
        self.txtWeight.clipsToBounds = true
        self.txtWeight.layer.masksToBounds = true
        self.txtWeight.layer.borderColor = UIColor.lightGray.cgColor
        self.txtWeight.layer.borderWidth = 1.5
        
        self.txtComplex.layer.cornerRadius = 4.0
        self.txtComplex.clipsToBounds = true
        self.txtComplex.layer.masksToBounds = true
        self.txtComplex.layer.borderColor = UIColor.lightGray.cgColor
        self.txtComplex.layer.borderWidth = 1.5
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
