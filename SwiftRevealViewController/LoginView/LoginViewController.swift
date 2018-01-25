//
//  LoginViewController.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 03/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD


class LoginViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPageViewControllerDataSource,UITextFieldDelegate {

    var appdel =  AppDelegate()
    @IBOutlet weak var tblview:UITableView!
    var dicvalue = NSMutableDictionary()
    @IBOutlet weak var btn_Login:UIButton!
    
    var arrPageImages : Array<String> = ["loginbanner.png"]
    var pageViewController: UIPageViewController?
    @IBOutlet weak var viewPageMain:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        appdel =  UIApplication.shared.delegate as! AppDelegate

        let nib = UINib(nibName: "Cell_Login", bundle: nil)
        tblview.register(nib, forCellReuseIdentifier: "Cell_Login")
        
        btn_Login.layer.cornerRadius = 4.0
        btn_Login.clipsToBounds = true
        btn_Login.layer.masksToBounds = true
        btn_Login.layer.borderColor = UIColor.clear.cgColor
        btn_Login.layer.borderWidth = 1.5
        
        
        dicvalue.setValue("", forKey: "UserName");
        dicvalue.setValue("", forKey: "Password");
        
        let defaults = UserDefaults.standard
        if let dic  = defaults.object(forKey: "ProfileData")
        {
            print(dic)
            self.appdel.userDataDic = defaults.object(forKey: "ProfileData") as! NSDictionary
            let strClientAdminId = self.appdel.userDataDic["ClientAdminId"] as! String
            if (strClientAdminId != nil && strClientAdminId != "")
            {
                self.appdel.strClientAdminId  = self.appdel.userDataDic["ClientAdminId"] as! String
                self.appdel.strClientId  = self.appdel.userDataDic["ClientId"] as! String
                print(self.appdel.strClientAdminId)
                self.appdel.createwithoutMenuView()
                
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Create page view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        pageViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        pageViewController?.dataSource = self
        
        let startingViewController: PageContentViewController = viewControllerAtIndex(index: 0)!
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        pageViewController!.view.frame = CGRect(x: 0, y: 0, width: viewPageMain.frame.size.width, height: viewPageMain.frame.size.height);
        addChildViewController(pageViewController!)
        viewPageMain.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
        
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PageContentViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PageContentViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if (index == self.arrPageImages.count) {
            return nil
        }
        
        return viewControllerAtIndex(index: index)
    }
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController?
    {
        //  The converted code is limited to 4 KB.
        //  Upgrade your plan to remove this limitation.
        if (self.arrPageImages.count == 0) || index >= self.arrPageImages.count {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Create a new view controller and pass suitable data.
        let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "PageContentViewController") as? PageContentViewController
        pageContentViewController?.imgFile = arrPageImages[index]
        pageContentViewController?.pageIndex = index
        return pageContentViewController
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.arrPageImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    @IBAction func btn_LoginClick(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if dicvalue["UserName"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.usernameReq)
        }
        else if  dicvalue["Password"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.passwordReq)
        }
        else {
            self.getUserLogin()
        }
 
    }
    
    
    
    // MARK: -
    // MARK: WebService Call
    
    func getUserLogin(){
        
        print("getUserLogin...")
        
        appdel.showMBProgressHUD()
        
        let strUrl = String(format: "%@?UserName=%@&Password=%@", CONSTANT.service_URL.UserLogin, dicvalue.object(forKey: "UserName") as! String,dicvalue.object(forKey: "Password") as! String)
        
        print(strUrl)
        
        Alamofire.request(strUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            self.appdel.hideMBProgressHUD()

            switch(response.result){
            case .success(_):
                if response.result.value != nil
                {
                    
                    let jsonObject = response.result.value as! NSDictionary
                    print(jsonObject)
                    
                    if jsonObject["IsAuthenticate"] as! Bool == true {
                        
                        let jsonArrLstLoginDetail = jsonObject.object(forKey: "LstLoginDetail") as! NSArray
                        print(jsonArrLstLoginDetail)
                        
                        self.appdel.userDataDic = jsonArrLstLoginDetail[0] as! NSDictionary
                        self.appdel.strClientAdminId  = self.appdel.userDataDic["ClientAdminId"] as! String
                        self.appdel.strClientId  = self.appdel.userDataDic["ClientId"] as! String
                        



                        let defaults = UserDefaults.standard
                        defaults.set(jsonArrLstLoginDetail[0] as! NSDictionary, forKey: "ProfileData")
                        defaults.set(true, forKey: "isLogin")
                        
                        let arrRightsNew = jsonObject.object(forKey: "LstRightsDetail") as! NSArray
                        let arrRights = NSMutableArray()
                        
                        for i in 0..<50{
                            let dictTemp = NSDictionary()
                            arrRights.insert(dictTemp, at: i)
                        }

                        for i in 0..<arrRightsNew.count{
                            
                            let dictTemp = arrRightsNew.object(at: i) as! NSDictionary
                            if (dictTemp.value(forKey: "MenuId") as! NSNumber) == 23{
                                arrRights.insert(dictTemp, at: 23)
                            }else if (dictTemp.value(forKey: "MenuId") as! NSNumber) == 13{
                                arrRights.insert(dictTemp, at: 13)
                            }else if (dictTemp.value(forKey: "MenuId") as! NSNumber) == 2{
                                arrRights.insert(dictTemp, at: 2)
                            }else if (dictTemp.value(forKey: "MenuId") as! NSNumber) == 15{
                                arrRights.insert(dictTemp, at: 15)
                            }else if (dictTemp.value(forKey: "MenuId") as! NSNumber) == 19{
                                arrRights.insert(dictTemp, at: 19)
                            }else if (dictTemp.value(forKey: "MenuId") as! NSNumber) == 18{
                                arrRights.insert(dictTemp, at: 18)
                            }else if (dictTemp.value(forKey: "MenuId") as! NSNumber) == 21{
                                arrRights.insert(dictTemp, at: 21)
                            }else if (dictTemp.value(forKey: "MenuId") as! NSNumber) == 24{
                                arrRights.insert(dictTemp, at: 24)
                            }
                        }
                        defaults.set(arrRights, forKey: "MenuRights")
                        defaults.synchronize()
                        
                        self.appdel.createwithoutMenuView()
//                        let objVC = CatalogueViewController(nibName: "ViewController", bundle: nil)
//                        self.navigationController?.pushViewController(objVC, animated: true)
                        
                        
                    }
                    else
                    {
                        self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.noUser)
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                self.appdel.hideMBProgressHUD()
                self.appdel.alertValidation(strMessage: response.result.error!.localizedDescription)
                
                break
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    // MARK: UITableView Method
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : Cell_Login = tableView.dequeueReusableCell(withIdentifier: "Cell_Login") as! Cell_Login
        
        cell.txt_label.tag = indexPath.row
        cell.txt_label.delegate = self
        if indexPath.row == 0
        {
            cell.txt_label.placeholder = "Username"
            cell.imgview.image = UIImage(named: "user.png")
            cell.txt_label.text = dicvalue.object(forKey: "UserName") as! String?

        }
        if indexPath.row == 1
        {
            cell.txt_label.placeholder = "*****"
            cell.imgview.image = UIImage(named: "lock.png")
            cell.txt_label.isSecureTextEntry =  true
            cell.txt_label.text = dicvalue.object(forKey: "Password") as! String?

        }
       
        
        //  cell.img_Name.image = UIImage.init(named:(self.arrIcons[indexPath.row] as? String)!)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    
    // MARK: -
    // MARK: UITextField methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 0 {
            dicvalue["UserName"] = textField.text
        }
        if textField.tag == 1 {
            dicvalue["Password"] = textField.text
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        return true
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
