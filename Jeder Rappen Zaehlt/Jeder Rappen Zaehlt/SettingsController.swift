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
    @IBOutlet weak var serverAdress: UITextField!
    @IBOutlet weak var serverToken: UITextField!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var serverPort: UITextField!
    @IBAction func statisticButtonPressed(sender: AnyObject) {
    }
    @IBAction func showLogButtonPressed(sender: AnyObject) {
    }
    @IBAction func closeButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}