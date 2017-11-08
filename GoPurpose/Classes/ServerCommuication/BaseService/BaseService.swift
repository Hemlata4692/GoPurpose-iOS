//
//  BaseService.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 06/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit
import Alamofire

struct alamofireRequestModal {
    var method: Alamofire.HTTPMethod
    var path: String
    var parameters: [String: AnyObject]?
    var encoding: JSONEncoding
    var headers: [String : String]?
    
    init() {
        method = .post
        path = ""
        parameters = nil
        encoding = JSONEncoding.default
        headers = nil
    }
}

class BaseService: NSObject {
    
    let reach = Reachability.init(hostname: "https://www.google.com")!
    func createNoNetworkConnectionView() {
        print("\n No Network Connection")
        SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle: NSLocalizedText(key: "noInternet"), closeButtonTitle: NSLocalizedText(key: "alertOk"))
    }
    
    func callPostService(_ alamoReq: alamofireRequestModal, success:@escaping ((_ responseObject: AnyObject?) -> Void), failure:@escaping ((_ error : NSError?) -> Void)) {
        // Log path and parameters
        print("AlamoRequest:\n path: \(alamoReq.path)")
        print("\n param: \(String(describing: alamoReq.parameters))")
        // Create alamofire request
      if reach.isReachable {
        // "alamoReq" is overridden in services, which will create a request here
        Alamofire.request(alamoReq.path, method: alamoReq.method, parameters: alamoReq.parameters, encoding: alamoReq.encoding)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    print("Success with JSON: \(String(describing: response.result.value))")
                    success(response.result.value as! [String:AnyObject] as AnyObject)
                }
                else {
                    AppDelegate().stopIndicator()
                    let error = response.result.value as! NSDictionary
                    let errorMessage = error.object(forKey: "message") as! String
                    print(errorMessage)
                    SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:errorMessage, closeButtonTitle: NSLocalizedText(key: "alertOk"))
                    // failure(error )
                }
        }
          } else {
            AppDelegate().stopIndicator()
            failure(nil)
            createNoNetworkConnectionView()
        }
    }
}
