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

class AddSchedulerVC: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate {

    var appDelegate =  AppDelegate()
    @IBOutlet weak var view_Navigation : UIView!

    var arrSchedulerList = NSMutableArray()
    var arrStatusList = NSMutableArray()
    
    @IBOutlet weak var tblMain : UITableView!
    @IBOutlet weak var lblSelectedSchduler : UILabel!
    
    @IBOutlet weak var btnDone : UIButton!

    var dictData = NSMutableDictionary()
    var dictEditData = NSMutableDictionary()

    @IBOutlet var pvComman: UIPickerView! = UIPickerView()
    @IBOutlet var dpComman: UIDatePicker! = UIDatePicker()

    var strClientID : String!
    var strClientName : String!
    var strCatalogueName : String!
    var strCatalogueID : String!
    var strAdd : String!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate =  UIApplication.shared.delegate as! AppDelegate
        dictData.setValue("", forKey: "StatusIndex")
        self.getStatusList()

        self.setupView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }
    
    func setupView(){
        self.view_Navigation.backgroundColor = CONSTANT.color_App.color_SCH
        
        self.lblSelectedSchduler.textColor = CONSTANT.color_App.color_SCH
        self.lblSelectedSchduler.text = strCatalogueName
        self.btnDone.backgroundColor = CONSTANT.color_App.color_SCH
        
        
        let nib1 = UINib(nibName: "cell_AddSchduler_Dropdown", bundle: nil)
        self.tblMain.register(nib1, forCellReuseIdentifier: "id_cell_AddSchduler_Dropdown")

        let nib2 = UINib(nibName: "cell_AddSchduler_TextView", bundle: nil)
        self.tblMain.register(nib2, forCellReuseIdentifier: "id_cell_AddSchduler_TextView")
        
        if strAdd == "yes"{
            dictData.setValue("", forKey: "SchID")
            dictData.setValue("", forKey: "StartDate")
            dictData.setValue("", forKey: "EndDate")
            dictData.setValue("", forKey: "Desc")
            dictData.setValue("", forKey: "StatusDesc")
            dictData.setValue("", forKey: "StatusIndex")
            
        }else{
            print("self.dictEditData : \(self.dictEditData)")
            
            self.strClientID = dictEditData.value(forKey: "ClientId") as! String
            self.strClientName = dictEditData.value(forKey: "ClientName") as! String
            
            dictData.setValue(dictEditData.value(forKey: "ScheduleId") as! String, forKey: "SchID")
            dictData.setValue(dictEditData.value(forKey: "StartDate") as! String, forKey: "StartDate")
            dictData.setValue(dictEditData.value(forKey: "EndDate") as! String, forKey: "EndDate")
            dictData.setValue(dictEditData.value(forKey: "Description") as! String, forKey: "Desc")
            dictData.setValue(dictEditData.value(forKey: "StatusComments") as! String, forKey: "StatusDesc")
            
//            dictData.setValue("", forKey: "StatusIndex")
        }
        
    }
    

// MARK: -
    @IBAction func action_Back(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_DPValueChanged(sender:UIDatePicker){
        print("action_dpValueChanged...tag:\(sender.tag)")
        print("date is:\(sender.date)")
        
        let newDate = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        

        
        if sender.tag == 0{ // start Date
            self.dictData.setValue(formatter.string(from: newDate), forKey: "StartDate")
//            let indexPath = NSIndexPath(row: 0, section: 0)
//            self.tblMain.reloadRows(at: [indexPath as IndexPath], with: .none)
        }else if sender.tag == 1{ // end date
            self.dictData.setValue(formatter.string(from: newDate), forKey: "EndDate")
//            let indexPath = NSIndexPath(row: 1, section: 0)
//            self.tblMain.reloadRows(at: [indexPath as IndexPath], with: .none)
        }

    }

    @IBAction func action_Done(sender:UIButton){
        print("action_Done...")
        
        if (self.dictData.value(forKey: "StartDate") as! String).count == 0{
                self.appDelegate.showMBProgressHUD_short(strMsg: "Please add the Start Date and time")
        }else if (self.dictData.value(forKey: "EndDate") as! String).count == 0{
            self.appDelegate.showMBProgressHUD_short(strMsg: "Please add the End Date and time")
        }else if (dictData.value(forKey: "StatusIndex") as! String).count == 0{
            self.appDelegate.showMBProgressHUD_short(strMsg: "Please select Status")
        }else{
            self.addScheduler()
        }
    }

    
// MARK: -
    func getStatusList(){
        print("getStatusList...")
        
        appDelegate.showMBProgressHUD()
        
        let strUrl = String(format: "%@?clientAdminId=%@", CONSTANT.service_URL.GetSchedulerStatusList,self.appDelegate.strClientAdminId)
        
        print("strUrl : \(strUrl)")
        
        Alamofire.request(strUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            self.appDelegate.hideMBProgressHUD()
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil
                {
                    let jsonObject = response.result.value as! NSDictionary
                    print(jsonObject)
                    
                    if jsonObject["IsError"] as! Bool == false
                    {
                        self.arrStatusList = NSMutableArray(array: jsonObject["LstStatusMaster"] as! NSArray)
                        
                        if self.strAdd == "no"{
                            for i in 0..<self.arrStatusList.count{
                                if ((self.arrStatusList.object(at: i) as! NSDictionary).value(forKey: "StatusId") as! String) == (self.dictEditData.value(forKey: "StatusId") as! String){
                                        self.dictData.setValue("\(i)", forKey: "StatusIndex")
                                    let indexPath = NSIndexPath(row: 3, section: 0)
                                    self.tblMain.reloadRows(at: [indexPath as IndexPath], with: .none)
                                }
                            }
                        }
                    }
                    else
                    {
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
    
    func addScheduler(){
        
        print("addScheduler...")
        self.appDelegate.showMBProgressHUD()
        
        
        if (dictData.value(forKey: "StatusIndex") as! String).count == 0 {
            return
        }
        let parameters: [String: Any] = [
            "ScheduleId": self.dictData.value(forKey: "SchID") as! String, // empty if new
            "StartDate": self.dictData.value(forKey: "StartDate") as! String,
            "EndDate": self.dictData.value(forKey: "EndDate") as! String,
            "CatalogueId": self.strCatalogueID,
            "Description": self.dictData.value(forKey: "Desc") as! String,
            "ClientAdminId": self.appDelegate.strClientAdminId,
            "StatusId": (self.arrStatusList.object(at: Int(dictData.value(forKey: "StatusIndex") as! String)!) as! NSDictionary).value(forKey: "StatusId") as! String,
            "ClientId": self.strClientID,
            "StatusComments": self.dictData.value(forKey: "StatusDesc") as! String,
            "IsDeleted": "false",
            ]

        print("parameters ==> \(parameters)")
        
        let parametersNew : [String:Any] = ["obj":parameters]
        
        Alamofire.request(CONSTANT.service_URL.AddEditScheduler, method: .post, parameters: parametersNew , encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            self.appDelegate.hideMBProgressHUD()
            
            switch(response.result){
            case .success(_):
                if response.result.value != nil{
                    
                    let jsonObject = response.result.value as! NSDictionary
                    print("jsonObject:\(jsonObject)")
                    
//                    if jsonObject["Flag"] as! Bool == true {
//
//                        if jsonObject["Success"] as! Bool == true {
//                        }
//                        else
//                        {
//                        }
//                    }
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
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30.0
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var flH : CGFloat = 0.0
        
        if (indexPath.row == 0) || (indexPath.row == 1) || (indexPath.row == 3) {
            flH = 55.0 // 61
        }else if  (indexPath.row == 2) || (indexPath.row == 4){
            flH = 120.0
        }
        
        return flH
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if (indexPath.row == 0){
            let cell : cell_AddSchduler_Dropdown = tableView.dequeueReusableCell(withIdentifier: "id_cell_AddSchduler_Dropdown") as! cell_AddSchduler_Dropdown
            cell.txtDropdown.delegate = self
            cell.txtDropdown.placeholder = "Select Start Date"
            cell.txtDropdown.tag = 0
            self.dpComman.tag = 0
            
            cell.txtDropdown.text = self.dictData.value(forKey: "StartDate") as? String
            
            cell.txtDropdown.inputView = nil
            cell.txtDropdown.inputView = self.dpComman
            
            
            return cell
        }else if (indexPath.row == 1){
            let cell : cell_AddSchduler_Dropdown = tableView.dequeueReusableCell(withIdentifier: "id_cell_AddSchduler_Dropdown") as! cell_AddSchduler_Dropdown

            cell.txtDropdown.delegate = self
            cell.txtDropdown.placeholder = "Select End Date"
            cell.txtDropdown.tag = 1
            self.dpComman.tag = 1
            cell.txtDropdown.text = self.dictData.value(forKey: "EndDate") as? String
            
            cell.txtDropdown.inputView = nil
            cell.txtDropdown.inputView = self.dpComman

            return cell


        }else if (indexPath.row == 2){
            let cell : cell_AddSchduler_TextView = tableView.dequeueReusableCell(withIdentifier: "id_cell_AddSchduler_TextView") as! cell_AddSchduler_TextView
            cell.tvDesc.delegate = self
            cell.tvDesc.tag = 2
            
            if cell.tvDesc.text  == "" ||  cell.tvDesc.text.isEmpty || cell.tvDesc.text == "Description here..."{
                cell.tvDesc.textColor = UIColor.lightGray
                cell.tvDesc.text = "Description here..."
            }
            
            if (self.dictData.value(forKey: "Desc") as! String).count > 0{
                cell.tvDesc.textColor = UIColor.black
                cell.tvDesc.text = self.dictData.value(forKey: "Desc") as? String
            }
            
            return cell
        }else if (indexPath.row == 3){
            let cell : cell_AddSchduler_Dropdown = tableView.dequeueReusableCell(withIdentifier: "id_cell_AddSchduler_Dropdown") as! cell_AddSchduler_Dropdown
            
            cell.txtDropdown.inputView = pvComman
            cell.txtDropdown.delegate = self
            cell.txtDropdown.placeholder = "Select Status"
            cell.txtDropdown.tag = 2
            
            if (self.dictData.value(forKey: "StatusIndex") as! String).count > 0{
                cell.txtDropdown.text = (self.arrStatusList.object(at: Int(self.dictData.value(forKey: "StatusIndex") as! String)!) as! NSDictionary).value(forKey: "Status") as? String
            }
            
            self.pvComman.tag = 2
            self.pvComman.delegate = self
            cell.txtDropdown.inputView = nil
            cell.txtDropdown.inputView = self.pvComman
            
            return cell
        }else{
            let cell : cell_AddSchduler_TextView = tableView.dequeueReusableCell(withIdentifier: "id_cell_AddSchduler_TextView") as! cell_AddSchduler_TextView
            cell.tvDesc.delegate = self
            cell.tvDesc.tag = 4
            if cell.tvDesc.text  == "" ||  cell.tvDesc.text.isEmpty || cell.tvDesc.text == "Status Comments"{
                cell.tvDesc.textColor = UIColor.lightGray
                cell.tvDesc.text = "Status Comments"
            }
            
            if (self.dictData.value(forKey: "StatusDesc") as! String).count > 0{
                cell.tvDesc.textColor = UIColor.black
                cell.tvDesc.text = self.dictData.value(forKey: "StatusDesc") as? String
            }

            return cell

        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    // MARK: -
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrStatusList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let strReturnString = (self.arrStatusList.object(at: row) as! NSDictionary).value(forKey: "Status") as? String
        return strReturnString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.dictData.setValue("\(row)", forKey: "StatusIndex")
    }
    // MARK: -
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing...\(textField.tag)")

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing...\(textField.tag)")
        if textField.tag == 0 {
            self.dpComman.tag = 0
        }else if textField.tag == 1 {
            self.dpComman.tag = 1
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing...\(textField.tag)")

        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing...\(textField.tag)")

        if textField.tag == 0{ // start Date
             let indexPath = NSIndexPath(row: 0, section: 0)
             self.tblMain.reloadRows(at: [indexPath as IndexPath], with: .none)
        }else if textField.tag == 1{ // end date
            let indexPath = NSIndexPath(row: 1, section: 0)
            self.tblMain.reloadRows(at: [indexPath as IndexPath], with: .none)
        }else if textField.tag == 2{ // Status
            let indexPath = NSIndexPath(row: 3, section: 0)
            self.tblMain.reloadRows(at: [indexPath as IndexPath], with: .none)
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
        
        if textView.text  == "" ||  textView.text.isEmpty || textView.text == "Description here..." || textView.text == "Status Comments"{
            textView.textColor = UIColor.black
            textView.text = ""
        }
//        else{
//            textView.text = "Description here..."
//            textView.textColor = UIColor.lightGray
//        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 2{ // description
            self.dictData.setValue(textView.text, forKey: "Desc")
        }else if textView.tag == 4{ // status description
            self.dictData.setValue(textView.text, forKey: "StatusDesc")
        }
    }
    
    // MARK: -

}
