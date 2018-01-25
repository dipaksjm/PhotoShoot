//
//  GarMentViewController.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 09/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD


class GarMentViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var colView : UICollectionView!
    var appdel =  AppDelegate()
    var arrGarmentList = NSMutableArray()
    var strCatalogueId  = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appdel =  UIApplication.shared.delegate as! AppDelegate
        
        let nib = UINib(nibName: "Cell_Catalogue", bundle: nil)
        self.colView.register(nib, forCellWithReuseIdentifier:"Cell_Catalogue")
        
        let nibAdd = UINib(nibName: "Cell_AddGarment", bundle: nil)
        self.colView.register(nibAdd, forCellWithReuseIdentifier:"Cell_AddGarment")
        
        self.colView.allowsSelection = true
        self.colView.allowsMultipleSelection = false
        
        self.callGetGarmentListByCaytalogueId()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func action_add(sender: UIButton!){
        print("action_add...")
    }
    
    // MARK: -
    // MARK: WebService Call
    
    func callGetGarmentListByCaytalogueId(){
        print("callGetGarmentListByCaytalogueId...")
        
        appdel.showMBProgressHUD()
        
        
        let strUrl = String(format: "%@?CatalogueId=%@", CONSTANT.service_URL.GetGarmentListByCaytalogueId,strCatalogueId)
        
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
                        self.arrGarmentList = NSMutableArray(array: jsonObject["LstGarment"] as! NSArray)
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
        return 1 + self.arrGarmentList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0
        {
            let cell:Cell_AddGarment = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_AddGarment", for: indexPath as IndexPath) as! Cell_AddGarment
          //  cell.btn_GarmentAdd.addTarget(self, action: #selector(action_add(sender:)), for: .touchUpInside)
            cell.btn_GarmentAdd.setImage(UIImage(named: "addGarment.png"), for: UIControlState.normal)
            cell.lblName.text = "ADD GARMENT"
            
            return cell
        }
        else
        {
            let rowint = indexPath.row - 1
            
            let cell:Cell_Catalogue = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_Catalogue", for: indexPath as IndexPath) as! Cell_Catalogue
            
            let dic  = self.arrGarmentList.object(at: rowint) as! NSDictionary
            cell.lbl_catalogueName.text = dic.value(forKey: "GarmentName") as? String
            cell.img_catalogue.setImageWith(NSURL(string: dic.value(forKey: "CoverImage") as! String)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
            
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
            let objGarAddViewController = GarAddViewController(nibName: "GarAddViewController", bundle: nil)
            objGarAddViewController.strCatalogueId = self.strCatalogueId
            self.navigationController?.pushViewController(objGarAddViewController, animated: true)
        }
        else{
            let objProductDetailsVC = ProductDetailsVC(nibName: "ProductDetailsVC", bundle: nil)
            let dictDetails = self.arrGarmentList.object(at: indexPath.row - 1) as! NSDictionary
            objProductDetailsVC.dictGarmentDetails = NSMutableDictionary(dictionary: dictDetails)
            self.navigationController?.pushViewController(objProductDetailsVC, animated: true)
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

