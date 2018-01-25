//
//  AddAccViewController.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 11/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
//AddAccViewController
class AccessorieListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tblView : UITableView!
    var appDelegate =  AppDelegate()
    var arrList = NSMutableArray()
    var dictGarmentDetails = NSMutableDictionary()

    var imagePicker = UIImagePickerController()
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate =  UIApplication.shared.delegate as! AppDelegate

        imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        
        let nib = UINib(nibName: "Cell_Access", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "Cell_Access")
        
        print("arrList: \(arrList)")
        
        print("dictGarmentDetails: \(dictGarmentDetails)")


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -
    func deleteAccessories(intIndex:Int){
        
        print("deleteAccessories...")
        
        let dictData = self.arrList.object(at: intIndex) as! NSDictionary
        
        self.appDelegate.showMBProgressHUD()

        let parameters: [String: Any] = [
            "GarmentId": self.dictGarmentDetails.value(forKey: "GarmentId") as! String,
            "AccessoriesId": dictData.value(forKey: "AccessoriesId") as! String,
            "ClientId": self.dictGarmentDetails.value(forKey: "ClientId") as! String,
            "CategoryId": "\(dictData.value(forKey: "CategoryId") as! NSNumber)",
            "CreatedBy": dictData.value(forKey: "CreatedBy") as! String,
            "ClientAdminId": self.appDelegate.strClientAdminId,
            "AccessoriesName": dictData.value(forKey: "AccessoriesName") as! String,
            "Description": dictData.value(forKey: "Description") as! String,
            "FullImage": (dictData.value(forKey: "FullImage") as! String).replacingOccurrences(of:CONSTANT.service_URL.pathImgRemove, with: ""),
            "Isdeleted": "true"
            ]
        
        print("parameters ==> \(parameters)")

        let parametersNew : [String:Any] = ["obj":parameters]
        
        Alamofire.request(CONSTANT.service_URL.AccessoriesAddEdit, method: .post, parameters: parametersNew , encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            self.appDelegate.hideMBProgressHUD()
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil{
                    
                    let jsonObject = response.result.value as! NSDictionary
                    print("jsonObject:\(jsonObject)")
                    
                    if jsonObject["IsError"] as! Bool == true {
                        self.appDelegate.showMBProgressHUD_short(strMsg: CONSTANT.AlretMessage.Accessory_deleted)
                        self.arrList.removeObject(at: intIndex)
                        self.tblView.reloadData()
                    }else{
                        
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                self.appDelegate.alertValidation(strMessage: response.result.error!.localizedDescription)
                break
            }
        }
        
        
    }
    // MARK: -
    
    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_Done(_ sender: Any)
    {
    }
    
    @IBAction func action_AddNewAccessory(_ sender: UIButton){
        let objAccessoriesDetailsViewController = AccessoriesDetailsViewController(nibName: "AccessoriesDetailsViewController", bundle: nil)        
        
        objAccessoriesDetailsViewController.isNew = "yes"
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "ClientId") as! String, forKey: "ClientId")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "GarmentId") as! String, forKey: "GarmentId")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "GarmentTitle") as! String, forKey: "GarmentTitle")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "CreatedBy") as! String, forKey: "CreatedBy")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "UniqCode") as! String, forKey: "UniqCode")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "ClientAdminId") as! String, forKey: "ClientAdminId")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "CatalogueId") as! String, forKey: "CatalogueId")
        
        self.navigationController?.pushViewController(objAccessoriesDetailsViewController, animated: true)

    }

    // MARK: -

    @IBAction func action_OpenPicker(_ sender: Any)
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: UITableView Method
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        print("canEditRowAt : \(String(describing: indexPath.row))")
//       return true
//    }
//
//    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
//        print("didEndEditingRowAt : \(String(describing: indexPath?.row))")
//    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arrList.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alertController = UIAlertController(title: "Are you sure want to delete this accessory?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "NO", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Cancel button");
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
                print("you have pressed OK button");
                print("editingStyle Delete: \(indexPath.row)")
                self.deleteAccessories(intIndex: indexPath.row)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)

            
        }
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : Cell_Access = tableView.dequeueReusableCell(withIdentifier: "Cell_Access") as! Cell_Access
        
        cell.lbl_AccName.text = (self.arrList.object(at: indexPath.row) as! NSDictionary).value(forKey: "AccessoriesName") as? String
        cell.lbl_AccDes.text = (self.arrList.object(at: indexPath.row) as! NSDictionary).value(forKey: "Description") as? String

        
        let strImgPath = (self.arrList.object(at: indexPath.row) as! NSDictionary).value(forKey: "AccessoriesImage") as! String
        if strImgPath.count > 0{
            cell.img_Acc.setImageWith(NSURL(string: strImgPath)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            cell.img_Acc.image = UIImage(named:"placeholder.png")
        }
       
        cell.btn_AccCU.setImage(UIImage(named:"arrow.png"), for: .normal)
        cell.layout_btnW.constant = 22.0
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let objAccessoriesDetailsViewController = AccessoriesDetailsViewController(nibName: "AccessoriesDetailsViewController", bundle: nil)
        
        objAccessoriesDetailsViewController.isNew = "no"
        objAccessoriesDetailsViewController.dictAccessDetails = NSMutableDictionary(dictionary: self.arrList.object(at: indexPath.row) as! NSDictionary)
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "ClientId") as! String, forKey: "ClientId")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "CreatedBy") as! String, forKey: "CreatedBy")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "CatalogueId") as! String, forKey: "CatalogueId")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "ClientAdminId") as! String, forKey: "ClientAdminId")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "UniqCode") as! String, forKey: "UniqCode")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "GarmentId") as! String, forKey: "GarmentId")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "CoverImage") as! String, forKey: "CoverImage")
        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "GarmentTitle") as! String, forKey: "GarmentTitle")
//        objAccessoriesDetailsViewController.dictAccessDetails.setValue(self.dictGarmentDetails.value(forKey: "Description") as! String, forKey: "Description")
        
        self.navigationController?.pushViewController(objAccessoriesDetailsViewController, animated: true)

        
    }
    
   // MARK: -
    
}
