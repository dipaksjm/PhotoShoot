//
//  ViewController.swift
//  SwiftRevealViewController
//
//  Created by Kristijan Kontus on 23/09/2016.
//  Copyright © 2016 kkontus. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SWRevealViewControllerDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var menuButton:UIButton!
    @IBOutlet weak var tblview:UITableView!
    var appDelegate =  AppDelegate()

    var arrName = NSArray()
    var arrIcons = NSArray()
    // MARK: -

    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate =  UIApplication.shared.delegate as! AppDelegate

        
//        if revealViewController() != nil {
//            menuButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            self.revealViewController().delegate = self
//            
//        }
        
        self.setupArray()
        
        let nib = UINib(nibName: "Cell_Main", bundle: nil)
        tblview.register(nib, forCellReuseIdentifier: "Cell_Main")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        if let dic  = defaults.object(forKey: "ProfileData"){
            self.appDelegate.userDataDic = defaults.object(forKey: "ProfileData") as! NSDictionary
            self.appDelegate.strClientAdminId  = self.appDelegate.userDataDic["ClientAdminId"] as! String
            self.appDelegate.strClientId  = self.appDelegate.userDataDic["ClientId"] as! String
            self.appDelegate.strRollID = "\(self.appDelegate.userDataDic["RoleId"] as! NSNumber)"
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        let defaults = UserDefaults.standard
//        let dictProfileData = defaults.value(forKey: "ProfileData") as! NSDictionary
//        self.appDelegate.strRollID  = "\(dictProfileData.value(forKey: "RoleId") as! NSNumber)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupArray()
    {
        arrName = ["CATALOG MASTER","SCHEDULER","MOOD BOARD", "GARMENT STATUS", "SHOOT DAY", "PHOTO SHOOT SHARE","APPROVAL STAGE","FINAL DELIVERY PHOTO"]
        arrIcons = ["catalogue.png","schedule.png","mood.png","garment.png","shootDay.png","shootShare.png","approval.png","finalDilivary.png"]
    }

    
    // MARK: -
    // MARK: UITableView Method
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 8
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : Cell_Main = tableView.dequeueReusableCell(withIdentifier: "Cell_Main") as! Cell_Main
        cell.lbl_Name.text = self.arrName[indexPath.row] as? String
        cell.img_Name.image = UIImage(named: (self.arrIcons[indexPath.row] as? String)!)

        if indexPath.row == 0
        {
            cell.backgroundColor = CONSTANT.color_App.color_CM
        }
        if indexPath.row == 1
        {
            cell.backgroundColor = CONSTANT.color_App.color_SCH
        }
        if indexPath.row == 2
        {
            cell.backgroundColor = CONSTANT.color_App.color_MB
        }
        if indexPath.row == 3
        {
            cell.backgroundColor = CONSTANT.color_App.color_GS
        }
        if indexPath.row == 4
        {
            cell.backgroundColor = CONSTANT.color_App.color_SD
        }
        if indexPath.row == 5
        {
            cell.backgroundColor = CONSTANT.color_App.color_PSS
        }
        if indexPath.row == 6
        {
            cell.backgroundColor = CONSTANT.color_App.color_AS
        }
        if indexPath.row == 7
        {
            cell.backgroundColor = CONSTANT.color_App.color_FDP
        }
        
      //  cell.img_Name.image = UIImage.init(named:(self.arrIcons[indexPath.row] as? String)!)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexPath.row == 0
        {
            let objCatalogueViewController = CatalogueViewController(nibName: "CatalogueViewController", bundle: nil)
            self.navigationController?.pushViewController(objCatalogueViewController, animated: true)
        }
        if indexPath.row == 1
        {
            let objSchedulerVC = SchedulerVC(nibName: "SchedulerVC", bundle: nil)
            self.navigationController?.pushViewController(objSchedulerVC, animated: true)
        }
//        if indexPath.row == 3
//        {
//            let objGarMentViewController = GarMentViewController(nibName: "GarMentViewController", bundle: nil)
//            self.navigationController?.pushViewController(objGarMentViewController, animated: true)
//        }
    }
    
    // MARK: -
   
    @IBAction func action_Logout(_ sender: Any){
        print("action_Logout...")
        let alertController = UIAlertController(title: CONSTANT.AlertTitle.Title, message: CONSTANT.AlretMessage.Logout, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("you have pressed OK button");
            
            let defaults: UserDefaults = UserDefaults.standard
            defaults.set(false, forKey: "isLogin")
            defaults.removeObject(forKey: "ProfileData")
            defaults.removeObject(forKey: "MenuRights")
            defaults.synchronize()
            
            self.appDelegate.strClientAdminId   = ""
            self.appDelegate.gotoLoginView()
            
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
        
    }
    
   
    
}
