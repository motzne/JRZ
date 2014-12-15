//
//  CreateUserController.swift
//  Jeder Rappen Zaehlt
//
//  Created by 2MT on 24.11.14.
//  Copyright (c) 2014 Erni Simon & Enz Tom. All rights reserved.
//

import Foundation
import UIKit


class CreateUserController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var kanton: UIPickerView!
    
    let dataTransmitter : DataTransmit = DataTransmit.sharedInstance
    
    var kantonsArray : NSMutableArray = NSMutableArray()
    
    var kantonData : Dictionary<String, String> = ["Luzern" :  "luzern",
        "Zug" :  "zug",
        "Nidwalden" :  "nidwalden",
        "Obwalden" :  "obwalden",
        "Uri" :  "uri",
        "Aargau" :  "aargau",
        "Appenzell I. Rh." :  "appenzel-inner",
        "Appenzell A. Rh." :  "appenzell-ausser",
        "Basel-Landschaft" :  "basel-land",
        "Basel-Stadt" :  "basel-stadt",
        "Bern" :  "bern",
        "Freiburg" :  "freiburg",
        "Genf" :  "genf",
        "Glarus" :  "glarus",
        "Graubünden" :  "graubuenden",
        "Jura" :  "jura",
        "Neuenburg" :  "neunburg",
        "Schaffhausen" :  "schaffhausen",
        "Schwyz" :  "schwyz",
        "Solothurn" :  "solothurn",
        "St. Gallen" :  "stgallen",
        "Tessin" :  "tessin",
        "Thurgau" :  "thurgau",
        "Waadt" :  "waadt",
        "Wallis" :  "wallis",
        "Zürich" :  "zurich"]
    
    var topKantone : NSMutableArray = ["Luzern", "Schwyz", "Zug", "Obwalden"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        kanton.dataSource = self;
        kanton.delegate = self;
        setupForm()
        
    }
    
    func initKantonsArray() {
        
        kantonsArray.addObjectsFromArray(topKantone)
        kantonsArray.addObject("____________")
        kantonsArray.addObjectsFromArray(kantonData.keys.array.sorted(<))
        
    }
    
    //MARK: Form-Helpers
    func setupForm() {
        firstname.text.removeAll()
        firstname.returnKeyType = .Done
        firstname.delegate = self
        sex.selectedSegmentIndex = 0;
        ageSlider.value = 42;
        ageLabel.text = "Alter: 42"
        kanton.reloadAllComponents()
        kanton.selectRow(0, inComponent: 0, animated: true)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: Page-Actions
    @IBAction func saveButtonPressed(sender: UIButton) {
        
        if(firstname.text != "") {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddhhmmss"
            
            let filename = dateFormatter.stringFromDate(NSDate()) + ".csv"
            
            let filepath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as String + "/" + filename
            
            if (filepath != "") {
                // Save data to file in format: Vorname;Geschlecht;Alter;Kanton
                var message : String = ""
                message += firstname.text + ";"
                message += String(sex.selectedSegmentIndex) + ";"
                message += String(Int(ageSlider.value)) + ";"
                message += String(kantonsArray[kanton.selectedRowInComponent(0)] as NSString)

                message.writeToFile(filepath, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
                
                // Add +1 to UserCreated_Counter
                let defaults = NSUserDefaults.standardUserDefaults()
                let UserCreated_Counter : Int = defaults.integerForKey("UserCreatedCounter")
                defaults.setInteger(UserCreated_Counter+1, forKey:"UserCreatedCounter")
                
                
                NSLog("Visitor \(message) saved to file: \(filepath)")
                
                let alertController = UIAlertController(title: "Daten gespeichert!", message: "Der Besucher wurde erfolgreich gespeichert.", preferredStyle: .Alert)
                let okayAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.setupForm()
                }
                
                dataTransmitter.startTransmit()
                
                alertController.addAction(okayAction)
                presentViewController(alertController, animated: true, completion: nil)
                
                
            }
        }
    }
    
    @IBAction func clearButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "Achtung Formular leeren", message: "Willst du das aktuelle Formular wirklich leeren? Nicht gespeicherte Daten gehen dabei verloren...", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .Cancel) { (action) in }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Leeren", style: .Destructive) { (action) in
            self.setupForm()
        }
        alertController.addAction(destroyAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func ageSliderChanged(sender: UISlider) {
        ageLabel.text = "Alter: \(Int(sender.value))";
    }
    
    
    //MARK: kantonPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (kantonsArray.count == 0)
        {
            initKantonsArray()
        }
        return kantonsArray.count
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        if (kantonsArray.count == 0)
        {
            initKantonsArray()
        }
        
        var kantonsName : String = kantonsArray[row] as String
        
        
        
        
        
        var tmpView = UIView(frame: CGRectMake(0, 0, 300, 24))
        
        var firstLabel  = UILabel(frame: CGRectMake(100, 0, 400, 24))
        firstLabel.text = kantonsName
        firstLabel.textColor = UIColor(red: 18/255.0, green: 106/255.0, blue: 149/255, alpha: 1.0)
        firstLabel.backgroundColor = UIColor.clearColor()
        
        if (kantonsName != "____________") {
            var bildName : String = kantonData[kantonsName]!
            var img = UIImage(named: bildName)
            var icon = UIImageView(image: img)
            icon.frame = CGRectMake(50, 0, 24, 24)
            
            tmpView.insertSubview(icon, atIndex: 0)
            tmpView.insertSubview(firstLabel, atIndex: 0)
            
        }
        return tmpView
        
    }
    
    
    
    
}