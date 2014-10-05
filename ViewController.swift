///Users/shreyaskal/Documents/Apps/Knapsack/Knapsack/ViewController.swift
//  ViewController.swift
//  Knapsack
//
//  Created by Shreyas Kalyan on 10/4/14.
//  Copyright (c) 2014 Shreyas Kalyan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet var appTitle : UILabel!
    @IBOutlet var locText : UILabel!
    @IBOutlet var addressTextField : UITextField!
    @IBOutlet var stateTextField : UITextField!
    @IBOutlet var zipTextField : UITextField!
    @IBOutlet var cityTextField : UITextField!
    @IBOutlet var priceTextField : UITextField!
    @IBOutlet var findButton : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColorFromRGB(0x45ACA2);
        appTitle.textAlignment = NSTextAlignment.Center;
    }
    
    func waitFor (inout wait: Bool){
        while(wait){
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 0.1))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }


    
    
    @IBAction func sendInfo(sender : UIButton){
                
        if (addressTextField.text.isEmpty || stateTextField.text.isEmpty ||
            zipTextField.text.isEmpty || priceTextField.text.isEmpty ||
            cityTextField.text.isEmpty){
                
                var alert = UIAlertController(title:"Error", message:"Please fill all fields", preferredStyle: UIAlertControllerStyle.Alert);
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
                self.presentViewController(alert, animated:true, completion:nil)
                
        }
        
        else {
            let address = addressTextField.text;
            let city = cityTextField.text;
            let state = stateTextField.text;
            let zip:Int? = zipTextField.text.toInt();
            let price:Double? = Double((priceTextField.text as NSString).doubleValue);
            
            if (zip == nil || price == nil){
                var alert = UIAlertController(title:"Error", message:"Please enter numerical values for ZIP and price", preferredStyle: UIAlertControllerStyle.Alert);
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
                self.presentViewController(alert, animated:true, completion:nil)
            }
            
            else {
                
                var query = Query(a: address, c: city, s: state, z: zip!, p: price!)
                var item = query.callOrdrin()
                
                
                
                var strItem : [String] = []
                for a in item{
                    if (a != nil){
                        strItem.append(a! as String)
                        
                    }
                }
                
                var alert = UIAlertController(title:"Order Ready", message:"Name: \(strItem[0]) \nPrice: \(strItem[1]) ", preferredStyle: UIAlertControllerStyle.Alert);
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
                alert.addAction(UIAlertAction(title: "Again", style: UIAlertActionStyle.Default, handler: nil));
                self.presentViewController(alert, animated:true, completion:nil)

                
                
            }
            
            
        }
        
        
        
    }
}

