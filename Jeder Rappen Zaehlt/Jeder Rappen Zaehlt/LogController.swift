//
//  LogController.swift
//  Jeder Rappen Zaehlt
//
//  Created by 2MT on 11.12.14.
//  Copyright (c) 2014 Erni Simon & Enz Tom. All rights reserved.
//

import Foundation
import UIKit

class LogController: UIViewController {
    
    
    @IBOutlet weak var logMessageBox: UITextView!
    
    let error_log = "error.log"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        if (dirs != nil) {
            let directories:[String] = dirs!
            let dirs = directories[0];
            let path = dirs.stringByAppendingPathComponent(error_log);
            
            //reading
            var error:NSError?
            let log_messages = String(contentsOfFile: path, encoding:NSUTF8StringEncoding, error: &error)
            if(log_messages != nil) {
                logMessageBox.text = log_messages
            }
            else {
                logMessageBox.text = "No log messages found!"
            }
            
        }
    }
    
    //MARK: Form-Helpers
    @IBAction func deleteLogFile() {
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        if (dirs != nil) {
            let directories:[String] = dirs!
            let dirs = directories[0];
            let path = dirs.stringByAppendingPathComponent(error_log);
            
            let fileManager : NSFileManager = NSFileManager.defaultManager()
            fileManager.removeItemAtPath(path, error: nil)
            logMessageBox.text = "No log messages found!"
        }
    }
    
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}