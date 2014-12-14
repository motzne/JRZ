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
    
    var path : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPath()
        refreshLogView()
    }

    func setPath() {
        let error_log = "error.log"
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        if (dirs != nil) {
            let directories:[String] = dirs!
            let dirs = directories[0];
            path = dirs.stringByAppendingPathComponent(error_log);
        }
    }
    
    @IBAction func deleteLogFile() {
        let fileManager : NSFileManager = NSFileManager.defaultManager()
        if (path != nil) {
            fileManager.removeItemAtPath(path!, error: nil)
            refreshLogView()
        }
    }
    
    func refreshLogView()
    {
        if (path != nil)
        {
            var error:NSError?
            let log_messages = String(contentsOfFile: path!, encoding:NSUTF8StringEncoding, error: &error)
            if(log_messages != nil) {
                logMessageBox.text = log_messages
            }
            else {
                logMessageBox.text = "No log messages found!"
            }
            
        }
        
        
    }
    
    //MARK: Form-Helpers
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}