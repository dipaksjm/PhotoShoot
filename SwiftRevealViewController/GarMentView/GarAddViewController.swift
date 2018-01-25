//
//  GarAddViewController.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 20/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit


class GarAddViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    @IBOutlet weak var tblView : UITableView!
    var appdel =  AppDelegate()
    var imagePicker = UIImagePickerController()
    var dicvalue = NSMutableDictionary()
    var strCatalogueId  = String()

    
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
        
        imagePicker.delegate = self
        
        dicvalue.setValue("", forKey: "GarmentName");
        dicvalue.setValue("", forKey: "GarmentTitle");
        dicvalue.setValue("", forKey: "Description");
        dicvalue.setValue("", forKey: "UniqCode");
        dicvalue.setValue("", forKey: "CoverImage");
        dicvalue.setValue(strCatalogueId, forKey: "CategoryId");

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
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
    @IBAction func action_Done(_ sender: Any)
    {
        print("dicvalue:\(dicvalue)")
        self.view.endEditing(true)
        
        if dicvalue["GarmentName"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Name)
        }
        else if  dicvalue["GarmentTitle"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Title)
        }
        else if  dicvalue["UniqCode"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Unicode)
        }
        else if  dicvalue["Description"] as? String == ""
        {
            self.appdel.alertValidation(strMessage: CONSTANT.AlretMessage.Description)
        }
        else
        {
            print("action_Done:")
        }
    }
    
    // MARK: -
    // MARK: UITableView Method
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        print("heightForRowAt...")
        if indexPath.row == 0
        {
            return 250
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
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row == 0
        {
            let cell : Cell_CataImageUpload = tableView.dequeueReusableCell(withIdentifier: "Cell_CataImageUpload") as! Cell_CataImageUpload
            let stringImg = dicvalue.value(forKey: "CoverImage") as! String
            if stringImg == "" ||  stringImg.isEmpty
            {
                cell.imgView_catalogue.image = UIImage(named:"placeholderAddImages.png")
            }
            else{
                cell.imgView_catalogue.image = UIImage(contentsOfFile: (dicvalue.value(forKey: "CoverImage") as? String)!)
            }
            return cell
        }
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3
        {
            let rowint = indexPath.row - 1
            
            let cell : Cell_ModelME = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelME") as! Cell_ModelME
            
            if indexPath.row == 1{
                cell.lblName.text = "NAME"
                cell.txtField.text = ""
                cell.txtField.keyboardType = .default
            }
            if indexPath.row == 2{
                cell.lblName.text = "TITLE"
                cell.txtField.text = ""
                cell.txtField.keyboardType = .default
            }
            if indexPath.row == 3{
                cell.lblName.text = "UNICODE"
                cell.txtField.text = ""
                cell.txtField.keyboardType = .numberPad
            }
           
            cell.txtField.tag =  rowint
            cell.txtField.delegate = self
            return cell
        }
        
        let cell : Cell_AddessModel = tableView.dequeueReusableCell(withIdentifier: "Cell_AddessModel") as! Cell_AddessModel
        cell.lblTitle.text = "DESCRIPTION"
        cell.txtaddress.text = ""
        cell.txtaddress.tag = indexPath.row
        cell.txtaddress.delegate = self
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
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
        
        let imgName = "germent.jpg"
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
            dicvalue["GarmentName"] = textField.text
        }
        if textField.tag == 1 {
            dicvalue["GarmentTitle"] = textField.text
        }
        if textField.tag == 2 {
            dicvalue["UniqCode"] = textField.text
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
         dicvalue["Description"] = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        return true
    }
    
    
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
    //        let indexPath = NSIndexPath(row: 4, section: 0)
    //        print("indexPath:\(indexPath)")
    //        self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
    //
    //    }
    
}

