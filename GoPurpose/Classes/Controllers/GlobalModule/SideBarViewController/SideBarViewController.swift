//
//  SideBarViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 02/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets and declarations
    @IBOutlet weak var sideBarTableView: UITableView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var CompanyNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    var tableCellDataArray: [String] = []
    var tableCellKeyArray: [String] = ["dashboardCell", "orderCell", "salesCell", "notificationCell", "SDGCell", "logoutCell"]
    // MARK: - end
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBarTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        userProfileImageView.layer.cornerRadius=65
        userProfileImageView.layer.masksToBounds = true
        if ((UserDefaults().string(forKey: "userProfileImage")) != nil) {
            userProfileImageView.downloadFrom(link: UserDefaults().string(forKey: "userProfileImage")!)
        }
        if (UserDefaults().string(forKey: "groupName") == nil) {
            userTypeLabel.text=NSLocalizedText(key: "dataNotAdded")
        }
        else {
        userTypeLabel.text=UserDefaults().string(forKey: "groupName")
        }
        if (UserDefaults().string(forKey: "businessName") == nil) {
            CompanyNameLabel.text=NSLocalizedText(key: "dataNotAdded")
        CompanyNameLabel.translatesAutoresizingMaskIntoConstraints = true;
            CompanyNameLabel.frame = CGRect(x: CompanyNameLabel.frame.origin.x, y: CompanyNameLabel.frame.origin.y, width: CompanyNameLabel.frame.size.width, height: 0)        }
        else {
            CompanyNameLabel.text=UserDefaults().string(forKey: "businessName")
        }
        tableCellDataArray = [NSLocalizedText(key: "sideBarDashboard"), NSLocalizedText(key: "sideBarOrder"), NSLocalizedText(key: "sideBarSales"), NSLocalizedText(key: "sideBarNotification"), NSLocalizedText(key: "sideBarSDG"), NSLocalizedText(key: "sideBarLogout")]
        self.sideBarTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     // MARK: - end
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableCellDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            if (UserDefaults().string(forKey: "groupId")as AnyObject).intValue == 4 {
                return 50
            }
            else {
                return 0
            }
        }
        else  if indexPath.row == 2 {
            if (UserDefaults().string(forKey: "groupId")as AnyObject).intValue == 4 {
                return 50
            }
            else {
                return 0
            }
        }
        else if indexPath.row == 3 {
            if (UserDefaults().string(forKey: "groupId")as AnyObject).intValue == 4 {
                return 50
            }
            else {
                return 0
            }
        }
        else {
            return 50

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellKeyArray[indexPath.row], for: indexPath)
        let nameLabel = cell.contentView.viewWithTag(1) as? UILabel
        nameLabel?.text=tableCellDataArray[indexPath.row]
        
        let notificationCountLabel = cell.contentView.viewWithTag(3) as? UILabel
        notificationCountLabel?.layer.cornerRadius = 8;
        notificationCountLabel?.clipsToBounds=true
        if ((nil == UserDefaults().string(forKey: "notificationCount")) || (UserDefaults().string(forKey: "notificationCount")?.isEmpty)!) {
            notificationCountLabel?.isHidden=true
        }
        else {
            notificationCountLabel?.isHidden=false
            notificationCountLabel?.text=UserDefaults().string(forKey: "notificationCount")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async( execute: {
            if indexPath.row == 2 {
                //open instruction pop up InstructionViewController
            }
            else if indexPath.row == 5 {
                //logout
                let alert = SCLAlertView()
                _ = alert.addButton(NSLocalizedText(key: "alertOk")) {
                    AppDelegate().unRegisterDeviceForNotification()
                    UserDefaults().removeObject(forKey: "quoteId")
                    let loginView = storyBoard.instantiateViewController(withIdentifier: "LoginView") as! UINavigationController
                    UIApplication.shared.keyWindow?.rootViewController = loginView
                }
                _ = alert.showWarning(NSLocalizedText(key: "alertTitle"), subTitle: NSLocalizedText(key: "logoutUser"), closeButtonTitle: NSLocalizedText(key: "alertCancel"))
            }
        })
    }
    // MARK: - end
    
}
