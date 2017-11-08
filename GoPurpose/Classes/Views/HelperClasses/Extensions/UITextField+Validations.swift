//
//  UITextField+Validations.swift
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit

extension UITextField {

    func isEmpty() -> Bool {
        let performedString: NSString = (self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))! as NSString
        return performedString.length == 0 ? true : false
    }
    
    func isValidEmail() -> Bool {
    let emailRegEx = """
    (?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}\
    ~-]+)*|"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\\
    x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*")@(?:(?:[A-Za-z0-9](?:[A-Za-\
    z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5\
    ]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-\
    9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\
    -\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])
    """
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: text)
    }
    
    func isValidContactNo() -> Bool {
        let contactRegex: NSString = "^[0-9]{6,16}$"
        let contactTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", contactRegex)
        return contactTest.evaluate(with: self.text)
    }
    
    func isValidPassword() -> Bool {
        //At least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
        let passwordRegex: NSString = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])"
//         let passwordRegex: NSString = "^(?=.*[A-Z])(?=.*[$@$#!%*?&])(?=.*[0-9])(?=.*[a-z])$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: text)
    }
    
    func isValidURL() -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: text)
    }

}
