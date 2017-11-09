//
//  CornerRadius+UIVIew.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 02/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    //add border and corner radius
    func addBorderRadius(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    //add corner radius
    func addCornerRadius(radius:CGFloat) {
        self.layer.cornerRadius = radius
    }
}

extension UIButton {
    //add border and corner radius
    func addButtonBorderRadius(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    //add corner radius
    func addButtonCornerRadius(radius:CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    //add bottom border
    func addBottomBorderWithColor(color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        self.layer.addSublayer(border)
    }
}
