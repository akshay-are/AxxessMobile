//
//  WebServices.swift
//  AxxessMobile
//
//  Created by Akshay Are on 20/07/20.
//  Copyright © 2020 Akshay Are. All rights reserved.
//

import UIKit
import Alamofire


typealias ServiceResponseArray = (NSArray?, NSError?) -> Void

class WebServices: NSObject {
    
    class var shared : WebServices {
    struct Singleton {
        static let instance = WebServices()
    }
    
    return Singleton.instance
    }
    
    func getRequestWithUrlArray(UrlString : String, onCompletion :@escaping ServiceResponseArray) -> Void{
           
           if NetworkState.isConnected() {
               print("Internet is available.")
               
               Alamofire.request(UrlString).responseJSON { response in
                   
                   print("\nUrl ===>",UrlString)
                   
                   
                   if let status = response.response?.statusCode {
                       print ("Status Code..",status)
                       if status == 200{
                           if let result = response.result.value {
                               let JSON = result as! NSArray
                               onCompletion(JSON, nil)
                               return
                           }
                       }
                       else{
                           onCompletion(nil, response.result.error as NSError?)
                       }
                   }
               
                   
               }
           }
           else
           {
               print("Check Internet Connection")
              
       }
    }
    
    class NetworkState {
           class func isConnected() ->Bool {
               return NetworkReachabilityManager()!.isReachable
           }
       }
    
    func checkForNetwork(onCompletion: (Bool) -> Void) {
        
        if NetworkState.isConnected(){
            onCompletion(true)
        }else{
            onCompletion(false)
        }
    }
    
}
