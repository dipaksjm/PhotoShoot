//
//  CatalogueViewController.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 05/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD


class CatalogueViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIActionSheetDelegate {

    @IBOutlet weak var colView : UICollectionView!
    var appdel =  AppDelegate()
    var arrCatalogueList = NSMutableArray()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        appdel =  UIApplication.shared.delegate as! AppDelegate
        
        let nib = UINib(nibName: "Cell_Catalogue", bundle: nil)
        self.colView.register(nib, forCellWithReuseIdentifier:"Cell_Catalogue")
        
        let nibAdd = UINib(nibName: "Cell_AddCatalogue", bundle: nil)
        self.colView.register(nibAdd, forCellWithReuseIdentifier:"Cell_AddCatalogue")
        
        self.colView.allowsSelection = true
        self.colView.allowsMultipleSelection = false
        
        self.callGetCatalogueList()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(CatalogueViewController.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.colView.addGestureRecognizer(lpgr)

        // Do any additional setup after loading the view.
    }

    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func action_add(sender: UIButton!){
        print("action_add...")
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
        
        let p = gestureReconizer.location(in: self.colView)
        let indexPath = self.colView.indexPathForItem(at: p)
        
        if let index = indexPath {
            var cell = self.colView.cellForItem(at: index)
            // do stuff with your cell, for example print the indexPath
            print(index.row)
            if index.row == 0{}
            else{
                
                let rowint = index.row - 1

                //Create the AlertController and add Its action like button in Actionsheet
                let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select Option", message: nil, preferredStyle: .actionSheet)
                
                let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    print("Cancel")
                }
                actionSheetControllerIOS8.addAction(cancelActionButton)
                
                let saveActionButton = UIAlertAction(title: "Edit", style: .default)
                { _ in
                    print("Edit")
                    let objCataAddViewController = CataAddViewController(nibName: "CataAddViewController", bundle: nil)
                    let dic  = NSMutableDictionary(dictionary: self.arrCatalogueList.object(at: rowint) as! NSDictionary)
                    objCataAddViewController.dicEditDetails = dic
                    objCataAddViewController.isedit = true
                    self.navigationController?.pushViewController(objCataAddViewController, animated: true)
                }
                actionSheetControllerIOS8.addAction(saveActionButton)
                
                let deleteActionButton = UIAlertAction(title: "Delete", style: .default)
                { _ in
                    print("Delete")
                    self.view.endEditing(true)

                    let dic  = NSMutableDictionary(dictionary: self.arrCatalogueList.object(at: rowint) as! NSDictionary)
                    
                    let dictMainarr : NSMutableDictionary = [:]
                    dictMainarr.setValue(dic.value(forKey: "CatalogueId") as? String, forKey: "CatalogueId")
                    dictMainarr.setValue("true", forKey: "Isdeleted")
                    dictMainarr.setValue(self.appdel.strClientAdminId, forKey: "ClientAdminId")
                    dictMainarr.setValue(dic.value(forKey: "ClientId") as? String, forKey: "ClientId")
                    dictMainarr.setValue(self.appdel.strClientAdminId, forKey: "CreatedBy")

                    let dictMain : NSMutableDictionary = [:]
                    dictMain.setValue(dictMainarr, forKey: "obj")
                    print("dictMain:\(dictMain)")
                    
                    self.appdel.showMBProgressHUD()
                    
                    let manager = AFHTTPSessionManager()
                    manager.requestSerializer = AFJSONRequestSerializer()
                    manager.responseSerializer = AFHTTPResponseSerializer()
                    manager.requestSerializer.timeoutInterval = 60
                    manager.post(CONSTANT.service_URL.CatalogueAddEdit, parameters: dictMain, success: {
                        requestOperation, response in
                        do {
                            let dictResult =  try JSONSerialization.jsonObject(with: (response as! NSData) as Data, options: []) as! NSDictionary
                            
                            print(dictResult)
                            self.appdel.hideMBProgressHUD()
                            self.appdel.alertValidation(strMessage: dictResult.value(forKey: "Message") as! String)
                            if dictResult.value(forKey: "IsError") as! Bool == false
                            {
                                self.arrCatalogueList.removeObject(at:rowint)
                                self.colView.reloadData()
                            }

                            
                        } catch let error as NSError {
                            print(error)
                            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Tryagain)
                        }
                        
                    },failure:{
                        requestOperation, error in
                        print("error is : \(error)")
                        self.appdel.hideMBProgressHUD()
                    })
                }
                actionSheetControllerIOS8.addAction(deleteActionButton)
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
            
        } else {
            print("Could not find index path")
        }
    }
    // MARK: -
    // MARK: WebService Call
    
    func callGetCatalogueList(){
        print("callGetCatalogueList...")
        
        appdel.showMBProgressHUD()
        
        let strUrl = String(format: "%@?clientAdminId=%@", CONSTANT.service_URL.GetCatalogueList,self.appdel.strClientAdminId)
        
        print(strUrl)
        
        Alamofire.request(strUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            self.appdel.hideMBProgressHUD()
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil
                {
                    let jsonObject = response.result.value as! NSDictionary
                    print(jsonObject)
                    
                    if jsonObject["IsError"] as! Bool == false
                    {
                        self.arrCatalogueList = NSMutableArray(array: jsonObject["LstCatalogue"] as! NSArray)
                        self.colView.reloadData()
                    }
                    else
                    {
                        self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.noData)
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
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.categorylists.count + 1
        return self.arrCatalogueList.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0
        {
            let cell:Cell_AddCatalogue = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_AddCatalogue", for: indexPath as IndexPath) as! Cell_AddCatalogue
           // cell.btn_catalogueAdd.addTarget(self, action: #selector(action_add(sender:)), for: .touchUpInside)
            return cell
        }
        else
        {
            let rowint = indexPath.row - 1
            
            let cell:Cell_Catalogue = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_Catalogue", for: indexPath as IndexPath) as! Cell_Catalogue
            
            let dic  = self.arrCatalogueList.object(at: rowint) as! NSDictionary
            cell.lbl_catalogueName.text = dic.value(forKey: "CatalogueName") as? String
            cell.img_catalogue.setImageWith(NSURL(string: dic.value(forKey: "CatalogueImage") as! String)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
           // cell.img_catalogue.contentMode = .scaleAspectFit
            
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            // Iphone
        if  CONSTANT.DeviceType.IS_IPHONE_6
        {
            return CGSize(width: 162, height: 233)
        }
        return CGSize(width: 192, height: 233)
    }

    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets{
       
            return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("category Index:\(indexPath.row)")
        
        if indexPath.row == 0
        {
            let objCataAddViewController = CataAddViewController(nibName: "CataAddViewController", bundle: nil)
            objCataAddViewController.isedit = false
            self.navigationController?.pushViewController(objCataAddViewController, animated: true)
        }
        else{
            let objGarMentViewController = GarMentViewController(nibName: "GarMentViewController", bundle: nil)
            let dic  = self.arrCatalogueList.object(at: indexPath.row - 1) as! NSDictionary
            objGarMentViewController.strCatalogueId = (dic.value(forKey: "CatalogueId") as? String)!
            self.navigationController?.pushViewController(objGarMentViewController, animated: true)
        }
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
