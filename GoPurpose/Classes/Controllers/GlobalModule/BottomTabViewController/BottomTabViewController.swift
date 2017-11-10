//
//  BottomTabViewController.swift
//  SideBarBottomBarSwift
//
//  Created by Ranosys-Mac on 28/10/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class BottomTabViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var dashboardButton: UIButton!
    @IBOutlet weak var homeImageIcon: UIImageView!
    @IBOutlet weak var messageImageIcon: UIImageView!
    @IBOutlet weak var productImageIcon: UIImageView!
    @IBOutlet weak var settingsImageIcon: UIImageView!
    //MARK: - end
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        messageButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        productButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        settingsButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        dashboardButton.isSelected=false
        productButton.isSelected=false
        messageButton.isSelected=false
        settingsButton.isSelected=false
        dashboardButton.titleLabel?.text=NSLocalizedText(key: "homeTab")
        messageButton.titleLabel?.text=NSLocalizedText(key: "messageTab")
        productButton.titleLabel?.text=NSLocalizedText(key: "productTab")
        settingsButton.titleLabel?.text=NSLocalizedText(key: "settingTab")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - end
    
    //MARK: - Set selected tab
    func showSelectedTab(item: Int) {
        switch item {
        case 1:
            dashboardButton?.isSelected=true
            dashboardButton?.backgroundColor=UIColor(red: 182/255, green: 37/255, blue: 70/255, alpha: 1)
            homeImageIcon.alpha=0.6
        case 2:
            messageButton?.isSelected=true
            messageButton?.backgroundColor=UIColor(red: 182/255, green: 37/255, blue: 70/255, alpha: 1)
            messageImageIcon.alpha=0.6
        case 3:
            productButton?.isSelected=true
            productButton?.backgroundColor=UIColor(red: 182/255, green: 37/255, blue: 70/255, alpha: 1)
            productImageIcon.alpha=0.6
        case 4:
            settingsButton?.isSelected=true
            settingsButton?.backgroundColor=UIColor(red: 182/255, green: 37/255, blue: 70/255, alpha: 1)
            settingsImageIcon.alpha=0.6
        default:
            break
        }
    }
    //MARK: - end
    
    //MARK: - IBActions
    @IBAction func dashboardButtonAction(_ sender: Any) {
        if (!dashboardButton.isSelected) {
            dashboardButton.backgroundColor=UIColor(red: 182/255, green: 37/255, blue: 70/255, alpha: 1)
            messageButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            productButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            settingsButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            UIApplication.shared.keyWindow?.rootViewController = nextViewController
        }
    }
    
    @IBAction func messageButtonAction(_ sender: Any) {
        if (!messageButton.isSelected) {
            dashboardButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            messageButton.backgroundColor=UIColor(red: 182/255, green: 37/255, blue: 70/255, alpha: 1)
            productButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            settingsButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
           //open zopim ticket
            let jwtUserIdentity = ZDKJwtIdentity(jwtUserIdentifier:UserDefaults().string(forKey: "userEmail"))
            ZDKConfig.instance().userIdentity = jwtUserIdentity
            ZDKRequests.presentRequestList(with: self)
        }
    }
    
    @IBAction func productButtonAction(_ sender: Any) {
        if (!productButton.isSelected) {
            dashboardButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            messageButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            productButton.backgroundColor=UIColor(red: 182/255, green: 37/255, blue: 70/255, alpha: 1)
            settingsButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let loginView = storyBoard.instantiateViewController(withIdentifier: "ProductListViewController") as? ProductListViewController
            self.navigationController?.setViewControllers([loginView!], animated: false)
        }
    }
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        if (!settingsButton.isSelected) {
            dashboardButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            messageButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            productButton.backgroundColor=UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            settingsButton.backgroundColor=UIColor(red: 182/255, green: 37/255, blue: 70/255, alpha: 1)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let loginView = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
            self.navigationController?.setViewControllers([loginView!], animated: false)
        }
    }
    //MARK: - end
}
