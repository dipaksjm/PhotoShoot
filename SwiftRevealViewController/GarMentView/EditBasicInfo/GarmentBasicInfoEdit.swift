//
//  GarAddViewController.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 20/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class GarmentBasicInfoEdit: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate{
    
    @IBOutlet weak var tblView : UITableView!
    var appdel =  AppDelegate()
    var dictGarmentDetailsNew = NSMutableDictionary()
    var arrGarmentImgList = NSMutableArray()
    var strCatalogueId  = String()
    
    var intCurrentPage  = 0

    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad...GarmentBasicInfoEdit...")
        
        appdel =  UIApplication.shared.delegate as! AppDelegate
        print("dictGarmentDetailsNew:\(dictGarmentDetailsNew)")
        
        //self.dictGarmentDetailsNew.removeObject(forKey: "LstGarmentImage")
        self.dictGarmentDetailsNew.removeObject(forKey: "LstModelImages")
        self.dictGarmentDetailsNew.removeObject(forKey: "LstAccessories")
        self.dictGarmentDetailsNew.removeObject(forKey: "LstModelmaster")
        
        print("dictGarmentDetailsNew:\(dictGarmentDetailsNew)")
        
        
        let arrTemp = NSArray()
        self.dictGarmentDetailsNew.setValue(arrTemp, forKey: "LstDeletedimages")
        
        let arrdic  =  NSMutableArray(array: (self.dictGarmentDetailsNew.value(forKey: "LstGarmentImage") as! NSArray))

        for i in 0..<arrdic.count
        {
            let dictMain : NSMutableDictionary = [:]
            let dic  = arrdic.object(at: i ) as! NSDictionary
            let strMediumImage = dic.value(forKey: "FullImage") as? String
            dictMain.setValue(strMediumImage, forKey: "FullImage")
            dictMain.setValue(false, forKey: "isManual")
            dictMain.setValue(false, forKey: "isSelect")
            dictMain.setValue(dic.value(forKey: "ImageId") as? String, forKey: "ImageId")

            self.arrGarmentImgList.add(dictMain)

        }
        print("self.arrGarmentImgList :\(self.arrGarmentImgList)")

        self.dictGarmentDetailsNew.setValue(self.arrGarmentImgList, forKey: "Lstimages")
        self.dictGarmentDetailsNew.removeObject(forKey: "LstGarmentImage")
        print("dictGarmentDetailsNew :\(dictGarmentDetailsNew)")

        
        self.setupView()
        
    }
    
    func setupView(){
        
        let nib11 = UINib(nibName: "Cell_ModelHeader", bundle: nil)
        self.tblView.register(nib11, forCellReuseIdentifier: "Cell_ModelHeader")
        
        
        let nib = UINib(nibName: "cell_imgCatelog", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "id_cell_imgCatelog")
        
        let nib1 = UINib(nibName: "Cell_ModelME", bundle: nil)
        tblView.register(nib1, forCellReuseIdentifier: "Cell_ModelME")
        
        let nibCell_AddessModel = UINib(nibName: "Cell_AddessModel", bundle: nil)
        self.tblView.register(nibCell_AddessModel, forCellReuseIdentifier: "Cell_AddessModel")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("dictGarmentDetailsNew:\(dictGarmentDetailsNew)")
        tblView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    func editModelImage(){
        print("editModelImage...")
        
        let objGarmentBasicInfoEdit_Images = GarmentBasicInfoEdit_Images(nibName: "GarmentBasicInfoEdit_Images", bundle: nil)
        objGarmentBasicInfoEdit_Images.dicModelDetail =  dictGarmentDetailsNew
        self.navigationController?.pushViewController(objGarmentBasicInfoEdit_Images, animated: true)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let viewWidth: CGFloat = scrollView.frame.size.width
        let pageNumber: Int = Int(floor((scrollView.contentOffset.x - viewWidth / 50) / viewWidth) + 1)
        
        let indexPath = NSIndexPath(row: 0, section: 0)
        print("indexPath:\(indexPath)")
        let cell = tblView.cellForRow(at: indexPath as IndexPath) as! Cell_ModelHeader
        cell.pageControl.currentPage = pageNumber
        
    }
    func pageChanged(sender:UIPageControl) {
        
        let indexPath = NSIndexPath(row: 0, section: 0)
        print("indexPath:\(indexPath)")
        let cell = tblView.cellForRow(at: indexPath as IndexPath) as! Cell_ModelHeader
        
        let pageNumber = cell.pageControl.currentPage
        var frame: CGRect = cell.scroll.frame
        frame.origin.x = CGFloat(Float(frame.size.width) * Float(pageNumber))
        frame.origin.y = 0
        cell.scroll.scrollRectToVisible(frame, animated: true)
    }
    

    // MARK: -

    @IBAction func action_Done(_ sender: Any){
        print("dictGarmentDetailsNew:\(dictGarmentDetailsNew)")
        self.view.endEditing(true)
        
        if dictGarmentDetailsNew["GarmentName"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Name)
        }
        else if  dictGarmentDetailsNew["GarmentTitle"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Title)
        }
        else if  dictGarmentDetailsNew["UniqCode"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Unicode)
        }else
        {
            
            let dictMain : NSMutableDictionary = [:]
            dictMain.setValue(self.setGarmentDetails(), forKey: "obj")
            print("dictMain:\(dictMain)")
            
            
            if let data = try? JSONSerialization.data(withJSONObject: dictMain, options: .prettyPrinted),
                let str = String(data: data, encoding: .utf8) {
                print(str)
            }
            appdel.showMBProgressHUD()
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFHTTPResponseSerializer()
            manager.requestSerializer.timeoutInterval = 60
            manager.post(CONSTANT.service_URL.SaveGarmentBasicInfo, parameters: dictMain, success: {
                requestOperation, response in
                do {
                    let dictResult =  try JSONSerialization.jsonObject(with: (response as! NSData) as Data, options: []) as! NSDictionary
                    
                    print(dictResult)
                    self.appdel.hideMBProgressHUD()
                    self.appdel.alertValidation(strMessage: dictResult.value(forKey: "Message") as! String)
                    
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
    }
    
    func setGarmentDetails()->NSMutableDictionary{
        
        print("dictGarmentDetailsNew is : \(dictGarmentDetailsNew)")

        let dic  = dictGarmentDetailsNew
        let arrdic  = dic.value(forKey: "Lstimages") as! NSArray
        if arrdic.count > 0
        {
            let dic1  = arrdic.object(at: 0) as! NSDictionary
            if dic1.value(forKey: "isManual") as? Bool ==  true{
                let strcoverImage = dic1.value(forKey: "FullImage") as? String
                let theFileName = (strcoverImage! as NSString).lastPathComponent
                let newcoverImage = "/UploadedImage/Garment/\(theFileName)"
                dic.setValue(newcoverImage, forKey: "CoverImage")
            }
            else{
                let strcoverImage = dic1.value(forKey: "FullImage") as? String
                let newcoverImage = strcoverImage?.replacingOccurrences(of: "http://162.241.243.214:421/", with: "", options: .literal, range: nil)
                print("newcoverImage :\(String(describing: newcoverImage))")
                dic.setValue(newcoverImage, forKey: "CoverImage")

            }
        }
        dic.setValue(false, forKey: "IsDeleted")
        dic.setValue(self.setGarmentImagesDetails(), forKey: "Lstimages")
        dic.setValue(self.setGarmentLstDeletedimagesDetails(), forKey: "LstDeletedimages")

        print("dic :\(dic)")

        return dic
        
    }
    func setGarmentLstDeletedimagesDetails()->NSMutableArray{
        let arrDetails = NSMutableArray()
        let arrdic  = dictGarmentDetailsNew.value(forKey: "LstDeletedimages") as! NSArray
        for i in 0..<arrdic.count
        {
             let dic  = arrdic.object(at: i ) as! NSDictionary
             let strImageDel = dic.value(forKey: "ImageId") as! String
              arrDetails.add(strImageDel)
        }
        
        return arrDetails
    }
    func setGarmentImagesDetails()->NSMutableArray{
        
        let arrDetails = NSMutableArray()
        
        let arrdic  = dictGarmentDetailsNew.value(forKey: "Lstimages") as! NSArray

        for i in 0..<arrdic.count
        {
            let dictMain : NSMutableDictionary = [:]
            let dic  = arrdic.object(at: i ) as! NSDictionary
            if dic.value(forKey: "isManual") as? Bool ==  true
            {
                let strcoverImage = dic.value(forKey: "FullImage") as? String
                let theFileName = (strcoverImage! as NSString).lastPathComponent
                let newcoverImage = "/UploadedImage/Garment/\(theFileName)"
                dictMain.setValue(newcoverImage, forKey: "FullImage")
                dictMain.setValue(true, forKey: "IsEditModelImage")
                dictMain.setValue("", forKey: "OldImage")

            }
            else{
                let strFullImage = dic.value(forKey: "FullImage") as? String
                let newFullImage = strFullImage?.replacingOccurrences(of: "http://162.241.243.214:421/", with: "", options: .literal, range: nil)
                print("newFullImage :\(String(describing: newFullImage))")
                dictMain.setValue(newFullImage, forKey: "FullImage")
                dictMain.setValue(false, forKey: "IsEditModelImage")

//                let strOldImage = dic.value(forKey: "OldImage") as? String
//                let theFileNameold = (strOldImage! as NSString).lastPathComponent
//                let newOldImage = "/UploadedImage/GarmentModel/\(theFileNameold)"
                dictMain.setValue("", forKey: "OldImage")

            }
            arrDetails.add(dictMain)
        }
        print("arrDetails :\(arrDetails)")
        
        return arrDetails
        
    }
    
    // MARK: -
    // MARK: UITableView Method
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        print("heightForRowAt...")
        if indexPath.row == 0
        {
            return 317
        }
        else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3
        {
            return 44
        }
        
        return 100
        
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if indexPath.row == 0{
            let cell : Cell_ModelHeader = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelHeader") as! Cell_ModelHeader
            
            cell.btnHeaderEdit.addTarget(self, action: #selector(self.editModelImage), for: UIControlEvents.touchUpInside)
            
            let arrdic  = dictGarmentDetailsNew.value(forKey: "Lstimages") as? NSArray
            
            let total = Float((arrdic?.count)!)

            cell.scroll.contentSize = CGSize(width: CGFloat(Float(tableView.frame.size.width) * total), height: cell.scroll.frame.size.height)
            // page control
            cell.scroll.delegate = self
            cell.pageControl.numberOfPages = Int(total)
            cell.pageControl.addTarget(self, action: #selector(pageChanged(sender:)), for: .valueChanged)
            
            var x: CGFloat = 0
            for i in 0..<Int(total)  {
                let image = UIImageView(frame: CGRect(x: x + 0, y: 0, width: tableView.frame.size.width, height: cell.scroll.frame.size.height))
                // image.image = UIImage(named: "\(i).jpg")
                let dic  = arrdic?.object(at: i ) as! NSDictionary
                if dic.value(forKey: "isManual") as? Bool ==  true{
                    image.image = UIImage(contentsOfFile: (dic.value(forKey: "FullImage") as? String)!)
                }
                else{
                    let strImgPath = dic.value(forKey: "FullImage") as? String
                    image.setImageWith(NSURL(string: strImgPath!)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
                }
                
                image.contentMode = .scaleAspectFit // ALTERNATIVE:  .ScaleAspectFit
                cell.scroll.addSubview(image)
                x += tableView.frame.size.width
            }
            return cell
        }
        
        else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3{
            let rowint = indexPath.row - 1
            
            let cell : Cell_ModelME = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelME") as! Cell_ModelME
            cell.txtField.isEnabled = true
            if indexPath.row == 1{
                cell.lblName.text = "NAME"
                cell.txtField.text = self.dictGarmentDetailsNew.value(forKey: "GarmentName") as? String
                cell.txtField.keyboardType = .default
            }
            if indexPath.row == 2{
                cell.lblName.text = "TITLE"
                cell.txtField.text = self.dictGarmentDetailsNew.value(forKey: "GarmentTitle") as? String
                cell.txtField.keyboardType = .default
            }
            if indexPath.row == 3{
                cell.lblName.text = "UNICODE"
                cell.txtField.text = self.dictGarmentDetailsNew.value(forKey: "UniqCode") as? String
                cell.txtField.keyboardType = .numberPad
                cell.txtField.isEnabled = false
            }
           
            cell.txtField.tag =  rowint
            cell.txtField.delegate = self
            return cell
            
        }
        else
        {
            let cell : Cell_AddessModel = tableView.dequeueReusableCell(withIdentifier: "Cell_AddessModel") as! Cell_AddessModel
            cell.lblTitle.text = "DESCRIPTION"
            cell.txtaddress.text = self.dictGarmentDetailsNew.value(forKey: "Description") as? String
            cell.txtaddress.tag = indexPath.row
            cell.txtaddress.delegate = self
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    // MARK: -

    func editGarmentPhoto(){
        print("editGarmentPhoto...")
//        let objGarmentBasicInfoEdit_Images = GarmentBasicInfoEdit_Images(nibName: "GarmentBasicInfoEdit_Images", bundle: nil)
//        objGarmentBasicInfoEdit_Images.dictGarmentInfo = NSMutableDictionary(dictionary: self.dictGarmentDetailsNew)
//        self.navigationController?.pushViewController(objGarmentBasicInfoEdit_Images, animated: true)

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
            self.dictGarmentDetailsNew.setValue(textField.text, forKey: "GarmentName")
        }
        if textField.tag == 1 {
            dictGarmentDetailsNew["GarmentTitle"] = textField.text
            self.dictGarmentDetailsNew.setValue(textField.text, forKey: "GarmentTitle")
        }
        if textField.tag == 2 {
            dictGarmentDetailsNew["UniqCode"] = textField.text
            self.dictGarmentDetailsNew.setValue(textField.text, forKey: "UniqCode")
        }
        print("dictGarmentDetailsNew:\(dictGarmentDetailsNew)")
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        return true
    }
    
    // MARK: - TextView
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
//         dictGarmentDetailsNew["Description"] = textView.text
        self.dictGarmentDetailsNew.setValue(textView.text, forKey: "Description")

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        return true
    }
}

