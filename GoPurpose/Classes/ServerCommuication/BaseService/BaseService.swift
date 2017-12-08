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
    
    func callPostService(_ alamoReq: alamofireRequestModal, success:@escaping ((_ responseObject: Any?) -> Void), failure:@escaping ((_ error : NSError?) -> Void)) {
        // Log path and parameters
        print("AlamoRequest:\n path: \(alamoReq.path)")
        print("\n param: \(String(describing: alamoReq.parameters))")
        // Create alamofire request
      if reach.isReachable {
        // "alamoReq" is overridden in services, which will create a request here

        Alamofire.request(alamoReq.path, method: alamoReq.method, parameters: alamoReq.parameters, encoding: alamoReq.encoding, headers: alamoReq.headers)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                print(response.response?.statusCode as Any)
                if response.response?.statusCode == 200 {
                    print("Success with JSON: \(String(describing: response.result.value))")
                    success(response.result.value as Any)
                }
                else {
                    AppDelegate().stopIndicator()
                    print("error with JSON: \(String(describing: response))")
                    var errorMessage: String
                    if response.response?.statusCode == 500 {
                        errorMessage = "Internal server error"//NSLocalizedText(key: "internalServerError")
                    }
                    else {
                    if !(response.result.value==nil) {
                        let error = response.result.value as! NSDictionary
                        errorMessage = error.object(forKey: "message") as! String
                    }
                    else if !(response.result.error == nil) {
                        errorMessage = response.result.error!.localizedDescription
                    }
                    else {
                        errorMessage=NSLocalizedText(key: "somethingWrongMessage")
                    }
                    }
                    SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:errorMessage, closeButtonTitle: NSLocalizedText(key: "alertOk"))
                   //  failure(errorMessage as NSError?)
                }
        }
          } else {
            AppDelegate().stopIndicator()
            failure(nil)
            createNoNetworkConnectionView()
        }
    }
    
    func callImageWebServiceAlamofire(imageDict: Data, alamoReq: alamofireRequestModal, success:@escaping ((_ responseObject: AnyObject?) -> Void), failure:@escaping ((_ error : NSError?) -> Void)) {
        // Log path and parameters
        print("AlamoRequest:\n path: \(alamoReq.path)")
        print("\n param: \(String(describing: alamoReq.parameters))")
        if reach.isReachable {
            // Call response handler method of alamofire
            let imageName = "\(Date().timeIntervalSince1970 * 1000)"
            Alamofire.upload(multipartFormData: { multipartFormData in
                for (key, value) in alamoReq.parameters! {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                multipartFormData.append(imageDict, withName: "avatar", fileName: imageName+".jpg", mimeType: "image/jpeg")
            }, to: alamoReq.path, method: alamoReq.method, headers: alamoReq.headers,
               encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (response) in
                        print("\n Response/Failure: \(response)")
                        if response.response?.statusCode == 200 {
                           // print("Success with JSON: \(String(describing: response.result.value))")
                            success(response.result.value as AnyObject)
                        }
                        else {
                            AppDelegate().stopIndicator()
                            let error = response.result.value as! NSDictionary
                            let errorMessage = error.object(forKey: "message") as! String
                            print(errorMessage)
                            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:errorMessage, closeButtonTitle: NSLocalizedText(key: "alertOk"))
                            // failure(error )
                        }
                    })
                case .failure(let encodingError):
                    AppDelegate().stopIndicator()
                    SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:encodingError.localizedDescription, closeButtonTitle: NSLocalizedText(key: "alertOk"))
                    failure(encodingError as NSError?)
                }
            })
        }  else {
            AppDelegate().stopIndicator()
            failure(nil)
            createNoNetworkConnectionView()
        }
        }
}

