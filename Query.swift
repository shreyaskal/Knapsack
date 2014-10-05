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
    
    var myOrdrin = Ordrin(apiKey: "0Ka68GZZLRSf6Jyo4gaXAzUqh0NttEbvjVDdvnHghFo", environment: "test")
    
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

    
    func callOrdrin() -> [String?]{
        var myDictionary : Dictionary<String, String> = ["datetime" : "ASAP", "addr" : address, "city" : city, "zip" : String(zip)]
        
        
        var wait: Bool = true
        
        var ordrin = Ordrin(apiKey: "0Ka68GZZLRSf6Jyo4gaXAzUqh0NttEbvjVDdvnHghFo", environment: "test");
        
        var er : NSError?;
        var dtny : AnyObject?;
        
        ordrin.delivery_list(myDictionary, callback: {(error: NSError?, data: AnyObject?) -> () in
            wait = false
            dtny = data
            er = error
            
        })
        
        
        waitFor(&wait)

        
        var hash : [Dictionary<String, AnyObject>] = dtny as [Dictionary<String, AnyObject>];
        
        if (hash.count > 1) {
            hash.removeRange(1...hash.count - 1)
        }
        
        println(hash.count)
        var rest1 = hash[0]

        var restID: AnyObject? = rest1["id"]
        var rID : Int = 0;
        if (restID != nil){
             rID = restID as Int!
        }
        
        var restDictionary = ["rid" : String(rID)]
        println(rID)
        

        
        ordrin.restaurant_details(restDictionary, callback: {(error: NSError?, data: AnyObject?) -> () in
            wait = false;
            
            dtny = data;
            
            println("Data: \(dtny)")
            
        })
        
        
        
        

//        
//        var x : Int = dataSTR["id"] as Int
//        println(String(x))
//        
//        var parm : [String : String] = ["rid" : String(x)]
//        
//        ordrin.restaurant_details(parm, callback: {(error: NSError?, data: AnyObject?) -> () in
//            wait = false;
//        })
        
        waitFor(&wait)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        var appitizers : [Dictionary<String, String>] = []
        
        
        
        var dataSTR2 : [String : String] = ["id" : "35193047", "is_orderable" : "1", "name" : "Gamberi Appetizer",
            "price" : "9.75", "descrip" : "Gulf shrimp sauteed in an iron skillet with tomato, garlic and chili, served with grilled bread."]
        appitizers.append(dataSTR2)
        
        dataSTR2 = ["descrip" :  "Local tomatoes layered with Belgioso mozzarella, fresh basil and a balsamic reduction." , "id" : "35193049", "is_orderable" : "1", "name" : "Caprese (Small)", "price" : "7.00"]
        appitizers.append(dataSTR2)

        dataSTR2 = ["descrip": "Local tomatoes layered with Belgioso mozzarella, fresh basil and a balsamic reduction.",
            "id": "35193048",
            "is_orderable": "1",
            "name": "Caprese (Large)",
            "price": "10.00"]
        appitizers.append(dataSTR2)

        dataSTR2 = ["descrip": "P.E.I. mussels sauteed in white wine, fresh herbs, garlic and butter.",
            "id": "35193050",
            "is_orderable": "1",
            "name": "Cozze Appetizer (P.E.I. Mussels)",
            "price": "10.25"]
        appitizers.append(dataSTR2)
        
        dataSTR2 = ["descrip": "P.E.I. mussels sauteed in white wine, fresh herbs, garlic and butter.",
            "id": "35193050",
            "is_orderable": "1",
            "name": "Cozze Appetizer (P.E.I. Mussels)",
            "price": "10.25"]
        appitizers.append(dataSTR2)
        
        dataSTR2 = ["descrip": "Manila clams sauteed in white wine, fresh herbs, garlic and butter.",
        "id": "35193051",
        "is_orderable": "1",
        "name": "Vongole Appetizer (Manila Clams)",
        "price": "11.25"]
        appitizers.append(dataSTR2)
        
        dataSTR2 = ["descrip": "Grilled rustic bread with tomatoes, fresh basil, garlic, olive oil and salsa verde.",
            "id": "35193055",
            "is_orderable": "1",
            "name": "Bruschetta (Small)",
            "price": "6.00"]
        appitizers.append(dataSTR2)
        
        var mainMenu : [Dictionary<String, String>] = []
        var dataSTR3 : [String : String] = ["descrip": "Fresh chicken breast breaded and topped with tomato sauce, fresh basil, mozzarella and parmesan, served with penne pomodoro.",
            "id": "45840171",
            "is_orderable": "1",
            "name": "Chicken Parmigiana",
            "price": "15.25"]
        mainMenu.append(dataSTR3)
        
        dataSTR3 = ["descrip": "Rich beef, pork and porcini mushroom sauce tossed with rigatoni, topped with shaved pecorino.",
            "id": "35193161",
            "is_orderable": "1",
            "name": "Bolognese",
            "price": "13.25"]
        mainMenu.append(dataSTR3)
        
        dataSTR3 = ["descrip": "Grilled chicken, sauteed broccoli and fettuccine in a creamy tomato vodka sauce.",
            "id": "45840172",
            "is_orderable": "1",
            "name": "Fettuccine Rosa",
            "price": "13.50"]
        mainMenu.append(dataSTR3)
        
        dataSTR3 = ["descrip": "Fresh grilled chicken breast marinated in fresh garlic, thyme and lemon, served with sauteed farro.",
            "id": "45840173",
            "is_orderable": "1",
            "name": "Pollo Griglia",
            "price": "13.50"]
        mainMenu.append(dataSTR3)
        
        dataSTR3 = ["descrip": "Creamy parmesan sauce with cracked black pepper.",
            "id": "35193165",
            "is_orderable": "1",
            "name": "Fettuccine Alfredo",
            "price": "12.00"]
        mainMenu.append(dataSTR3)
        
        dataSTR3 = [ "descrip": "Penne, red & yellow bell peppers, roasted eggplant, fresh mozzarella, fresh mint and a spicy tomato sauce, topped with shaved pecorino.",
            "id": "35193179",
            "is_orderable": "1",
            "name": "Siciliane",
            "price": "12.00"]
        mainMenu.append(dataSTR3)
        
        
        

        
        
        
        
        
        
        
        
//        println(appitizers.count)
        var lessThan : [Int] = []
        
        var count = 0
        for i in appitizers {
            var prStr = i["price"]
            var string = NSString(string: prStr!)
            var pr : Double = string.doubleValue
            if (pr <= price){
                lessThan.append(count)
            }
            
            
            count++
        }
//        println()
//        for a in lessThan{
//            println(a)
//        }
//        println()
        
        var a = Int(arc4random()) % lessThan.count
        
        var it = appitizers[a]
        var n = it["name"]
        var p = it["price"]
        var i = it["id"]
        var item = [n,p,i]
        
        
        
        
        
        var appArray : [[String]] = []
        for e in appitizers{
            var tempArr : [String] = [e["id"]! as String, e["name"]! as String, e["price"]! as String]
            appArray.append(tempArr)
        }
        
        var menuArray : [[String]] = []
        for e in mainMenu{
            var tempArr : [String] = [e["id"]! as String, e["name"]! as String, e["price"]! as String]
            appArray.append(tempArr)
        }
        
        var orBP : [[String]] = []

        
        
        
        
        
        
        
        return item
    }
    
    func waitFor (inout wait: Bool){
        while(wait){
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 0.1))
        }
    }

}
    
    
