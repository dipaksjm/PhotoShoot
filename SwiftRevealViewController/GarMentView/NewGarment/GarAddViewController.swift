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




class GarAddViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource  {
    
    @IBOutlet weak var tblView : UITableView!
    var appdel =  AppDelegate()
    var imagePicker = UIImagePickerController()
    @IBOutlet var pvComman: UIPickerView! = UIPickerView()

    var dicvalue = NSMutableDictionary()
    var strCatalogueId  = String()
    var arrGarmentImgList = NSMutableArray()
    
    var arrClientList = NSMutableArray()


    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appdel =  UIApplication.shared.delegate as! AppDelegate
        self.appdel.dictAddNewGarment.removeAllObjects()
        
        let nib = UINib(nibName: "Cell_CataImageUpload", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "Cell_CataImageUpload")
        
        let nib1 = UINib(nibName: "Cell_ModelME", bundle: nil)
        tblView.register(nib1, forCellReuseIdentifier: "Cell_ModelME")
        
        let nibCell_AddessModel = UINib(nibName: "Cell_AddessModel", bundle: nil)
        self.tblView.register(nibCell_AddessModel, forCellReuseIdentifier: "Cell_AddessModel")
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        
        dicvalue.setValue("", forKey: "GarmentName");
        dicvalue.setValue("", forKey: "GarmentTitle");
        dicvalue.setValue("", forKey: "Description");
        dicvalue.setValue("", forKey: "UniqCode");
        dicvalue.setValue("", forKey: "CoverImage");
        dicvalue.setValue("", forKey: "ClientName");
        dicvalue.setValue("", forKey: "ClientIndex");
        dicvalue.setValue(strCatalogueId, forKey: "CatalogueId");
        
        print("viewDidLoad : \(dicvalue)")
        
        
        self.appdel.dictAddNewGarment.setValue("", forKey: "GarmentName");
        self.appdel.dictAddNewGarment.setValue("", forKey: "GarmentTitle");
        self.appdel.dictAddNewGarment.setValue("", forKey: "Description");
        self.appdel.dictAddNewGarment.setValue("", forKey: "UniqCode");
        self.appdel.dictAddNewGarment.setValue("", forKey: "CoverImage");
        self.appdel.dictAddNewGarment.setValue("", forKey: "CatalogueId");
        self.appdel.dictAddNewGarment.setValue("", forKey: "ClientIndex");
        self.appdel.dictAddNewGarment.setValue("", forKey: "ClientId");
        self.appdel.dictAddNewGarment.setValue("", forKey: "CreatedBy");
        self.appdel.dictAddNewGarment.setValue("", forKey: "CreatedDate");
        self.appdel.strCurrentClass = CONSTANT.className.AddNewGarment
        
        
        
        if self.appdel.strRollID == "2"{
            self.getClientList()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        dicvalue.setValue(self.appdel.dictAddNewGarment.value(forKey: "GarmentName") as! String, forKey: "GarmentName");
        dicvalue.setValue(self.appdel.dictAddNewGarment.value(forKey: "GarmentTitle") as! String, forKey: "GarmentTitle");
        dicvalue.setValue(self.appdel.dictAddNewGarment.value(forKey: "Description") as! String, forKey: "Description");
        dicvalue.setValue(self.appdel.dictAddNewGarment.value(forKey: "UniqCode") as! String, forKey: "UniqCode");
        dicvalue.setValue(self.appdel.dictAddNewGarment.value(forKey: "CoverImage") as! String, forKey: "CoverImage");
        dicvalue.setValue(self.appdel.dictAddNewGarment.value(forKey: "CatalogueId") as! String, forKey: "CatalogueId");
        if self.appdel.strRollID == "2"{
            dicvalue.setValue(self.appdel.dictAddNewGarment.value(forKey: "ClientIndex") as! String, forKey: "ClientIndex");
        }
        dicvalue.setValue(self.appdel.dictAddNewGarment.value(forKey: "ClientId") as! String, forKey: "ClientId");
        dicvalue.setValue(self.appdel.dictAddNewGarment.value(forKey: "CreatedBy") as! String, forKey: "CreatedBy");
        dicvalue.setValue(self.appdel.dictAddNewGarment.value(forKey: "CreatedDate") as! String, forKey: "CreatedDate");
        
        print("viewWillAppear : \(dicvalue)")

        self.tblView.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
        self.appdel.strCurrentClass = ""
    }
    // MARK: -

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
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let fileManager = FileManager.default
        
        let imgName = "\(self.appdel.generateTimeStamp()).jpg"
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imgName)
        print(paths)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        dicvalue.setValue(paths, forKey: "CoverImage")
        dismiss(animated: true, completion: nil)
        
        let indexPath = NSIndexPath(row: 0, section: 0)
        print("indexPath:\(indexPath)")
        self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
    }
    
    
    // MARK: -
    
    
    @IBAction func action_Done(_ sender: Any){
        self.view.endEditing(true)
        print("dicvalue:\(dicvalue)")

        if dicvalue["GarmentName"] as? String == ""{
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Name)
        }else if  dicvalue["GarmentTitle"] as? String == ""{
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Title)
        }else if  dicvalue["UniqCode"] as? String == ""{
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Unicode)
        }else{
            if self.appdel.strRollID == "2" && dicvalue["ClientIndex"] as? String == "" {
                self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.PleaseSelectClient)
            }else{
                
                if self.isUnicodeAvailable() == "yes"{
                    print("all ok")
                    

                    
                    let objGarAddViewController2 = GarAddViewController2(nibName: "GarAddViewController2", bundle: nil)
                    self.appdel.dictAddNewGarment.setValue(dicvalue.value(forKey: "GarmentName"), forKey: "GarmentName")
                    self.appdel.dictAddNewGarment.setValue(dicvalue.value(forKey: "GarmentTitle"), forKey: "GarmentTitle")
                    self.appdel.dictAddNewGarment.setValue(dicvalue.value(forKey: "Description"), forKey: "Description")
                    self.appdel.dictAddNewGarment.setValue(dicvalue.value(forKey: "UniqCode"), forKey: "UniqCode")
                    self.appdel.dictAddNewGarment.setValue(dicvalue.value(forKey: "CoverImage"), forKey: "CoverImage")
                    self.appdel.dictAddNewGarment.setValue(self.appdel.strClientAdminId, forKey: "ClientAdminId")
                    if self.appdel.strRollID == "2"{
                        let strSelectedClient = (self.arrClientList.object(at: Int(dicvalue["ClientIndex"] as! String)!) as! NSDictionary).value(forKey: "ClientId") as! String
                        self.appdel.dictAddNewGarment.setValue(strSelectedClient, forKey: "ClientId")
                        self.appdel.dictAddNewGarment.setValue(dicvalue["ClientIndex"] as! String, forKey: "ClientIndex")
                    }else{
                        self.appdel.dictAddNewGarment.setValue(self.appdel.strClientId, forKey: "ClientId")
                    }
                    self.appdel.dictAddNewGarment.setValue(self.appdel.strClientId, forKey: "CreatedBy")
                    self.appdel.dictAddNewGarment.setValue("", forKey: "CreatedDate")
                    self.appdel.dictAddNewGarment.setValue(self.strCatalogueId, forKey: "CatalogueId")
                    
                    print("self.appdel.dictAddNewGarment q:\(self.appdel.dictAddNewGarment)")

                    self.navigationController?.pushViewController(objGarAddViewController2, animated: true)

                }else{
                    self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.UnicodeShouldBeUnique)
                }
            }
        }
        print("dicvalue2:\(dicvalue)")
    }
    
    func isUnicodeAvailable()-> String {
        print("completeLoadAction...")
        
        var strIsAvailable = "no"

        let strUrl = String(format: "%@?UniqueCode=%@", CONSTANT.service_URL.CheckUnicode,dicvalue.value(forKey: "UniqCode") as! String)

        let request = URLRequest(url: NSURL(string: strUrl)! as URL)
        do {
           let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
           let data = try NSURLConnection.sendSynchronousRequest(request, returning: response)
            do {
                let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                let dictResp = jsonSerialized! as NSDictionary

                if dictResp.value(forKey: "IsAvailable") as! Bool == false{
                    strIsAvailable = "yes"
                }else{
                    strIsAvailable = "no"
                }

            }catch let error as NSError {
                print("2nd : \(error)")
            }
        }catch let error as NSError {
            print("1st : \(error)")
        }
        return strIsAvailable
    }
   
    
    func testSync(){
        print("testSync...")
        
        
        
        /*
        manager.post(CONSTANT.service_URL.CheckUnicode, parameters: parameters, success: {
            requestOperation, response in
            //                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
            
            do {
                let dictResult =  try JSONSerialization.jsonObject(with: (response as! NSData) as Data, options: []) as! NSDictionary
                
                print("dictResult : \(dictResult)")
                
                if dictResult.value(forKey: "IsAvailable") as! Bool == false{
                    strIsAvailable = "yes"
                }else{
                    strIsAvailable = "no"
                }
                
            } catch let error as NSError {
                print(error)
                self.appdel.showMBProgressHUD_short(strMsg: CONSTANT.AlretMessage.Tryagain)
            }
        },failure:{
            requestOperation, error in
            print("error is : \(error)")
            self.appdel.hideMBProgressHUD()
        })
        
        */
    }
    
    
    
    func getClientList(){
        print("getClientList...")
        
        
        self.appdel.showMBProgressHUD()
        
        let strUrl = String(format: "%@?ClientAdminId=%@", CONSTANT.service_URL.GetClientList,self.appdel.strClientAdminId)
        print("strUrl : \(strUrl)")
        
        
        Alamofire.request(strUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            self.appdel.hideMBProgressHUD()
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil
                {
                    let dictResp = response.result.value as! NSDictionary
                    print("dictResp :\(dictResp)")
                    self.arrClientList = NSMutableArray(array:dictResp.value(forKey: "LstClient") as! NSArray)
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.appdel.hideMBProgressHUD()
                self.appdel.alertValidation(strMessage: response.result.error!.localizedDescription)
                break
            }
        }
        self.tblView.reloadData()
    }
    
    // MARK: -
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 250
            }else{
                return 44
            }
        }else{
                return 100
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var intRowCount = 0
        if section == 0{
            intRowCount =  4
            if self.appdel.strRollID == "2"{
                intRowCount =  5
            }
        }else{
             intRowCount = 1
        }
        return intRowCount

    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if indexPath.section == 0{
            if indexPath.row == 0{
                let cell : Cell_CataImageUpload = tableView.dequeueReusableCell(withIdentifier: "Cell_CataImageUpload") as! Cell_CataImageUpload
                let stringImg = dicvalue.value(forKey: "CoverImage") as! String
                if stringImg == "" ||  stringImg.isEmpty{
                    cell.imgView_catalogue.image = UIImage(named:"placeholderAddImages.png")
                }else{
                    cell.imgView_catalogue.image = UIImage(contentsOfFile: (dicvalue.value(forKey: "CoverImage") as? String)!)
                }
                return cell
            }else{
                
                let cell : Cell_ModelME = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelME") as! Cell_ModelME
                cell.txtField.delegate = self
                cell.txtField.tag = indexPath.row
                
                if indexPath.row == 1{
                    cell.lblName.text = "NAME"
                    cell.txtField.text = self.dicvalue.value(forKey: "GarmentName") as? String
                    cell.txtField.keyboardType = .default
                }else if indexPath.row == 2{
                    cell.lblName.text = "TITLE"
                    cell.txtField.text = self.dicvalue.value(forKey: "GarmentTitle") as? String
                    cell.txtField.keyboardType = .default
                }else if indexPath.row == 3{
                    cell.lblName.text = "UNICODE"
                    cell.txtField.text = self.dicvalue.value(forKey: "UniqCode") as? String
                    cell.txtField.keyboardType = .numberPad
                }else if indexPath.row == 4{
                    cell.lblName.text = "CLIENT"
                    
//                    if (self.dicvalue.value(forKey: "ClientIndex") as? String)!.count > 0{
//                        let intIndex = Int((self.dicvalue.value(forKey: "ClientIndex") as? String)!)
//                        let strFName = (self.arrClientList.object(at: intIndex!) as? NSDictionary)?.value(forKey: "FirstName") as! String
//                        let strLName = (self.arrClientList.object(at: intIndex!) as? NSDictionary)?.value(forKey: "LastName") as! String
//                        cell.txtField.text = "\(strFName) \(strLName)"
//                    }else{
//                        cell.txtField.text = ""
//                    }
                    
                    cell.txtField.text = self.dicvalue.value(forKey: "ClientName") as? String

                    self.pvComman.tag = 2
                    self.pvComman.delegate = self
                    self.pvComman.dataSource = self
                    cell.txtField.inputView = nil
                    cell.txtField.inputView = self.pvComman
                }
                

                return cell
            }
        }else{
            let cell : Cell_AddessModel = tableView.dequeueReusableCell(withIdentifier: "Cell_AddessModel") as! Cell_AddessModel
            cell.lblTitle.text = "DESCRIPTION"
            cell.txtaddress.text = self.dicvalue.value(forKey: "Description") as? String
            cell.txtaddress.tag = indexPath.row
            cell.txtaddress.delegate = self
            return cell

        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if (indexPath.row == 0 && indexPath.section == 0){
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
    }
    
    
    // MARK: -
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrClientList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let strFName = (self.arrClientList.object(at: row) as? NSDictionary)?.value(forKey: "FirstName") as! String
        let strLName = (self.arrClientList.object(at: row) as? NSDictionary)?.value(forKey: "LastName") as! String
        
        return "\(strFName) \(strLName)"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        //        let strFName = (self.arrClientList.object(at: row) as? NSDictionary)?.value(forKey: "FirstName") as! String
        //        let strLName = (self.arrClientList.object(at: row) as? NSDictionary)?.value(forKey: "LastName") as! String
        //        let strClientId = (self.arrClientList.object(at: row) as? NSDictionary)?.value(forKey: "ClientId") as! String
        //
        //        self.dicvalue.setValue("\(strFName) \(strLName)", forKey: "ClientName")
        self.dicvalue.setValue("\(row)", forKey: "ClientIndex")
        
        //        let indexPath = NSIndexPath(row: 4, section: 0)
        //        print("indexPath:\(indexPath)")
        //        self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
        
    }
    
    
    // MARK: -
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if textField.tag == 1 {
            dicvalue["GarmentName"] = textField.text
        }else if textField.tag == 2 {
            dicvalue["GarmentTitle"] = textField.text
        }else if textField.tag == 3 {
            dicvalue["UniqCode"] = textField.text
        }else if textField.tag == 4 {
          let intIndex = Int((self.dicvalue.value(forKey: "ClientIndex") as? String)!)
            
            if (self.dicvalue.value(forKey: "ClientIndex") as? String != ""){
                let strFName = (self.arrClientList.object(at: intIndex!) as? NSDictionary)?.value(forKey: "FirstName") as! String
                let strLName = (self.arrClientList.object(at: intIndex!) as? NSDictionary)?.value(forKey: "LastName") as! String
                dicvalue["ClientName"] = "\(strFName) \(strLName)"
                let indexPath = NSIndexPath(row: 4, section: 0)
                self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
            }
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
    
    // MARK: -
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        self.dicvalue.setValue(textView.text, forKey: "Description")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        return true
    }
    
    
 
    
}

