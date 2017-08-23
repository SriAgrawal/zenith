//
//  ZNPaymentMethodVC.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 08/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNPaymentMethodVC: UIViewController, PayPalPaymentDelegate {
    
    //PayPal Variable Declaration and Initiallization
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    var payPalConfig    = PayPalConfiguration()
    @IBOutlet var paymentPopupView: UIView!
    @IBOutlet var cashOnDeliveryButton: UIButton!
    @IBOutlet var paymentViaPaypalButton: UIButton!
    @IBOutlet var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet var paymentLabel: UILabel!
    var isPaypal = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        self.paymentPopupView.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    //MARK: - helper method
    func initialMethod()
    {
        
        if UIScreen.main.bounds.width == 320 {
            self.viewTopConstraint.constant = 155
            self.paymentLabel.font = UIFont(name: "ITCKabelStd-Medium", size: 17)
            
        }
        //  PayPal Set Up
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "Awesome Shirts, Inc."
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
        
    }
    
    @IBAction func crossButtonClick(_ sender: UIButton) {
        self.view .endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    //Pay Via PayPal Button Action
    @IBAction func onPayViaPaypalClick(_ sender: UIButton) {
    
        isPaypal = true
        self.paymentViaPaypalButton.isSelected = true
        self.cashOnDeliveryButton.isSelected = false
        
    }
    
    // PayPalPaymentDelegate Method  //.......................................................
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
        })
    }
    
    
    @IBAction func okBtnAction(_ sender: UIButton) {
        
        //NotificationCenter.default.removeObserver("dismissPopUp")
        if paymentViaPaypalButton.isSelected == true {
            self.dismiss(animated: false, completion: nil)
            self.perform( #selector(postNotifi), with: nil, afterDelay: 0.1)
        }
        else{
            self.dismiss(animated: false, completion: nil)
            self.perform( #selector(postNotifi), with: nil, afterDelay: 0.1)
        }
    }
    
    @IBAction func OnCashOnDeliveryClick(_ sender: UIButton) {
        isPaypal = false
        self.paymentViaPaypalButton.isSelected = false
        self.cashOnDeliveryButton.isSelected = true
    }
    
    func postNotifi()  {
        //NotificationCenter.default.removeObserver(rawValue: "dismissPopUp")

        let dic:[String: Bool] = ["isPal": isPaypal]
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissPopUp"), object: nil, userInfo: dic)
    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyNotificationNew"), object: nil, userInfo: dic as! [AnyHashable : Any])

    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
