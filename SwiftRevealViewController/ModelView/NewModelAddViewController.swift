//
//  NewModelAddViewController.swift
//  SwiftRevealViewController
//
//  Created by Devang Patel on 12/01/18.
//  Copyright © 2018 kkontus. All rights reserved.
//

import UIKit

class NewModelAddViewController: UIViewController ,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "cell_CatelogueName", bundle: nil)
        self.tblView.register(nib, forCellReuseIdentifier: "id_cell_CatelogueName")
        
        let nib1 = UINib(nibName: "Cell_ModelHeader", bundle: nil)
        self.tblView.register(nib1, forCellReuseIdentifier: "Cell_ModelHeader")
        
        let nibCell_AddessModel = UINib(nibName: "Cell_AddessModel", bundle: nil)
        self.tblView.register(nibCell_AddessModel, forCellReuseIdentifier: "Cell_AddessModel")
        
        let nibCell_ModelDetails = UINib(nibName: "Cell_ModelDetails", bundle: nil)
        self.tblView.register(nibCell_ModelDetails, forCellReuseIdentifier: "Cell_ModelDetails")
        
        // Do any additional setup after loading the view.
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        else if indexPath.row == 2
        {
            return 89
        }
        return 100
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell : Cell_ModelHeader = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelHeader") as! Cell_ModelHeader
            
            cell.scroll.contentSize = CGSize(width: tableView.frame.size.width * 3, height: cell.scroll.frame.size.height)
            // page control
            cell.scroll.delegate = self
            cell.pageControl.numberOfPages = 3
            cell.pageControl.addTarget(self, action: #selector(pageChanged(sender:)), for: .valueChanged)
            
            var x: CGFloat = 0
            for i in 1..<4 {
                let image = UIImageView(frame: CGRect(x: x + 0, y: 0, width: tableView.frame.size.width, height: cell.scroll.frame.size.height))
                image.image = UIImage(named: "\(i).jpg")
                image.contentMode = .scaleToFill // ALTERNATIVE:  .ScaleAspectFit
                cell.scroll.addSubview(image)
                x += tableView.frame.size.width
            }
            return cell
        }
        if indexPath.row == 1{
            
            let cell : cell_CatelogueName = tableView.dequeueReusableCell(withIdentifier: "id_cell_CatelogueName") as! cell_CatelogueName
            cell.txtTitle.placeholder = "NAME THE MODEL"
            return cell
        }
        if indexPath.row == 2{
            
            let cell : Cell_ModelDetails = tableView.dequeueReusableCell(withIdentifier: "Cell_ModelDetails") as! Cell_ModelDetails
            
            return cell
        }
        
        let cell : Cell_AddessModel = tableView.dequeueReusableCell(withIdentifier: "Cell_AddessModel") as! Cell_AddessModel
        cell.txtaddress.text = ""
      
        
        return cell
        
        
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }


}
