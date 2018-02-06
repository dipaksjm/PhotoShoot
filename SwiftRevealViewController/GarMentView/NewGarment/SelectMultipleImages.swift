//
//  ImageAddEditViewController.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 18/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class SelectMultipleImages: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var appDelegate =  AppDelegate()
    @IBOutlet weak var colView : UICollectionView!
    @IBOutlet weak var lblHeaderName : UILabel!
    @IBOutlet weak var btnAddDelete : UIButton!
    
    var arrCatalogueList = NSMutableArray()
    
    var dicModelDetail = NSMutableDictionary()
    var arrModelImages = NSMutableArray()
    var arrDeleteImages = NSMutableArray()
    
    var imagePicker = UIImagePickerController()
    var inttotal =  Int()
    
    var intClassIndex =  Int()
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inttotal = 0
        
        print("ADD EDIT arrModelDetail:\(dicModelDetail)")
        
        self.setupView()
        self.setupViewOfClass()
        
    }
    
    func setupView(){
        appDelegate =  UIApplication.shared.delegate as! AppDelegate
        
        let nib = UINib(nibName: "Cell_ImageAddedit", bundle: nil)
        self.colView.register(nib, forCellWithReuseIdentifier:"Cell_ImageAddedit")
        self.colView.allowsMultipleSelection = true
        
        self.imagePicker.delegate = self

    }
    func setupViewOfClass(){
        if intClassIndex == 1{ // ADD NEW GARMENT
            let arrdic  =  NSMutableArray(array: (dicModelDetail.value(forKey: "Lstimages") as? NSArray)!)
            
            for i in 0..<arrdic.count{
                let dictMain : NSMutableDictionary = [:]
                let dic  = arrdic.object(at: i ) as! NSDictionary
                let strMediumImage = dic.value(forKey: "FullImage") as? String
                dictMain.setValue(strMediumImage, forKey: "FullImage")
                dictMain.setValue(false, forKey: "isManual")
                dictMain.setValue(false, forKey: "isSelect")
                dictMain.setValue(dic.value(forKey: "ImageId") as? String, forKey: "ImageId")
                dictMain.setValue(dic.value(forKey: "OldImage") as? String, forKey: "OldImage")
                arrModelImages.add(dictMain)
            }
            print("arrModelImages :\(arrModelImages)")
        }
    }
    
    @IBAction func action_Back(_ sender: Any){
        
        dicModelDetail.setValue(arrModelImages, forKey: "Lstimages")
        dicModelDetail.setValue(arrDeleteImages, forKey: "LstDeletedimages")
        
        print("arrModelDetail :\(self.dicModelDetail)")
        
        
        let viewControllers = self.navigationController?.viewControllers
        let count = viewControllers!.count
        if count > 1 {
            if let mVC = viewControllers?[count - 1] as? GarmentBasicInfoEdit {
                //Set the value
                mVC.dictGarmentDetailsNew = self.dicModelDetail
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let fileManager = FileManager.default
        
        let imgName = "\(inttotal).jpg"
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imgName)
        print(paths)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        
        let dic = NSMutableDictionary()
        dic.setValue(paths, forKey: "FullImage")
        dic.setValue(true, forKey: "isManual")
        dic.setValue(false, forKey: "isSelect")
        dic.setValue("", forKey: "ImageId")
        dic.setValue("", forKey: "OldImage")
        
        arrModelImages.add(dic)
        print("arrModelImages:\(arrModelImages)")
        
        colView.reloadData()
        
        inttotal = inttotal + 1
        
        dismiss(animated: true, completion: nil)
        
        
    }
    // MARK: -
    
    @IBAction func action_AddDelete(_ sender: Any){
        
        if btnAddDelete.titleLabel?.text == "DELETE" {
            print("DELETE")
            
            for i in 0..<self.arrModelImages.count{
                for j in 0..<self.arrModelImages.count{
                    
                    let dic  = NSMutableDictionary(dictionary: arrModelImages.object(at: j) as! NSDictionary)
                    if dic.value(forKey: "isSelect") as? Bool == true {
                        
                        if dic.value(forKey: "isManual") as? Bool == false {
                            let dictMain : NSMutableDictionary = [:]
                            let strImageId = dic.value(forKey: "ImageId") as? String
                            dictMain.setValue(strImageId, forKey: "ImageId")
                            self.arrDeleteImages.add(dictMain)
                        }
                        
                        self.arrModelImages.removeObject(at: j)
                        
                        break
                    }
                }
            }
            print("self.arrModelImages \(self.arrModelImages)")
            print("arrDeleteImages \(self.arrDeleteImages)")
            
            self.colView.reloadData()
            
            self.setButtonTitle()
            
        }else{
            
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
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.categorylists.count + 1
        return arrModelImages.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let rowint = indexPath.row
        
        let cell:Cell_ImageAddedit = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_ImageAddedit", for: indexPath as IndexPath) as! Cell_ImageAddedit
        
        let dic  = arrModelImages.object(at: rowint) as! NSDictionary
        
        if dic.value(forKey: "isSelect") as? Bool == true {
            cell.img_Sub.alpha =  0.5
        }
        else{
            cell.img_Sub.alpha =  0
        }
        
        if dic.value(forKey: "isManual") as? Bool ==  true{
            cell.img_Main.image = UIImage(contentsOfFile: (dic.value(forKey: "FullImage") as? String)!)
        }
        else{
            let strImgPath = dic.value(forKey: "FullImage") as? String
            cell.img_Main.setImageWith(NSURL(string: strImgPath!)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
        }
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize{
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
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! Cell_ImageAddedit
        
        let dic  = NSMutableDictionary(dictionary: arrModelImages.object(at: indexPath.row) as! NSDictionary)
        dic.setValue(true, forKey:"isSelect")
        cell.img_Sub.alpha = 0.5
        self.arrModelImages.replaceObject(at: indexPath.row, with: dic)
        
        self.setButtonTitle()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! Cell_ImageAddedit
        
        let dic  = NSMutableDictionary(dictionary: arrModelImages.object(at: indexPath.row) as! NSDictionary)
        dic.setValue(false, forKey:"isSelect")
        cell.img_Sub.alpha = 0
        self.arrModelImages.replaceObject(at: indexPath.row, with: dic)
        
        self.setButtonTitle()
        
    }
    
    func setButtonTitle(){
        for i in 0..<self.arrModelImages.count
        {
            let dic  = NSMutableDictionary(dictionary: arrModelImages.object(at: i) as! NSDictionary)
            if dic.value(forKey: "isSelect") as? Bool == true
            {
                btnAddDelete.setTitle("DELETE", for: UIControlState.normal)
                break
            }
            else{
                btnAddDelete.setTitle("NEW", for: UIControlState.normal)
            }
        }
    }
    
     // MARK: -
     
    
    
}
