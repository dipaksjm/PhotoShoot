//
//  AppDelegate.swift
//  SwiftRevealViewController
//
//  Created by Kristijan Kontus on 23/09/2016.
//  Copyright © 2016 kkontus. All rights reserved.
//

import UIKit

import CoreLocation
import MBProgressHUD
import Alamofire
import SwiftyJSON
import SystemConfiguration

extension Date {
    func toTimeStamp() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

// /*
struct CONSTANT {
    
    struct service_URL {
        
        static let CommanURL = "http://162.241.243.214:422/PhotoShoot.svc/"
        
        //comman
        static let UserLogin = "\(CommanURL)UserLogin"
        static let pathImgRemove =  "http://162.241.243.214:421"

        static let GetStatusList = "\(CommanURL)GetStatusList"
        static let GetModelList = "\(CommanURL)GetModelList"
        static let CheckUnicode = "\(CommanURL)CheckUniqueCode"

        // Catalogue
        static let GetCatalogueList = "\(CommanURL)GetCatalogueList"
        static let CatalogueAddEdit = "\(CommanURL)CatalogueAddEdit"
        static let GetClientListByclientAdminId = "\(CommanURL)GetClientListByclientAdminId"
        
        // Garment
        static let GetGarmentListByCaytalogueId = "\(CommanURL)GetGarmentListByCatalogueId"
        static let GetGarmentDetails = "\(CommanURL)GetGarmentById"
        static let SaveGarmentBasicInfo = "\(CommanURL)GarmentEdit"
        static let AddModel = "\(CommanURL)AddModel"
        static let ModelMapping = "\(CommanURL)Garment_ModelMappingAddEdit"
        static let GetClientList = "\(CommanURL)GetClientListByclientAdminId"

        

        
        
        static let AccessoriesAddEdit = "\(CommanURL)AccessoriesAddEdit"

        
        // Schedular
        static let GetSchedulerList = "\(CommanURL)GetSchedulerListByCatalogueId"
        static let GetSchedulerStatusList = "\(CommanURL)GetStatusList"
        static let AddEditScheduler = "\(CommanURL)SchedulerAddEdit"

    }
    
    struct color_App {
        static let color_CM = UIColor(red: 112.0/255.0, green: 217.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        static let color_SCH = UIColor(red: 180.0/255.0, green: 121.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        static let color_MB = UIColor(red: 145.0/255.0, green: 171.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        static let color_GS = UIColor(red: 241.0/255.0, green: 178.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        static let color_SD = UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 157.0/255.0, alpha: 1.0)
        static let color_PSS = UIColor(red: 112.0/255.0, green: 233.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        static let color_AS = UIColor(red: 167.0/255.0, green: 214.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        static let color_FDP = UIColor(red: 112.0/255.0, green: 217.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        static let color_default_darkGray = UIColor.darkGray
        static let color_TittleDefault_Black = UIColor.black
    }
    
    struct className{
        static let AddNewGarment = "addnewgarment"
    }

    
//    struct Font {
//        static let roboto_Bold_20 = UIFont(name: "Triomphe-Bold", size: 20)
//        static let roboto_Bold_16 = UIFont(name: "Triomphe-Bold", size: 16)
//        static let roboto_Bold_17 = UIFont(name: "Triomphe-Bold", size: 17)
//        static let roboto_Bold_12 = UIFont(name: "Triomphe-Bold", size: 12)
//
//        static let roboto_Mid_20  = UIFont(name: "Triomphe-Regular", size: 20)
//        static let roboto_Mid_17  = UIFont(name: "Triomphe-Regular", size: 17)
//
//        static let roboto_Mid_16  = UIFont(name: "Triomphe-Regular", size: 16)
//        static let roboto_Mid_14  = UIFont(name: "Triomphe-Regular", size: 14)
//
//        static let roboto_Regular_20  = UIFont(name: "Triomphe-Light", size: 20)
//        static let roboto_Regular_16  = UIFont(name: "Triomphe-Light", size: 16)
//        static let roboto_Regular_14  = UIFont(name: "Triomphe-Light", size: 14)
//        static let roboto_Regular_11  = UIFont(name: "Triomphe-Light", size: 11)
//
//        static let roboto_Regular_12  = UIFont(name: "Triomphe-Regular", size: 12)
//    }
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    struct GoogleAPI
    {
        static let PlaceApiKey  = "AIzaSyD-xaDhKcLwLLFY6Vvx4pwkzO8LB1-ZaiY"
        //        https://maps.googleapis.com/maps/api/geocode/json?address=Badrinarayan%20society&key=AIzaSyD-xaDhKcLwLLFY6Vvx4pwkzO8LB1-ZaiY
    }
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
        
    }
    
    struct DeviceIdiom {
        static let deviceIdiom_Ipad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    struct AlertTitle
    {
        static let Title    = "PhotoShoot"
    }
    struct AlretMessage
    {
        static let noData   = "No Record Found."
        static let noUser   = "No User Found."
        static let passwordReq   = "Password Required."
        static let usernameReq    = "Username Required."
        
        static let Tryagain    = "Please try again."
        static let Logout   =  "Are you sure you want to logout?"
        
        //Garment
        static let Name    = "Name Required."
        static let Title    = "Title Required."
        static let Description    = "Description Required."
        static let LaunchDate    = "Launch Date Required."
        static let Status    = "Status Required."
        static let StatusComment    = "Status Comment Required."
        static let Unicode    = "Unicode Required."
        
        // GarmentDetails
        static let Accessory_deleted   =  "Accessory successfully deleted."
        static let Accessory_edited   =  "Accessory successfully updated."
        static let Accessory_added   =  "Accessory successfully added."
        static let ModelNotFound   =  "Model not found."
        static let PleaseSelectModel   =  "Please select any model."
        static let ModelMapSuccess   =  "Model mapped successfully."
        static let ModelMapFail   =  "Model mapping failed, \(Tryagain)."
        static let PleaseSelectClient   =  "Please select client."
        static let UnicodeShouldBeUnique   =  "Garment Unicode must be unique."

        

        
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userDataDic         = NSDictionary()
    var strClientAdminId    = String()
    var strClientId         = String()
    var strRollID           = String()
    
    var dictAddNewGarment   = NSMutableDictionary()
    
    var strCurrentClass     = String()
    
    
// MARK: -

    func createMenuView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "RearViewController") as! RearViewController
      
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        rearViewController.mainViewController = nvc
        
        let swRevealViewController = ContainerSWRevealViewController()
        swRevealViewController.setFront(nvc, animated: true)
        swRevealViewController.setRear(rearViewController, animated: true)
        
        self.window?.rootViewController = swRevealViewController
        self.window?.makeKeyAndVisible()
    }
    func createwithoutMenuView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        nvc.navigationBar.isHidden = true
        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()
    }
    
    func gotoLoginView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let objLoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.window?.rootViewController = objLoginViewController
        self.window?.makeKeyAndVisible()
    }

    
    func addIQKeyBoardManager()
    {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    
    // MARK: -
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
      //  self.createMenuView()
        
        self.addIQKeyBoardManager()        

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - UIAlertController Method
    
    func alertValidation(strMessage : String)
    {
        let alertController = UIAlertController(title: CONSTANT.AlertTitle.Title, message: strMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        //        alertController.view.tintColor = CONSTANT.color_App.color_yellowColor
    }
    
    // MARK: - MBProgressHUD Show/Hide Method
    
    func showMBProgressHUD()
    {
        let loadingNotification = MBProgressHUD.showAdded(to: self.window!, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }
    
    func hideMBProgressHUD()
    {
        MBProgressHUD.hide(for: self.window!, animated: true)
        
    }
    func showMBProgressHUD_short(strMsg:String)
    {
        let loadingNotification = MBProgressHUD.showAdded(to: self.window!, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = strMsg
        loadingNotification.hide(animated: true, afterDelay: 3)
    }
    
    // MARK: -
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func generateTimeStamp()->String{
        return("\(Date().toTimeStamp()!)")
    }

}

