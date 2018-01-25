//
//  CataAddViewController.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 20/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD


class CataAddViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    @IBOutlet weak var tblView : UITableView!
    var appdel =  AppDelegate()
    var dicvalue = NSMutableDictionary()
    var arrStatusList = NSMutableArray()
    var arrClientList = NSMutableArray()

    var dicEditDetails = NSMutableDictionary()
    var isedit = Bool()

    
    
    @IBOutlet var pvComman: UIPickerView! = UIPickerView()
    @IBOutlet var dpComman: UIDatePicker! = UIDatePicker()
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        appdel =  UIApplication.shared.delegate as! AppDelegate
        
        let nib = UINib(nibName: "Cell_CataImageUpload", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "Cell_CataImageUpload")
        
        let nib1 = UINib(nibName: "Cell_ModelME", bundle: nil)
        tblView.register(nib1, forCellReuseIdentifier: "Cell_ModelME")
        
        let nibCell_AddessModel = UINib(nibName: "Cell_AddessModel", bundle: nil)
        self.tblView.register(nibCell_AddessModel, forCellReuseIdentifier: "Cell_AddessModel")
        // Do any additional setup after loading the view.
        
        if isedit == false
        {
            if appdel.strClientId == "" || appdel.strClientId.isEmpty
            {
                dicvalue.setValue("", forKey: "ClientId");
                dicvalue.setValue("", forKey: "ClientName");
            }
            else
            {
                dicvalue.setValue(appdel.strClientId, forKey: "ClientId");
                dicvalue.setValue("", forKey: "ClientName");
            }
        }
        else
        {
            dicvalue.setValue(dicEditDetails.object(forKey: "ClientId") as! String, forKey: "ClientId");
            dicvalue.setValue(dicEditDetails.object(forKey: "ClientName") as! String, forKey: "ClientName");
        }
        
        if isedit == false
        {
            dicvalue.setValue("", forKey: "CatalogueName");
            dicvalue.setValue("", forKey: "CatalogueId");
            dicvalue.setValue("", forKey: "CatalogueTitle");
            dicvalue.setValue("", forKey: "Description");
            dicvalue.setValue("", forKey: "LaunchDate");
            dicvalue.setValue("", forKey: "Status");
            dicvalue.setValue("", forKey: "StatusId");
            dicvalue.setValue("", forKey: "StatusComment");
            dicvalue.setValue("", forKey: "CatalogueImage");
        }
        else
        {
            dicvalue.setValue(dicEditDetails.object(forKey: "CatalogueName") as! String, forKey: "CatalogueName");
            dicvalue.setValue(dicEditDetails.object(forKey: "CatalogueId") as! String, forKey: "CatalogueId");
            dicvalue.setValue(dicEditDetails.object(forKey: "CatalogueTitle") as! String, forKey: "CatalogueTitle");
            dicvalue.setValue(dicEditDetails.object(forKey: "Description") as! String, forKey: "Description");
            dicvalue.setValue(dicEditDetails.object(forKey: "LaunchDate") as! String, forKey: "LaunchDate");
            
            let arr = dicEditDetails.object(forKey: "LstCatalogueStatusLists") as! NSArray
            if arr.count > 0
            {
                let dic  = arr.object(at: 0) as! NSDictionary
                dicvalue.setValue(dic.object(forKey: "StatusText") as! String, forKey: "Status");
                dicvalue.setValue(dic.object(forKey: "Status") as! String, forKey: "StatusId");
                dicvalue.setValue(dic.object(forKey: "Comments") as! String, forKey: "StatusComment");
            }
            dicvalue.setValue(dicEditDetails.object(forKey: "CatalogueImage") as! String, forKey: "CatalogueImage");
        }
        
        self.callGetStatusList()
        self.callGetClientListByclientAdminId()
        
        self.imagePicker.delegate = self

    }

    // MARK: -
    // MARK: WebService Call
  //    http://162.241.243.214:422/PhotoShoot.svc/GetClientListByclientAdminId?ClientAdminId=ff197e34-8f8c-4587-a401-221e3449e611
    
    func callGetClientListByclientAdminId(){
        print("callGetClientListByclientAdminId...")
        
        let strUrl = String(format: "%@?clientAdminId=%@", CONSTANT.service_URL.GetClientListByclientAdminId,self.appdel.strClientAdminId)
        
        print(strUrl)
        
        Alamofire.request(strUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil
                {
                    let jsonObject = response.result.value as! NSDictionary
                    print(jsonObject)
                    
                    if jsonObject["IsError"] as! Bool == false
                    {
                        self.arrClientList = NSMutableArray(array: jsonObject["LstClient"] as! NSArray)
                    }
                    else
                    {
                        self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.noData)
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                self.appdel.alertValidation(strMessage: response.result.error!.localizedDescription)
                break
            }
        }
    }
    
    
    func callGetStatusList(){
        print("callGetStatusList...")
        
        let strUrl = String(format: "%@?clientAdminId=%@", CONSTANT.service_URL.GetStatusList,self.appdel.strClientAdminId)
        
        print(strUrl)
        
        Alamofire.request(strUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil
                {
                    let jsonObject = response.result.value as! NSDictionary
                    print(jsonObject)
                    
                    if jsonObject["IsError"] as! Bool == false
                    {
                        self.arrStatusList = NSMutableArray(array: jsonObject["LstStatusMaster"] as! NSArray)
                    }
                    else
                    {
                        self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.noData)
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
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
    // MARK: uibutton action
    
    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setCatalogDetails()->NSMutableDictionary{
        
        let dictMain : NSMutableDictionary = [:]
        dictMain.setValue(dicvalue.value(forKey: "CatalogueId") as? String, forKey: "CatalogueId")
        dictMain.setValue(dicvalue.value(forKey: "CatalogueName") as? String, forKey: "CatalogueName")
        dictMain.setValue(dicvalue.value(forKey: "CatalogueTitle") as? String, forKey: "CatalogueTitle")
        dictMain.setValue(dicvalue.value(forKey: "Description") as? String, forKey: "Description")
        dictMain.setValue(dicvalue.value(forKey: "LaunchDate") as? String, forKey: "LaunchDate")
        dictMain.setValue(dicvalue.value(forKey: "StatusId") as? String, forKey: "StatusId")
        dictMain.setValue(dicvalue.value(forKey: "StatusComment") as? String, forKey: "StatusComment")
        dictMain.setValue("false", forKey: "IsDeleted")

        let strcoverImage = dicvalue.value(forKey: "CatalogueImage") as? String
        let theFileName = (strcoverImage! as NSString).lastPathComponent
        let newcoverImage = "/UploadedImage/Catalogue/\(theFileName)"
        dictMain.setValue(newcoverImage, forKey: "CatalogueImage")
        
        dictMain.setValue("true", forKey: "IsActive")
        dictMain.setValue(appdel.strClientAdminId, forKey: "ClientAdminId")
        if appdel.strClientId == "" || appdel.strClientId.isEmpty
        {
            dictMain.setValue(dicvalue.value(forKey: "ClientId") as? String, forKey: "ClientId")
        }
        else
        {
            dictMain.setValue(appdel.strClientId, forKey: "ClientId")
        }
        
        
        dictMain.setValue(appdel.strClientAdminId, forKey: "CreatedBy")
        dictMain.setValue("", forKey: "LiveLink")
        dictMain.setValue("", forKey: "DownloadLink")
      
        print("dictMain :\(dictMain)")
        return dictMain
        
    }
    
    @IBAction func action_Done(_ sender: Any)
    {
        print("dicvalue:\(dicvalue)")
      
        self.view.endEditing(true)
        
        if dicvalue["CatalogueName"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Name)
        }
        else if  dicvalue["CatalogueTitle"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Title)
        }
        else if  dicvalue["Description"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Description)
        }
        else if  dicvalue["LaunchDate"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.LaunchDate)
        }
        else if  dicvalue["Status"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Status)
        }
        else if  dicvalue["StatusComment"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.StatusComment)
        }
        else {
        
            let dictMain : NSMutableDictionary = [:]
            dictMain.setValue(self.setCatalogDetails(), forKey: "obj")
            print("dictMain:\(dictMain)")
            
            appdel.showMBProgressHUD()
            
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
    
    @IBAction func action_DPValueChanged(sender:UIDatePicker){
        print("action_dpValueChanged...tag:\(sender.tag)")
        print("date is:\(sender.date)")
        
        let newDate = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        self.dicvalue.setValue(formatter.string(from: newDate), forKey: "LaunchDate")
        
        if appdel.strClientId == "" || appdel.strClientId.isEmpty
        {
            let indexPath = NSIndexPath(row: 5, section: 0)
            print("indexPath:\(indexPath)")
            self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
        }
        else
        {
            let indexPath = NSIndexPath(row: 4, section: 0)
            print("indexPath:\(indexPath)")
            self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
        }
    }
    
    // MARK: -
    // MARK: UITableView Method
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        print("heightForRowAt...")
        
        if appdel.strClientId == "" || appdel.strClientId.isEmpty
        {
            if indexPath.row == 0
            {
                return 250
            }
            
            else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 6
            {
                return 44
            }
            
            return 100
        }
        else
        {
            if indexPath.row == 0
            {
                return 250
            }
            else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5
            {
                return 44
            }
            
            return 100
        }
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if appdel.strClientId == "" || appdel.strClientId.isEmpty
        {
            return 8
        }
        return 7
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if appdel.strClientId == "" || appdel.strClientId.isEmpty
        {
            if indexPath.row == 0{
                
                let cell : Cell_CataImageUpload = tableView.dequeueReusableCell(withIdentifier: "Cell_CataImageUpload") as! Cell_CataImageUpload
                
                let stringImg = dicvalue.value(forKey: "CatalogueImage") as! String
                if stringImg == "" ||  stringImg.isEmpty
                {
                    cell.imgView_catalogue.image = UIImage(named:"placeholderAddImages.png")
                }
                else{
                    
                    let myURLString = dicvalue.value(forKey: "CatalogueImage") as? String
                    var _: URL?
                    if (myURLString?.lowercased().hasPrefix("http://"))! {
                        cell.imgView_catalogue.setImageWith(NSURL(string: dicvalue.value(forKey: "CatalogueImage") as! String)! as URL, placeholderImage: UIImage(named: "placeholderAddImages.png"))

                    }
                    else {
                        print("http: NO")
                        cell.imgView_catalogue.image = UIImage(contentsOfFile: (dicvalue.value(forKey: "CatalogueImage") as? String)!)

                    }
                    
                    
                    
                }
                return cell
            }
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 6
            {
                let rowint = indexPath.row - 1
                
                let cell : Cell_ModelME = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelME") as! Cell_ModelME
                
                 if indexPath.row == 1{
                    cell.lblName.text = "CLIENT"
                    cell.txtField.text = dicvalue.object(forKey: "ClientName") as! String?
                    self.pvComman.tag = 0
                    self.pvComman.delegate = self
                    cell.txtField.inputView = nil
                    cell.txtField.inputView = self.pvComman
                    
                }
                if indexPath.row == 2{
                    cell.lblName.text = "NAME"
                    cell.txtField.text = dicvalue.object(forKey: "CatalogueName") as! String?
                    cell.txtField.keyboardType = .default
                }
                if indexPath.row == 3{
                    cell.lblName.text = "TITLE"
                    cell.txtField.text = dicvalue.object(forKey: "CatalogueTitle") as! String?
                    cell.txtField.keyboardType = .default
                }
                if indexPath.row == 5{
                    cell.lblName.text = "LAUNCH DATE"
                    cell.txtField.text = dicvalue.object(forKey: "LaunchDate") as! String?
                    cell.txtField.keyboardType = .numberPad
                    cell.txtField.inputView = self.dpComman
                    
                }
                if indexPath.row == 6{
                    cell.lblName.text = "STATUS"
                    cell.txtField.text = dicvalue.object(forKey: "Status") as! String?
                    self.pvComman.tag = 5
                    self.pvComman.delegate = self
                    cell.txtField.inputView = nil
                    cell.txtField.inputView = self.pvComman
                }
                cell.txtField.tag =  rowint
                cell.txtField.delegate = self
                return cell
            }
            
            let cell : Cell_AddessModel = tableView.dequeueReusableCell(withIdentifier: "Cell_AddessModel") as! Cell_AddessModel
            if indexPath.row == 4
            {
                cell.lblTitle.text = "DESCRIPTION"
                cell.txtaddress.text = dicvalue.object(forKey: "Description") as! String?
            }
            if indexPath.row == 7
            {
                cell.lblTitle.text = "STATUS NOTE"
                cell.txtaddress.text = dicvalue.object(forKey: "StatusComment") as! String?
            }
            cell.txtaddress.tag = indexPath.row
            cell.txtaddress.delegate = self
            
            return cell
            
        }
        else
        {
            if indexPath.row == 0
            {
                let cell : Cell_CataImageUpload = tableView.dequeueReusableCell(withIdentifier: "Cell_CataImageUpload") as! Cell_CataImageUpload
                
                let stringImg = dicvalue.value(forKey: "CatalogueImage") as! String
                if stringImg == "" ||  stringImg.isEmpty
                {
                    cell.imgView_catalogue.image = UIImage(named:"placeholderAddImages.png")
                }
                else{
                    
                    let myURLString = dicvalue.value(forKey: "CatalogueImage") as? String
                    var _: URL?
                    if (myURLString?.lowercased().hasPrefix("http://"))! {
                        print("http:")
                        cell.imgView_catalogue.setImageWith(NSURL(string: dicvalue.value(forKey: "CatalogueImage") as! String)! as URL, placeholderImage: UIImage(named: "placeholderAddImages.png"))
                        
                    }
                    else {
                        cell.imgView_catalogue.image = UIImage(contentsOfFile: (dicvalue.value(forKey: "CatalogueImage") as? String)!)
                    }
                }
                
                return cell
            }
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5
            {
                let rowint = indexPath.row - 1
                
                let cell : Cell_ModelME = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelME") as! Cell_ModelME
                
                if indexPath.row == 1{
                    cell.lblName.text = "NAME"
                    cell.txtField.text = dicvalue.object(forKey: "CatalogueName") as! String?
                    cell.txtField.keyboardType = .default
                }
                if indexPath.row == 2{
                    cell.lblName.text = "TITLE"
                    cell.txtField.text = dicvalue.object(forKey: "CatalogueTitle") as! String?
                    cell.txtField.keyboardType = .default
                }
                if indexPath.row == 4{
                    cell.lblName.text = "LAUNCH DATE"
                    cell.txtField.text = dicvalue.object(forKey: "LaunchDate") as! String?
                    cell.txtField.keyboardType = .numberPad
                    cell.txtField.inputView = self.dpComman
                    
                }
                if indexPath.row == 5{
                    cell.lblName.text = "STATUS"
                    cell.txtField.text = dicvalue.object(forKey: "Status") as! String?
                    cell.txtField.keyboardType = .default
                    self.pvComman.delegate = self
                    self.pvComman.tag = 5
                    cell.txtField.inputView = self.pvComman
                }
                cell.txtField.tag =  rowint
                cell.txtField.delegate = self
                return cell
            }
            
            let cell : Cell_AddessModel = tableView.dequeueReusableCell(withIdentifier: "Cell_AddessModel") as! Cell_AddessModel
            
            
            if indexPath.row == 3
            {
                cell.lblTitle.text = "DESCRIPTION"
                cell.txtaddress.text = dicvalue.object(forKey: "Description") as! String?
            }
            if indexPath.row == 6
            {
                cell.lblTitle.text = "STATUS NOTE"
                cell.txtaddress.text = dicvalue.object(forKey: "StatusComment") as! String?
            }
            cell.txtaddress.tag = indexPath.row
            cell.txtaddress.delegate = self
            
            return cell
            
        }
       
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexPath.row == 0
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
    }
   
    // MARK: -
    // MARK: UIImagePickerController  didFinishPickingMediaWithInfo
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let fileManager = FileManager.default
        
        let imgName = "AddNewCata.jpg"
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imgName)
        print(paths)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        dicvalue.setValue(paths, forKey: "CatalogueImage")
    
        dismiss(animated: true, completion: nil)
        
        
        let indexPath = NSIndexPath(row: 0, section: 0)
        print("indexPath:\(indexPath)")
        self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
        
    }
    
    
    
    // MARK: -
    // MARK: UITextField methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing...\(textField.tag)")
        if appdel.strClientId == "" || appdel.strClientId.isEmpty
        {
            if textField.tag == 0 {
                self.pvComman.tag = 0
            }else if textField.tag == 5 {
                self.pvComman.tag = 5
            }
        }
        else
        {
            self.pvComman.tag = 5
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if appdel.strClientId == "" || appdel.strClientId.isEmpty
        {
            if textField.tag == 1 {
                dicvalue["CatalogueName"] = textField.text
            }
            if textField.tag == 2 {
                dicvalue["CatalogueTitle"] = textField.text
            }
            if textField.tag == 4 {
                dicvalue["Status"] = textField.text
            }
        }
        else
        {
            if textField.tag == 0 {
                dicvalue["CatalogueName"] = textField.text
            }
            if textField.tag == 1 {
                dicvalue["CatalogueTitle"] = textField.text
            }
            if textField.tag == 3 {
                dicvalue["Status"] = textField.text
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
    
    // MARK: - TextView
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if appdel.strClientId == "" || appdel.strClientId.isEmpty
        {
            if textView.tag == 4
            {
                dicvalue["Description"] = textView.text
            }
            else{
                dicvalue["StatusComment"] = textView.text
            }
        }
        else
        {
            if textView.tag == 3
            {
                dicvalue["Description"] = textView.text
            }
            else{
                dicvalue["StatusComment"] = textView.text
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        return true
    }
    
    // MARK: -
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pvComman.tag == 5{
          return self.arrStatusList.count
        }
        return self.arrClientList.count

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pvComman.tag == 5{
            let strReturnString = (self.arrStatusList.object(at: row) as! NSDictionary).value(forKey: "Status") as? String
            return strReturnString
        }
        else{
            let strReturnString = (self.arrClientList.object(at: row) as! NSDictionary).value(forKey: "FirstName") as? String
            return strReturnString
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if pvComman.tag == 5{

            let strReturnString = (self.arrStatusList.object(at: row) as! NSDictionary).value(forKey: "Status") as? String
            let strReturnStringID = (self.arrStatusList.object(at: row) as! NSDictionary).value(forKey: "StatusId") as? String

            self.dicvalue.setValue(strReturnString, forKey: "Status")
            self.dicvalue.setValue(strReturnStringID, forKey: "StatusId");

            if appdel.strClientId == "" || appdel.strClientId.isEmpty
            {
                let indexPath = NSIndexPath(row: 6, section: 0)
                print("indexPath:\(indexPath)")
                self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
            }
            else{
                let indexPath = NSIndexPath(row: 5, section: 0)
                print("indexPath:\(indexPath)")
                self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
            }
        }
        else
        {
            let strReturnString = (self.arrClientList.object(at: row) as! NSDictionary).value(forKey: "FirstName") as? String
            let strReturnStringID = (self.arrClientList.object(at: row) as! NSDictionary).value(forKey: "ClientId") as? String
            
            self.dicvalue.setValue(strReturnString, forKey: "ClientName")
            self.dicvalue.setValue(strReturnStringID, forKey: "ClientId");
            
            let indexPath = NSIndexPath(row: 1, section: 0)
            print("indexPath:\(indexPath)")
            self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
        }
    }
    
    
    
 
    // MARK: -
    
//    // MARK: -
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return 2
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let strReturnString = self.arrComplexList.object(at: row) as? String
//        return strReturnString
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
//        let dic  = NSMutableDictionary(dictionary: self.arrModelDetail.object(at: 0) as! NSDictionary)
//        let strReturnString = self.arrComplexList.object(at: row) as? String
//        dic.setValue(strReturnString, forKey:"Complex")
//        self.arrModelDetail.replaceObject(at: 0, with: dic)
//        print("dic :\(self.arrModelDetail.object(at: 0) as! NSDictionary)")
//
//
//            let indexPath = NSIndexPath(row: 4, section: 0)
//            print("indexPath:\(indexPath)")
//            self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
//
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
