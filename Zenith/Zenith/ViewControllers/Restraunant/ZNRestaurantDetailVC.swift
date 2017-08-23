//
//  ZNRestaurantDetailVC.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 03/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNRestaurantDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var restaurantInfo = ZNStoreInfo()
    var storeId = NSString()
    var addressId = NSString()
    var revardsArray = [String]()
    var rewardNumArray = [String]()

    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var restaurantDetailTableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var spaOffer: UIButton!

    @IBOutlet weak var bookAppointmentBtn: UIButton!
    @IBOutlet weak var OfferStoreBtn: UIButton!
    @IBOutlet weak var bookTableBtn: UIButton!
    @IBOutlet weak var takeAwayOrderBtn: UIButton!
    @IBOutlet weak var offerResturantBtn: UIButton!
    
    @IBOutlet weak var twoBtnView: UIView!
    @IBOutlet weak var threeBtnView: UIView!
    @IBOutlet weak var fourBtnView: UIView!
    
    
    //MARK: - UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        self.navigationController?.isNavigationBarHidden = true
        restaurantDetailTableView.tableHeaderView = headerView
        self.restaurantDetailTableView.tableFooterView = UIView(frame: CGRect.zero)

        //Set exclusive touch
         callBtn.isExclusiveTouch = true
        mapBtn.isExclusiveTouch = true
         shareBtn.isExclusiveTouch = true
        
        self.twoBtnView.isHidden = true
        self.threeBtnView.isHidden = true
        self.fourBtnView.isHidden = true
        self.OfferStoreBtn.isHidden = true
        
        //register cell
        self.restaurantDetailTableView.register(UINib(nibName: "ZNStoreDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNStoreDetailTableViewCell")
    self.restaurantDetailTableView.register(UINib(nibName:"ZNStoreUserInfoTableCell", bundle: nil), forCellReuseIdentifier: "ZNStoreUserInfoTableCell")
        self.restaurantDetailTableView.register(UINib(nibName:"ZNJoinUsTableCell", bundle: nil), forCellReuseIdentifier: "ZNJoinUsTableCell")
        
        rewardNumArray = ["1.", "2.", "3."]
        
        self.restaurantDetailTableView.estimatedRowHeight = 100
        self.restaurantDetailTableView.rowHeight = UITableViewAutomaticDimension
        
        callApiMethodToGetStoreDetails(storeID: storeId)
    }
    
    //MARK: - UITableView DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return rewardNumArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch indexPath.section {
        case 0:
            return 55
        case 1:
            return 100
        case 2:
            return self.restaurantDetailTableView.rowHeight
        default:
            return self.restaurantDetailTableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        restaurantDetailTableView.allowsSelection = true
        switch indexPath.section {
        case 0:
            var upperCell = tableView.dequeueReusableCell(withIdentifier:"ZNStoreUserInfoTableCell") as? ZNStoreUserInfoTableCell
            
            
            if upperCell == nil {
                upperCell = ZNStoreUserInfoTableCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNStoreUserInfoTableCell")
            }
            upperCell?.selectionStyle = .none
            
            switch indexPath.row {
            case 0:
                upperCell?.storeUserTitleLbl.text = "Email"
                upperCell?.storeUserInfoLbl.text = restaurantInfo.storeEmail
                break
            case 1:
                upperCell?.storeUserTitleLbl.text = "Address"
                upperCell?.storeUserInfoLbl.text = restaurantInfo.storeAddress
                break
            case 2:
                upperCell?.storeUserTitleLbl.text = "Website"
                upperCell?.storeUserInfoLbl.text = restaurantInfo.storeWebsite
                break
            default: break
            }
          
            return upperCell!
        case 1:
            var joinCell = tableView.dequeueReusableCell(withIdentifier:"ZNJoinUsTableCell") as? ZNJoinUsTableCell
            joinCell?.selectionStyle = .none
            if joinCell == nil {
                joinCell = ZNJoinUsTableCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNJoinUsTableCell")
            }
            
            joinCell?.joinBtn.addTarget(self,action:#selector(joinBtnAction),
                                        for:.touchUpInside)
            if #available(iOS 10.0, *) {
                joinCell?.fbBtn.addTarget(self,action:#selector(faceBookUrl(_:)),
                                          for:.touchUpInside)
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 10.0, *) {
                joinCell?.twitterBtn.addTarget(self,action:#selector(twitterUrl(_:)),
                                               for:.touchUpInside)
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 10.0, *) {
                joinCell?.instagramBtn.addTarget(self,action:#selector(instagramUrl(_:)),
                                                 for:.touchUpInside)
            } else {
                // Fallback on earlier versions
            }
            return joinCell!
            
        case 2:
            var cell = tableView.dequeueReusableCell(withIdentifier:"ZNStoreDetailTableViewCell") as? ZNStoreDetailTableViewCell
            
            if cell == nil {
                cell = ZNStoreDetailTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNStoreDetailTableViewCell")
            }
            
            // cell?.rewardLabel.setLineHeight(lineHeight: 25)
            cell?.selectionStyle = .none
            cell?.storeAddressLabel.text = "On a purchasing of $500 you will get a 50 points."
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "Valid until 08/09/2017")
            attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(colorLiteralRed: 0, green: 183/255, blue: 251/255, alpha: 1.0), range: NSMakeRange(11, (attrString.length-11)))
            
            cell?.storeDistanceLabel.attributedText = attrString
            return cell!
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier:"ZNStoreDetailTableViewCell") as? ZNStoreDetailTableViewCell
            return cell!
        }
    }
    
    //MARK: - UIButton Action Method
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func myRewardsButtonAction(_ sender: Any) {
        let vcObj = ZNRestaurantRewardsVC()
        vcObj.storeId = self.restaurantInfo.storeId
        vcObj.storeImage = self.restaurantInfo.storeImage
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    func joinBtnAction() {
        
        if (restaurantInfo.storeJoin == "1"){
            _ = AlertController.alert("", message: "Store already joined")
        }
        else{
            callApiMethodToJoinStore(storeID: self.storeId)
        }
    }
    
    @IBAction func orderTakeAwayButtonAction(_ sender: UIButton) {
        let vcObj = ZNDishListViewController()
        vcObj.storeId = self.restaurantInfo.storeId
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func bookTableButtonAction(_ sender: UIButton) {
        let vcObj = ZNBookATableVC()
        vcObj.storeId = self.storeId as NSString
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func offerBtnAction(_ sender: UIButton) {
        let vcObj = ZNOffersLoyalityEarnedVC()
        vcObj.storeId = storeId as String
        vcObj.isFrom = false
        self.navigationController?.pushViewController(vcObj, animated: true)
        
    }
    @IBAction func bookAppointmentAction(_ sender: Any) {
        let vcObj = ZNBookAppointmentVC()
        vcObj.storeId = self.storeId
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
  
    @IBAction func callButtonAction(_ sender: UIButton) {
        callLabel.backgroundColor = UIColor.white
        mapLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        shareLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)

        if let phoneCallURL = URL(string: "tel://\(restaurantInfo.storeContactNo)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            } else {
                print("call failed")
            }
        }
    }
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        callLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        mapLabel.backgroundColor = UIColor.white
        shareLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        
        let vcObj = ZNRouteMapVC()
        vcObj.navtitle = self.navTitleLabel.text! as NSString
        vcObj.destinationLat = restaurantInfo.storeLat as NSString;
        vcObj.destinationLong = restaurantInfo.storeLong as NSString;
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        callLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        mapLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        shareLabel.backgroundColor = UIColor.white
        
        // text to share
        let text = "This is some text that I want to share."
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }


    @available(iOS 10.0, *)
    func faceBookUrl(_ sender: UIButton) -> Void {
        if (restaurantInfo.storeFacebook.length != 0) {
        UIApplication.shared.open(URL (string: restaurantInfo.storeFacebook)! , options: [:], completionHandler: nil)
        }
    
    }
    @available(iOS 10.0, *)
    func twitterUrl(_ sender: UIButton) -> Void {
        if (restaurantInfo.storeTwitter.length != 0) {
           UIApplication.shared.open(URL (string: restaurantInfo.storeTwitter)! , options: [:], completionHandler: nil)
        }
    }
    @available(iOS 10.0, *)
    func instagramUrl(_ sender: UIButton) -> Void {
        if (restaurantInfo.storeInstagram.length != 0) {
               UIApplication.shared.open(URL (string: restaurantInfo.storeInstagram)! , options: [:], completionHandler: nil)
        }
    }
    
    //MARK: - WebService Method
    
    func callApiMethodToGetStoreDetails(storeID: NSString!) {
        
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = storeID
        paramDict[KAddress_Id] = addressId
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KStoreDetail) { (result :AnyObject?, error :NSError?) in
            let response = result as! NSDictionary
            
            if error == nil {
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                   self.restaurantInfo = self.parseStoreDataWithList(storeDic: response.object(forKey: KStoreDetail ) as! NSDictionary) as ZNStoreInfo
                    self.callSetUpIntitalView()
                    self.restaurantDetailTableView.reloadData()
                }
                else {
                    _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                }
            }
            else {
                _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
            }
        }
    }
    
    func callApiMethodToJoinStore(storeID: NSString!) {
        
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = storeID
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KJoinStore) { (result :AnyObject?, error :NSError?) in
            let response = result as! NSDictionary
            
            if error == nil {
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                }
                else {
                    _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                }
            }
            else {
                _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
            }
        }
    }
    
    func parseStoreDataWithList(storeDic:NSDictionary) -> ZNStoreInfo{
            let storeObject = ZNStoreInfo()
            storeObject.storeName = storeDic.validatedValue(KStore_Name, expected: "" as AnyObject) as! String
            storeObject.storeId = storeDic.validatedValue(KStore_Id, expected: "" as AnyObject) as! String
            storeObject.storeImage = storeDic.validatedValue(KCover_Image, expected: "" as AnyObject) as! String
            storeObject.storeEmail = storeDic.validatedValue(Kemail, expected: "" as AnyObject) as! String
            storeObject.storeContactNo = storeDic.validatedValue(KPhoneNumber, expected: "" as AnyObject) as! String
         storeObject.storeAddress = "\(storeDic.validatedValue(KAddress, expected: "" as AnyObject)), \(storeDic.validatedValue(KCity, expected: "" as AnyObject)), \(storeDic.validatedValue(Kcountry, expected: "" as AnyObject))"
         storeObject.book_appointment = storeDic.validatedValue(KBook_Appointment, expected: "" as AnyObject) as! String
            storeObject.book_table = storeDic.validatedValue(KBook_Table, expected: "" as AnyObject) as! String
            storeObject.order_take_away = storeDic.validatedValue(KOrder_Take_Away, expected: "" as AnyObject) as! String
            storeObject.storeLat = storeDic.validatedValue(KLatitude, expected: "" as AnyObject) as! String
            storeObject.storeLong = storeDic.validatedValue("langitude", expected: "" as AnyObject) as! String
            storeObject.storeRewards = storeDic.validatedValue(KReward, expected: "" as AnyObject) as! String
            storeObject.storeJoin = storeDic.validatedValue(KStore_Join, expected: "" as AnyObject) as! String
          storeObject.storeWebsite = storeDic.validatedValue(KWebsite, expected: "" as AnyObject) as! String
          storeObject.storeFacebook = storeDic.validatedValue(KFacebook_Link, expected: "" as AnyObject) as! String
          storeObject.storeTwitter = storeDic.validatedValue(KTwitter, expected: "" as AnyObject) as! String
          storeObject.storeInstagram = storeDic.validatedValue(KInstagram, expected: "" as AnyObject) as! String
        
        return storeObject
    }
    
    func callSetUpIntitalView() {
        
         restaurantImageView.sd_setImage(with: URL(string: restaurantInfo.storeImage), placeholderImage: UIImage(named: "crownPlaza"), options: SDWebImageOptions.refreshCached)
        navTitleLabel.text = restaurantInfo.storeName
        
        if (restaurantInfo.book_table == "0" && restaurantInfo.book_appointment == "0" && restaurantInfo.order_take_away == "0") {
            self.twoBtnView.isHidden = true
            self.threeBtnView.isHidden = true
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = false
   
        }
        else if (restaurantInfo.book_table == "0" && restaurantInfo.book_appointment == "0" && restaurantInfo.order_take_away == "1" )
        {
            //Appointment
            self.twoBtnView.isHidden = false
            self.threeBtnView.isHidden = true
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }
        else if (restaurantInfo.book_table == "0" && restaurantInfo.book_appointment == "1" && restaurantInfo.order_take_away == "0" )
        {
            //Appointment
            self.twoBtnView.isHidden = false
            self.threeBtnView.isHidden = true
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }else if (restaurantInfo.book_table == "0" && restaurantInfo.book_appointment == "1" && restaurantInfo.order_take_away == "1" )
        {
            //Appointment
            self.twoBtnView.isHidden = true
            self.threeBtnView.isHidden = false
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }else if (restaurantInfo.book_table == "1" && restaurantInfo.book_appointment == "0" && restaurantInfo.order_take_away == "0" )
        {
            //Appointment
            self.twoBtnView.isHidden = false
            self.threeBtnView.isHidden = true
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }else if (restaurantInfo.book_table == "1" && restaurantInfo.book_appointment == "0" && restaurantInfo.order_take_away == "1" )
        {
            //Appointment
            self.twoBtnView.isHidden = true
            self.threeBtnView.isHidden = false
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }else if (restaurantInfo.book_table == "1" && restaurantInfo.book_appointment == "1" && restaurantInfo.order_take_away == "0" )
        {
            //Appointment
            self.twoBtnView.isHidden = true
            self.threeBtnView.isHidden = false
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }
        else{
            self.twoBtnView.isHidden = true
            self.threeBtnView.isHidden = true
            self.fourBtnView.isHidden = false
            self.OfferStoreBtn.isHidden = false
        }
    }
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

