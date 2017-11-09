//
//  DynamicHeightWidth.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 06/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    // MARK: Dynamic height for label
    func dynamicHeightWidthForString(width: CGFloat, font:UIFont, isWidth:Bool) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        if isWidth {
            return label.frame.width + 1
        }
        else {
            return label.frame.height + 1
        }
    }
    
    // MARK: Dynamic size for label
    func dynamicSizeForString(width: CGFloat, font:UIFont) -> CGSize {
        let label: UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        label.frame.size.width=label.frame.width + 1
        label.frame.size.height=label.frame.height + 1
        return label.frame.size
    }
}
