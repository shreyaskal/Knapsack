//
//  Query.swift
//  Knapsack
//
//  Created by Shreyas Kalyan on 10/4/14.
//  Copyright (c) 2014 Shreyas Kalyan. All rights reserved.
//

import Foundation

class Query{
    let address : String;
    let city : String;
    let state : String;
    let zip  : Int;
    let price : Double;
    
    
    
    init (a : String, c : String, s : String, z: Int, p: Double){
        address = a;
        city = c;
        state = s;
        zip = z;
        price = p;
    }
    
    var myOrdrin = Ordrin(apiKey: "orqweJcnpgD4mxVRPKRTGAVbTGab33DlqqEDllP4Bck", environment: "test")
    
    func testOrdrin() {
        //delivery list test
        var myDict = Dictionary<String, String>()
        var wait = true
        var blank : AnyObject?;
        myDict["datetime"] = "ASAP";
        myDict["zip"] = "08820";
        myDict["city"] = "Edison";
        myDict["addr"] = "14 Annette Drive";
        myOrdrin.delivery_list(myDict, callback: {(error: NSError?, data: AnyObject?) -> () in
            println("success")
            blank = data
            println("data:  \(data)")
            wait = false
        })

        println("data:  \(blank)")

    }

    
    func callOrdrin() {
        var myDictionary : [String: String] = ["datetime" : "ASAP", "addr" : address, "city" : city, "zip" : String(zip)]
        
        
        var wait: Bool = true
        
        var ordrin = Ordrin(apiKey: "8Ny6jRdXfw3we6laZh1eoet6ypvMEY_5texkay0O5-w", environment: "test");
        
        var er : NSError?;
        var dtny : AnyObject?;
        
        ordrin.delivery_list(myDictionary, callback: {(error: NSError?, data: AnyObject?) -> () in
            wait = false
            dtny = data
            er = error
        })
        
        // Keeps giving me nil for data - will try and fix server connection
        
        waitFor(&wait)
        
        
        
        
        let dataSTR = ["id" : 26981, "na" : "PASTA POMODORO", "cs_phone" : "800-951-3663", "allow_tip" : 1, "allow_asap" : "yes", "addr": "146 SUNSET DRIVE", "city": "SAN RAMON", "postal_code": "94583"]
        
        var x : Int = dataSTR["id"] as Int
        
        var parm : [String : String] = ["rid" : String(x)]
        
        ordrin.restaurant_details(parm, callback: {(error: NSError?, data: AnyObject?) -> () in
        })
        
        
        
        
        
        
    }
    
    func waitFor (inout wait: Bool){
        while(wait){
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 0.1))
        }
    }

}
    
    
