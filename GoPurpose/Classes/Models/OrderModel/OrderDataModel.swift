//
//  OrderDataModel.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 24/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class OrderDataModel: NSObject {

    var orderId: String?
    var orderDetailId: String?
    var orderDate: String?
    var currentPage: String?
    var totalRecord: Any?
//    var productQuantity: String?
//    var productType: String?
//    var productPrice: String?
//    var productImage: String?
//    var productStatus: String?
//    var currentPage: String?
//    var searchKey: String?
//    var totalRecordsCount: Any?
    var orderListDataArray:NSMutableArray = NSMutableArray()
    
    // MARK: - Get order list
    func getOrderListingData(_ productData: OrderDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.getOrderListing(productData, success: {(responseObj) in
            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Order details
    func getOrderDetailsData(_ productData: OrderDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.getOrderDetailsDataService(productData, success: {(responseObj) in
        
            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end
}
