//
//  OrderDetailsViewController.swift
//  GoPurpose
//
//  Created by Monika on 24/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit
// MARK: - Table view cell class
class OrderDetailCell: UITableViewCell {
    //Order Id cell
    @IBOutlet weak var productNameHeadingLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    //Order detail cell
    @IBOutlet weak var skuHeadingLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var QuantityHeadingLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceHeadingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    //Order total cell
    @IBOutlet weak var totalHeadingLabel: UILabel!
    @IBOutlet weak var priceTotalLabel: UILabel!
    //Address cell
    @IBOutlet weak var addressInfoHeadingLabel: UILabel!
    @IBOutlet weak var shipToHeadingLabel: UILabel!
    @IBOutlet weak var shippingAddressHeadingLabel: UILabel!
    @IBOutlet weak var shippingAddressLabel: UILabel!
    @IBOutlet weak var shippingZipcodeHeadingLabel: UILabel!
    @IBOutlet weak var shippingZipcodeLabel: UILabel!
    @IBOutlet weak var shippingContactHeadingLabel: UILabel!
    @IBOutlet weak var shippingContactLabel: UILabel!
    @IBOutlet weak var shippingContactNumberHeadingLabel: UILabel!
    @IBOutlet weak var shippingContactNumberLabel: UILabel!
    @IBOutlet weak var billToHeadingLabel: UILabel!
    @IBOutlet weak var billingAddressHeadingLabel: UILabel!
    @IBOutlet weak var billingAddressLabel: UILabel!
    @IBOutlet weak var billingZipcodeHeadingLabel: UILabel!
    @IBOutlet weak var billingZipcodeLabel: UILabel!
    @IBOutlet weak var billingContactHeadingLabel: UILabel!
    @IBOutlet weak var billingContactLabel: UILabel!
    @IBOutlet weak var billingContactNumberHeadingLabel: UILabel!
    @IBOutlet weak var billingContactNumberLabel: UILabel!
}
// MARK: - end

class OrderDetailsViewController: GlobalViewController, UITableViewDelegate, UITableViewDataSource {
    var orderId: String?
    var orderDetailArray:NSMutableArray = NSMutableArray()
    @IBOutlet weak var orderTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        orderDetailArray = ["profileImageCell", "companyCell"]
        
        AppDelegate().showIndicator()
        self.perform(#selector(getOrderDetails), with: nil, afterDelay: 0.1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - end
    
    //MARK: - Webservices
    //Get order details data
    @objc func getOrderDetails() {
        let orderData = OrderDataModel()
        orderData.orderDetailId=orderId
        OrderDataModel().getOrderDetailsData(orderData, success: { (response) in
            AppDelegate().stopIndicator()
            self.orderDetailArray.addObjects(from: orderData.productDataArray as! [Any])
            if self.orderDetailArray.count==0 {
                //self.noRecordLabel.isHidden=false;
            }
            self.orderTableView.reloadData()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return orderDetailArray.count + 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row==0 {
                return 55
            }
            else if indexPath.row ==  orderDetailArray.count + 1 {
                return 40
            } else {
                return 160
            }
        } else {
            return 280
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = String()
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cellIdentifier = "orderIdCell"
            } else if indexPath.row ==  orderDetailArray.count + 1 {
                cellIdentifier = "orderTotalCell"
            } else {
                cellIdentifier = "purchaseListCell"
            }
        } else {
            cellIdentifier = "addressCell"
        }
        let cell:OrderDetailCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OrderDetailCell
        
        //Set top border
        let topBorder = CALayer()
        topBorder.borderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor;
        topBorder.borderWidth = 1;
        topBorder.frame = CGRect(x: 0, y: 1, width: self.view.frame.size.width - 20, height: 1)
        cell.contentView.layer.addSublayer(topBorder)
        
        //Set left border
        let leftBorder = CALayer()
        leftBorder.backgroundColor = UIColor.green.cgColor
        leftBorder.borderWidth = 1
        leftBorder.frame = CGRect(x: 1, y: 1, width: 1, height: cell.contentView.frame.size.height)
        cell.contentView.layer.addSublayer(leftBorder)
        
        //Set right border
        let rightBorder = CALayer()
        rightBorder.backgroundColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor
        rightBorder.borderWidth = 1
        rightBorder.frame = CGRect(x: self.view.frame.size.width - 22, y: 1, width: 1, height: cell.contentView.frame.size.height)
        cell.contentView.layer.addSublayer(rightBorder)
        
        //Set bottom border
        if (indexPath.section == 0 && indexPath.row ==  orderDetailArray.count + 1) || (indexPath.section == 1) {
            let bottomBorder = CALayer()
            bottomBorder.borderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor;
            bottomBorder.borderWidth = 1;
            bottomBorder.frame = CGRect(x: 0, y: cell.contentView.frame.size.height - 1, width: self.view.frame.size.width - 20, height: 1)
            cell.contentView.layer.addSublayer(bottomBorder)
        }
        
        if indexPath.section == 0 {
            var data = OrderDataModel()
            if (self.orderDetailArray.count == 0)  {
            }
            else {
               // data = self.orderDetailArray[indexPath.row] as! OrderDataModel
            }
           
           //cell.productNameHeadingLabel
            cell.productNameLabel.text=data.productName
//             cell.orderIdLabel.text=
//            //Order detail cell
//            // cell.skuHeadingLabel
           cell.skuLabel.text = data.productSKU
//             //cell.QuantityHeadingLabel
             cell.quantityLabel.text = data.productQty
//             //cell.priceHeadingLabel
             cell.priceLabel.text = data.productPrice
//            //Order total cell
//            // cell.totalHeadingLabel.text=
//             cell.priceTotalLabel.text=
        }
        
        
        if indexPath.section == 1 {
            let address="5 c 7, duplex colony, bikaner, Rajasthan, India"
            cell.shippingAddressLabel.text = address
            cell.shippingAddressLabel.numberOfLines = 0
            cell.shippingAddressLabel.translatesAutoresizingMaskIntoConstraints = true
            var textHeight = cell.shippingAddressLabel.text?.dynamicHeightWidthForString(width: (orderTableView.frame.size.width/2) - 30, font: FontUtility.montserratLight(size: 14), isWidth: false)
            cell.shippingAddressLabel.frame=CGRect(x:10,y:cell.shippingAddressLabel.frame.origin.y + 1,width: (orderTableView.frame.size.width/2) - 30,height:textHeight!)
            cell.shippingAddressLabel.backgroundColor = UIColor.red
            
            cell.billingAddressLabel.text = address
            cell.billingAddressLabel.numberOfLines = 0
            cell.billingAddressLabel.translatesAutoresizingMaskIntoConstraints = true
            textHeight = cell.shippingAddressLabel.text?.dynamicHeightWidthForString(width: (orderTableView.frame.size.width/2) - 30, font: FontUtility.montserratLight(size: 14), isWidth: false)
            cell.billingAddressLabel.frame=CGRect(x:cell.shippingAddressLabel.frame.origin.y + cell.shippingAddressLabel.frame.size.width+10,y:cell.shippingAddressLabel.frame.origin.y + 1,width: (orderTableView.frame.size.width/2) - 30,height:textHeight!)
        }
        return cell
    }
    // MARK: - end
}
