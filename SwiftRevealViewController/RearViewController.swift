//
//  RearViewController.swift
//  SwiftRevealViewController
//
//  Created by Kristijan Kontus on 23/09/2016.
//  Copyright © 2016 kkontus. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case View = 0
    case Photo
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class RearViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LeftMenuProtocol {
    @IBOutlet weak var tableView: UITableView!
    var mainViewController: UIViewController!
    var photoViewController: UIViewController!
    var mapViewController: UIViewController!
    var blahViewController: UIViewController!
    var videoViewController: UIViewController!
    let menus = ["View", "Photo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = UIScreen.main.bounds.size.width - 100
        self.revealViewController().rearViewRevealOverdraw = 0
        self.revealViewController().rearViewRevealDisplacement = 0
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        let photoViewController = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        self.photoViewController = UINavigationController(rootViewController: photoViewController)
    
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame: CGRect.zero) //IMPORTANT: this hides empty cells (and cell separators)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = menus[indexPath.row]
            
            switch menu {
            case .View:
                //you can add some cell costumisation here
                cell.backgroundColor = UIColor.lightGray
                cell.isUserInteractionEnabled = true
                return cell
            case .Photo:
                //you can add some cell costumisation here
                cell.backgroundColor = UIColor.lightGray
                cell.isUserInteractionEnabled = true
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu: menu)
            
            switch menu {
            case .View: break
            case .Photo: break
            }
        }
    }
    
    /*
     * This way we instantiate ViewController when needed, not on SideMenu initialization (viewDidLoad), because we don't want it in memory until we go to that view
     */
   
    /*
     * This way we deallocate ViewController after changing to another ViewController, so we don't keep it in memory all the time
     */
    func deallocateDynamicallyCreatedViewControllers() {        
        self.videoViewController = nil
    }
    
    func changeViewController(menu: LeftMenu) {
        deallocateDynamicallyCreatedViewControllers()
        
        switch menu {
        case .View:
            self.revealViewController().pushFrontViewController(self.mainViewController, animated: true)
            break
        case .Photo:
            self.revealViewController().pushFrontViewController(self.photoViewController, animated: true)
            break
        }
    }
    
}

