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
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
}

class NotificationViewController: GlobalViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets and declarations
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var noRecordeLabel: UILabel!
    var totalRecords: Any?
    var currentPageCount:Int = 1
    let footerView = UIView()
    var notificationListArray:NSMutableArray = []
    // MARK: - end
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NSLocalizedText(key: "notifications")
        noRecordeLabel.isHidden=true;
        noRecordeLabel.text=NSLocalizedText(key: "norecord")
        // Do any additional setup after loading the view.
        self.addFooterView()
        notificationListArray = NSMutableArray()
        AppDelegate().showIndicator()
        self.perform(#selector(getNotificationList), with: nil, afterDelay: 0.1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addFooterView() {
        footerView.backgroundColor = UIColor.white
        footerView.frame=CGRect(x:0, y:0, width:notificationTableView.frame.size.width, height:30)
        let pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        pagingSpinner.startAnimating()
        pagingSpinner.color = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        pagingSpinner.hidesWhenStopped = true
        footerView.addSubview(pagingSpinner)
    }
    // MARK: - end
    
    // MARK: - Webservice
    @objc func getNotificationList() {
        let notificationList = ProfileDataModel()
         notificationList.currentPage = String(currentPageCount)
        ProfileDataModel().notificationListService(notificationList, success: { (response) in
            AppDelegate().stopIndicator()
            self.notificationListArray.addObjects(from: notificationList.notificationArray as! [Any])
            self.totalRecords=notificationList.totalRecords as! Int
            if self.notificationListArray.count==0 {
               self.noRecordeLabel.isHidden=false;
            }
            self.notificationTableView.reloadData()
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    
    func marknotificationRead(index:Int, notificationId:String) {
        let notificationList = ProfileDataModel()
        notificationList.notificationId=notificationId
        ProfileDataModel().markNotificationAsRead(notificationList, success: { (response) in
            AppDelegate().stopIndicator()
            var notificationData = ProfileDataModel()
            notificationData=self.notificationListArray[index] as! ProfileDataModel
            notificationData.notificationStatus="1"
            self.notificationTableView.reloadData()
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    // MARK: - end
    
    // MARK: - Table view delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationListArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationCell = (tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? NotificationCell)!
         var notificationData = ProfileDataModel()
        notificationData=notificationListArray[indexPath.row] as! ProfileDataModel
        if notificationData.notificationStatus == "1" {
            cell.notificationLabel.alpha=0.3
        }
        else {
            cell.notificationLabel.alpha=1.0
        }
        cell.notificationLabel.text=notificationData.notificationMessage as String?
        cell.contentView.layer.borderWidth = 1;
        cell.contentView.layer.borderColor = tableViewContentBorderColor.cgColor
        cell.notificationLabel.translatesAutoresizingMaskIntoConstraints=true
        let textHeight = cell.notificationLabel.text?.dynamicHeightWidthForString(width: notificationTableView.frame.size.width-75, font: FontUtility.montserratRegular(size: 15), isWidth: false)
        cell.notificationLabel.frame=CGRect(x:42,y:(cell.contentView.frame.size.height/2-textHeight!/2),width:notificationTableView.frame.size.width-75,height:textHeight!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var notificationData = ProfileDataModel()
        notificationData=notificationListArray[indexPath.row] as! ProfileDataModel
        if (CGFloat((notificationData.notificationMessage?.dynamicHeightWidthForString(width: notificationTableView.frame.size.width-75, font: FontUtility.montserratRegular(size: 15), isWidth: false))!) < 60) {
            return 60+12
        }
        else {
            return (notificationData.notificationMessage?.dynamicHeightWidthForString(width: notificationTableView.frame.size.width-75, font: FontUtility.montserratRegular(size: 15), isWidth: false))!+12
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigate to other screen
        var notificationData = ProfileDataModel()
        notificationData=notificationListArray[indexPath.row] as! ProfileDataModel
        self.marknotificationRead(index: indexPath.row, notificationId: notificationData.notificationId!)
        let secondViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
         secondViewController.orderId = notificationData.targetId!
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.notificationListArray.count == totalRecords as! Int {
           notificationTableView.tableFooterView=nil
        }
        else if(indexPath.row == self.notificationListArray.count - 1) {
            if(self.notificationListArray.count < totalRecords as! Int) {
                tableView.tableFooterView = footerView;
                currentPageCount += 1
                self.getNotificationList()
            }
            else {
                notificationTableView.tableFooterView = nil;
            }
        }
    }
    // MARK: - end
}
