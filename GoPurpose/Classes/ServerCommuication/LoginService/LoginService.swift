//
//  LoginService.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 06/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

private var kLogin = "ranosys/customer/customerLogin"
private var kForgotPassword = "ranosys/customer/forgotPassword"
private var kSaveDeviceToken = "ranosys/saveDeviceToken"
private var kResetPassword = "ranosys/customer/resetPassword"

class LoginService: BaseService {
    
    // MARK: - Login user service
 func loginUserRequest(_ loginData: LoginDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
    var request:alamofireRequestModal = alamofireRequestModal()
    request.method = .post
    request.parameters = ["email": loginData.email as AnyObject, "password": loginData.password  as AnyObject, "isSocialLogin": loginData.isSocialLogin as AnyObject, "countryCode": localeCountryCode() as AnyObject] as [String : AnyObject]
    print("login request %@", request.parameters as Any)
    request.path = basePath + kLogin
    self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end

    // MARK: - Forgot password service
    func forgotPasswordService(_ loginData: LoginDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .post
        request.parameters = ["email": loginData.email as AnyObject, "template": "email"  as AnyObject] as [String : AnyObject]
        print("forgot passwod request %@", request.parameters as Any)
        request.path = basePath + kForgotPassword
        self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Reset password service
    func resetPasswordService(_ loginData: LoginDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .post
        request.parameters = ["email": loginData.email as AnyObject, "password": loginData.password as AnyObject, "requestOTP": loginData.otpNumber as AnyObject] as [String : AnyObject]
        print("reset passwod request %@", request.parameters as Any)
        request.path = basePath + kResetPassword
        self.callPostService(request, success: success, failure: failure)
    }
    
    // MARK: - end
    
    // MARK: - Save device token service
    func saveDeviceTokenService(_ loginData: LoginDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .post
        request.parameters = ["customerId": UserDefaults().string(forKey: "userId") as AnyObject, "deviceType": 2, "deviceToken": UserDefaults().string(forKey: "deviceToken") as AnyObject] as [String : AnyObject]
        print("save device token request %@", request.parameters as Any)
        request.path = basePath + kSaveDeviceToken
       self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end

}