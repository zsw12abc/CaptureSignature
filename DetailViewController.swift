//
//  DetailViewController.swift
//  CaptureSignature
//
//  Created by ShaoweiZhang on 15/12/5.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class DetailViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signatureImage: UIImageView!
    
    var signImage: UIImage?;
    var name: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameLabel.text = name;
        signatureImage.image = signImage;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailButtonPressed(sender: AnyObject) {
        print("email button pressed");
        if MFMailComposeViewController.canSendMail(){
            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = self
            controller.setSubject("My Sigunare")
            controller.setToRecipients(["zswkiller@gmail.com"])
            controller.addAttachmentData(UIImageJPEGRepresentation(signImage!, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "signature.jpeg")
            controller.setMessageBody("thanks for using my app", isHTML: false)
            self.presentViewController(controller, animated: true, completion: nil)
        }else{
            print("cant send this email")
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
            switch result.rawValue{
            case MFMailComposeResultSent.rawValue:
                print("email has beed sent")
            case MFMailComposeResultCancelled.rawValue:
                print("email has been canceled")
            case MFMailComposeResultSaved.rawValue:
                print("email has been saved")
            case MFMailComposeResultFailed.rawValue:
                print("send failure")
            default:
                print("email didnt be sent")
                break
        }
    }
}

