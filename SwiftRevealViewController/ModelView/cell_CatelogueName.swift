//
//  cell_CatelogueName.swift
//  SwiftRevealViewController
//
//  Created by Dips here... on 1/9/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class cell_CatelogueName: UITableViewCell {

    @IBOutlet weak var btn_EditTitle : UIButton!
    @IBOutlet weak var txtTitle : UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtTitle.frame.size.height))
        txtTitle.leftView = paddingView
        txtTitle.leftViewMode = .always
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
