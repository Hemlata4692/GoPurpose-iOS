//
//  SideBarViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 02/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableCellArray: [String] = ["dashboardCell", "orderCell", "salesCell", "notificationCell", "sgdCell", "logoutCell"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        if indexPath.row == 0 {
            let nameLabel = cell.contentView.viewWithTag(2) as? UILabel
            nameLabel?.text = "Hemlata"
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            //open instruction pop up InstructionViewController
        }
        else if indexPath.row == 3 {
            //logout
            //            UserDefaults.standard.setValue(nil, forKey: "userId")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let loginView = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            UIApplication.shared.keyWindow?.rootViewController = loginView
        }
        tableView .reloadData()
    }
    // MARK: - end
    

}
