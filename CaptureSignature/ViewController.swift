//
//  ViewController.swift
//  CaptureSignature
//
//  Created by ShaoweiZhang on 15/12/5.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var drawView: YPDrawSignatureView!
    var alertView = UIAlertView();
    var sign: UIImage?;
    
    @IBOutlet weak var colorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clearButtonPressed(sender: UIButton) {
         drawView.clearSignature();
    }

    @IBAction func saveButtonPressed(sender: UIButton) {
        sign = drawView.getSignature();
        
        alertView.title = "Signature";
        alertView.message = "Please enter your name:";
        alertView.addButtonWithTitle("Cancel");
        alertView.addButtonWithTitle("Save");
        alertView.cancelButtonIndex = 0;
        alertView.delegate=self;
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput;
        alertView.show();
    }
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            print("Cancelled")
        } else {
            let name = alertView.textFieldAtIndex(0);
            print(name?.text);
            print(sign);
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            let newUser = NSEntityDescription.insertNewObjectForEntityForName("Users", inManagedObjectContext: context) as NSManagedObject
            do{
                newUser.setValue("\(name!.text!)", forKey: "name");
                newUser.setValue(sign, forKey: "signature");
                try context.save();
            } catch {
                print(error);
            }
            let request = NSFetchRequest(entityName: "Users");
            request.returnsObjectsAsFaults = false;
            do {
                let results = try context.executeFetchRequest(request);
                for result : AnyObject in results {
                    print(result.name!);
                    print(result.valueForKey("signature"));
                    print("*************");
                }
            }catch{
                print(error);
            }

        }
    }
    @IBAction func colorButtonPressed(sender: UIButton) {
        if drawView.color == UIColor.blackColor() {
            drawView.color = UIColor.redColor();
            colorButton.setTitle("Red", forState: .Normal)
            colorButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        } else if drawView.color == UIColor.redColor(){
            drawView.color = UIColor.blackColor();
            colorButton.setTitle("Black", forState: .Normal)
            colorButton.setTitleColor(UIColor.blackColor(), forState: .Normal);
        }
    }
}

