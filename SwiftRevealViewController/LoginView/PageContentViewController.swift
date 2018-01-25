//
//  PageContentViewController.swift
//  pageviewDEMMMOO
//
//  Created by Devang Patel on 04/01/18.
//  Copyright © 2018 Bhoomika. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

        var pageIndex: Int = 0
        var imgFile = ""
        var txtTitle = ""
        @IBOutlet weak var ivScreenImage: UIImageView!
        @IBOutlet weak var lblScreenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//  The converted code is limited to 4 KB.
//  Upgrade your plan to remove this limitation.
        ivScreenImage.image = UIImage(named: imgFile)
        
        view.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
