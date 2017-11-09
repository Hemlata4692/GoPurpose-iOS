//
//  LocalizedString.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 06/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class LocalizedString: NSObject {
    class func changeLocalizedString(_ string: String) -> String {
//        return ([NSDictionary: Any](contentsOf: (Bundle.main.path(forResource: UserDefaults.standard.object(forKey: "Language") as? String, ofType: "strings")) ?? ""))?[string]
        let path = Bundle.main.path(forResource: UserDefaults().string(forKey: "Language"), ofType: "strings")
        if  let dict = NSDictionary(contentsOfFile: path!)?.object(forKey: string) {
            return dict as! String
        }
        return String()
    }

}
