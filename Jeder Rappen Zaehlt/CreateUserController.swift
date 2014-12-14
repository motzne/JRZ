//
//  CreateUserController.swift
//  Jeder Rappen Zaehlt
//
//  Created by 2MT on 24.11.14.
//  Copyright (c) 2014 Erni Simon & Enz Tom. All rights reserved.
//

import Foundation
import UIKit


class CreateUserController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var kanton: UIPickerView!
    
    var kantonData : Dictionary<String, String> = ["Luzern" :  "luzern",
        "Zug" :  "zug",
        "Nidwalden" :  "nidwalden",
        "Obwalden" :  "obwalden",
        "Uri" :  "uri",
        "Aargau" :  "aargau",
        "Appenzell-Innerrhoden" :  "appenzel-inner",
        "Appenzell-Ausserrhoden" :  "appenzell-ausser",
        "Basel-Land" :  "basel-land",
        "Basel-Stadt" :  "basel-stadt",
        "Bern" :  "bern",
        "Fribourg" :  "freiburg",
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
        "Vaud" :  "waadt",
        "Wallis" :  "wallis",
        "Zürich" :  "zurich"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        kanton.dataSource = self;
        kanton.delegate = self;
        setupForm()
    }
    
    //MARK: Form-Helpers
    func setupForm() {
        firstname.text.removeAll()
        sex.selectedSegmentIndex = 0;
        ageSlider.value = 42;
        ageLabel.text = "Alter: 42"
        kanton.reloadAllComponents()
        kanton.selectRow(0, inComponent: 0, animated: true)
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
                let message = "\(firstname.text);\(String(sex.selectedSegmentIndex));\(Int(ageSlider.value));\(kanton.selectedRowInComponent(0))"
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
        return kantonData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return Array(kantonData.keys)[row]
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var key : String = Array(kantonData.keys).sorted(<)[row]  //Katonsname
        var value : String = Array(kantonData.values).sorted(<)[row] //Bild-Name
        var tmpView = UIView(frame: CGRectMake(0, 0, 300, 24))
        
        var firstLabel  = UILabel(frame: CGRectMake(100, 0, 400, 24))
        firstLabel.text = key
        firstLabel.textColor = UIColor(red: 18/255.0, green: 106/255.0, blue: 149/255, alpha: 1.0)
        firstLabel.backgroundColor = UIColor.clearColor()
        
        var img = UIImage(named: value)
        var icon = UIImageView(image: img)
        icon.frame = CGRectMake(50, 0, 24, 24)
        
        tmpView.insertSubview(icon, atIndex: 0)
        tmpView.insertSubview(firstLabel, atIndex: 0)
        return tmpView
        
    }
    
    
    
    
}