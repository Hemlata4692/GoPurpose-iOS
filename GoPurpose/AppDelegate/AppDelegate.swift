//
//  AppDelegate.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 31/10/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    // MARK: - Declarations
    var window: UIWindow?
    var logoImage:UIImageView = UIImageView()
    var loaderView:UIView = UIView()
    var spinnerView:MMMaterialDesignSpinner=MMMaterialDesignSpinner()
    var notificationEnabled:String!
    var targetId:String?
    var notificationId:String?
    var notificationTapped:String?
     var deviceNotificationToken:String?
    // MARK: - end
    
    // MARK: - Show indicator
    func showIndicator() {
        // Initialize the progress view
        window = UIWindow(frame: UIScreen.main.bounds)
        let rect=CGRect(x:3, y:3, width:50, height:50)
        logoImage.frame=rect
        logoImage.backgroundColor=UIColor.white
        logoImage.layer.cornerRadius=25.0
        logoImage.center = (self.window?.center)!
        loaderView.frame=self.window!.bounds
        loaderView.backgroundColor=UIColor(red: 63.0/255.0, green: 63.0/255.0, blue: 63.0/255.0, alpha: 0.3)
        loaderView.tag=100
        loaderView.addSubview(logoImage)
        spinnerView.frame = CGRect(x:0, y:0, width:40, height:40)
        self.spinnerView.bounds = CGRect(x:0, y:0, width:40, height:40);
        self.spinnerView.tintColor = UIColor.black
        self.spinnerView.center = (self.window?.center)!
        self.spinnerView.lineWidth=3.0;
        UIApplication.shared.keyWindow?.addSubview(loaderView)
        loaderView.addSubview(self.spinnerView)
        self.spinnerView.startAnimating()
        self.window?.makeKeyAndVisible()
    }
    // MARK: - end
    
    // MARK: - Stop indicator
    func stopIndicator () {
        self.spinnerView.stopAnimating()
        for loaderView in (UIApplication.shared.keyWindow?.subviews)!{
            if loaderView.tag == 100 {
                loaderView.removeFromSuperview()
                self.spinnerView.removeFromSuperview()
            }
        }
    }
    // MARK: - end
    
    // MARK: - Appdelegate methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //navigation bar color
        UINavigationBar.appearance().barTintColor = UIColor (red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black, NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): FontUtility.montserratMedium(size: 20)]
        
        if (nil==UserDefaults().string(forKey: "Language")) {
            UserDefaults().set("gp_en", forKey: "Language")
        }
        // check if user is already logged in
        if (nil==UserDefaults().string(forKey: "quoteId")) {
            let loginView = storyBoard.instantiateViewController(withIdentifier: "LoginView") as! UINavigationController
            self.window?.rootViewController = loginView
        }
        else {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.window?.rootViewController = nextViewController
        }
        
        //
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        UIApplication.shared.applicationIconBadgeNumber = 0

        //register device for notification
        registerDeviceForNotification()
        
        //Zopim integration
        ZDKConfig.instance().initialize(withAppId:"e5dd7520b178e21212f5cc2751a28f4b5a7dc76698dc79bd",   zendeskUrl:"https://rememberthedate.zendesk.com",     clientId:"client_for_rtd_jwt_endpoint")
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // MARK: - end
    
    // MARK: - Push notification methods
    //register device for remote notifications
    func registerDeviceForNotification() {
      if #available(iOS 10, *) {
    UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
    UIApplication.shared.registerForRemoteNotifications()
        }
       else {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
        }
        notificationEnabled="1"
    }
    
    func unRegisterDeviceForNotification() {
        UIApplication.shared.unregisterForRemoteNotifications()
        notificationEnabled="0"
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string//let datastring = NSString(data: fooData, encoding: String.Encoding.utf8.rawValue)
        let deviceID = NSData(data: deviceToken)
        let deviceTokenString = "\(deviceID)"
            .trimmingCharacters(in: CharacterSet(charactersIn:"<>"))
            .replacingOccurrences(of: " ", with: "")
        print("deviceTokenString : \(deviceTokenString)")
        UserDefaults().set(deviceTokenString, forKey: "deviceToken")
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        self.deviceNotificationToken=deviceTokenString
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    
  @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Called to let your app know which action was selected by the user for a given notification.
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        print("\(String(describing: userInfo))")
            let alertDict = userInfo["aps"] as! NSDictionary
            targetId = alertDict["targat_id"] as? String
            notificationId = alertDict["notification_id"] as? String
            notificationTapped="1"
            self.marknotificationRead(notificationId: notificationId!)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.window?.rootViewController = nextViewController
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
        
    }
    // MARK: - end
    
    func marknotificationRead(notificationId:String) {
        let notificationList = ProfileDataModel()
        notificationList.notificationId=self.notificationId
        ProfileDataModel().markNotificationAsRead(notificationList, success: { (response) in
            AppDelegate().stopIndicator()
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
}

