//
//  ProductService.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 22/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

 private var kProductList = "gopurpose/marketplace/products"

class ProductService: BaseService {

    // MARK: - Get product service
    func getProductListService(_ productData: ProductDataModel, success: @escaping ((_ responseObject: Any?) -> Void), failure: @escaping ((_ error : NSError?) -> Void)) {
        let headers = [
            "Authorization": "Bearer " + UserDefaults().string(forKey: "apiKey")!,
            ]
        var request:alamofireRequestModal = alamofireRequestModal()
        request.method = .post
        request.parameters = nil
        request.headers=headers
        print("get product list request %@", request.parameters as Any)
        request.path = basePath + kProductList
        self.callPostService(request, success: success, failure: failure)
    }
    // MARK: - end
}

