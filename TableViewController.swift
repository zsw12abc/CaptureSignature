//
//  TableViewController.swift
//  CaptureSignature
//
//  Created by ShaoweiZhang on 15/12/5.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var signDic = [String: UIImage]();
    var signArray = Array<String>();
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshData();
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        refreshData();
    }
    
    func refreshData(){
        signDic = [String: UIImage]();
        signArray = Array<String>();
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Users");
        request.returnsObjectsAsFaults = false;
        do {
            let results = try context.executeFetchRequest(request);
            for result : AnyObject in results {
                print(result.name!);
                print(result.valueForKey("signature"));
                let name = result.name!;
                let signatureImage = result.valueForKey("signature") as! UIImage;
                signDic[name] = signatureImage;
                signArray.append(name);
                print("*************");
            }
        }catch{
            print(error);
        }
        tableView.reloadData();

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return signDic.count;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        let name = signArray[indexPath.row];
        let signImage = signDic[name];
        let image = cell.viewWithTag(102) as! UIImageView
        let title = cell.viewWithTag(101) as! UILabel
        title.text = name;
        image.image = signImage;
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let vc = segue.destinationViewController as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            if let index = indexPath {
                let name = signArray[index.row];
                vc.name = name;
                vc.signImage = signDic[name];
            }
        }
    }
    @IBAction func sortButtonPressed(sender: UIBarButtonItem) {
        print("sort button pressed");
        let len = signArray.count;
        for var i = 0; i < len - 1; i++ {
            for var j = 0; j < len - 1 - i; j++ {
                if signArray[j] > signArray[j + 1] {
                    let temp = signArray[j];
                    signArray[j] = signArray[j + 1];
                    signArray[j + 1] = temp;
                }
            }
        }
        print(signArray);
        tableView.reloadData();
    }
}


