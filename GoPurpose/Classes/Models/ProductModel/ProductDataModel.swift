//
//  ProductDataModel.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 22/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class ProductDataModel: NSObject {
    var productId: String?
    var productName: String?
    var productSKU: String?
    var productQuantity: String?
    var productType: String?
    var productPrice: String?
    var productImage: String?
    var productStatus: String?
    var currentPage: String?
    var searchKey: String?
    var totalRecordsCount: Any?
    var productListDataArray:NSMutableArray = NSMutableArray()
    
    var totalProducts: Any?
    var pendingApproval: Any?
    var lifeTimeSale: Any?
    var pendingFullfilment: Any?
    var totalOrders: Any?
    var groupName: String?
    var userProfileImage: String?
    var groupId: Any?
    var dashboardDataArray:NSMutableDictionary = NSMutableDictionary()
    
    // MARK: - Get product list
    func getProductListingData(_ productData: ProductDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.getProductListing(productData, success: {(responseObj) in
            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Dashboard list
    func getDashboardListingData(_ productData: ProductDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.dashboardServieData(productData, success: {(responseObj) in
              UserDefaults().set(productData.userProfileImage!, forKey: "userProfileImage")
            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end
}
