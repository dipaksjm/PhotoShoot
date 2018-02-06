//
//  ProductDetailsVC.swift
//  SwiftRevealViewController
//
//  Created by Dips here... on 1/6/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD


class GarAddViewController2: UIViewController,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIPageViewControllerDelegate {
    
    var appDelegate =  AppDelegate()
    
    var arrImgGarment = NSMutableArray()
    var arrAccessory = NSMutableArray()
    var arrModel = NSMutableArray()
    var arrEnvironment = NSMutableArray()

    @IBOutlet var tblMain : UITableView!
    var intCurrentPage  = 0
    

    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate =  UIApplication.shared.delegate as! AppDelegate
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear...\(self.appDelegate.dictAddNewGarment)")
        
        self.setupView()

        
        self.tblMain.reloadData()
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning()   }
    
    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }

    func setupView(){
        
        if let isGarmentAvailable = self.appDelegate.dictAddNewGarment.value(forKey: "LstGarmentImage") as? NSArray{
            if isGarmentAvailable.isKind(of: NSArray.self){
                self.arrImgGarment = NSMutableArray(array: isGarmentAvailable)
            }
        }else{
            let arrTemp = NSMutableArray()
            self.appDelegate.dictAddNewGarment.setValue(arrTemp, forKey: "LstGarmentImage")
        }
        
        if let isAcceAvailable = self.appDelegate.dictAddNewGarment.value(forKey: "LstAccessories") as? NSArray{
            if isAcceAvailable.isKind(of: NSArray.self){
                self.arrAccessory = NSMutableArray(array: isAcceAvailable)
            }
        }else{
            let arrTemp = NSMutableArray()
            self.appDelegate.dictAddNewGarment.setValue(arrTemp, forKey: "LstAccessories")
        }
        
        if let isModelAvailable = self.appDelegate.dictAddNewGarment.value(forKey: "LstModelmaster") as? NSArray{
            if isModelAvailable.isKind(of: NSArray.self){
                self.arrModel = NSMutableArray(array: isModelAvailable)
            }
        }else{
            let arrTemp = NSMutableArray()
            self.appDelegate.dictAddNewGarment.setValue(arrTemp, forKey: "LstModelmaster")
        }
        
//        if let isEnvironmentAvailable = self.appDelegate.dictAddNewGarment.value(forKey: "???") as? NSArray{
//            if isEnvironmentAvailable.isKind(of: NSArray.self){
//                self.arrImgGarment = NSMutableArray(array: isGarmentAvailable)
//            }
//        }

        
        let nibImagePagination = UINib(nibName: "cell_imgCatelog", bundle: nil)
        self.tblMain.register(nibImagePagination, forCellReuseIdentifier: "id_cell_imgCatelog")
        
        let nibSeperateCV = UINib(nibName: "cell_cvCatelogList", bundle: nil)
        self.tblMain.register(nibSeperateCV, forCellReuseIdentifier: "id_cell_cvCatelogList")
        
        let nibCatelogueName = UINib(nibName: "cell_CatelogueName", bundle: nil)
        self.tblMain.register(nibCatelogueName, forCellReuseIdentifier: "id_cell_CatelogueName")
        
        print(" self.appDelegate.dictAddNewGarment : \(self.appDelegate.dictAddNewGarment)")

        print("\(self.arrAccessory.count)")
        print("\(self.arrModel.count)")
        print("\(self.arrImgGarment.count)")
    }
    
    // MARK: -
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (scrollView.isKind(of: UICollectionView.self)) || (scrollView.isKind(of: UITableView.self)){
            print("UICollectionView... scrolled")
            return
        }
        
        var floatX : CGFloat = 0.0
        for i in 0..<self.arrImgGarment.count{
//            print("floatX : \(floatX), scrollView.contentOffset.x : \(scrollView.contentOffset.x)")
            
            if floatX == scrollView.contentOffset.x{
                print("new index is : \(i)")
                self.intCurrentPage = i
                let indexPath = NSIndexPath(row: 0, section: 0)
                self.tblMain.reloadRows(at: [indexPath as IndexPath], with: .none)
                self.perform(#selector(reloadImageView), with: nil, afterDelay: 0.6)
                break
            }
            floatX = floatX + self.tblMain.frame.size.width
        }
    }
    
    func reloadImageView(){
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.tblMain.reloadRows(at: [indexPath as IndexPath], with: .none)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollView.contentSize : \(scrollView.contentOffset.x)")
    }
    
    
    
    // MARK: -
//    /*
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            
//            if indexPath.section == 0{
//                reusableview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
//            }else if indexPath.section == 1{
//                reusableview.frame = CGRect(x: 0, y: 70, width: self.view.frame.width, height: 50)
//            }else{
//                reusableview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
//            }
            reusableview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70)

//            reusableview.backgroundColor = UIColor.yellow
            return reusableview
            
            
        default:  fatalError("Unexpected element kind")
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var intCount = 1
        
        if collectionView.tag == 0{
            intCount = intCount + self.arrAccessory.count
        }else if collectionView.tag == 1{
            intCount = intCount + self.arrModel.count
        }else if collectionView.tag == 2{
            intCount = intCount + self.arrEnvironment.count
        }
        return intCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0{
            if indexPath.row == 0{
                let cell:Cell_cv_GarmentAcc = collectionView.dequeueReusableCell(withReuseIdentifier: "id_Cell_cv_GarmentAcc", for: indexPath as IndexPath) as! Cell_cv_GarmentAcc
//                cell.btn_image.setBackgroundImage(UIImage(named:"addAcce.png") , for: .normal)
                cell.btn_image.setImage(UIImage(named:"addAcce.png"), for: .normal)
                cell.imgType.image = nil
                cell.tag = indexPath.row
                cell.accessibilityValue = "AC"
                return cell
            }else{
                let cell:Cell_cv_GarmentAcc = collectionView.dequeueReusableCell(withReuseIdentifier: "id_Cell_cv_GarmentAcc", for: indexPath as IndexPath) as! Cell_cv_GarmentAcc
                let strImgPath = (self.arrAccessory.object(at: indexPath.row-1) as! NSDictionary).value(forKey: "SmallImage") as! String
                if strImgPath.count > 0{
                    cell.imgType.image = UIImage(contentsOfFile:strImgPath)
                }else{
                    cell.imgType.image = UIImage(named:"placeholder.png")
                }
                
                cell.tag = indexPath.row
                cell.accessibilityValue = "AC"
                return cell
            }
        }else if collectionView.tag == 1{
            if indexPath.row == 0{
                let cell:Cell_cv_GarmentAcc = collectionView.dequeueReusableCell(withReuseIdentifier: "id_Cell_cv_GarmentAcc", for: indexPath as IndexPath) as! Cell_cv_GarmentAcc
//                cell.btn_image.setBackgroundImage(UIImage(named:"addAcce.png") , for: .normal)
                cell.btn_image.setImage(UIImage(named:"addAcce.png"), for: .normal)
                cell.imgType.image = nil

                cell.tag = indexPath.row
                cell.accessibilityValue = "MO"
                return cell
            }else{
                let cell:Cell_cv_GarmentAcc = collectionView.dequeueReusableCell(withReuseIdentifier: "id_Cell_cv_GarmentAcc", for: indexPath as IndexPath) as! Cell_cv_GarmentAcc
                
                let strImgPath = (self.arrModel.object(at: indexPath.row-1) as! NSDictionary).value(forKey: "CoverImage") as! String
                if strImgPath.count > 0{
                    cell.imgType.setImageWith(NSURL(string: strImgPath)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
                }else{
                    cell.imgType.image = UIImage(named:"placeholder.png")
                }

                cell.tag = indexPath.row
                cell.accessibilityValue = "MO"
                return cell
            }
        }else{
            if indexPath.row == 0{
                let cell:Cell_cv_GarmentAcc = collectionView.dequeueReusableCell(withReuseIdentifier: "id_Cell_cv_GarmentAcc", for: indexPath as IndexPath) as! Cell_cv_GarmentAcc
//                cell.btn_image.setBackgroundImage(UIImage(named:"addAcce.png") , for: .normal)
                cell.tag = indexPath.row
                cell.btn_image.setImage(UIImage(named:"addAcce.png"), for: .normal)
                cell.imgType.image = UIImage(named:"addAcce.png")
                cell.imgType.image = nil
                cell.accessibilityValue = "EN"
                return cell
            }else{
                let cell:Cell_cv_GarmentAcc = collectionView.dequeueReusableCell(withReuseIdentifier: "id_Cell_cv_GarmentAcc", for: indexPath as IndexPath) as! Cell_cv_GarmentAcc
                
                let strImgPath = (self.arrEnvironment.object(at: indexPath.row-1) as! NSDictionary).value(forKey: "??????") as! String
                if strImgPath.count > 0{
                    cell.imgType.setImageWith(NSURL(string: strImgPath)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
                }else{
                    cell.imgType.image = UIImage(named:"placeholder.png")
                }

                cell.tag = indexPath.row
                cell.accessibilityValue = "EN"
                return cell
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // Iphone
        if  CONSTANT.DeviceType.IS_IPHONE_6
        {
            return CGSize(width: 70, height: 70)
        }
        return CGSize(width: 70, height: 70)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsetsMake(3, 3, 3, 3)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionView tag:\(collectionView.tag) row:\(indexPath.row)")
     
        if collectionView.tag == 0{ // accessories
            
            if indexPath.row == 0
            {
                let objAccessorieListVC = AccessorieListVC(nibName: "AccessorieListVC", bundle: nil)
             
                objAccessorieListVC.arrList = self.arrAccessory
                objAccessorieListVC.dictGarmentDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "ClientId") as! String, forKey: "ClientId")
//                objAccessorieListVC.dictGarmentDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "GarmentId") as! String, forKey: "GarmentId")
                objAccessorieListVC.dictGarmentDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "CreatedBy") as! String, forKey: "CreatedBy")
                objAccessorieListVC.dictGarmentDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "GarmentTitle") as! String, forKey: "GarmentTitle")
//                objAccessorieListVC.self.appDelegate.dictAddNewGarment.setValue(self.self.appDelegate.dictAddNewGarment.value(forKey: "Description") as! String, forKey: "Description")
                objAccessorieListVC.dictGarmentDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "UniqCode") as! String, forKey: "UniqCode")
                objAccessorieListVC.dictGarmentDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "ClientAdminId") as! String, forKey: "ClientAdminId")
                objAccessorieListVC.dictGarmentDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "CatalogueId") as! String, forKey: "CatalogueId")
                objAccessorieListVC.dictGarmentDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "CoverImage") as! String, forKey: "CoverImage")
                self.navigationController?.pushViewController(objAccessorieListVC, animated: true)
            }
            else
            {
                let objAccessoriesDetailsViewController = AccessoriesDetailsViewController(nibName: "AccessoriesDetailsViewController", bundle: nil)
                
                objAccessoriesDetailsViewController.isNew = "no"
                objAccessoriesDetailsViewController.intIndex = indexPath.row-1
                objAccessoriesDetailsViewController.dictAccessDetails = NSMutableDictionary(dictionary: self.arrAccessory.object(at: indexPath.row-1) as! NSDictionary)
                objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "ClientId") as! String, forKey: "ClientId")
                objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "GarmentId") as! String, forKey: "GarmentId")
                objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "GarmentTitle") as! String, forKey: "GarmentTitle")
                objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "CreatedBy") as! String, forKey: "CreatedBy")
//                objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.self.appDelegate.dictAddNewGarment.value(forKey: "Description") as! String, forKey: "Description")
                objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "UniqCode") as! String, forKey: "UniqCode")
                objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "CoverImage") as! String, forKey: "CoverImage")
                objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "ClientAdminId") as! String, forKey: "ClientAdminId")
                objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.appDelegate.dictAddNewGarment.value(forKey: "CatalogueId") as! String, forKey: "CatalogueId")
                

                
                self.navigationController?.pushViewController(objAccessoriesDetailsViewController, animated: true)
            }
            
        }else if collectionView.tag == 1{ // model
            if indexPath.row == 0
            {
//                let objNewModelAddViewController = NewModelAddViewController(nibName: "NewModelAddViewController", bundle: nil)
//                self.navigationController?.pushViewController(objNewModelAddViewController, animated: true)
                
                let objModelList = ModelList(nibName: "ModelList", bundle: nil)
                objModelList.arrModelListPrevious = self.arrModel
                objModelList.strGarmentID = self.self.appDelegate.dictAddNewGarment.value(forKey: "GarmentId") as! String as NSString
                self.navigationController?.pushViewController(objModelList, animated: true)

            }
            else{
                let objModelViewController = ModelViewController(nibName: "ModelViewController", bundle: nil)
                objModelViewController.arrModelDetail = self.arrModel
                self.navigationController?.pushViewController(objModelViewController, animated: true)
            }
            
        }else if collectionView.tag == 2{ // environment
            
        }

      
    }
//     */
    
    // MARK: -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 251.0
        }else if indexPath.section == 1{
            return 45.0
        }
        return 130.0 // 122
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 || section == 1{
            return 1
        }else{
            return 3
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0{
            let cell : cell_imgCatelog = tableView.dequeueReusableCell(withIdentifier: "id_cell_imgCatelog") as! cell_imgCatelog
            cell.svMain.delegate = self
            cell.svMain.backgroundColor = UIColor.white
            
            for i in 0..<self.arrImgGarment.count{
//                (cell.svMain.viewWithTag(100+i) as! UIScrollView).removeFromSuperview()
                if let isImgView = cell.svMain.viewWithTag(100+i){
                    if isImgView.isKind(of: UIImageView.self){
                        isImgView.removeFromSuperview()
                    }
                }
            }
            
            cell.btnEditPhoto.addTarget(self, action: #selector(self.editGarmentPhoto), for: UIControlEvents.touchUpInside)
            cell.btnEditPhoto.setImage(UIImage(named: "editName.png"), for: .normal)
            

            
            cell.svMain.contentSize.width = CGFloat(Float(self.tblMain.frame.size.width) * Float(self.arrImgGarment.count))
            cell.pcImage.numberOfPages = self.arrImgGarment.count
            print("intCurrentPage :\(intCurrentPage)")
            cell.pcImage.currentPage = intCurrentPage

            var floatX : CGFloat = 0.0
            for i in 0..<self.arrImgGarment.count{
                let imgCatelogue = UIImageView()
                imgCatelogue.frame = CGRect(x: floatX, y: 0, width: self.tblMain.frame.size.width, height: 251)
                imgCatelogue.image = UIImage(named: "placeholder.png")
                let dictGDetails = self.arrImgGarment.object(at: i) as! NSDictionary
//                imgCatelogue.setImageWith(NSURL(string: dictGDetails.value(forKey: "MediumImage") as! String)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
                imgCatelogue.tag = 100 + i
                imgCatelogue.contentMode = UIViewContentMode.scaleAspectFit
                cell.svMain.addSubview(imgCatelogue)
                floatX = floatX + self.tblMain.frame.size.width
            }
            
            if self.arrImgGarment.count == 0{
                let imgCatelogue = UIImageView()
                imgCatelogue.frame = CGRect(x: floatX, y: 0, width: self.tblMain.frame.size.width, height: 251)
                imgCatelogue.image = UIImage(named: "placeholderAddImages.png")
                imgCatelogue.tag = 1313
                imgCatelogue.contentMode = UIViewContentMode.scaleAspectFit
                cell.svMain.addSubview(imgCatelogue)
            }
            
            
            
            cell.pcImage.backgroundColor = UIColor.clear
            cell.pcImage.transform = CGAffineTransform(scaleX: 2, y: 2)
            cell.pcImage.tintColor = UIColor.lightGray
            cell.pcImage.pageIndicatorTintColor = UIColor.gray
            cell.pcImage.currentPageIndicatorTintColor = CONSTANT.color_App.color_CM
            cell.pcImage.setNeedsDisplay()
            cell.pcImage.tag = 3343
            
            let X : CGFloat = CGFloat(cell.pcImage.currentPage) * self.tblMain.frame.size.width
            cell.svMain.setContentOffset(CGPoint(x:X, y:0), animated: false)
            return cell
        }else if indexPath.section == 1{
            let cell : cell_CatelogueName = tableView.dequeueReusableCell(withIdentifier: "id_cell_CatelogueName") as! cell_CatelogueName
            cell.txtTitle.text = self.self.appDelegate.dictAddNewGarment.value(forKey: "GarmentTitle") as? String
            cell.txtTitle.textColor = CONSTANT.color_App.color_CM
            cell.btn_EditTitle.addTarget(self, action: #selector(self.editGarmentTitle), for: UIControlEvents.touchUpInside)
            return cell
        }else{
            
           let cell : cell_cvCatelogList = tableView.dequeueReusableCell(withIdentifier: "id_cell_cvCatelogList") as! cell_cvCatelogList
            
            if indexPath.row == 0{
                cell.lblTitle.text = "ACCESSORIES"
            }else if indexPath.row == 1{
                cell.lblTitle.text = "MODEL"
            }else if indexPath.row == 2{
                cell.lblTitle.text = "ENVIRONMENT"
            }
            cell.lblTitle.textColor = UIColor.darkGray
            
//            cell.lblTitle.text = "\(indexPath.row)"
            cell.cvMain.delegate = self
            cell.cvMain.dataSource = self
            cell.cvMain.tag = indexPath.row
            
            let nib = UINib(nibName: "Cell_Catalogue", bundle: nil)
            cell.cvMain.register(nib, forCellWithReuseIdentifier:"Cell_Catalogue")
            
            let nibAdd = UINib(nibName: "Cell_cv_GarmentAcc", bundle: nil)
            cell.cvMain.register(nibAdd, forCellWithReuseIdentifier:"id_Cell_cv_GarmentAcc")
            
            cell.cvMain.allowsSelection = true
            cell.cvMain.allowsMultipleSelection = false

            cell.cvMain.backgroundColor = UIColor.clear
            
            cell.cvMain.reloadData()
            return cell

        }

    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    // MARK: -
    
    
    
    

    func editGarmentTitle(){
        print("editGarmentTitle...")
//        let objGarmentBasicInfoEdit = GarmentBasicInfoEdit(nibName: "GarmentBasicInfoEdit", bundle: nil)
//        let dictTemp : NSDictionary = self.self.appDelegate.dictAddNewGarment
//        objGarmentBasicInfoEdit.dictGarmentDetailsNew = NSMutableDictionary(dictionary: dictTemp)
//        self.navigationController?.pushViewController(objGarmentBasicInfoEdit, animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func editGarmentPhoto(){
        print("editGarmentPhoto...")
         let objSelectMultipleImages = SelectMultipleImages(nibName: "SelectMultipleImages", bundle: nil)
         self.navigationController?.pushViewController(objSelectMultipleImages, animated: true)


    }
    
}
