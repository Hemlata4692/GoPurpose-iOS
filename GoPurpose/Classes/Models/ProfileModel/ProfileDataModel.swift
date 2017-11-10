//
//  ProfileDataModel.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 10/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class ProfileDataModel: NSObject {

    var userId: String?
    var userName: String?
    var email: String?
    var companyName: String?
    var profileImage: String?
    var currentPassword: String?
    var newPassword: String?
    var firstName: String?
    var lastName: String?
    var defaultCurrency: String?
    var defaultLanguage: String?
    var groupName: String?
    var groupId: String?
    var successMessage: String?

    // MARK: - Get user profile
    func getUserProfile(_ profileData: ProfileDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
            ConnectionManager.sharedInstance.getUserProfileData(profileData, success: {(responseObj) in
       
                success(responseObj)
            }, failure: failure)
        }
    // MARK: - end
    
    // MARK: - Update user image
    func updateUserProfileImage(_ profileData: ProfileDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.updateUserProfileImage(profileData, success: {(responseObj) in

            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Change password
    func changePasswordService(_ profileData: ProfileDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.changePasswordService(profileData, success: {(responseObj) in
           
            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end
}
