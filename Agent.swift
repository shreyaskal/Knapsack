//
//  Agent.swift
//  Knapsack
//
//  Created by Shreyas Kalyan on 10/4/14.
//  Copyright (c) 2014 Shreyas Kalyan. All rights reserved.
//

import Foundation
class Agent: NSObject {
    
    /**
    * Members
    */
    
    var request: NSMutableURLRequest? = nil
    var done: (NSError?, NSHTTPURLResponse?) -> () = { (_: NSError?, _: NSHTTPURLResponse?) -> () in }
    var myDone: (NSError?, NSHTTPURLResponse?, NSMutableData?) -> () = { (_: NSError?, _: NSHTTPURLResponse?, _: NSData?) -> () in }
    var error: NSError? = nil
    var response: NSHTTPURLResponse? = nil
    var data: NSMutableData = NSMutableData()
    
    /**
    * Initialize
    */
    
    init(method: String, url: String, headers: Dictionary<String, String>?) {
        println("starting init")
        super.init()
        let _url = NSURL(string: url)
        self.request = NSMutableURLRequest(URL: _url)
        self.request!.HTTPMethod = method;
        if ((headers) != nil) {
            self.request!.allHTTPHeaderFields = headers!
        }
    }
    
    /**
    * GET
    */
    
    class func get(url: String) -> Agent {
        println("basic get")
        return Agent(method: "GET", url: url, headers: nil)
    }
    
    class func get(url: String, headers: Dictionary<String, String>) -> Agent {
        return Agent(method: "GET", url: url, headers: headers)
    }
    
    
    class func get(url: String, done: (NSError?, NSHTTPURLResponse?, NSMutableData?) -> ()) -> Agent {
        println("printing correct get")
        return Agent.get(url).end(done)
    }
    
    class func get(url: String, done: (NSError?, NSHTTPURLResponse?) -> ()) -> Agent {
        println("printing wrong get")
        return Agent.get(url).end(done)
    }
    
    class func get(url: String, headers: Dictionary<String, String>, done: (NSError?, NSHTTPURLResponse?) -> ()) -> Agent {
        return Agent.get(url, headers: headers).end(done)
    }
    
    class func get(url: String, headers: Dictionary<String, String>, done: (NSError?, NSHTTPURLResponse?, NSMutableData?) -> ()) -> Agent {
        return Agent.get(url, headers: headers).end(done)
    }
    
    /**
    * POST
    */
    
    class func post(url: String) -> Agent {
        return Agent(method: "POST", url: url, headers: nil)
    }
    
    class func post(url: String, headers: Dictionary<String, String>) -> Agent {
        return Agent(method: "POST", url: url, headers: headers)
    }
    
    class func post(url: String,
        headers: Dictionary<String, String>,
        data: Dictionary<String, AnyObject>) -> Agent {
            return Agent.put(url, headers: headers).send(data)
    }
    
    class func post(url: String,
        data: Dictionary<String, AnyObject>) -> Agent {
            return Agent.post(url).send(data)
    }
    
    class func post(url: String,
        data: Dictionary<String, AnyObject>,
        done: (NSError?, NSHTTPURLResponse?, data: NSMutableData?) -> ()) -> Agent {
            println("correct post")
            return Agent.post(url, data: data).send(data).end(done)
    }
    
    class func post(url: String,
        data: Dictionary<String, AnyObject>,
        done: (NSError?, NSHTTPURLResponse?) -> ()) -> Agent {
            println("bad post")
            return Agent.post(url, data: data).send(data).end(done)
    }
    
    class func post(url: String,
        headers: Dictionary<String, String>,
        data: Dictionary<String, AnyObject>,
        done: (NSError?, NSHTTPURLResponse?) -> ()) -> Agent {
            return Agent.post(url, headers: headers, data: data).send(data).end(done)
    }
    
    class func post(url: String,
        headers: Dictionary<String, String>,
        data: Dictionary<String, AnyObject>,
        done: (NSError?, NSHTTPURLResponse?, data: NSMutableData?) -> ()) -> Agent {
            return Agent.post(url, headers: headers, data: data).send(data).end(done)
    }
    
    /**
    * PUT
    */
    
    class func put(url: String) -> Agent {
        return Agent(method: "PUT", url: url, headers: nil)
    }
    
    class func put(url: String, headers: Dictionary<String, String>) -> Agent {
        return Agent(method: "PUT", url: url, headers: headers)
    }
    
    class func put(url: String,
        data: Dictionary<String, AnyObject>,
        done: (NSError?, NSHTTPURLResponse?, data: NSMutableData?) -> ()) -> Agent {
            println("correct put")
            return Agent.put(url, data: data).send(data).end(done)
    }
    
    class func put(url: String,
        headers: Dictionary<String, String>,
        data: Dictionary<String, AnyObject>) -> Agent {
            return Agent.put(url, headers: headers).send(data)
    }
    
    class func put(url: String,
        data: Dictionary<String, AnyObject>) -> Agent {
            return Agent.put(url).send(data)
    }
    
    class func put(url: String,
        data: Dictionary<String, AnyObject>,
        done: (NSError?, NSHTTPURLResponse?) -> ()) -> Agent {
            return Agent.put(url, data: data).send(data).end(done)
    }
    
    class func put(url: String,
        headers: Dictionary<String, String>,
        data: Dictionary<String, AnyObject>,
        done: (NSError?, NSHTTPURLResponse?) -> ()) -> Agent {
            return Agent.put(url, headers: headers, data: data).send(data).end(done)
    }
    
    /**
    * DELETE
    */
    
    class func del(url: String) -> Agent {
        return Agent(method: "DELETE", url: url, headers: nil)
    }
    
    class func delete(url: String, headers: Dictionary<String, String>) -> Agent {
        return Agent(method: "DELETE", url: url, headers: headers)
    }
    
    class func delete(url: String,
        headers: Dictionary<String, String>,
        done: (NSError?, NSHTTPURLResponse?, data: NSMutableData?) -> ()) -> Agent {
            println("correct delete")
            return Agent.delete(url, headers: headers).send(headers).end(done)
    }
    
    class func delete(url: String, done: (NSError?, NSHTTPURLResponse?) -> ()) -> Agent {
        return Agent.del(url).end(done)
    }
    
    class func delete(url: String, headers: Dictionary<String, String>, done: (NSError?, NSHTTPURLResponse?) -> ()) -> Agent {
        return Agent.delete(url, headers: headers).end(done)
    }
    
    /**
    * Methods
    */
    
    func send(data: Dictionary<String, AnyObject>) -> Agent {
        var error: NSError?
        var json = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(0), error: &error)
        // TODO: handle error
        self.set("Content-Type", value: "application/json")
        self.request!.HTTPBody = json
        //println(data)
        return self
    }
    
    func send(data: Dictionary<String, String>) -> Agent {
        var error: NSError?
        var json = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(0), error: &error)
        // TODO: handle error
        self.set("Content-Type", value: "application/json")
        self.request!.HTTPBody = json
        //println(data)
        return self
    }
    
    func set(header: String, value: String) -> Agent {
        self.request!.setValue(value, forHTTPHeaderField: header)
        return self
    }
    
    func end(myDone: (NSError?, NSHTTPURLResponse?, NSMutableData?) -> ()) -> Agent {
        println("printing correct end")
        self.myDone = myDone
        let connection = NSURLConnection(request: self.request!, delegate: self, startImmediately: true)
        return self
    }
    
    
    func end(myDone: (NSError?, NSHTTPURLResponse?, NSData?) -> ()) -> Agent {
        println("printing correct end")
        self.myDone = myDone
        let connection = NSURLConnection(request: self.request!, delegate: self, startImmediately: true)
        return self
    }
    
    
    func end(done: (NSError?, NSHTTPURLResponse?) -> ()) -> Agent {
        println("printing wrong end")
        self.done = done
        let connection = NSURLConnection(request: self.request!, delegate: self, startImmediately: true)
        return self
    }
    
    
    /**
    * Delegate
    */
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        println("handling response")
        self.response = response
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        println("handling error")
        println(error)
        self.error = error
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        println("handling data")
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!){
        println("request complete")
        //println(self.error)
        //println(self.response)
        //println(self.data)
        self.myDone(self.error, self.response, self.data)
    }
    
}
