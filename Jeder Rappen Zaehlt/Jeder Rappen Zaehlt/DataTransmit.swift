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
        self.target = "http://api.jrz14.ch/add_besucher.php"
    }
    init( target : String) {
        self.target = target
    }
    
    
    func startTransmit() {

            let text = "some text"
            
            //writing
            text.writeToFile(path + "/test.csv", atomically: false, encoding: NSUTF8StringEncoding, error: nil);
            text.writeToFile(path + "/test2.csv", atomically: false, encoding: NSUTF8StringEncoding, error: nil);
            text.writeToFile(path + "/test3.csv", atomically: false, encoding: NSUTF8StringEncoding, error: nil);
            
            //reading
            //let text2 : String = String(contentsOfFile: file, encoding: NSUTF8StringEncoding, error: nil)!
        
            //NSLog(text2)
        
        
        //queue.addOperationWithBlock() {
          //  while(true) {
        NSLog(path)
                let enumerator : NSDirectoryEnumerator = self.fileManager.enumeratorAtPath(self.path)!
        while let element : String = enumerator.nextObject() as? String {
                    //NSLog("Element before suffix check" + element)
                    if element.hasSuffix("csv") {
                        NSLog("Element: " + element)
                    }
                }
          //  }
       // }
    }
    
    func stopTransmit() {
        
    }


    
}