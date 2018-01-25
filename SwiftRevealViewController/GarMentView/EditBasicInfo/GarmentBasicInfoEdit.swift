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
    var appDelegate =  AppDelegate()
    var dictGarmentDetailsNew = NSMutableDictionary()
    var arrGarmentImgList = NSMutableArray()
    var strCatalogueId  = String()
    
    var intCurrentPage  = 0

    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad...GarmentBasicInfoEdit...")
        
        appDelegate =  UIApplication.shared.delegate as! AppDelegate
        
        print("dictGarmentDetailsNew:\(dictGarmentDetailsNew)")

        self.setupView()
        
    }
    
    func setupView(){
        let nib = UINib(nibName: "cell_imgCatelog", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "id_cell_imgCatelog")
        
        let nib1 = UINib(nibName: "Cell_ModelME", bundle: nil)
        tblView.register(nib1, forCellReuseIdentifier: "Cell_ModelME")
        
        let nibCell_AddessModel = UINib(nibName: "Cell_AddessModel", bundle: nil)
        self.tblView.register(nibCell_AddessModel, forCellReuseIdentifier: "Cell_AddessModel")
        
        self.arrGarmentImgList = NSMutableArray(array: self.dictGarmentDetailsNew.value(forKey: "LstGarmentImage") as! NSArray)
        
        self.dictGarmentDetailsNew.setValue(self.dictGarmentDetailsNew.value(forKey: "LstGarmentImage") as! NSArray, forKey: "Lstimages")
        
        let arrTemp = NSArray()
        self.dictGarmentDetailsNew.setValue(arrTemp, forKey: "LstDeletedimages")

        
        self.dictGarmentDetailsNew.removeObject(forKey: "LstGarmentImage")
        self.dictGarmentDetailsNew.removeObject(forKey: "LstModelImages")
        self.dictGarmentDetailsNew.removeObject(forKey: "LstAccessories")
        self.dictGarmentDetailsNew.removeObject(forKey: "LstModelmaster")
        
        
        print("dictGarmentDetailsNew:\(dictGarmentDetailsNew)")

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.isKind(of: UICollectionView.self)) || (scrollView.isKind(of: UITableView.self)){
            return
        }
        
        var floatX : CGFloat = 0.0
        for i in 0..<self.arrGarmentImgList.count{
            if floatX == scrollView.contentOffset.x{
                self.intCurrentPage = i
                let indexPath = NSIndexPath(row: 0, section: 0)
                self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
                self.perform(#selector(reloadImageView), with: nil, afterDelay: 0.6)
                break
            }
            floatX = floatX + self.tblView.frame.size.width
        }
    }
    
    func reloadImageView(){
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
    }

    // MARK: -

    @IBAction func action_Done(_ sender: Any){
        print("dictGarmentDetailsNew:\(dictGarmentDetailsNew)")
        self.view.endEditing(true)
        
        if dictGarmentDetailsNew["GarmentName"] as? String == ""
        {
            self.appDelegate.alertValidation(strMessage: CONSTANT.AlretMessage.Name)
        }
        else if  dictGarmentDetailsNew["GarmentTitle"] as? String == ""
        {
            self.appDelegate.alertValidation(strMessage: CONSTANT.AlretMessage.Title)
        }
        else if  dictGarmentDetailsNew["UniqCode"] as? String == ""
        {
            self.appDelegate.alertValidation(strMessage: CONSTANT.AlretMessage.Unicode)
        }else
        {
            print("action_Done:")
            self.saveGarment()
        }
    }
    
    
    func saveGarment(){
    
    print("saveGarment...")
        
        print("self.dictGarmentDetailsNew :  \(self.dictGarmentDetailsNew)")
        
        return

        return
//    self.appDelegate.showMBProgressHUD()
        
    let parameters: [String: Any] = [
        "GarmentId": "",
        "GarmentName": "",
        "GarmentTitle": "",
        "Description": "",
        "UniqCode": "",
        "CoverImage": "",
        "IsActive": "",
        "ClientId": "",
        "CreatedBy": "",
        "Isdeleted": "false",
        ]
//        Lstimages
//        LstDeletedimages
    print("parameters ==> \(parameters)")
    
    let parametersNew : [String:Any] = ["obj":parameters]
    
    Alamofire.request(CONSTANT.service_URL.AddEditScheduler, method: .post, parameters: parametersNew , encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
    
        self.appDelegate.hideMBProgressHUD()
        switch(response.result){
        case .success(_):
            if response.result.value != nil{
                
                let dictRes = response.result.value as! NSDictionary
                print("dictRes:\(dictRes)")
                
                if dictRes["Success"] as! Bool == true {
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
    // MARK: UITableView Method
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        print("heightForRowAt...")
        if indexPath.row == 0
        {
            return 251.0
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
            let cell : cell_imgCatelog = tableView.dequeueReusableCell(withIdentifier: "id_cell_imgCatelog") as! cell_imgCatelog
            cell.svMain.delegate = self
            cell.svMain.backgroundColor = UIColor.white
            
            
            for i in 0..<self.arrGarmentImgList.count{
                if let isImgView = cell.svMain.viewWithTag(100+i){
                    if isImgView.isKind(of: UIImageView.self){
                        isImgView.removeFromSuperview()
                    }
                }
            }
            
            cell.btnEditPhoto.addTarget(self, action: #selector(self.editGarmentPhoto), for: UIControlEvents.touchUpInside)
            
            
            cell.svMain.contentSize.width = CGFloat(Float(self.tblView.frame.size.width) * Float(self.arrGarmentImgList.count))
            cell.pcImage.numberOfPages = self.arrGarmentImgList.count
            cell.pcImage.currentPage = intCurrentPage
            
            var floatX : CGFloat = 0.0
            for i in 0..<self.arrGarmentImgList.count{
                let imgCatelogue = UIImageView()
                imgCatelogue.frame = CGRect(x: floatX, y: 0, width: self.tblView.frame.size.width, height: 251)
                //                imgCatelogue.image = UIImage(named: "\(i+1).jpg")
                let dictGDetails = self.arrGarmentImgList.object(at: i) as! NSDictionary
                imgCatelogue.setImageWith(NSURL(string: dictGDetails.value(forKey: "MediumImage") as! String)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
                imgCatelogue.tag = 100 + i
                imgCatelogue.contentMode = UIViewContentMode.scaleAspectFit
                cell.svMain.addSubview(imgCatelogue)
                floatX = floatX + self.tblView.frame.size.width
            }
            
            cell.pcImage.backgroundColor = UIColor.clear
            cell.pcImage.transform = CGAffineTransform(scaleX: 2, y: 2)
            cell.pcImage.tintColor = UIColor.lightGray
            cell.pcImage.pageIndicatorTintColor = UIColor.gray
            cell.pcImage.currentPageIndicatorTintColor = CONSTANT.color_App.color_CM
            cell.pcImage.setNeedsDisplay()
            cell.pcImage.tag = 3343
            
            let X : CGFloat = CGFloat(cell.pcImage.currentPage) * self.tblView.frame.size.width
            cell.svMain.setContentOffset(CGPoint(x:X, y:0), animated: false)
            return cell
        }else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3{
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
        }else{
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
        let objGarmentBasicInfoEdit_Images = GarmentBasicInfoEdit_Images(nibName: "GarmentBasicInfoEdit_Images", bundle: nil)
        objGarmentBasicInfoEdit_Images.dictGarmentInfo = NSMutableDictionary(dictionary: self.dictGarmentDetailsNew)
        self.navigationController?.pushViewController(objGarmentBasicInfoEdit_Images, animated: true)

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
//            dictGarmentDetailsNew["GarmentName"] = textField.text
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

