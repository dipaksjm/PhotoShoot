//
//  SchedulerVC.swift
//  SwiftRevealViewController
//
//  Created by Dips here... on 1/16/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }
    }
}

class SchedulerVC: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var layout_btnAddW: NSLayoutConstraint!

    var appDelegate =  AppDelegate()
    var arrSchedulerList = NSMutableArray()
    var arrCatalogueList = NSMutableArray()
    var intSelectedSchedulerIndex : Int = 0
    var intSelectedSchedulerIndexTemp : Int = 0
    var dictSchdularRights = NSDictionary()
    

    @IBOutlet weak var view_Navigation : UIView!

    @IBOutlet weak var tblMain : UITableView!

    // searchbar
    @IBOutlet weak var view_search : UIView!
    @IBOutlet weak var txtS_Search : UITextField!
    @IBOutlet weak var btnS_AddScheduler : UIButton!
    
    @IBOutlet var pvCataloguList: UIPickerView! = UIPickerView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate =  UIApplication.shared.delegate as! AppDelegate
        self.dictSchdularRights = (UserDefaults.standard.value(forKey: "MenuRights") as! NSArray).object(at: 23) as! NSDictionary
        print("dictSchdularRights:\(dictSchdularRights)")
        
        self.getCatalogueList()
        self.setupView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }
    
    func setupView(){
        self.view_Navigation.backgroundColor = CONSTANT.color_App.color_SCH
        
        let nib1 = UINib(nibName: "cell_Schduler", bundle: nil)
        self.tblMain.register(nib1, forCellReuseIdentifier: "id_cell_Schduler")
        

        if (self.dictSchdularRights.value(forKey: "Add") as! NSNumber) == 0{
            self.btnS_AddScheduler.isHidden = true
            self.layout_btnAddW.constant = 0
        }else{
            self.layout_btnAddW.constant = 34
        }
        self.view_search.setNeedsDisplay()
        
        if (self.dictSchdularRights.value(forKey: "Delete") as! NSNumber) == 0{
            self.tblMain.isEditing = false
        }


        
        intSelectedSchedulerIndex = -1

        pvCataloguList.delegate = self
        pvCataloguList.dataSource = self
        self.txtS_Search.inputView = pvCataloguList
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SchedulerVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SchedulerVC.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.txtS_Search.inputAccessoryView = toolBar
        
        
        self.btnS_AddScheduler.backgroundColor = CONSTANT.color_App.color_SCH
        
        self.view_search.layer.cornerRadius = 4.0
        self.view_search.layer.borderColor = UIColor.lightGray.cgColor
        self.view_search.layer.borderWidth = 1.0
        self.view_search.clipsToBounds = true
        self.view_search.layer.masksToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtS_Search.frame.size.height))
        txtS_Search.leftView = paddingView
        txtS_Search.leftViewMode = .always
    }

// MARK: -
    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func action_AddSchdular(_ sender: UIButton){
        print("action_AddSchdular...")
        let objAddSchedulerVC = AddSchedulerVC(nibName: "AddSchedulerVC", bundle: nil)
        objAddSchedulerVC.strClientID = (self.arrCatalogueList.object(at: self.intSelectedSchedulerIndex) as! NSDictionary).value(forKey: "ClientId") as! String
        objAddSchedulerVC.strClientName = (self.arrCatalogueList.object(at: self.intSelectedSchedulerIndex) as! NSDictionary).value(forKey: "ClientName") as! String
        objAddSchedulerVC.strCatalogueName = self.txtS_Search.text
        objAddSchedulerVC.strCatalogueID = (self.arrCatalogueList.object(at: self.intSelectedSchedulerIndex) as! NSDictionary).value(forKey: "CatalogueId") as! String
        objAddSchedulerVC.strAdd = "yes"
        self.navigationController?.pushViewController(objAddSchedulerVC, animated: true)
    }
    
    @IBAction func action_SearchCatelogue(_ sender: UIButton){
        print("action_SearchCatelogue...")
        
    }

    @IBAction func action_EditSchdular(_ sender: UIButton){
        print("action_EditSchdular...\(sender.tag)")
        
        let objAddSchedulerVC = AddSchedulerVC(nibName: "AddSchedulerVC", bundle: nil)
        objAddSchedulerVC.strClientID = (self.arrCatalogueList.object(at: self.intSelectedSchedulerIndex) as! NSDictionary).value(forKey: "ClientId") as! String
        objAddSchedulerVC.strClientName = (self.arrCatalogueList.object(at: self.intSelectedSchedulerIndex) as! NSDictionary).value(forKey: "ClientName") as! String
        objAddSchedulerVC.strCatalogueName = self.txtS_Search.text
        objAddSchedulerVC.strCatalogueID = (self.arrCatalogueList.object(at: self.intSelectedSchedulerIndex) as! NSDictionary).value(forKey: "CatalogueId") as! String
        objAddSchedulerVC.dictEditData = NSMutableDictionary(dictionary: self.arrSchedulerList.object(at: sender.tag) as! NSDictionary)
        objAddSchedulerVC.strAdd = "no"
        self.navigationController?.pushViewController(objAddSchedulerVC, animated: true)


        
    }
// MARK: -
    func getCatalogueList(){
        print("getCatalogueList...")
        
        self.appDelegate.showMBProgressHUD()
        
        let strUrl = String(format: "%@?clientAdminId=%@", CONSTANT.service_URL.GetCatalogueList,self.appDelegate.strClientAdminId)
        print("getCatalogueList : \(strUrl)")

        
        Alamofire.request(strUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            self.appDelegate.hideMBProgressHUD()
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil
                {
                    let jsonObject = response.result.value as! NSDictionary
                    print(jsonObject)
                    
                    if jsonObject["IsError"] as! Bool == false{
                        self.arrCatalogueList = NSMutableArray(array: jsonObject["LstCatalogue"] as! NSArray)
                        if self.arrCatalogueList.count > 0{
                            self.intSelectedSchedulerIndex = 0
                            self.intSelectedSchedulerIndexTemp = 0
                            self.txtS_Search.text = (self.arrCatalogueList.object(at: self.intSelectedSchedulerIndex) as! NSDictionary).value(forKey: "CatalogueName") as? String
                            self.getSchedulerList()
                        }else{
                            self.appDelegate.showMBProgressHUD_short(strMsg: "Catalogue not found")
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
        }
    }
    
    func getSchedulerList(){
        print("getSchedulerList...")
        
        appDelegate.showMBProgressHUD()
        
        let strCatalogueID = (self.arrCatalogueList.object(at: self.intSelectedSchedulerIndex) as! NSDictionary).value(forKey: "CatalogueId") as? String
        let strUrl = String(format: "%@?catalogueId=%@", CONSTANT.service_URL.GetSchedulerList,strCatalogueID!)
        
        print("strUrl : \(strUrl)")
        
        Alamofire.request(strUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            self.appDelegate.hideMBProgressHUD()
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil
                {
                    let jsonObject = response.result.value as! NSDictionary
                    print("jsonObject : \(jsonObject)")
                    
                    if jsonObject["IsError"] as! Bool == false{
                        self.arrSchedulerList = NSMutableArray(array: jsonObject["LstScheduler"] as! NSArray)
                        if self.arrSchedulerList.count == 0{
                            self.appDelegate.showMBProgressHUD_short(strMsg: "Selected catalogue scheduler list not found")
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
            self.tblMain.reloadData()
        }
    }
    
    func deleteScheduler(intIndex:Int){
        
        print("deleteScheduler...")
//        self.appDelegate.showMBProgressHUD()
        
        let dictDeleteSch = self.arrSchedulerList.object(at: intIndex) as! NSDictionary
        let strCatalogueID = (self.arrCatalogueList.object(at: self.intSelectedSchedulerIndex) as! NSDictionary).value(forKey: "CatalogueId") as? String

        let parameters: [String: Any] = [
            "ScheduleId": dictDeleteSch.value(forKey: "ScheduleId") as! String,
            "StartDate": dictDeleteSch.value(forKey: "StartDate") as! String,
            "EndDate": dictDeleteSch.value(forKey: "EndDate") as! String,
            "CatalogueId": strCatalogueID!,
            "Description": "",
            "ClientAdminId": self.appDelegate.strClientAdminId,
            "StatusId": "",
            "ClientId": dictDeleteSch.value(forKey: "ClientId") as! String,
            "StatusComments": "",
            "Isdeleted": "true",
            ]
        
        print("parameters ==> \(parameters)")
        
        let parametersNew : [String:Any] = ["obj":parameters]
        
        Alamofire.request(CONSTANT.service_URL.AddEditScheduler, method: .post, parameters: parametersNew , encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            self.appDelegate.hideMBProgressHUD()
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil{
                    
                    let jsonObject = response.result.value as! NSDictionary
                    print("res jsonObject:\(jsonObject)")
                    
                         if jsonObject["IsError"] as! Bool == false {
                            self.appDelegate.showMBProgressHUD_short(strMsg: "Scheduler successfully deleted")
                            self.perform(#selector(self.getSchedulerList), with: nil, afterDelay: 1)
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
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let viewSection  = UIView()
//        viewSection.frame = CGRect(x: 0, y: 0, width: self.tblMain.frame.size.width, height: 30)
//        viewSection.backgroundColor = UIColor.white
//
//        let lblSectionName = UILabel()
//        lblSectionName.frame = CGRect(x: 10, y: 0, width: self.tblMain.frame.size.width, height: 30)
//        lblSectionName.backgroundColor = UIColor.clear
//        lblSectionName.font = CONSTANT.Font.roboto_Mid_16
//        lblSectionName.numberOfLines = 2
//        lblSectionName.textColor = UIColor.black
//        lblSectionName.text = "TODAY"
//        viewSection.addSubview(lblSectionName)
//
//        return viewSection
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30.0
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101.0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arrSchedulerList.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("cellForRowAt...start")

        let cell : cell_Schduler = tableView.dequeueReusableCell(withIdentifier: "id_cell_Schduler") as! cell_Schduler
        
        cell.lblPilar.backgroundColor = CONSTANT.color_App.color_SCH
        
        let strStartDate  = "Start Date:\((self.arrSchedulerList.object(at: indexPath.row) as! NSDictionary).value(forKey: "StartDate") as! String)"
        let strS = NSMutableAttributedString(string: strStartDate)
        strS.setColorForText("Start Date:", with: UIColor.darkGray)
        cell.lblStartDate.attributedText = strS

        let strEndDate   = "End Date:\((self.arrSchedulerList.object(at: indexPath.row) as! NSDictionary).value(forKey: "EndDate") as! String)"
        let strE = NSMutableAttributedString(string: strEndDate)
        strE.setColorForText("End Date:", with: UIColor.darkGray)
        cell.lblEndDate.attributedText = strE

        cell.lblDesc.text = (self.arrSchedulerList.object(at: indexPath.row) as! NSDictionary).value(forKey: "Description") as? String
        let strColorCode = (self.arrSchedulerList.object(at: indexPath.row) as! NSDictionary).value(forKey: "StatusColorCode") as? String
        cell.lblBotum.backgroundColor = self.appDelegate.hexStringToUIColor(hex: strColorCode!)
        cell.lblStatus.text = (self.arrSchedulerList.object(at: indexPath.row) as! NSDictionary).value(forKey: "Status") as? String
        cell.lblStatus.textColor = cell.lblBotum.backgroundColor
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(action_EditSchdular(_:)), for: .touchUpInside)
        
        if (self.dictSchdularRights.value(forKey: "Edit") as! NSNumber) == 0{
            cell.btnEdit.isHidden = true
        }



        print("cellForRowAt...end")

        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("editingStyle Delete: \(indexPath.row)")
            self.deleteScheduler(intIndex: indexPath.row)
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    // MARK: -
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrCatalogueList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let strReturnString = (self.arrCatalogueList.object(at: row) as! NSDictionary).value(forKey: "CatalogueName") as! String
        return strReturnString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        print("didSelectRow...")
        intSelectedSchedulerIndexTemp = row
    }
    
    func doneClick() {
        self.intSelectedSchedulerIndex = self.intSelectedSchedulerIndexTemp
        self.txtS_Search.resignFirstResponder()
        
        self.txtS_Search.text = (self.arrCatalogueList.object(at: self.intSelectedSchedulerIndex) as! NSDictionary).value(forKey: "CatalogueName") as? String
        self.getSchedulerList()
    }
    func cancelClick() {
        self.intSelectedSchedulerIndexTemp = self.intSelectedSchedulerIndex
        self.txtS_Search.resignFirstResponder()
    }

    
    // MARK: -

    
}
