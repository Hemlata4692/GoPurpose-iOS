//
//  NotificationViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 03/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var notificationLabel: UILabel!
}

class NotificationViewController: GlobalViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets and declarations
    @IBOutlet weak var notificationTableView: UITableView!
    // MARK: - end
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NSLocalizedText(key: "notifications")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - end
    
    // MARK: - Table view delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationCell = (tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? NotificationCell)!
        //cell.notificationLabel.text=missionDataValue.missionTitle as String?
        cell.contentView.layer.borderWidth = 1;
        cell.contentView.layer.borderColor = UIColor (red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1.0).cgColor
        cell.notificationLabel.translatesAutoresizingMaskIntoConstraints=true
        let textHeight = cell.notificationLabel.text?.dynamicHeightWidthForString(width: notificationTableView.frame.size.width-75, font: FontUtility.montserratRegular(size: 15), isWidth: false)
        cell.notificationLabel.frame=CGRect(x:42,y:8,width:notificationTableView.frame.size.width-75,height:textHeight!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigate to other screen
    }
    // MARK: - end
}
