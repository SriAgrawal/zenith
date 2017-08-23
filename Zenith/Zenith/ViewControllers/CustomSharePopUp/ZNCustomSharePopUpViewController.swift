//
//  ZNCustomSharePopUpViewController.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 10/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import  Social
import MessageUI

class ZNCustomSharePopUpViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var sharefbBtn: UIButton!
    @IBOutlet weak var shareEmailBtn: UIButton!
    
    //MARK: - UIVirewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        btnView.layer.cornerRadius = 8
        cancelBtn.layer.cornerRadius = 8
        sharefbBtn.layer.cornerRadius = 8
        shareEmailBtn.layer.cornerRadius = 8
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("Write your email here...", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        _ = AlertController.alert("Could Not Send Email", message:  "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    // MARK: MFMailComposeViewControllerDelegate
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UIButton Action Method
    @IBAction func shareViaFbBtnAction(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Share on Facebook")
            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareViaEmailBtnAction(_ sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
