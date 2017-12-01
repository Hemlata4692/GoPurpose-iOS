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
    var orderListDataArray:NSMutableArray = NSMutableArray()
    
    //Order details
    var orderStatus: String?
    var orderState: String?
    var purchaseOrderId: String?
    var shippingAddress: NSDictionary = NSDictionary()
    var billingAddress: NSDictionary = NSDictionary()
    var fullBillingAddress: String?
    var fullShippingAddress: String?
    var incrementId: String?
    var productId: String?
    var productName: String?
    var productPrice: Any?
    var productSKU: String?
    var productQty: Any?
    var totalAmount: Any?
    var productDataArray:NSMutableArray = NSMutableArray()
    var trackingNumber: String?
    var trackShipmentArray:NSMutableArray = NSMutableArray()
    
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
    
    // MARK: - Shipment details
    func trackShipmetDetail(_ productData: OrderDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.getShipmentDataService(productData, success: {(responseObj) in
            
            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Get currency details
    func getCurrencyDetail(_ productData: OrderDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.getCurrencyDetailService(productData, success: {(responseObj) in
            
            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end
}
