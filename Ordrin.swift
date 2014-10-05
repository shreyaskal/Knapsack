//
//  Ordrin.swift
//  Knapsack
//
//  Created by Ordr.in
//  Edited by Shreyas Kalyan 10/4/2014
//

import Foundation

class Ordrin {
    
    
    let apiKey : String
    let environment : String
    let urls : Dictionary<String,String>

    
    
    init(apiKey: String, environment: String) {
        self.apiKey = apiKey
        self.environment = environment
        
        if(environment == "test") {
            urls = [
                "restaurant" : "https://r-test.ordr.in",
                "order" : "https://o-test.ordr.in",
                "user" : "https://u-test.ordr.in"
            ]
        } else { // environment == "production"
            urls = [
                "restaurant" : "https://r.ordr.in",
                "order" : "https://o.ordr.in",
                "user" : "https://u.ordr.in"
            ]
        }
    }
    

    func makeApiRequest( apiGroup : String, endpointPath : String, pathTpl : String, method : String = "get", userAuth : Bool = false, parameters : Dictionary<String, String>, postFields : [String]?, callback : (NSError?, AnyObject?) -> () ) {
        
        var uri = endpointPath
        var postData: Dictionary<String, AnyObject> = [:]
        
        for path in pathTpl.componentsSeparatedByString("/"){
            if path.hasPrefix(":") {
                var param = path.substringFromIndex(path.startIndex);
                
                // ISSSUE #20
                
                var parm : NSString = param
                parm = parm.substringFromIndex(1)
                param = parm
                
                uri += "/\(parameters[param]!)";
            } else if(!path.isEmpty){
                uri += "/\(path)"
            }
            
        }
        println("Hitting \(uri)");
        
        if (postFields != nil) {
            for field in postFields!{
                if (parameters[field] != nil) {
                    postData[field] = parameters[field]
                }
            }
        }
        
        if userAuth {
            var email = parameters["email"]
            var password: String = parameters["password"]!
            
            // Only when resetting password
            if (parameters["current_password"] != nil) {
                password = parameters["current_password"]!
            }
//            println("Password: \(password)")
            var hashCode = hashUser(password, email: email!, uri: uri)
            uri += "?_auth=1,\(apiKey)&_uauth=1,\(email),\(hashCode)"
        } else {
            uri += "?_auth=1,\(apiKey)"
        }
        
        
        var encodedUrl : NSString = "\(urls[apiGroup]!)\(uri)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//        println(encodedUrl)
        
        // Agent stuff - will refactor for more generality later
        if method == "post" {
            Agent.post(encodedUrl,
                data: postData,
                done: { (error: NSError?, response: NSHTTPURLResponse?, data: NSMutableData?) -> () in
                    if ((error) != nil) {
                        callback(error, nil)
                    } else {
                        var results = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                        callback(nil, results)
                    }
            })
        } else if method == "put" {
            Agent.put(encodedUrl,
                data: postData,
                done: { (error: NSError?, response: NSHTTPURLResponse?, data: NSMutableData?) -> () in
                    if ((error) != nil) {
                        callback(error, nil)
                    } else {
                        var results = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                        callback(nil, results)
                    }
            })
        } else if method == "delete" {
            Agent.delete(encodedUrl,
                headers: [:],
                done: { (error: NSError?, response: NSHTTPURLResponse?, data: NSMutableData?) -> () in
                    if ((error) != nil) {
                        callback(error, nil)
                    } else {
                        var results = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                        callback(nil, results)
                    }
            })
        } else {
            Agent.get(encodedUrl,
                done: { (error: NSError?, response: NSHTTPURLResponse?, data: NSMutableData?) -> () in
                    if ((error) != nil) {
                        callback(error, nil)
                    } else {
                        var results : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
 //                       println(results)
                        callback(nil, results)
                    }
            })
        }
        
    }
    
    func restaurant_details(params: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        var endpointPath = "/rd"
        var pathTpl = "/:rid"
        var required = ["rid"]
        
        if validateParams(params, required: required){
            makeApiRequest("restaurant", endpointPath: endpointPath, pathTpl: pathTpl, parameters: params, postFields: nil, callback: callback)
        }
    }
    
    func delivery_list(params: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
 //       println("list called")
        var endpointPath = "/dl"
        var pathTpl = "/:datetime/:zip/:city/:addr"
        var required = ["datetime", "zip", "city", "addr"]
        
        if validateParams(params, required: required){
            for a in params{
                println(a)
            }
            makeApiRequest("restaurant", endpointPath: endpointPath, pathTpl: pathTpl, parameters: params, postFields: nil, callback: callback)
        }
    }
    
    func delivery_check(params: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
 //       println("check called")
        var endpointPath = "/dc"
        var pathTpl = "/:rid/:datetime/:zip/:city/:addr"
        var required = ["rid", "datetime", "zip", "city", "addr"]
        
        if validateParams(params, required: required){
            makeApiRequest("restaurant", endpointPath: endpointPath, pathTpl: pathTpl, parameters: params, postFields: nil, callback: callback)
        }
    }
    
    func fee(params: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
  //      println("fee called")
        var endpointPath = "/fee"
        var pathTpl = "/:rid/:subtotal/:tip/:datetime/:zip/:city/:addr"
        var required = ["rid", "subtotal", "tip", "datetime", "zip", "city", "addr"]
        
        if validateParams(params, required: required){
            makeApiRequest("restaurant", endpointPath: endpointPath, pathTpl: pathTpl, parameters: params, postFields: nil, callback: callback)
        }
    }
    
    
    func order_guest(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        
        var postFields: [String] = ["tray", "tip", "delivery_date", "delivery_time", "first_name", "last_name", "addr", "city", "state", "zip", "phone", "em", "password", "card_name", "card_number", "card_cvc", "card_expiry",
            "card_bill_addr", "card_bill_addr2", "card_bill_city", "card_bill_state", "card_bill_zip", "card_bill_phone"
        ]
        
        makeApiRequest("order", endpointPath: "/o", pathTpl: "/:rid", method: "post", parameters: parameters, postFields: postFields, callback: callback)
    }
    
    func order_user(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        
        var postFields: [String] = ["email", "tray", "tip", "delivery_date", "first_name", "last_name", "addr", "city",
            "state", "zip", "phone", "em", "password", "card_name", "card_number", "card_cvc", "card_expiry",
            "card_bill_addr", "card_bill_addr2", "card_bill_city", "card_bill_state", "card_bill_zip", "card_bill_phone",
            "nick", "card_nick"
        ]
        
        makeApiRequest("order", endpointPath: "/o", pathTpl: "/:rid", method: "post", userAuth: true, parameters: parameters, postFields: postFields, callback: callback)
    }
    
    func get_account_info(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email", userAuth: true, parameters: parameters, postFields: nil, callback: callback)
    }
    
    func get_all_saved_addrs(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email/addrs", userAuth: true, parameters: parameters, postFields: nil, callback: callback)
    }
    
    func get_saved_addr(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email/addrs/:nick", userAuth: true, parameters: parameters, postFields: nil, callback: callback)
    }
    
    func get_all_saved_ccs(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email/ccs/", userAuth: true, parameters: parameters, postFields: nil, callback: callback)
    }
    
    func get_saved_cc(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email/ccs/:nick", userAuth: true, parameters: parameters, postFields: nil, callback: callback)
    }
    
    func get_order_history(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email/orders/", userAuth: true, parameters: parameters, postFields: nil, callback: callback)
    }
    
    func get_order(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email/orders/:oid", userAuth: true, parameters: parameters, postFields: nil, callback: callback)
    }
    
    func create_account(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        var postFields: [String] = ["email", "pw", "first_name", "last_name"]
        var password: String = parameters["pw"]!
        var newParams = parameters
        password = crypto.sha256HashFor(password)
        newParams["pw"] = password
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email", method: "post", parameters: newParams, postFields: postFields, callback: callback)
    }
    
    func create_addr(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        var postFields: [String] = [
            "email","nick", "addr", "addr2", "city", "state",
            "zip", "phone"
        ]
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email/addrs/:nick", method: "put", userAuth: true, parameters: parameters, postFields: postFields, callback: callback)
    }
    
    func create_cc(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        var postFields: [String] = [
            "email", "nick", "name", "number",
            "cvc", "expiry_month", "expiry_year",
            "type", "bill_addr", "bill_addr2", "bill_city",
            "bill_state", "bill_zip", "bill_phone"
        ]
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email/ccs/:nick", method: "put", userAuth: true, parameters: parameters, postFields: postFields, callback: callback)
    }
    
    func change_password(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        var postFields: [String] = ["password"]
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email/password", method: "put", userAuth: true, parameters: parameters, postFields: postFields, callback: callback)
    }
    
    func delete_addr(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email/addrs/:nick", method: "delete", userAuth: true, parameters: parameters, postFields: nil, callback: callback)
    }
    
    func delete_cc(parameters: Dictionary<String, String>, callback: (NSError?, AnyObject?) -> ()) {
        makeApiRequest("user", endpointPath: "/u", pathTpl: "/:email/ccs/:nick", method: "delete", userAuth: true, parameters: parameters, postFields: nil, callback: callback)
    }
    
    // Need to do all non get requests(put and delete) to finish the User API.
    
    func validateParams(params: Dictionary<String, String>, required: [String]) -> Bool{
        for key in required {
            if !(params[key] != nil) {
//                println("ERROR: required field '\(key)' not found")
                return false
            }
        }
        
        return true
    }
    
    
    var crypto: Crypto = Crypto()
    func hashUser(password: String, email: String, uri: String) -> NSString{
        
        var pass_hash = crypto.sha256HashFor(password)
        
        return crypto.sha256HashFor(pass_hash + email + uri)
    }
    
    
}