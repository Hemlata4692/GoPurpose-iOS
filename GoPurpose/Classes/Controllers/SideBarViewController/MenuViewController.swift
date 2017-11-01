//
//  MenuViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 01/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit


class MenuViewController: UITableViewController {
    
   var arrayOfStrings: [String] = ["ProfileCell", "MissionCell", "InstructionCell", "LogoutCell"]
  
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - end
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 204
        } else {
            return 80
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: arrayOfStrings[indexPath.row], for: indexPath)
        if indexPath.row == 0 {
        let nameLabel = cell.contentView.viewWithTag(2) as? UILabel
        nameLabel?.text = "Hemlata"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
