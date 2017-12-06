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
private var kNotificationList = "gopurpose/notifications/getList"

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
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!,
            ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .get
        request.parameters = nil
        request.headers=headers
        print("get country list request %@", request.parameters as Any)
        request.path = basePath + kCountryCode
        self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Get user service
    func getUserProfileServiceData(_ profileData: ProfileDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!,
            ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .get
        request.parameters = nil
        request.headers=headers
        print("get user profile request %@", request.parameters as Any)
        request.path = basePath + kUserProfile
        self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Save user service
    func saveUserProfileServiceData(_ profileData: ProfileDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!,
            ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .put
        let param=["email": profileData.email as AnyObject, "lastname": profileData.lastName as AnyObject, "firstname": profileData.firstName as AnyObject, "id": profileData.userId as AnyObject, "website_id": profileData.websiteId as AnyObject, "store_id": profileData.storeId as AnyObject, "group_id": profileData.groupId as AnyObject, "addresses": profileData.addressArray as AnyObject, "custom_attributes": profileData.customerAttributeArray as AnyObject]
        request.parameters = ["customer":param] as [String: AnyObject]
        request.headers=headers
        print("save user profile request %@", request.parameters as Any)
        request.path = basePath + kUserProfile
        self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end
    
    // MARK: - User profile image service
    func updateUserprofileImageService(_ profileData: ProfileDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!,
            ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .post
        request.headers = headers
        let imageData = UIImageJPEGRepresentation(profileData.userProfileImage!,0.3)
        let imageUploadPath = BASE_URL + UserDefaults().string(forKey: "Language")! + "/"
        request.path = imageUploadPath + kEditProfilePicture
        request.parameters = ["customerId" : UserDefaults().string(forKey: "userId") as AnyObject] as [String: AnyObject]
        self.callImageWebServiceAlamofire(imageDict: imageData!, alamoReq: request, success: success, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Notification service
    func notificationListService(_ profileData: ProfileDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        print(UserDefaults().string(forKey: "apiKey")!)
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!,
            ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .post
        let filterGroup:NSMutableArray = NSMutableArray()
        let filter:NSMutableArray = NSMutableArray()
        let sortOrders:NSMutableArray = NSMutableArray()
        filter.add(["condition_type": "eq", "field": "customer_id", "value": UserDefaults().string(forKey: "userId") as AnyObject])
        filterGroup.add(["filters":filter])
       sortOrders.add(["direction": "DESC", "field": "created_at"])
        let param2=["current_page": profileData.currentPage as AnyObject,"filter_groups":filterGroup,"page_size": "12", "sort_orders": sortOrders] as [String : Any]
        request.parameters = ["criteria":param2] as [String : AnyObject]
        request.headers=headers
        print("notificationListService request %@", request.parameters as Any)
        request.path = basePath + kNotificationList
        self.callPostService(request, success: success, failure: failure)
    }
    
    func markNotificationRead(_ profileData: ProfileDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!,
            ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .post
        request.parameters = ["notificationId":profileData.notificationId, "status":"1"] as [String : AnyObject]
        request.headers=headers
        print("mark notificationread request %@", request.parameters as Any)
        request.path = basePath + kNotificationList
        self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end
}

