//
//  LoginService.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 06/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

private var kLogin = "gp_en/rest/gp_en/V1/ranosys/customer/customerLogin"

class LoginService: BaseService {
    
    // MARK: - Login user service
 func loginUserRequest(_ loginData: LoginDataModel, success: @escaping ((_ responseObject: AnyObject?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
    var request:alamofireRequestModal = alamofireRequestModal()
    request.method = .post
    request.parameters = ["email": loginData.email as AnyObject, "password": loginData.password  as AnyObject, "isSocialLogin": loginData.isSocialLogin as AnyObject, "countryCode": localeCountryCode() as AnyObject] as [String : AnyObject]
    print("login request %@", request.parameters as Any)
    request.path = BASE_URL + kLogin
    self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end

}
