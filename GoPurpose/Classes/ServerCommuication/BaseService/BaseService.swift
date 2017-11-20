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
                if response.response?.statusCode == 200 {
                    print("Success with JSON: \(String(describing: response.result.value))")
                    success(response.result.value as Any)
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
    
    func callImageWebServiceAlamofire(imageDict: Data, alamoReq: alamofireRequestModal, success:@escaping ((_ responseObject: AnyObject?) -> Void), failure:@escaping ((_ error : NSError?) -> Void)) {
        // Log path and parameters
        print("AlamoRequest:\n path: \(alamoReq.path)")
        print("\n param: \(String(describing: alamoReq.parameters))")
      //  let params: Dictionary<String, String> = alamoReq.parameters! as! Dictionary<String, String>
        if reach.isReachable {
            // Call response handler method of alamofire

            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in alamoReq.parameters! {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                    multipartFormData.append(imageDict, withName: "image", fileName: "image.png", mimeType: "image/png")
                
            }, usingThreshold: UInt64.init(), to: alamoReq.path, method: alamoReq.method, headers:  alamoReq.headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print("Succesfully uploaded")
                        if let err = response.error{
//                            onError?(err)
                            print(err)
                            return
                        }
//                        onCompletion?(nil)
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
//                    onError?(error)
                }
            }
        }
            
            
//            Alamofire.upload(multipartFormData: { multipartFormData in
//                // Fetching data from dictionary and
//                // Appending image in the request
////                let imgData = Array(imageDict.values)[0]
////                let imgName = Array(imageDict.keys)[0] as String
//                //[formData appendPartWithFileData:imageData name:@"avatar" fileName:[NSString stringWithFormat:@"%@.jpg",imageName] mimeType:@"image/jpeg"];
//                //alamoReq.path, method: alamoReq.method, parameters: alamoReq.parameters, encoding: alamoReq.encoding, headers: alamoReq.headers
//                multipartFormData.append(imageDict, withName: "hemlata", fileName: "file.jpeg", mimeType: "image/jpeg")
//                }, to: alamoReq.path, method: alamoReq.method, headers: alamoReq.headers,
//                    encodingCompletion: { encodingResult in
//                        switch encodingResult {
//                        case .success(let upload, _, _):
//                            upload.responseJSON(completionHandler: { (response) in
//                                print("\n Response/Failure: \(response)")
//                                switch response.result {
//                                case .success(let data):
//                                    guard let errorMessage = (data as? NSDictionary)?.value(forKey: "error") else {
//                                        print("\n Success: \(response)")
//                                        success(data as AnyObject?)
//                                        return
//                                    }
//                                    let errorTemp = NSError.init(domain: "", code: 200, userInfo: ["error" : errorMessage])
//                                    print("\n Failure: \(errorTemp.localizedDescription), errorMessage: \(errorMessage)")
//                                    failure(errorTemp as NSError?)
//
//                                case .failure(let error):
//                                    print("\n Failure: \(error.localizedDescription)")
//                                    failure(error as NSError?)
//                                }
//                            })
//                        case .failure(let encodingError):
//                            print("error:\(encodingError.localizedDescription)")
//                            failure(encodingError as NSError?)
//                        }
//            })
//        } else {
//            failure(nil)
//            createNoNetworkConnectionView()
//        }
//    }
}
}
