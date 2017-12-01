//
//  OrderService.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 24/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

private var kOrderList = "gopurpose/marketplace/orders"
private var kOrderDetails = "orders"
private var kTrackShippment="shipments";
private var kGetCurrency="directory/currency";

class OrderService: BaseService {

    // MARK: - Order list service
    func getOrderListService(_ orderData: OrderDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!
        ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .post
        // {"searchCriteria":{"current_page":1,"page_size":12,"sort_orders":[{"direction":"DESC","field":"created_at"}]}}
        let param=["current_page": orderData.currentPage as AnyObject, "page_size": "12"] as [String : Any]
        request.parameters = ["searchCriteria":param] as [String: AnyObject]
        request.headers=headers
        print("get order list request %@", request.parameters as Any)
        request.path = basePath + kOrderList
        self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Order detail
    func getOrderDetailsData(_ productData: OrderDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!
        ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .post
        let filterGroup:NSMutableArray = NSMutableArray()
        let filter:NSMutableArray = NSMutableArray()
        let sortOrders:NSMutableArray = NSMutableArray()
        filter.add(["condition_type": "eq", "field": "entity_id", "value": productData.orderDetailId])
            filterGroup.add(["filters":filter])
            sortOrders.add(["direction": "DESC", "field": "created_at"])
        let param2=["current_page": "1","filter_groups":filterGroup,"page_size": "12", "sort_orders": sortOrders] as [String : Any]
        request.parameters = ["searchCriteria":param2] as [String : AnyObject]
        request.headers=headers
        print("getOrderDetailsData request %@", request.parameters as Any)
        request.path = basePath + kOrderDetails
        self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Order detail
    func trackShipmentData(_ productData: OrderDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!
        ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .post
        let filterGroup:NSMutableArray = NSMutableArray()
        let filter:NSMutableArray = NSMutableArray()
        let sortOrders:NSMutableArray = NSMutableArray()
        filter.add(["condition_type": "eq", "field": "order_id", "value": productData.orderId])
        filterGroup.add(["filters":filter])
        sortOrders.add(["direction": "DESC", "field": "order_id"])
        let param2=["current_page": "0","filter_groups":filterGroup,"page_size": "0", "sort_orders": sortOrders] as [String : Any]
        request.parameters = ["searchCriteria":param2] as [String : AnyObject]
        request.headers=headers
        print("track shipment request %@", request.parameters as Any)
        request.path = basePath + kTrackShippment
        self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end
    
    // MARK: - Get currency detail
    func getCurrencyDetailData(_ productData: OrderDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!
        ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .get
        request.parameters = nil
        request.headers=headers
        print("curreny request %@", request.parameters as Any)
        request.path = basePath + kGetCurrency
        self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end
}
