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
    var userProfileImage: UIImage?
    var currentPassword: String?
    var newPassword: String?
    var firstName: String?
    var lastName: String?
    var defaultCurrency: String?
    var defaultLanguage: NSString?
    var groupName: String?
    var groupId: Any?
    var successMessage: String?
    var businessName: String?
    var zipcode: String?
    var businessNumber: String?
    var businessCountry: String?
    var businessAddressLine1: String?
    var businessAddressLine2: String?
    var businessDescription: String?
    var contactNumber: String?
    var websiteId: Any?
    var storeId: Any?
    var customerAttributeArray:NSMutableArray = NSMutableArray()
    var addressArray:NSMutableArray = NSMutableArray()
    var countryArray:NSMutableArray = NSMutableArray()
    
    // MARK: - Get user profile
    func getUserProfile(_ profileData: ProfileDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
            ConnectionManager.sharedInstance.getUserProfileData(profileData, success: {(responseObj) in
//        let responseObj = ProfileDataModel.init(dictionary: responseObj as! Dictionary)
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
    
    // MARK: - save user profile
    func saveUserProfile(_ profileData: ProfileDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.saveUserProfileData(profileData, success: {(responseObj) in
            
            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Country list
    func getCountryListData(_ profileData: ProfileDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.getCountryListing(profileData, success: {(responseObj) in
            
            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end
}
