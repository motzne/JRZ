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
    @IBOutlet weak var serverPort: UITextField!
    @IBOutlet weak var versionLabel: UILabel!

    @IBAction func statisticButtonPressed(sender: AnyObject) {
    }
    @IBAction func showLogButtonPressed(sender: AnyObject) {
    }
    @IBAction func closeButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})

    }
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        let version : AnyObject! = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")
    
        serverAddress.text =  defaults.objectForKey("serverAddress") as? String
        serverPort.text =  defaults.objectForKey("serverPort") as? String
        serverToken.text =  defaults.objectForKey("serverToken") as? String

        versionLabel.text = version.description

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(animated: Bool) {
        saveServerSettings()

    }
    
    func saveServerSettings(){
        defaults.setObject(serverAddress.text, forKey:"serverAddress")
        defaults.setObject(serverPort.text, forKey:"serverPort")
        defaults.setObject(serverToken.text, forKey:"serverToken")
        defaults.synchronize()
    }
   
    
    
}