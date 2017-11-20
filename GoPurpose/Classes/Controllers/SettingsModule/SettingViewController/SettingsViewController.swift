//
//  SettingsViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 02/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

// MARK: - Table view cell class
class ProfileTableCell: UITableViewCell {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var enableNotificationSwitch: UISwitch!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var changePasswordLabel: UILabel!
}
// MARK: - end

class SettingsViewController: GlobalViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets and delarations
    @IBOutlet weak var profileTableView: UITableView!
    
    var tableCellKeysArray: [String] = ["profileImageCell", "companyCell", "emailCell", "changePasswordCell", "notificationCell"]
    // MARK: - end
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title=NSLocalizedText(key: "profile")
        self.showSelectedTab(item: 4)
        self.profileTableView.reloadData()
    }
    // MARK: - end
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableCellKeysArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row==0 {
            return 160
        }
        else if indexPath.row==1 {
            return 25
        }
        else if indexPath.row==2 {
            return 45
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: tableCellKeysArray[indexPath.row], for: indexPath) as! ProfileTableCell
        cell.userProfileImage?.layer.cornerRadius=60
        cell.userProfileImage?.layer.masksToBounds = true
        cell.changePasswordLabel?.text=NSLocalizedText(key: "changePasswordProfile")
        cell.notificationLabel?.text=NSLocalizedText(key: "notifications")
        
        cell.enableNotificationSwitch?.addTarget(self, action: #selector(switchIsChanged(mySwitch:)), for: UIControlEvents.valueChanged)
        cell.enableNotificationSwitch?.backgroundColor=kBorderColor
        cell.enableNotificationSwitch?.layer.cornerRadius=16.0
        cell.editProfileButton?.addTarget(self, action:#selector(editProfileAction(sender:)), for: .touchUpInside)
        
        //set switch on/off acc to notification enabled or not
        if myDelegate?.notificationEnabled == "1" {
            cell.enableNotificationSwitch?.setOn(true, animated: true)
        }
        else {
            cell.enableNotificationSwitch?.setOn(false, animated: true)
        }
        
        cell.emailLabel?.text=UserDefaults().string(forKey: "userEmail")
        cell.companyNameLabel?.text=UserDefaults().string(forKey: "businessName")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async( execute: {
            if indexPath.row == 3 {
                //navigate to change password
                let secondViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
        })
    }
    // MARK: - end
    
    // MARK: - IBActions
    @objc func switchIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            AppDelegate().registerDeviceForNotification()
            self.saveDeviceToken()
        } else {
            AppDelegate().unRegisterDeviceForNotification()
        }
    }
    
    @objc func editProfileAction(sender: UIButton) {
        //navigate to edit profile
        let secondViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    // MARK: - end
    
    // MARK: - Web services
    @objc func saveDeviceToken() {
        let userData = LoginDataModel()
        LoginDataModel().saveDeviceToken(userData, success: { (response) in
            AppDelegate().stopIndicator()
            print(userData as AnyObject)
            // Successfully logged in, move to next screen
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    // MARK: - end
}

