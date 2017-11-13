//
//  ProfileService.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 10/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

private var kChangePassword = "ranosys/customer/changePassword"
private var kCountryCode = "directory/countries"
private var kUserProfile = "customers/me"
private var kUserImpactsPoints = "ranosys/myimpactpoints"
private var kEditProfilePicture = "customerprofile/index"

class ProfileService: BaseService {

    // MARK: - Change password service
    func changePasswordService(_ profileData: ProfileDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!,
        ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .post
        request.parameters = ["currentPassword": profileData.currentPassword as AnyObject, "newPassword": profileData.newPassword as AnyObject] as [String : AnyObject]
        request.headers=headers
        print("change password request %@", request.parameters as Any)
        request.path = basePath + kChangePassword
        self.callPostService(request, success: success, failure: failure)
        
    }
    // MARK: - end
    
    // MARK: - Get country code service
    func getCountryCodeService(_ profileData: ProfileDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
       // super.get(kCountryCode, parameters: nil, onSuccess: success, onFailure: failure)
    }
    // MARK: - end
    
    // MARK: - Get user service
    func getUserProfileServiceData(_ profileData: ProfileDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .get
        request.parameters = nil
        print("get user profile request %@", request.parameters as Any)
        request.path = basePath + kUserProfile
        self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end
    
    // MARK: - User profile image service
    func updateUserprofileImageService(_ profileData: ProfileDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
//        let parameters = (["customerId": UserDefaultManager.getValue("userId" as? UnsafeMutableRawPointer ?? UnsafeMutableRawPointer())]) as? [StringLiteralConvertible: UnknownType]
//        super.postImage(kEditProfilePicture, parameters: parameters, image: profileData.userImage, success: success, failure: failure)
    }
    // MARK: - end
    
}
