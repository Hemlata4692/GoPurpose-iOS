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
    @IBOutlet weak var orderStatusLabel: UILabel!
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

class OrderDetailsViewController: GlobalBackViewController, UITableViewDelegate, UITableViewDataSource {
   
    // MARK: - IBOutlets and variables
    var orderId: String?
    var orderDetailArray:NSMutableArray = NSMutableArray()
    var currencySymbolArray:NSMutableArray = NSMutableArray()
    var totalPrice: String?
    var orderStatus: String?
    var purchaseOrderId: String?
    var shippingAddressData: NSDictionary = NSDictionary()
    var billingAddressData: NSDictionary = NSDictionary()
    var trackingDataArray:NSMutableArray = NSMutableArray()
    var conversionPrice: Double = 0.0
    var currencySymbol: String?
    
    @IBOutlet weak var noRecordLabel: UILabel!
    @IBOutlet weak var trackOrderButton: UIButton!
    @IBOutlet weak var orderTableView: UITableView!
    // MARK: - end
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NSLocalizedText(key:"orderDetails")
        noRecordLabel.isHidden=true
        noRecordLabel.text=NSLocalizedText(key: "noRecord")
        trackOrderButton.addButtonCornerRadius(radius: 20)
        AppDelegate().showIndicator()
        self.perform(#selector(getCurrencyDetails), with: nil, afterDelay: 0.1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - end
    
    //MARK: - Webservices
    //track shipment service
    @objc func getCurrencyDetails() {
        let orderData = OrderDataModel()
        OrderDataModel().getCurrencyDetail(orderData, success: { (response) in
            self.currencySymbolArray=orderData.availableCurrencyArray.mutableCopy() as! NSMutableArray
            self.getOrderDetails()
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    
    //Get order details data
    @objc func getOrderDetails() {
        let orderData = OrderDataModel()
        orderData.orderDetailId=orderId
        OrderDataModel().getOrderDetailsData(orderData, success: { (response) in
            self.orderDetailArray=(orderData.productDataArray as NSArray).mutableCopy() as! NSMutableArray
            if self.orderDetailArray.count==0 {
                self.noRecordLabel.isHidden=false
                self.orderTableView.isHidden=true
                self.trackOrderButton.isHidden=true
                AppDelegate().stopIndicator()
            }
            else {
                self.getShipmentDetails(purchaseId: orderData.purchaseOrderId!)
                self.noRecordLabel.isHidden=true
                self.orderTableView.isHidden=false
                self.orderStatus=orderData.orderStatus
                self.shippingAddressData=orderData.shippingAddress["address"] as! NSDictionary
                self.billingAddressData=orderData.billingAddress
                for i in 0..<self.currencySymbolArray.count {
                    let currencyDict = self.currencySymbolArray.object(at: i) as! NSDictionary
                    if (currencyDict["currency_to"]! as? String == orderData.orderCurrencyCode! as? String) {
                        self.conversionPrice = currencyDict["rate"] as! Double
                        self.currencySymbol = currencyDict["currency_symbol"] as? String
                    }
                }
                self.totalPrice = self.currencySymbol! + (NSString(format:"%.1f", orderData.totalAmount! as! Double) as String) as String
                self.orderTableView.reloadData()
                self.orderTableView.translatesAutoresizingMaskIntoConstraints=true
               if (self.orderStatus?.contains(NSLocalizedText(key: "canceled")))! {
                    self.trackOrderButton.isHidden=true
                    self.orderTableView.frame=CGRect(x:10,y:-12,width:kScreenWidth-20,height:kScreenHeight-75)
                }
                else {
                    self.trackOrderButton.isHidden=false
                    self.orderTableView.frame=CGRect(x:10,y:-15,width:kScreenWidth-20,height:kScreenHeight-165)
                }
            }
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    
    //track shipment service
    func getShipmentDetails(purchaseId:String) {
        let orderData = OrderDataModel()
        orderData.orderId=purchaseId
        OrderDataModel().trackShipmetDetail(orderData, success: { (response) in
            AppDelegate().stopIndicator()
            self.trackingDataArray=(orderData.trackShipmentArray as NSArray).mutableCopy() as! NSMutableArray
            if (self.trackingDataArray.count == 0) {
                self.trackOrderButton.isHidden=true
                self.orderTableView.frame=CGRect(x:10,y:-12,width:kScreenWidth-20,height:kScreenHeight-75)
            }
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
        if self.orderDetailArray.count>0 {
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
            if !(self.orderDetailArray.count==0) {
                let shppingAddressArray:[String] = (shippingAddressData["street"] as! NSArray) as! [String];
                let shppingAddress =  shppingAddressArray.joined(separator: " ")
                let textHeight = (shppingAddress).dynamicHeightWidthForString(width: (orderTableView.frame.size.width/2) - 30, font: FontUtility.montserratLight(size: 14), isWidth: false)
                return 260+textHeight
            }
            else {
                return 280
            }
        }
        }
        else {
            return 0
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
        
        cell.contentView.layer.borderWidth=1.0
        cell.contentView.layer.borderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor
        
        if indexPath.section == 0 {
            if !(self.orderDetailArray.count==0) {
                var data = OrderDataModel()
                if indexPath.row == 0 {
                    cell.orderIdLabel.text=purchaseOrderId
                    if (orderStatus?.contains(NSLocalizedText(key: "complete")))! {
                        cell.orderStatusLabel.attributedText = self.setAttributedString(dataString:String(orderStatus!).uppercased(), headingData:NSLocalizedText(key: "status1"),textFont:FontUtility.montserratRegular(size: 13), headingFont:FontUtility.montserratRegular(size: 15),color:UIColor(red: 163.0/255.0, green: 217.0/255.0, blue: 131.0/255.0, alpha: 1.0))
                    }
                    else  if (orderStatus?.contains(NSLocalizedText(key: "canceled")))! {
                        cell.orderStatusLabel.attributedText = self.setAttributedString(dataString:String(orderStatus!).uppercased(), headingData:NSLocalizedText(key: "status1"),textFont:FontUtility.montserratRegular(size: 13), headingFont:FontUtility.montserratRegular(size: 15),color:UIColor(red: 227.0/255.0, green: 88.0/255.0, blue: 95.0/255.0, alpha: 1.0))
                    }
                    else {
                        cell.orderStatusLabel.attributedText = self.setAttributedString(dataString:String(orderStatus!).uppercased(), headingData:NSLocalizedText(key: "status1"),textFont:FontUtility.montserratRegular(size: 13), headingFont:FontUtility.montserratRegular(size: 15),color:UIColor(red: 245.0/255.0, green: 218.0/255.0, blue: 63.0/255.0, alpha: 1.0))
                    }
                } else if indexPath.row ==  orderDetailArray.count + 1 {
                    cell.totalHeadingLabel.text = NSLocalizedText(key: "totalHeading")
                    cell.priceTotalLabel.text = totalPrice
                } else {
                    print(orderDetailArray.count)
                    data = self.orderDetailArray[indexPath.row-1] as! OrderDataModel
                    cell.productNameHeadingLabel.text=NSLocalizedText(key: "productName")
                    cell.skuHeadingLabel.text=NSLocalizedText(key: "skuHeading")
                    cell.QuantityHeadingLabel.text=NSLocalizedText(key: "qty")
                    cell.priceHeadingLabel.text=NSLocalizedText(key: "priceHeading")
                    cell.skuLabel.text = data.productSKU
                    cell.productNameLabel.text=data.productName
                    cell.quantityLabel.text = NSString(format:"%d", data.productQty as! Int) as String
//                    let totalMultipliedPrice = Double(data.productPrice as! Double) * (data.productQty as! Double)
//                    let convertedPrice = Double(totalMultipliedPrice) * (conversionPrice)
                    cell.priceLabel.text = currencySymbol! + (NSString(format:"%.1f", data.productPrice as! Double) as String) as String
                }
            }
        }
        else if indexPath.section == 1 {
            if !(self.orderDetailArray.count==0) {
                //set localised text
                cell.addressInfoHeadingLabel.text=NSLocalizedText(key: "billingShippingText")
                cell.shipToHeadingLabel.text=NSLocalizedText(key: "shipTo")
                cell.shippingAddressHeadingLabel.text=NSLocalizedText(key: "address")
                cell.shippingZipcodeHeadingLabel.text=NSLocalizedText(key: "zipCode")
                cell.shippingContactNumberHeadingLabel.text=NSLocalizedText(key: "contactNumber")
                cell.billToHeadingLabel.text=NSLocalizedText(key: "billTo")
                cell.billingAddressHeadingLabel.text=NSLocalizedText(key: "address")
                cell.shippingContactHeadingLabel.text=NSLocalizedText(key: "contactPerson")
                cell.billingZipcodeHeadingLabel.text=NSLocalizedText(key: "zipCode")
                cell.billingContactHeadingLabel.text=NSLocalizedText(key: "contactPerson")
                cell.billingContactNumberHeadingLabel.text=NSLocalizedText(key: "contactNumber")
                //set text
                cell.shippingZipcodeLabel.text=shippingAddressData["postcode"] as? String
                let shppingAddressArray:[String] = (shippingAddressData["street"] as! NSArray) as! [String];
                let shppingAddress =  shppingAddressArray.joined(separator: " ")
                cell.shippingAddressLabel.text=shppingAddress
           
                let billingAddressArray:[String] = (billingAddressData["street"] as! NSArray) as! [String];
                let billingAddress =  billingAddressArray.joined(separator: " ")
                cell.billingAddressLabel.text=billingAddress
                cell.billingZipcodeLabel.text=billingAddressData["postcode"] as? String
                cell.billingContactLabel.text=billingAddressData["firstname"] as? String
                cell.billingContactNumberLabel.text=billingAddressData["telephone"] as? String
                //dynamic height
                cell.shippingAddressLabel.numberOfLines = 0
                cell.shippingAddressLabel.translatesAutoresizingMaskIntoConstraints = true
                var textHeight = cell.shippingAddressLabel.text?.dynamicHeightWidthForString(width: (orderTableView.frame.size.width/2) - 30, font: FontUtility.montserratLight(size: 14), isWidth: false)
                cell.shippingAddressLabel.frame=CGRect(x:10,y:cell.shippingAddressLabel.frame.origin.y + 1,width: (orderTableView.frame.size.width/2) - 25,height:textHeight!)
                cell.billingAddressLabel.numberOfLines = 0
                cell.billingAddressLabel.translatesAutoresizingMaskIntoConstraints = true
                textHeight = cell.billingAddressLabel.text?.dynamicHeightWidthForString(width: (orderTableView.frame.size.width/2) - 30, font: FontUtility.montserratLight(size: 14), isWidth: false)
                cell.billingAddressLabel.frame=CGRect(x:cell.shippingAddressLabel.frame.origin.x + cell.shippingAddressLabel.frame.size.width+20,y:cell.billingAddressLabel.frame.origin.y + 1,width: (orderTableView.frame.size.width/2) - 25,height:textHeight!)
            }
        }
        return cell
    }
    
    //set attributed code
    func setAttributedString(dataString: String, headingData: String, textFont:UIFont, headingFont:UIFont, color:UIColor) -> NSMutableAttributedString {
        let headingString = [NSAttributedStringKey.foregroundColor: UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1.0), NSAttributedStringKey.font: headingFont]
        let valueString = [NSAttributedStringKey.foregroundColor:color, NSAttributedStringKey.font: textFont]
        let partOne = NSMutableAttributedString(string: headingData, attributes: headingString)
        let partTwo = NSMutableAttributedString(string: dataString, attributes: valueString)
        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(partTwo)
        return combination
    }
    // MARK: - end
    
    // MARK: - IBActions
    @IBAction func trackOrderButtonAction(_ sender: Any) {
        var orderData = OrderDataModel()
        orderData=self.trackingDataArray[0] as! OrderDataModel
        let trackingURL="http://gonatuur.aftership.com/" + orderData.trackingNumber!
        UIApplication.shared.openURL(NSURL.init(string: trackingURL)! as URL)
    }
    // MARK: - end
}
