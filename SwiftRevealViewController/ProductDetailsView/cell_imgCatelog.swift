//
//  cell_imgCatelog.swift
//  SwiftRevealViewController
//
//  Created by Dips here... on 1/8/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class cell_imgCatelog: UITableViewCell {

    @IBOutlet var svMain : UIScrollView!
    @IBOutlet var pcImage : UIPageControl!
    @IBOutlet var btnEditPhoto : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
