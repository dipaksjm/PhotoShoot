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

class ModelList: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblView : UITableView!
    var appDelegate =  AppDelegate()
    var arrModelList = NSMutableArray()
    var arrModelListPrevious = NSMutableArray()

    var refreshControl: UIRefreshControl!

    var strGarmentID : NSString!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate =  UIApplication.shared.delegate as! AppDelegate

        self.setupView()
        self.getModelList()

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupView(){
        let nib = UINib(nibName: "cell_modelList", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "id_cell_modelList")
        
        


    }
    
    
    // MARK: -
    
    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Done(_ sender: Any){
        let strAttributeValue = "yes"
        let predicate = NSPredicate(format: "isCheck like %@",strAttributeValue);
        let arrCheckMark = (arrModelList as NSArray).filtered(using: predicate)
        
        print("filteredArray:\(arrCheckMark)")
        
        if arrCheckMark.count > 0{
            self.mapSelectedModel(arrNewModel: arrCheckMark as NSArray)
        }else{
            self.appDelegate.showMBProgressHUD_short(strMsg: CONSTANT.AlretMessage.PleaseSelectModel)
        }
    }
    
    
    
    @IBAction func action_AddNewModel(_ sender: UIButton){
        print("action_AddNewModel...")
        let objNewModelAddViewController = NewModelAddViewController(nibName: "NewModelAddViewController", bundle: nil)
        self.navigationController?.pushViewController(objNewModelAddViewController, animated: true)
    }

    // MARK: -
    
    func getModelList(){
        print("getModelList...")
        
        self.appDelegate.showMBProgressHUD()
        
        let strUrl = String(format: "%@?clientAdminId=%@", CONSTANT.service_URL.GetModelList,self.appDelegate.strClientAdminId)
        
        print("strUrl : \(strUrl)")
        
        Alamofire.request(strUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            self.appDelegate.hideMBProgressHUD()
            
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil{
                    let dictRes = response.result.value as! NSDictionary
                    print("dictRes : \(dictRes)")
                    
                    if dictRes["IsError"] as! Bool == false
                    {
                        self.arrModelList = NSMutableArray(array: dictRes.value(forKey: "LstModel") as! NSArray)
                        if self.arrModelList.count > 0{
                            
                            for j in 0..<self.arrModelList.count{
                                let dictTemp = NSMutableDictionary(dictionary: (self.arrModelList.object(at: j) as! NSDictionary))
                                dictTemp.setValue("no", forKey: "isCheck")
                                self.arrModelList.replaceObject(at: j, with: dictTemp)
                            }

                            print("self.arrModelList : \(self.arrModelList)")

                            for i in 0..<self.arrModelListPrevious.count{
                                for j in 0..<self.arrModelList.count{
                                    if ((self.arrModelListPrevious.object(at: i) as! NSDictionary).value(forKey: "ModelId") as! String) == ((self.arrModelList.object(at: j) as! NSDictionary).value(forKey: "ModelId") as! String){
                                        (self.arrModelList.object(at: j) as! NSMutableDictionary).setValue("yes", forKey: "isCheck")
                                        break
                                    }
                                }
                             }
                            print("self.arrModelList2 : \(self.arrModelList)")

                        }else{
                            self.appDelegate.showMBProgressHUD_short(strMsg: CONSTANT.AlretMessage.ModelNotFound)
                        }
                    }else{
                        self.appDelegate.alertValidation(strMessage: CONSTANT.AlretMessage.noData)
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                self.appDelegate.hideMBProgressHUD()
                self.appDelegate.alertValidation(strMessage: response.result.error!.localizedDescription)
                
                break
            }
            self.tblView.reloadData()
        }
    }
    
    func mapSelectedModel(arrNewModel:NSArray){
        print("mapSelectedModel....\(arrNewModel)")

        let dictPrePara = NSMutableDictionary()

        dictPrePara.setValue(self.strGarmentID, forKey: "GarmentId")
        print("self.strGarmentID....\(self.strGarmentID)")
        print("dictPrePara....\(dictPrePara)")

        let arrModelMapping = NSMutableArray()
        for i in 0..<arrNewModel.count{
            let strMID = (arrNewModel.object(at: i) as! NSDictionary).value(forKey: "ModelId") as! String
            let dictTemp = NSMutableDictionary()
            dictTemp.setValue(strMID, forKey: "ModelId")
            dictTemp.setValue(self.appDelegate.strClientAdminId, forKey: "ClientAdminId")
            dictTemp.setValue(self.appDelegate.strClientId, forKey: "ClientId")
            arrModelMapping.add(dictTemp)
        }
        dictPrePara.setValue(arrModelMapping, forKey: "LstGarmentModelMappings")
        let dictParaFinal : [String:Any] = ["obj":dictPrePara]
        print("dictParaFinal....\(dictParaFinal)")

  
        Alamofire.request(CONSTANT.service_URL.ModelMapping, method: .post, parameters: dictParaFinal , encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            self.appDelegate.hideMBProgressHUD()
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil{
                    
                    let jsonObject = response.result.value as! NSDictionary
                    print("jsonObject:\(jsonObject)")
                    
                    if jsonObject["IsError"] as! Bool == false {
                        self.appDelegate.showMBProgressHUD_short(strMsg: CONSTANT.AlretMessage.ModelMapSuccess)
                        
                        let viewControllers = self.navigationController?.viewControllers

                        for i in 0..<viewControllers!.count{
                            if let viewController = self.navigationController?.viewControllers[i] {
                                if viewController.isKind(of: ProductDetailsVC.self) {
                                    let vcTemp = self.navigationController?.viewControllers[i] as! ProductDetailsVC
                                    vcTemp.strIsNeedReload = "yes"
                                    break
                                }
                            }
                        }
                        self.perform(#selector(self.action_Back(_:)), with: nil, afterDelay: 2)
                    }else{
                        self.appDelegate.showMBProgressHUD_short(strMsg: CONSTANT.AlretMessage.ModelMapFail)
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
    
    @IBAction func action_CheckUnCheck(_ sender: UIButton){
        print("action_CheckUnCheck....\(sender.tag)")
        
        
        if ((self.arrModelList.object(at: sender.tag) as! NSDictionary).value(forKey: "isCheck") as! String) == "yes"{
            (self.arrModelList.object(at: sender.tag) as! NSMutableDictionary).setValue("no", forKey: "isCheck")
        }else{
            (self.arrModelList.object(at: sender.tag) as! NSMutableDictionary).setValue("yes", forKey: "isCheck")
        }

        self.tblView.reloadData()
    }

  
    // MARK: -


    
    // MARK: -
    // MARK: UITableView Method
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arrModelList.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : cell_modelList = tableView.dequeueReusableCell(withIdentifier: "id_cell_modelList") as! cell_modelList
        
        cell.lbl_AccName.text = (self.arrModelList.object(at: indexPath.row) as! NSDictionary).value(forKey: "Name") as? String
        cell.lbl_AccDes.text = (self.arrModelList.object(at: indexPath.row) as! NSDictionary).value(forKey: "Address") as? String

        
        let strImgPath = (self.arrModelList.object(at: indexPath.row) as! NSDictionary).value(forKey: "CoverImage") as! String
        if strImgPath.count > 0{
            cell.img_Acc.setImageWith(NSURL(string: strImgPath)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            cell.img_Acc.image = UIImage(named:"placeholder.png")
        }
       
        if ((self.arrModelList.object(at: indexPath.row) as! NSDictionary).value(forKey: "isCheck") as! String) == "yes"{
            cell.btn_AccCU.setBackgroundImage(UIImage(named: "checked.png"), for: .normal)
        }else{
            cell.btn_AccCU.setBackgroundImage(UIImage(named: "unchecked.png"), for: .normal)
        }
        cell.btn_AccCU.addTarget(self, action: #selector(self.action_CheckUnCheck(_:)), for: UIControlEvents.touchUpInside)
        cell.btn_AccCU.tag = indexPath.row

        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        let objAccessoriesDetailsViewController = AccessoriesDetailsViewController(nibName: "AccessoriesDetailsViewController", bundle: nil)
//        self.navigationController?.pushViewController(objAccessoriesDetailsViewController, animated: true)

        
    }
    
   // MARK: -
    
}
