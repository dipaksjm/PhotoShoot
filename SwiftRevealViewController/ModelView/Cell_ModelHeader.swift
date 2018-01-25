//
//  Cell_ModelHeader.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 11/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class Cell_ModelHeader: UITableViewCell {

    @IBOutlet weak var viewscrll : UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var btnHeaderEdit : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
