//
//  AccessoriesDetailsViewController.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 12/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class AccessoriesDetailsViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var tblView: UITableView!
    var appDelegate =  AppDelegate()
    var dictAccessDetails = NSMutableDictionary()
    
    var isEditable = Bool()
    var isNew = String()
    var imagePicker = UIImagePickerController()
    var intIndex = Int()
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("dictAccessDetails : \(dictAccessDetails)")
        isEditable =  false
        
        appDelegate =  UIApplication.shared.delegate as! AppDelegate
        imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        
        self.setupView()
        
    }
    
    
    func setupView(){
        
        let nib = UINib(nibName: "cell_CatelogueName", bundle: nil)
        self.tblView.register(nib, forCellReuseIdentifier: "id_cell_CatelogueName")
        
        let nib1 = UINib(nibName: "Cell_ModelHeader", bundle: nil)
        self.tblView.register(nib1, forCellReuseIdentifier: "Cell_ModelHeader")
        
        let nibCell_AccessoriesTextView = UINib(nibName: "Cell_AccessoriesTextView", bundle: nil)
        self.tblView.register(nibCell_AccessoriesTextView, forCellReuseIdentifier: "Cell_AccessoriesTextView")
        
        if isNew == "yes"{
            self.dictAccessDetails.setValue("", forKey: "AccessoriesId")
            self.dictAccessDetails.setValue(1, forKey: "CategoryId")
            self.dictAccessDetails.setValue("", forKey: "AccessoriesName")
            self.dictAccessDetails.setValue("", forKey: "Description")
            self.dictAccessDetails.setValue("", forKey: "FullImage")
            self.dictAccessDetails.setValue(self.appDelegate.strClientAdminId, forKey: "ClientAdminId")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Done(_ sender: Any){
        print("action_Done...\(self.dictAccessDetails)")
        

    }

    // MARK: -
    /*
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
    */
    
    @objc func editInformation(sender: UIButton!){
        print("editInformation...")
        if let button = sender {
            if button.isSelected {
                // set deselected
                button.isSelected = false
                isEditable = false
            } else {
                // set selected
                button.isSelected = true
                isEditable = true
            }
        }
        self.tblView.reloadData()
        
    }
    
    @IBAction func action_CamaraOption(_ sender: UIButton){
        print("action_CamaraOption...\(sender.tag)")
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }else{
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let fileManager = FileManager.default
        
        let imgName = "\(self.appDelegate.generateTimeStamp()).jpg"
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imgName)
        print("local paths : \(paths)")
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        self.dictAccessDetails.setValue(paths, forKey: "FullImage")
        self.dictAccessDetails.setValue(paths, forKey: "SmallImage")
        self.dictAccessDetails.setValue(paths, forKey: "MediumImage")


        dismiss(animated: true, completion: nil)
        
        let indexPath = NSIndexPath(row: 0, section: 0)
        print("indexPath:\(indexPath)")
        self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
    }

    
    
    // MARK: -

    @IBAction func addEditAccessories(){
        
        self.view.endEditing(true)
        
        
        if self.appDelegate.strCurrentClass == CONSTANT.className.AddNewGarment{
            print("yes...")
            print("self.dictAccessDetails : \(self.dictAccessDetails)")
            
            if self.isNew == "yes"{
                let arrTemp = NSMutableArray(array: self.appDelegate.dictAddNewGarment.value(forKey: "LstAccessories") as! NSArray)
                arrTemp.add(self.dictAccessDetails)
                self.appDelegate.dictAddNewGarment.setValue(arrTemp, forKey: "LstAccessories")
                self.navigationController?.popViewController(animated: true)
            }else{
                let arrTemp = NSMutableArray(array: self.appDelegate.dictAddNewGarment.value(forKey: "LstAccessories") as! NSArray)
                arrTemp.replaceObject(at: self.intIndex, with: self.dictAccessDetails)
                self.appDelegate.dictAddNewGarment.setValue(arrTemp, forKey: "LstAccessories")
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }else{
            self.appDelegate.showMBProgressHUD()
            
            let parameters: [String: Any] = [
                "GarmentId": self.dictAccessDetails.value(forKey: "GarmentId") as! String,
                "AccessoriesId": self.dictAccessDetails.value(forKey: "AccessoriesId") as! String,
                "ClientId": self.dictAccessDetails.value(forKey: "ClientId") as! String,
                "CategoryId": "\(self.dictAccessDetails.value(forKey: "CategoryId") as! NSNumber)",
                "CreatedBy": self.dictAccessDetails.value(forKey: "CreatedBy") as! String,
                "ClientAdminId": self.dictAccessDetails.value(forKey: "ClientAdminId") as! String,
                "AccessoriesName": self.dictAccessDetails.value(forKey: "AccessoriesName") as! String,
                "Description": self.dictAccessDetails.value(forKey: "Description") as! String,
                "FullImage": "/UploadedImage/Accessories/F_636512245326575285.jpg",//(self.dictAccessDetails.value(forKey: "FullImage") as! String).replacingOccurrences(of:CONSTANT.service_URL.pathImgRemove, with: ""),
                "Isdeleted": "false"
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
                        
                        if jsonObject["IsError"] as! Bool == false {
                            if self.isNew == "yes"{
                                self.appDelegate.showMBProgressHUD_short(strMsg: CONSTANT.AlretMessage.Accessory_added)
                            }else{
                                self.appDelegate.showMBProgressHUD_short(strMsg: CONSTANT.AlretMessage.Accessory_edited)
                            }
                            self.perform(#selector(self.action_Back(_:)), with: nil, afterDelay: 3)
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
    }
    
    // MARK: -
    // MARK: UITableView Method
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        print("heightForRowAt...")
        if indexPath.row == 0
        {
            return 317
        }
        else if indexPath.row == 1
        {
            return 45
        }
        return 133
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if indexPath.row == 0 // accessory Image
        {
            let cell : Cell_ModelHeader = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelHeader") as! Cell_ModelHeader
            
            cell.scroll.contentSize = CGSize(width: tableView.frame.size.width * 1, height: cell.scroll.frame.size.height)
            // page control
            cell.scroll.delegate = self
            cell.pageControl.numberOfPages = 1
//            cell.pageControl.addTarget(self, action: #selector(pageChanged(sender:)), for: .valueChanged)
            cell.pageControl.isHidden = true
            
            let x: CGFloat = 0
            let imgAccessory = UIImageView(frame: CGRect(x: x + 0, y: 0, width: tableView.frame.size.width, height: cell.scroll.frame.size.height))
            
            if self.appDelegate.strCurrentClass == CONSTANT.className.AddNewGarment{
                if (self.dictAccessDetails.value(forKey: "FullImage") as! String).count > 0{
                    imgAccessory.image = UIImage(contentsOfFile: self.dictAccessDetails.value(forKey: "FullImage") as! String)
                }else{
                    imgAccessory.image = UIImage(named: "placeholder.png")
                }
            }else{
                imgAccessory.image = UIImage(named: "placeholder.png")
            }
//
            
            
//            let strImgPath = dictAccessDetails.object(forKey: "MediumImage") as! String
//            imgAccessory.setImageWith(NSURL(string: strImgPath)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
            imgAccessory.contentMode = .scaleAspectFit // ALTERNATIVE:  .ScaleAspectFit
            cell.scroll.addSubview(imgAccessory)
            cell.btnHeaderEdit.addTarget(self, action: #selector(action_CamaraOption(_:)), for: .touchUpInside)

            return cell
        }else  if indexPath.row == 1{ // accessory Tittle
            
            
            let cell : cell_CatelogueName = tableView.dequeueReusableCell(withIdentifier: "id_cell_CatelogueName") as! cell_CatelogueName
            cell.btn_EditTitle.addTarget(self, action: #selector(editInformation(sender:)), for: UIControlEvents.touchUpInside)
            cell.txtTitle.text = dictAccessDetails.object(forKey: "AccessoriesName") as? String
            cell.txtTitle.placeholder = "Enter accessory name"
            cell.txtTitle.delegate = self
            cell.txtTitle.layer.cornerRadius = 4.0
            cell.txtTitle.clipsToBounds = true
            cell.txtTitle.layer.masksToBounds = true
            cell.txtTitle.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtTitle.layer.borderWidth = 1.5
            cell.txtTitle.tag = 1
            
            if self.isNew == "yes"{
                isEditable = true
                cell.btn_EditTitle.isHidden = true
            }
            
            
            if isEditable == true{
                cell.txtTitle.isUserInteractionEnabled = true
            }else{
                cell.txtTitle.isUserInteractionEnabled = false
            }
            return cell
        }else  if indexPath.row == 2{ // Accessory Description
            let cell : Cell_AccessoriesTextView = tableView.dequeueReusableCell(withIdentifier: "Cell_AccessoriesTextView") as! Cell_AccessoriesTextView
            cell.txtDescri.text = dictAccessDetails.object(forKey: "Description") as? String
            cell.txtDescri.delegate = self
//            cell.txtDescri.isEditable = false
            cell.txtDescri.layer.cornerRadius = 4.0
            cell.txtDescri.clipsToBounds = true
            cell.txtDescri.layer.masksToBounds = true
            cell.txtDescri.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtDescri.layer.borderWidth = 1.5
            cell.txtDescri.tag = 1
            
            if cell.txtDescri.text.count == 0 || cell.txtDescri.text == "Enter accessory description..."{
                cell.txtDescri.text = "Enter accessory description..."
                cell.txtDescri.textColor = UIColor.lightGray
            }else{
                cell.txtDescri.textColor = UIColor.black
            }
            
            
            
            if self.isNew == "yes"{
                isEditable = true
            }

            
            if isEditable == true{
                cell.txtDescri.isUserInteractionEnabled = true
            }else{
                cell.txtDescri.isUserInteractionEnabled = false
            }
            return cell

        }else{
            let cell : Cell_AccessoriesTextView = tableView.dequeueReusableCell(withIdentifier: "Cell_AccessoriesTextView") as! Cell_AccessoriesTextView
            return cell
        }
    
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }

    // MARK: -
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing...\(textField.tag)")
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing...\(textField.tag)")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing...\(textField.tag)")
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing...\(textField.tag)")
        
        if textField.tag == 1{ // titile
            self.dictAccessDetails.setValue(textField.text, forKey: "AccessoriesName")
            let indexPath = NSIndexPath(row: 1, section: 0)
            self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn...\(textField.tag)")
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing...\(textView.tag)")

        if textView.text  == "" ||  textView.text.isEmpty || textView.text == "Enter accessory description..."{
            textView.textColor = UIColor.black
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing...\(textView.tag)")
        print("textView.text...\(textView.text)")

        if textView.tag == 1{ // description
            self.dictAccessDetails.setValue(textView.text, forKey: "Description")
            let indexPath = NSIndexPath(row: 2, section: 0)
            self.tblView.reloadRows(at: [indexPath as IndexPath], with: .none)

        }
    }
    
}
