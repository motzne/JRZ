//
//  DataTransmit.swift
//  Jeder Rappen Zaehlt
//
//  Created by Simon Erni on 11.12.14.
//  Copyright (c) 2014 Erni Simon & Enz Tom. All rights reserved.
//

//TODO: Sync Knopf


import Foundation

class DataTransmit {
    
    var apiURL : String
    var logger : Logger
    let queue = NSOperationQueue()
    let path : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as String
    
    let fileManager : NSFileManager = NSFileManager.defaultManager()
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    init(logger : Logger) {
        
        if let url : String = defaults.objectForKey("serverAddress") as String?{
            self.apiURL = url + "/registration_add.php"
         } else {
            self.apiURL = ""
        }
        self.logger = logger
    }
    
    /**
    * Start den Übermittlungsvorgang. Ruft für alle Files im "Caches" Ordner nach, ob da irgendwelche Files mit .csv liegen - wenn ja, sendet es diese an den JRZ Server.
    *
    */
    func startTransmit() {
        NSLog(path)
        let enumerator : NSDirectoryEnumerator = self.fileManager.enumeratorAtPath(self.path)!
        while let element : String = enumerator.nextObject() as? String {
            if element.hasSuffix("csv") {
                post(self.path + "/" + element, time:element)
            }
        }
        
    }
    
    func refreshLastSuccesfulTransmit()
    {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy - HH:mm"
        
        defaults.setObject(dateFormatter.stringFromDate(NSDate()), forKey: "lastUploadedDate")
        
    }
    
    func postFinished(filePath : String, success:Bool, message:String)
    {
        if(success)
        {
            self.logger.log(filePath.lastPathComponent + " transmitted!")
            let fileManager : NSFileManager = NSFileManager.defaultManager()
            fileManager.removeItemAtPath(filePath, error: nil)
            
            refreshLastSuccesfulTransmit()
            
        } else {
            logger.log(filePath.lastPathComponent + " failed! " + message)
        }
    }
    
    //Path to the CSV separated File which has to be submitted to the Server with the Timestamp when it has been created.
    func post(filePath : String, time : String)
    {
        var request = NSMutableURLRequest(URL: NSURL(string: apiURL)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let text : String = String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: nil)!
        
        var paramsArray = text.componentsSeparatedByString(";")
        
        //Check if all required parameters are there. If not, just discard the message.
        if (paramsArray.count == 4)
        {
            
            //Build the HTTP Body with all the required Parameters
            var httpBody = ""
            httpBody += ("vorname=" + paramsArray[0])
            httpBody += ("&geschlecht=" + paramsArray[1])
            httpBody += ("&alter=" + paramsArray[2])
            httpBody += ("&kanton=" + paramsArray[3])
            //ToDo: Supply Timestamp
            //httpBody += ("&timestamp=" + paramsArray[3])
            
            request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
            
            //Content-Type Header
            request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            
            //Answer Content-Type
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            
            //Create Asynchronious Task
            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                
                //JSONObjectWithData successful?
                if(err != nil) {
                    self.postFinished(filePath, success:false, message:err!.localizedDescription)
                    return
                }
                
                //json is optionally bounded. So, check for value:
                if let parseJSON = json {
                    
                    //Is there a "response" in the JSON?
                    if let response = parseJSON["response"] as? String {
                        if (response != "Success")
                        {
                            self.postFinished(filePath, success: false, message: response)
                            return
                        }
                        //Here everything went good.
                        self.postFinished(filePath, success: true, message: "OK")
                        return
                    }
                    else {
                        self.postFinished(filePath, success: false, message: "Answering JSON doesn't have a response part.")
                        return
                    }
                }
                else {
                    //JSON is nil
                    self.postFinished(filePath, success: false, message: "JSON war null")
                    return
                }
            })
            task.resume()
        }
    }
}