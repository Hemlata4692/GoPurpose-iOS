//
//  LoginDataModel.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 06/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class LoginDataModel: NSObject {

    var userId: String?
    var email: String?
    var password: String?
    var profileImage: String?
    var otpNumber: String?
    var accessToken: String?
    var quoteId: String?
    var firstName: String?
    var lastName: String?
    var isSocialLogin: String?
    var apiKey: String?
    var defaultCurrency: String?
    var defaultLanguage: String?
    var groupName: String?
    var businesName: String?
    var groupId: Any?
    var followCount: Any?
    var notificationCount: Any?
    var quoteCount: Any?
    var wishlistCount: Any?
  
       // MARK: - Login API
    func requestForLogin(_ userData: LoginDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.loginUserWebservice(userData, success: {(responseObj) in
            UserDefaults().set(userData.quoteId, forKey: "quoteId")
            UserDefaults().set(userData.apiKey, forKey: "apiKey")
            UserDefaults().set(userData.groupName, forKey: "groupName")
            UserDefaults().set(userData.groupId, forKey: "groupId")
            UserDefaults().set(userData.notificationCount, forKey: "notificationCount")
            UserDefaults().set(userData.email, forKey: "userEmail")
            UserDefaults().set(userData.userId, forKey: "userId")
             UserDefaults().set(userData.businesName, forKey: "businessName")
            success(responseObj)
        }, failure: failure)
    }
       // MARK: - end
    
       // MARK: - Reset Pasword API
    func resetPasswordService(_ userData: LoginDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
         ConnectionManager.sharedInstance.resetPasswordService(userData, success: {(responseObj) in
           success(responseObj)
         }, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Forgot password API
    func forgotPasswordService(_ userData: LoginDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
      ConnectionManager.sharedInstance.forgotPasswordService(userData, success: {(responseObj) in
           success(responseObj)
         }, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Save device token
    func saveDeviceToken(_ userData: LoginDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.sendDevcieToken(userData, success: {(responseObj) in
           success(responseObj)
         }, failure: failure)
    }
    // MARK: - end
    
    // MARK: - CMS block
    func getCMSBlockData(_ userData: LoginDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.getBlockData(userData, success: {(responseObj) in
            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end
    
}
