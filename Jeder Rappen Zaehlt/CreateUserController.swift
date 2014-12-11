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
    @IBAction func ageSliderChanged(sender: UISlider) {
        ageLabel.text = "Alter: \(Int(sender.value))";
    }
    let kantonData = ["Luzern","Zug","Nidwalden","Obwalden","Uri"]

 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        kanton.dataSource = self;
        kanton.delegate = self;
        self.setupForm()
    }

    
    func setupForm() {
        //TODO: Formular löschen
        firstname.text.removeAll()
        sex.selectedSegmentIndex = 0;
        ageSlider.value = 42;
        ageLabel.text = "Alter: 42"
        kanton.reloadAllComponents()
        kanton.selectRow(0, inComponent: 0, animated: true)
        

    }
//MARK: Page-Actions
    @IBAction func saveButtonPressed(sender: UIButton) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"

        let filename = dateFormatter.stringFromDate(NSDate()) + ".csv"
        let filepath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as String + "/" + filename
        NSLog(filepath)

        if (filepath != "") {
            //Vorname;Geschlecht;Alter;Kanton
            
            let message = "\(firstname.text);\(String(sex.selectedSegmentIndex));\(Int(ageSlider.value));\(kanton.selectedRowInComponent(0))"
           
            message.writeToFile(filepath, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
            
            NSLog(message)
        }
        
            
        
        
        
    }
    @IBAction func clearButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "8-ung: Formular leeren", message: "Willst du das aktuelle Formular wirklich leeren? Nicht gespeicherte Daten gehen dabei verloren...", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .Cancel) { (action) in
            println("User cancelled delete-action") //TODO: nichts machen?
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Leeren", style: .Destructive) { (action) in
            self.setupForm()
        }
        alertController.addAction(destroyAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }


    
//MARK: kantonPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kantonData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return kantonData[row]
    }
    

    
}