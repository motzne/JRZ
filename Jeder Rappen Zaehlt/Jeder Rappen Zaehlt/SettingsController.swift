//
//  SettingsController.swift
//  Jeder Rappen Zaehlt
//
//  Created by 2MT on 24.11.14.
//  Copyright (c) 2014 Erni Simon & Enz Tom. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: UIViewController {
    @IBOutlet weak var serverAddress: UITextField!
    @IBOutlet weak var serverToken: UITextField!
    //@IBOutlet weak var serverPort: UITextField!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var lastUploadDate: UILabel!
    @IBOutlet weak var countUserCreated: UILabel!
    @IBOutlet weak var countQueueEntries: UILabel!

    let defaults = NSUserDefaults.standardUserDefaults()
    let version : AnyObject! = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")


    override func viewDidLoad() {
        super.viewDidLoad()
        serverAddress.text =  defaults.objectForKey("serverAddress") as? String
        //serverPort.text =  defaults.objectForKey("serverPort") as? String
        serverToken.text =  defaults.objectForKey("serverToken") as? String
        countUserCreated.text =  String(defaults.integerForKey("UserCreatedCounter"))
        countQueueEntries.text =  String(countQueuedFiles())
        lastUploadDate.text =  defaults.objectForKey("lastUploadedDate") as? String
        versionLabel.text = version.description

    }
    
    override func viewDidDisappear(animated: Bool) {
        saveServerSettings()
    }

//MARK: Form-Helpers
    func countQueuedFiles() -> Int{
       
        let path : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as String
        
        let fileManager : NSFileManager = NSFileManager.defaultManager()
        let enumerator : NSDirectoryEnumerator = fileManager.enumeratorAtPath(path)!
        var counter : Int = 0

        while let element : String = enumerator.nextObject() as? String {
            if element.hasSuffix("csv") {
                counter +=  1
            }
        }
        
        return counter
    }
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func syncNowButtonPressed(sender: AnyObject) {
        DataTransmit.sharedInstance.startTransmit()
    }
    
    func saveServerSettings(){
        defaults.setObject(serverAddress.text, forKey:"serverAddress")
        //defaults.setObject(serverPort.text, forKey:"serverPort")
        defaults.setObject(serverToken.text, forKey:"serverToken")
        defaults.synchronize()
    }
    
}