//
//  ProductListViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 02/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

// MARK: - Table view cell class
class ProductListCell: UITableViewCell {
    @IBOutlet weak var skuHeadingLabel: UILabel!
    @IBOutlet weak var productSkuLabel: UILabel!
    @IBOutlet weak var qunatityHeadingLabel: UILabel!
    @IBOutlet weak var qunatityLabel: UILabel!
    @IBOutlet weak var priceHeadingLabel: UILabel!
    @IBOutlet weak var priceProductLabel: UILabel!
    @IBOutlet weak var typeHeadingLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var productImageViiew: UIImageView!
}
// MARK: - end

class ProductListViewController: GlobalViewController,UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlet and variable declarations
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var noRecordLabel: UILabel!
    var totalRecords: Any?
    var currentPageCount:Int = 1
    var productListingArray:NSMutableArray = NSMutableArray()
    let footerView = UIView()
  //MARK: - end
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NSLocalizedText(key: "product")
        noRecordLabel.isHidden=true;
        noRecordLabel.text=NSLocalizedText(key: "norecord")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showSelectedTab(item: 3)
        self.addFooterView()
        AppDelegate().showIndicator()
        self.perform(#selector(getProductList), with: nil, afterDelay: 0.1)
    }
    
    func addFooterView() {
        footerView.backgroundColor = UIColor.white
        footerView.frame=CGRect(x:0, y:0, width:productTableView.frame.size.width, height:30)
        let pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        pagingSpinner.startAnimating()
        pagingSpinner.color = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        pagingSpinner.hidesWhenStopped = true
        footerView.addSubview(pagingSpinner)
    }
    //MARK: - end
    
    //MARK: - Webservices
    //Get product listing data
    @objc func getProductList() {
        let productData = ProductDataModel()
        productData.currentPage = String(currentPageCount)
        productData.searchKey=""
        ProductDataModel().getProductListingData(productData, success: { (response) in
            AppDelegate().stopIndicator()
            self.productListingArray.addObjects(from: productData.productListDataArray as! [Any])
            self.totalRecords=productData.totalRecordsCount as! Int
            if self.productListingArray.count==0 {
                self.noRecordLabel.isHidden=false;
            }
            self.productTableView.reloadData()
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
        return self.productListingArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 125
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        headerView.frame=CGRect(x:tableView.frame.origin.x, y:tableView.frame.origin.y, width:tableView.frame.size.width, height:50)
        headerView.layer.borderWidth=1.0
        headerView.layer.borderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor
        
        var productData = ProductDataModel()
        productData = self.productListingArray[section] as! ProductDataModel
        let productNameLabel = UILabel(frame: CGRect(x: 8, y: 2, width: headerView.frame.size.width-145, height: 46))
        productNameLabel.font = FontUtility.montserratMedium(size: 15)
        productNameLabel.textAlignment = .left
        productNameLabel.text = productData.productName
        headerView.addSubview(productNameLabel)
        
        let statusLabel = UILabel(frame: CGRect(x: productNameLabel.frame.size.width+10, y: 2, width: headerView.frame.size.width-productNameLabel.frame.size.width-15, height: 46))
        statusLabel.font = FontUtility.montserratMedium(size: 15)
        statusLabel.textAlignment = .right
        if productData.productStatus == "1" {
            statusLabel.text = NSLocalizedText(key: "Approved")
            statusLabel.textColor = UIColor(red: 62.0/255.0, green: 196.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        }
        else {
            statusLabel.text = NSLocalizedText(key: "Pending")
            statusLabel.textColor = UIColor(red: 227.0/255.0, green: 88.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        }
        headerView.addSubview(statusLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProductListCell = tableView.dequeueReusableCell(withIdentifier: "productDetailCell", for: indexPath) as! ProductListCell
    
        cell.contentView.layer.borderWidth=1.0
        cell.contentView.layer.borderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor
        
        cell.skuHeadingLabel?.text=NSLocalizedText(key: "skuHeading")
        cell.priceHeadingLabel?.text=NSLocalizedText(key: "priceHeading")
        cell.qunatityHeadingLabel?.text=NSLocalizedText(key: "quantityHeading")
        cell.typeHeadingLabel?.text=NSLocalizedText(key: "typeHeading")
        
        var productData = ProductDataModel()
        productData = self.productListingArray[indexPath.section] as! ProductDataModel
        
        cell.productSkuLabel?.text=productData.productSKU
        cell.priceProductLabel?.text = "$" + String(format: "%.1f", Double (productData.productPrice!)!)
        cell.priceProductLabel?.textColor = UIColor(red: 227.0/255.0, green: 88.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        cell.qunatityLabel?.text=productData.productQuantity
        cell.typeLabel?.text=productData.productType
        if (productData.productImage != nil) {
            cell.productImageViiew?.downloadFrom(link: productData.productImage!)
        }
        return cell
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            if self.productListingArray.count == totalRecords as! Int {
                 productTableView.tableFooterView=nil
            }
            else {
            productTableView.tableFooterView=footerView
            // call method to add data to tableView
            currentPageCount = +1
            self.getProductList()
            }
        }
    }
    // MARK: - end
    
    // MARK: - IBActions
    @IBAction func searchButtonAction(_ sender: Any) {
        let searchView = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchView, animated: true)
    }
    // MARK: - end
}
