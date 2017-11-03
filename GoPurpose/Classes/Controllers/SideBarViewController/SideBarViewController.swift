//
//  SideBarViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 02/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sideBarTableView: UITableView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var CompanyNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    
    var tableCellArray: [String] = ["dashboardCell", "orderCell", "salesCell", "notificationCell", "SDGCell", "logoutCell"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       UIApplication.shared.statusBarStyle = .lightContent
        userProfileImageView.layer.cornerRadius=65
        userProfileImageView.layer.masksToBounds = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
     UIApplication.shared.statusBarStyle = .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellArray[indexPath.row], for: indexPath)
        let notificationCountLabel = cell.contentView.viewWithTag(3) as? UILabel
        notificationCountLabel?.isHidden=true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            //open instruction pop up InstructionViewController
        }
        else if indexPath.row == 5 {
            //logout
            //            UserDefaults.standard.setValue(nil, forKey: "userId")
            let loginView = storyBoard.instantiateViewController(withIdentifier: "LoginView") as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = loginView
        }
        tableView .reloadData()
    }
    // MARK: - end

}
