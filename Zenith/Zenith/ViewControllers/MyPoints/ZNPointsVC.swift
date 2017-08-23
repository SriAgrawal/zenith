//
//  ZNPointsVC.swift
//  Zenith
//
//  Created by Anjali on 02/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit


let notificationName = Notification.Name("NotificationIdentifier")

class ZNPointsVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
  
    @IBOutlet var tableViewPoints: UITableView!
    
    var dataSourceArray = [Any]()

    var pagNo : String = "1"
    var pageSize : String = "10"
    var pagination = ZNPagination()
    var loadExecute = Bool()
    var totalPoints : String = ""

    //MARK:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
    }
    
    //MARK:- Helper Method
    func customInit()  {
        self.tableViewPoints.register(UINib(nibName: "ZNPointsTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNPointsTableViewCell")
        
        tableViewPoints.dataSource = self
        tableViewPoints.delegate = self
        //pagination.current_page = "1"
        //callApiMethodToGetMyPoints(pageNumber: pagination.current_page)

          }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pagination.current_page = "1"
        callApiMethodToGetMyPoints(pageNumber: pagination.current_page)
        

    }
    
    //MARK: - Tableview Delegates and Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNPointsTableViewCell") as? ZNPointsTableViewCell
        
        if cell1 == nil{
            cell1 = ZNPointsTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNPointsTableViewCell")
        }
        
        
        let dataDict:ZNRetailersInfo = (self.dataSourceArray[indexPath.row]as! ZNRetailersInfo)
        cell1?.itemNameLabel.text = dataDict.retailerName
        //cell1?.retailersImageView.image=UIImage(named: dataDict.value(forKey: retailerImage)as! String)
        cell1?.pointLabel.text = dataDict.retailerPoints
        cell1?.itemImageView.sd_setImage(with: URL(string:dataDict.retailerImage), placeholderImage: UIImage(named:"cover_image_placeholder"), options: .refreshCached)

        
      return cell1!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //TODO
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset <= 10.0) {
            if (self.pagination.current_page < self.pagination.max_page && loadExecute){
                loadExecute = false
                
                let stringNumber = pagination.current_page
                let numberFromString = Int(stringNumber)!+1
                let x : Int = numberFromString
                var myString = String(x)
                self.callApiMethodToGetMyPoints(pageNumber:myString)
                
            }
        }
    }
    
    
    func callApiMethodToGetMyPoints(pageNumber:String) -> Void {
        
        let paramDict = NSMutableDictionary()
        
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "10"
        
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KMyPoints) { (result :AnyObject?, error :NSError?) in
            
            let response = result as! NSDictionary
            
            if error == nil {
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    
                    self.totalPoints  = response.validatedValue("total_points", expected: "" as AnyObject) as! String
                    
                    if self.pagination.current_page == "1" {
                        self.dataSourceArray.removeAll()
                    }
                    
                
                    let dict = ["point": self.totalPoints]
                    let nsDict = dict as NSDictionary

                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyNotification"), object: nil, userInfo: nsDict as! [AnyHashable : Any])
                    
                    
                    if let dict = response.object(forKey: "category_list") as? NSArray {
                        
                        for rowItem in dict as! Array<Dictionary<String,Any>>{
                            
                            self.dataSourceArray += [ZNRetailersInfo .getMypoints(responseDict:rowItem as Dictionary<String, AnyObject>)]
                        }
                        
                        self.loadExecute = true
                    }
                    self.tableViewPoints.reloadData()
                }
                else {
                    //_ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                    self.tableViewPoints.reloadData()
                }
            }
            else {
                _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
            }
        }
    }
    
    

    //MARK:- Memory Warning Method    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
