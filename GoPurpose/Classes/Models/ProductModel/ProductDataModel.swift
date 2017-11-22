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
    var productPrice: UIImage?
    var productImage: String?
    var productStatus: String?
    var productListDataArray:NSMutableArray = NSMutableArray()
    
    // MARK: - Get product list
    func getProductListingData(_ productData: ProductDataModel, success: @escaping ((_ response: Any?) -> Void), failure: @escaping ((_ err : NSError?) -> Void)) {
        ConnectionManager.sharedInstance.getProductListing(productData, success: {(responseObj) in
            //        let responseObj = ProfileDataModel.init(dictionary: responseObj as! Dictionary)
            success(responseObj)
        }, failure: failure)
    }
    // MARK: - end

}
