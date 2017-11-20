//
//  Constant.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 01/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import Foundation
import UIKit

//Storyboard initialisation
let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

// Base URL
let BASE_URL: String = "https://dev.gopurpose.com/"
let basePath = BASE_URL + UserDefaults().string(forKey: "Language")! + "/rest/" + UserDefaults().string(forKey: "Language")!+"/V1/"

// Constants for screen sizes
let kScreenSize = UIScreen.main.bounds.size
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

//appdelegate object
let myDelegate = UIApplication.shared.delegate as? AppDelegate

//static colors
let kBorderColor: UIColor = UIColor(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 0.7)
let kBottomTabDeSelectedColor: UIColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
let kBottomTabSelectedColor: UIColor = UIColor(red: 182/255, green: 37/255, blue: 70/255, alpha: 1)
let tableViewContentBorderColor: UIColor = UIColor (red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1.0)

//Camera/Gallery permissions
let kCameraPermission: String       = "\"GoPurpose Would\" Like to Access the Camera"
let kCameraUsageMessage: String     = "Application will use camera to take photos for report upload and profile photo"
let kGalleryPermission: String      = "\"GoPurpose Would\" Like to Access Your Photos"
let kGalleryUsageMessage: String    = "Application will use photo library to select profile photo"


//Define to use multi language
func NSLocalizedText(key: String) -> String {
    return LocalizedString.changeLocalizedString(key)
}

//Get country code
func localeCountryCode() -> String {
    return ((Locale.current as NSLocale).object(forKey: .countryCode) as? String)!
}

