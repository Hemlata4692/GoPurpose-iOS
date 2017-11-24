//
//  OrderListingViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 03/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit
class OrderListCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
}

class OrderListingViewController: GlobalViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var orderListTableView: UITableView!
    @IBOutlet weak var noRecordLabel: UILabel!
    var totalRecords: Any?
    var currentPageCount:Int = 1
    let footerView = UIView()
    var orderListingArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NSLocalizedText(key: "orderList")
        // Do any additional setup after loading the view.
        noRecordLabel.isHidden=true;
        noRecordLabel.text=NSLocalizedText(key: "norecord")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.addFooterView()
         orderListingArray = NSMutableArray()
        AppDelegate().showIndicator()
        self.perform(#selector(getOrderListing), with: nil, afterDelay: 0.1)
    }
    
    func addFooterView() {
        footerView.backgroundColor = UIColor.white
        footerView.frame=CGRect(x:0, y:0, width:orderListTableView.frame.size.width, height:30)
        let pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        pagingSpinner.startAnimating()
        pagingSpinner.color = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        pagingSpinner.hidesWhenStopped = true
        footerView.addSubview(pagingSpinner)
    }

    //MARK: - Webservices
    //Get order listing data
    @objc func getOrderListing() {
        let orderData = OrderDataModel()
        orderData.currentPage = String(currentPageCount)
        OrderDataModel().getOrderListingData(orderData, success: { (response) in
            AppDelegate().stopIndicator()
            self.orderListingArray.addObjects(from: orderData.orderListDataArray as! [Any])
            self.totalRecords=orderData.totalRecord as! Int
            if self.orderListingArray.count==0 {
                self.noRecordLabel.isHidden=false;
            }
            self.orderListTableView.reloadData()
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    //MARK: - end
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderListingArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderListCell = tableView.dequeueReusableCell(withIdentifier: "orderListCell", for: indexPath) as! OrderListCell
        cell.contentView.layer.borderWidth=1.0
        cell.contentView.layer.borderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor
        var productData = OrderDataModel()
        productData = self.orderListingArray[indexPath.row] as! OrderDataModel
        
        cell.orderIdLabel.attributedText=self.setAttributedString(dataString:productData.orderId!, headingData:NSLocalizedText(key: "purchaseOrder"), textFont:FontUtility.montserratMedium(size: 15), headingFont:FontUtility.montserratSemiBold(size: 16))
       
        cell.dateLabel.attributedText = self.setAttributedString(dataString:self.convertDateFormater(date:productData.orderDate!), headingData:NSLocalizedText(key: "orderDate"),textFont:FontUtility.montserratMedium(size: 12), headingFont:FontUtility.montserratSemiBold(size: 14))
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigate to other screen
        var productData = OrderDataModel()
        productData = self.orderListingArray[indexPath.row] as! OrderDataModel
        let secondViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        secondViewController.orderId = productData.orderDetailId!
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    //pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            if self.orderListingArray.count == totalRecords as! Int {
                orderListTableView.tableFooterView=nil
            }
            else {
                orderListTableView.tableFooterView=footerView
                // call method to add data to tableView
                currentPageCount = +1
                self.getOrderListing()
            }
        }
    }
    // MARK: - end
    
    // MARK: - Date formatter
    func convertDateFormater(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
  // MARK: - end
    
    func setAttributedString(dataString: String, headingData: String, textFont:UIFont, headingFont:UIFont) -> NSMutableAttributedString {
        let headingString = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: headingFont]
        let valueString = [NSAttributedStringKey.foregroundColor:UIColor(red: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0), NSAttributedStringKey.font: textFont]
        let partOne = NSMutableAttributedString(string: headingData, attributes: headingString)
        let partTwo = NSMutableAttributedString(string: dataString, attributes: valueString)
        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(partTwo)
        return combination
    }
}
