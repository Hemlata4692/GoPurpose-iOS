//
//  ConnectionManager.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 06/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class ConnectionManager: NSObject {
    
    // MARK: - Shared instance
    static let sharedInstance = ConnectionManager()
    // MARK: - end
    
    // MARK: - Login user service
    func loginUserWebservice(_ userData: LoginDataModel, success:@escaping ((_ response: Any?) -> Void), failure:@escaping ((_ err : NSError?) -> Void)) {
        LoginService().loginUserRequest(userData, success: {(response) in
            print("login response %@", response as AnyObject)
            //Parse data from server response and store in datamodel
            let dataDict = response as! NSDictionary
            let customerDict = dataDict["customer"] as! NSDictionary
            userData.userId = customerDict["id"] as? String
            userData.profileImage = customerDict["profile_pic"] as? String
            userData.apiKey = dataDict["api_key"] as? String
            userData.followCount = dataDict["follow_count"] as? String
            userData.notificationCount = dataDict["notifications_count"] as? String
            userData.quoteId = dataDict["quote_id"] as? String
            userData.quoteCount = dataDict["quote_count"] as? String
            userData.wishlistCount = dataDict["wishlist_count"] as? String
            userData.firstName = customerDict["firstname"] as? String
            userData.lastName = customerDict["lastname"] as? String
            userData.groupName = customerDict["group_name"] as? String
            userData.groupId = customerDict["group_id"] as? String
            if ((customerDict["default_currency"] as? String == "") || customerDict["default_currency"] as? String == nil) {
                UserDefaults().set(dataDict["local_currency_code"] as? String, forKey: "DefaultCurrencyCode")
            }
            else {
                UserDefaults().set(customerDict["default_currency"]as? String, forKey: "DefaultCurrencyCode")
            }
            if ((customerDict["default_language"]as? String == "") || customerDict["default_language"]as? String == nil) {
                UserDefaults().set(dataDict["local_language"] as? String, forKey: "Language")
            }
            else {
                if (customerDict["default_language"] as? String == "4") {
                    UserDefaults.standard.setValue("gp_en", forKey: "Language")
                }
                else if (customerDict["default_language"] as? String == "5") {
                    UserDefaults.standard.setValue("gp_zh", forKey: "Language")
                }
                else if (customerDict["default_language"] as? String == "6") {
                    UserDefaults.standard.setValue("gp_cn", forKey: "Language")
                }
            }
            success(userData)
            },failure:failure)
    }
    // MARK: - end
    
    // MARK: - Reset password service
    func resetPasswordService(_ userData: LoginDataModel, success:@escaping ((_ response: Any?) -> Void), failure:@escaping ((_ err : NSError?) -> Void)) {
        LoginService().resetPasswordService(userData, success: {(response) in
            print("reset password response %@", response as AnyObject)
            //Parse data from server response and store in data model
           // userData.successMessage = response["message"]
            success(userData)
        },failure:failure)
    }
    // MARK: - end
    
    // MARK: - Forgot password service
    func forgotPasswordService(_ userData: LoginDataModel, success:@escaping ((_ response: Any?) -> Void), failure:@escaping ((_ err : NSError?) -> Void)) {
        LoginService().forgotPasswordService(userData, success: {(response) in
            print("forgot password response %@", response as AnyObject)
            //Parse data from server response and store in data model
           // userData.otpNumber = response[0]["resetOTP"]
            success(userData)
        },failure:failure)
    }
    // MARK: - end
    
    // MARK: - Send device token
    func sendDevcieToken(_ userData: LoginDataModel, success:@escaping ((_ response: Any?) -> Void), failure:@escaping ((_ err : NSError?) -> Void)) {
        LoginService().saveDeviceTokenService(userData, success: {(response) in
            print("saev device token response %@", response as AnyObject)
            //Parse data from server response and store in data model
            success(userData)
        },failure:failure)
    }
    // MARK: - end
}