//
//  DataTransmit.swift
//  Jeder Rappen Zaehlt
//
//  Created by Simon Erni on 11.12.14.
//  Copyright (c) 2014 Erni Simon & Enz Tom. All rights reserved.
//

import Foundation

class DataTransmit {
    
    var target : String
    
    let queue = NSOperationQueue()
    let path : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as String
    
    let fileManager : NSFileManager = NSFileManager.defaultManager()
    
    
    init() {
        self.target = "http://api.jrz14.ch/registration_add.php"
    }
    init( target : String) {
        self.target = target
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
                post(self.path + "/" + element)
            }
        }
        
    }
    
    func post(filePath : String)
    {
        var request = NSMutableURLRequest(URL: NSURL(string: target)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let text : String = String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: nil)!
        
        var paramsArray = text.componentsSeparatedByString(";")
        if (paramsArray.count == 4)
        {
            var params = ["vorname":paramsArray[0], "geschlecht":paramsArray[1], "alter":paramsArray[2], "kanton":paramsArray[3]] as Dictionary
            
            var err: NSError?
            
            //Build the HTTP Body with all the required Parameters
            var http_body = ("vorname=" + paramsArray[0])
            http_body = http_body + ("&geschlecht=" + paramsArray[1])
            http_body = http_body + ("&alter=" + paramsArray[2])
            http_body = http_body + ("&kanton=" + paramsArray[3])
            
            request.HTTPBody = http_body.dataUsingEncoding(NSUTF8StringEncoding)
            
            //Content-Type Header
            request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            
            //Answer Content-Type
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //Create Asynchronious Task
            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                if(error == nil) {
                    
                }
                
                
                NSLog("Response: \(response)")
                
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                NSLog("Body: \(strData)\n\n")
                
                //NSLog(error.description)
                
                /* var err: NSError?
                
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
                
                // json = {"response":"Success","msg":"User login successfully."}
                if((err) != nil) {
                NSLog(err!.localizedDescription)
                }
                else {
                var success = json["response"] as? String
                NSLog("Succes: \(success)")
                if json["response"] as NSString == "Success"
                
                {
                NSLog("Login Successfull")
                }
                var responseMsg=json["msg"] as String
                }*/
            })
            task.resume()
        }
    }
    
    func stopTransmit() {
        
    }
    
    
    
}