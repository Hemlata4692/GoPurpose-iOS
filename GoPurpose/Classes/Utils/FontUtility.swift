//
//  FontUtility.swift
//   GoPurpose
//
//  Created by Ranosys-Mac on 01/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class FontUtility: UIFont {
   
    class func regularFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    class func mediumFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }

    class func lightFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: size)!
    }
    
   class func getStringLength(textString: String, textFont: UIFont) -> Float {
    let stringBoundingBox: CGSize = textString.size(withAttributes: [NSAttributedStringKey.font : textFont])
        return Float(stringBoundingBox.width)
    }

}
