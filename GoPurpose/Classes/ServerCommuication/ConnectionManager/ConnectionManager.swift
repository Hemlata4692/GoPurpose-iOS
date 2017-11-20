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
            userData.followCount = dataDict["follow_count"] 
            userData.notificationCount = dataDict["notifications_count"]
            userData.quoteId = dataDict["quote_id"] as? String
            userData.quoteCount = dataDict["quote_count"]
            userData.wishlistCount = dataDict["wishlist_count"]
            userData.firstName = customerDict["firstname"] as? String
            userData.lastName = customerDict["lastname"] as? String
            userData.groupName = customerDict["group_name"] as? String
            userData.groupId = customerDict["group_id"]
            userData.email = customerDict["email"] as? String
            userData.businesName=customerDict["business_name"] as? String
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
            print("save device token response %@", response as AnyObject)
            //Parse data from server response and store in data model
            success(userData)
        },failure:failure)
    }
    // MARK: - end
    
    // MARK: - Change password service
    func changePasswordService(_ profileData: ProfileDataModel, success:@escaping ((_ response: Any?) -> Void), failure:@escaping ((_ err : NSError?) -> Void)) {
        ProfileService().changePasswordService(profileData, success: {(response) in
            print("change Password Service response %@", response as AnyObject)
            //Parse data from server response and store in data model
            success(profileData)
        },failure:failure)
    }
    // MARK: - end
    
    // MARK: - User profile service
    func getUserProfileData(_ profileData: ProfileDataModel, success:@escaping ((_ response: Any?) -> Void), failure:@escaping ((_ err : NSError?) -> Void)) {
        ProfileService().getUserProfileServiceData(profileData, success: {(response) in
            //Parse data from server response and store in data model
            print("user profile response %@", response as Any)
            let dataDict = response as! NSDictionary
            profileData.customerAttributeArray = (dataDict["custom_attributes"] as! NSArray).mutableCopy() as! NSMutableArray
            let searchPredicate1 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_name")
            let searchPredicate2 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_zipcode")
            let searchPredicate3 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_registration_number")
            let searchPredicate4 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_country")
            let searchPredicate5 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_address_line_one")
            let searchPredicate6 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_address_line_two")
            let searchPredicate7 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_description")
            let searchPredicate8 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_contact_person")
            let searchPredicate9 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "DefaultLanguage")
            let array1 = (profileData.customerAttributeArray as NSMutableArray).filtered(using: searchPredicate1)
            if (array1.count>0) {
             let dictValues = array1[0] as! NSDictionary
                profileData.businessName=dictValues["value"] as? String
            }
            else {
                profileData.businessName=NSLocalizedText(key: "dataNotAdded")
            }
            let array2 = (profileData.customerAttributeArray as NSMutableArray).filtered(using: searchPredicate2)
            if (array2.count>0) {
                let dictValues = array2[0] as! NSDictionary
                profileData.zipcode=dictValues["value"] as? String
            }
            else {
                profileData.zipcode=NSLocalizedText(key: "dataNotAdded")
            }
            let array3 = (profileData.customerAttributeArray as NSMutableArray).filtered(using: searchPredicate3)
            if (array3.count>0) {
                let dictValues = array3[0] as! NSDictionary
                profileData.businessNumber=dictValues["value"] as? String
            }
            else {
                profileData.businessNumber=NSLocalizedText(key: "dataNotAdded")
            }
            let array4 = (profileData.customerAttributeArray as NSMutableArray).filtered(using: searchPredicate4)
            if (array4.count>0) {
                let dictValues = array4[0] as! NSDictionary
                profileData.businessCountry=dictValues["value"] as? String
            }
            else {
                profileData.businessCountry=NSLocalizedText(key: "dataNotAdded")
            }
            let array5 = (profileData.customerAttributeArray as NSMutableArray).filtered(using: searchPredicate5)
            if (array5.count>0) {
                let dictValues = array5[0] as! NSDictionary
                profileData.businessAddressLine1=dictValues["value"] as? String
            }
            else {
                profileData.businessAddressLine1=NSLocalizedText(key: "dataNotAdded")
            }
            let array6 = (profileData.customerAttributeArray as NSMutableArray).filtered(using: searchPredicate6)
            if (array6.count>0) {
                let dictValues = array6[0] as! NSDictionary
                profileData.businessAddressLine2=dictValues["value"] as? String
            }
            else {
                profileData.businessAddressLine2=NSLocalizedText(key: "dataNotAdded")
            }
            let array7 = (profileData.customerAttributeArray as NSMutableArray).filtered(using: searchPredicate7)
            if (array7.count>0) {
                let dictValues = array7[0] as! NSDictionary
                profileData.businessDescription=dictValues["value"] as? String
            }
            else {
                profileData.businessDescription=NSLocalizedText(key: "dataNotAdded")
            }
            let array8 = (profileData.customerAttributeArray as NSMutableArray).filtered(using: searchPredicate8)
            if (array8.count>0) {
                let dictValues = array8[0] as! NSDictionary
                profileData.contactNumber=dictValues["value"] as? String
            }
            else {
                profileData.contactNumber=NSLocalizedText(key: "dataNotAdded")
            }
            let array9 = (profileData.customerAttributeArray as NSMutableArray).filtered(using: searchPredicate9)
            if (array9.count>0) {
                let dictValues = array9[0] as! NSDictionary
                profileData.defaultLanguage=dictValues["value"] as? NSString
            }
            else {
                profileData.defaultLanguage="4"
            }
            profileData.email=dataDict["email"] as? String
            profileData.firstName=dataDict["firstname"] as? String
            profileData.lastName=dataDict["lastname"] as? String
            profileData.storeId=dataDict["store_id"]
            profileData.websiteId=dataDict["website_id"]
            profileData.groupId=dataDict["group_id"]
            profileData.addressArray=(dataDict["addresses"] as! NSArray).mutableCopy() as! NSMutableArray
            success(profileData)
        },failure:failure)
    }
    // MARK: - end
    
    // MARK: - Save user profile service
    func saveUserProfileData(_ profileData: ProfileDataModel, success:@escaping ((_ response: Any?) -> Void), failure:@escaping ((_ err : NSError?) -> Void)) {
        ProfileService().saveUserProfileServiceData(profileData, success: {(response) in
            //Parse data from server response and store in data model
            print("update profile response %@", response as Any)
            let dataDict = response as! NSDictionary
            profileData.customerAttributeArray = (dataDict["custom_attributes"] as! NSArray).mutableCopy() as! NSMutableArray
            let searchPredicate = NSPredicate(format: "attribute_code CONTAINS[C] %@", "DefaultLanguage")
            let array = (profileData.customerAttributeArray as NSMutableArray).filtered(using: searchPredicate)
            if (array.count>0) {
                let dictValues = array[0] as! NSDictionary
                profileData.defaultLanguage=dictValues["value"] as? NSString
                var languageValue:String?
                if (profileData.defaultLanguage?.intValue == 4) {
                    languageValue="gp_en";
                }
                else if (profileData.defaultLanguage?.intValue == 5) {
                    languageValue="gp_zh";
                }
                else if (profileData.defaultLanguage?.intValue == 6) {
                    languageValue="gp_cn";
                }
                UserDefaults().set(languageValue, forKey: "Language")
            }
            success(profileData)
        },failure:failure)
    }
    // MARK: - end
    
    // MARK: - User profile image
    func updateUserProfileImage(_ profileData: ProfileDataModel, success:@escaping ((_ response: Any?) -> Void), failure:@escaping ((_ err : NSError?) -> Void)) {
        ProfileService().updateUserprofileImageService(profileData, success: {(response) in
            //Parse data from server response and store in data model
            print("user profile image %@", response as Any)
           // profileData.userImageURL = response["profile_pic"]
            success(profileData)
        },failure:failure)
    }
    // MARK: - end
    
    // MARK: - Get country list
    func getCountryListing(_ profileData: ProfileDataModel, success:@escaping ((_ response: Any?) -> Void), failure:@escaping ((_ err : NSError?) -> Void)) {
        ProfileService().getCountryCodeService(profileData, success: {(response) in
            //Parse data from server response and store in data model
            print("getCountryListing data %@", response as Any)
            let dataArray=(response as! NSArray).mutableCopy() as! NSMutableArray
            for i in 0..<dataArray.count {
                let dataDict=dataArray[i] as! NSDictionary
                profileData.countryArray.add(dataDict["full_name_locale"] as! String)
            }
            success(profileData)
        },failure:failure)
    }
    // MARK: - end
}
