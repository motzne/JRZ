//
//  Logger.swift
//  Jeder Rappen Zaehlt
//
//  Created by Simon Erni on 14.12.14.
//  Copyright (c) 2014 Erni Simon & Enz Tom. All rights reserved.
//

import Foundation

class Logger {
    
    let error_log = "error.log"
    var logFilePath : String
    let fileManager : NSFileManager = NSFileManager.defaultManager()
    
    init() {
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        if (dirs != nil) {
            let directories:[String] = dirs!
            logFilePath = directories[0].stringByAppendingPathComponent(error_log);
        }
        else {
            logFilePath = "";
        }
    }
    
    func log(message : String)
    {
        
        NSLog(message)
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy - HH:mm"
        
        var messageForFile = "[" + dateFormatter.stringFromDate(NSDate()) + "]" + message + "\r\n"
        
        if(!fileManager.fileExistsAtPath(logFilePath))
        {
            objc_sync_enter(self)
            messageForFile.writeToFile(logFilePath, atomically:true, encoding:NSUTF8StringEncoding, error:nil);
            objc_sync_exit(self)
        }
        else
        {
            var fileHandle : NSFileHandle = NSFileHandle(forWritingAtPath:logFilePath)!
            fileHandle.seekToEndOfFile()
            objc_sync_enter(self)
            fileHandle.writeData((messageForFile as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            objc_sync_exit(self)
        }
    }
}
