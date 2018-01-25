//
//  ModelViewController.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 11/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ModelViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    var arrModelDetail = NSMutableArray()
    var appdel =  AppDelegate()
    var arrModelImages = NSMutableArray()
    var arrComplexList = NSMutableArray()
    @IBOutlet var pvComman: UIPickerView! = UIPickerView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("arrModelDetail:\(arrModelDetail)")
        appdel =  UIApplication.shared.delegate as! AppDelegate
        
        let dic  = self.arrModelDetail.object(at: 0) as! NSDictionary
        let arrdic  =  NSMutableArray(array: (dic.value(forKey: "LstModelImages") as? NSArray)!)
        
        for i in 0..<arrdic.count
        {
            let dictMain : NSMutableDictionary = [:]
            let dic  = arrdic.object(at: i ) as! NSDictionary
            let strMediumImage = dic.value(forKey: "MediumImage") as? String
            dictMain.setValue(strMediumImage, forKey: "FullImage")
            dictMain.setValue(false, forKey: "isManual")
            dictMain.setValue(false, forKey: "isSelect")
            
            arrModelImages.add(dictMain)
            
        }
        print("arrModelImages :\(arrModelImages)")
        
        let dicMut  =  NSMutableDictionary(dictionary: (self.arrModelDetail.object(at: 0) as! NSDictionary))
        dicMut.setValue(arrModelImages, forKey: "LstModelImages")
        self.arrModelDetail.replaceObject(at: 0, with: dic)

        
        let nib = UINib(nibName: "cell_CatelogueName", bundle: nil)
        self.tblView.register(nib, forCellReuseIdentifier: "id_cell_CatelogueName")
        
        let nib1 = UINib(nibName: "Cell_ModelHeader", bundle: nil)
        self.tblView.register(nib1, forCellReuseIdentifier: "Cell_ModelHeader")
        
        let nibCell_ModelDetails = UINib(nibName: "Cell_ModelDetails", bundle: nil)
        self.tblView.register(nibCell_ModelDetails, forCellReuseIdentifier: "Cell_ModelDetails")
        
        let nibCell_AddessModel = UINib(nibName: "Cell_AddessModel", bundle: nil)
        self.tblView.register(nibCell_AddessModel, forCellReuseIdentifier: "Cell_AddessModel")
        
        let nibCell_ModelME = UINib(nibName: "Cell_ModelME", bundle: nil)
        self.tblView.register(nibCell_ModelME, forCellReuseIdentifier: "Cell_ModelME")
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("arrModelDetail:\(arrModelDetail)")
        
        
        arrComplexList.add("White")
        arrComplexList.add("Dark")
        arrComplexList.add("Brown")
        arrComplexList.add("Medium")
        arrComplexList.add("Fair")
        arrComplexList.add("Olive")

        tblView.reloadData()

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

    @IBAction func action_Back(_ sender: Any){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func action_Done(_ sender: Any)
    {
        self.view.endEditing(true)
        
        let dictMain : NSMutableDictionary = [:]
        dictMain.setValue(self.setModelDetails(), forKey: "objModelMaster")
        print("dictMain:\(dictMain)")
            
        appdel.showMBProgressHUD()
            
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.timeoutInterval = 60
        manager.post(CONSTANT.service_URL.AddModel, parameters: dictMain, success: {
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
    
    func setModelDetails()->NSMutableDictionary{
        
        
        let dic  = self.arrModelDetail.object(at: 0) as! NSDictionary
        
        let dictMain : NSMutableDictionary = [:]
        
        dictMain.setValue(dic.value(forKey: "Address") as! String, forKey: "Address")
        dictMain.setValue(dic.value(forKey: "Age") as! String, forKey: "Age")
        dictMain.setValue(dic.value(forKey: "City") as! String, forKey: "City")
        dictMain.setValue(appdel.strClientAdminId, forKey: "ClientAdminId")
        dictMain.setValue(appdel.strClientId, forKey: "ClientId")
        dictMain.setValue(dic.value(forKey: "Complex") as! String, forKey: "Complex")

        
        let dichm  = self.arrModelDetail.object(at: 0) as! NSDictionary
        let arrdic  = dichm.value(forKey: "LstModelImages") as! NSArray
            if arrdic.count > 0
            {
                let dic1  = arrdic.object(at: 0) as! NSDictionary
                if dic1.value(forKey: "isManual") as? Bool ==  true{
                    let strcoverImage = dic1.value(forKey: "FullImage") as? String
                    let theFileName = (strcoverImage! as NSString).lastPathComponent
                    let newcoverImage = "/UploadedImage/GarmentModel/\(theFileName)"
                    dictMain.setValue(newcoverImage, forKey: "CoverImage")
                    
            }
            else{
                    let strcoverImage = dic1.value(forKey: "FullImage") as? String
                    let newcoverImage = strcoverImage?.replacingOccurrences(of: "http://162.241.243.214:421/", with: "", options: .literal, range: nil)
                    print("newcoverImage :\(String(describing: newcoverImage))")
                    dictMain.setValue(newcoverImage, forKey: "CoverImage")

            }
        }
        
        dictMain.setValue(dic.value(forKey: "Email") as! String, forKey: "Email")
        dictMain.setValue(dic.value(forKey: "Height") as! String, forKey: "Height")
        dictMain.setValue("true", forKey: "IsActive")
        dictMain.setValue(dic.value(forKey: "MobileNo") as! String, forKey: "MobileNo")
        dictMain.setValue(dic.value(forKey: "ModelId") as! String, forKey: "ModelId")
        dictMain.setValue(dic.value(forKey: "State") as! String, forKey: "State")
        dictMain.setValue(dic.value(forKey: "Width") as! String, forKey: "Width")
        dictMain.setValue(self.setModelImagesDetails(), forKey: "LstModelImages")
        dictMain.setValue(dic.value(forKey: "Name") as! String, forKey: "Name")


        print("dictMain :\(dictMain)")

        return dictMain
        
    }
    
    func setModelImagesDetails()->NSMutableArray{
        
        let arrDetails = NSMutableArray()

        let dic  = self.arrModelDetail.object(at: 0) as! NSDictionary
        let arrdic  = dic.value(forKey: "LstModelImages") as! NSArray
        
        for i in 0..<arrdic.count
        {
            let dictMain : NSMutableDictionary = [:]
            let dic  = arrdic.object(at: i ) as! NSDictionary
            if dic.value(forKey: "isManual") as? Bool ==  true
            {
                let strcoverImage = dic.value(forKey: "FullImage") as? String
                let theFileName = (strcoverImage! as NSString).lastPathComponent
                let newcoverImage = "/UploadedImage/GarmentModel/\(theFileName)"
                dictMain.setValue(newcoverImage, forKey: "FullImage")
                dictMain.setValue("true", forKey: "IsEditModelImage")
                dictMain.setValue("", forKey: "OldImage")

            }
            else{
                let strFullImage = dic.value(forKey: "FullImage") as? String
                let newFullImage = strFullImage?.replacingOccurrences(of: "http://162.241.243.214:421/", with: "", options: .literal, range: nil)
                print("newFullImage :\(String(describing: newFullImage))")
                dictMain.setValue(newFullImage, forKey: "FullImage")
                dictMain.setValue("false", forKey: "IsEditModelImage")
                
                let strOldImage = dic.value(forKey: "OldImage") as? String
                let theFileNameold = (strOldImage! as NSString).lastPathComponent
                let newOldImage = "/UploadedImage/GarmentModel/\(theFileNameold)"
                dictMain.setValue(newOldImage, forKey: "OldImage")

            }
            arrDetails.add(dictMain)

        }
        print("arrDetails :\(arrDetails)")

        return arrDetails
        
    }
    
    
    func editModelImage(){
        print("editModelImage...")
        let objImageAddEditViewController = ImageAddEditViewController(nibName: "ImageAddEditViewController", bundle: nil)
        objImageAddEditViewController.arrModelDetail =  arrModelDetail
        self.navigationController?.pushViewController(objImageAddEditViewController, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -
    // MARK: UITableView Method
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        print("heightForRowAt...")
        if indexPath.row == 0
        {
            return 317
        }
        else if indexPath.row == 1
        {
             return 45
        }
        else if indexPath.row == 2 || indexPath.row == 3
        {
            return 44
        }
        else if indexPath.row == 4
        {
            return 89
        }
        return 100
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 6
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell : Cell_ModelHeader = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelHeader") as! Cell_ModelHeader
            
            let rowint = indexPath.row
            
            cell.btnHeaderEdit.addTarget(self, action: #selector(self.editModelImage), for: UIControlEvents.touchUpInside)
            

            let dic  = self.arrModelDetail.object(at: rowint) as! NSDictionary
            let arrdic  = dic.value(forKey: "LstModelImages") as? NSArray

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
        if indexPath.row == 1{
            
            let rowint = indexPath.row - 1
            
            let cell : cell_CatelogueName = tableView.dequeueReusableCell(withIdentifier: "id_cell_CatelogueName") as! cell_CatelogueName
            cell.txtTitle.placeholder = "NAME THE MODEL"
            let dic  = self.arrModelDetail.object(at: rowint) as! NSDictionary
            cell.txtTitle.text = dic.value(forKey: "Name") as? String
            return cell
        }
        if indexPath.row == 2{
            
            let rowint = indexPath.row - 2
            
            let cell : Cell_ModelME = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelME") as! Cell_ModelME
            cell.lblName.text = "MOBILE"
            let dic  = self.arrModelDetail.object(at: rowint) as! NSDictionary
            cell.txtField.text = dic.value(forKey: "MobileNo") as? String
            cell.txtField.tag =  1
            cell.txtField.keyboardType = .numberPad


            return cell
        }
        if indexPath.row == 3{
            
            let rowint = indexPath.row - 3
            
            let cell : Cell_ModelME = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelME") as! Cell_ModelME
            cell.lblName.text = "EMAIL"
            let dic  = self.arrModelDetail.object(at: rowint) as! NSDictionary
            cell.txtField.text = dic.value(forKey: "Email") as? String
            cell.txtField.tag =  2
            cell.txtField.keyboardType = .emailAddress

            return cell
            
        }
        if indexPath.row == 4{
            
             let rowint = indexPath.row - 4
            
             let cell : Cell_ModelDetails = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelDetails") as! Cell_ModelDetails
             let dic  = self.arrModelDetail.object(at: rowint) as! NSDictionary
            
            self.pvComman.delegate = self
             cell.txtComplex.inputView = self.pvComman
            
             cell.txtComplex.text = dic.value(forKey: "Complex") as? String
             cell.txtWeight.text = dic.value(forKey: "Width") as? String
             cell.txtHeight.text = dic.value(forKey: "Height") as? String
            cell.txtAge.text = dic.value(forKey: "Age") as? String
            
            cell.txtAge.keyboardType = .numberPad
            cell.txtHeight.keyboardType = .numberPad
            cell.txtWeight.keyboardType = .numberPad

            cell.txtHeight.delegate = self
            cell.txtAge.delegate = self
            cell.txtWeight.delegate = self

            cell.txtHeight.tag = 3
            cell.txtAge.tag = 4
            cell.txtWeight.tag = 5
            
            return cell
        }
        let rowint = indexPath.row - 5
        let cell : Cell_AddessModel = tableView.dequeueReusableCell(withIdentifier: "Cell_AddessModel") as! Cell_AddessModel
        let dic  = self.arrModelDetail.object(at: rowint) as! NSDictionary
        cell.txtaddress.text = dic.value(forKey: "Address") as? String
        cell.txtaddress.delegate = self
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
        let dic  = NSMutableDictionary(dictionary: self.arrModelDetail.object(at: 0) as! NSDictionary)
        if textField.tag == 1 {
            dic.setValue(textField.text, forKey:"MobileNo")
        }
        if textField.tag == 2 {
            dic.setValue(textField.text, forKey:"Email")
        }
        if textField.tag == 3 {
            dic.setValue(textField.text, forKey:"Height")
        }
        if textField.tag == 4 {
            dic.setValue(textField.text, forKey:"Age")
        }
        if textField.tag == 5 {
            dic.setValue(textField.text, forKey:"Width")
        }
        if textField.tag == 6 {
            dic.setValue(textField.text, forKey:"Complex")
        }
        
        self.arrModelDetail.replaceObject(at: 0, with: dic)

        print("dic :\(self.arrModelDetail.object(at: 0) as! NSDictionary)")
        
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
        let dic  = NSMutableDictionary(dictionary: self.arrModelDetail.object(at: 0) as! NSDictionary)
        dic.setValue(textView.text, forKey:"Address")
        self.arrModelDetail.replaceObject(at: 0, with: dic)

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        return true
    }
    
    
    // MARK: -
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrComplexList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let strReturnString = self.arrComplexList.object(at: row) as? String
        return strReturnString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let dic  = NSMutableDictionary(dictionary: self.arrModelDetail.object(at: 0) as! NSDictionary)
        let strReturnString = self.arrComplexList.object(at: row) as? String
        dic.setValue(strReturnString, forKey:"Complex")
        self.arrModelDetail.replaceObject(at: 0, with: dic)
        print("dic :\(self.arrModelDetail.object(at: 0) as! NSDictionary)")
        
        
        let indexPath = NSIndexPath(row: 4, section: 0)
        print("indexPath:\(indexPath)")
        self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
        
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
