//
//  SearchViewController.swift
//  GoPurpose
//
//  Created by Hemlata Khajanchi on 22/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

// MARK: - Table view cell class
class serachProductCell: UITableViewCell {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
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

class SearchViewController: GlobalViewController , UITableViewDelegate, UITableViewDataSource {
     // MARK: - IBOutlets and declarations
    @IBOutlet weak var serachProductTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var noRecordLabel: UILabel!
    var tableCellKeysArray: [String] = ["productNameCell", "productDetailCell"]
     // MARK: - end
    
     // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title=NSLocalizedText(key: "product")
        self.showSelectedTab(item: 3)
    }
     // MARK: - end
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableCellKeysArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row==0 {
            return 50
        }
        else {
            return 125
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:serachProductCell = tableView.dequeueReusableCell(withIdentifier: tableCellKeysArray[indexPath.row], for: indexPath) as! serachProductCell
        //        if ((UserDefaults().string(forKey: "userProfileImage"))! != nil) {
        //            cell.userProfileImage?.downloadFrom(link: UserDefaults().string(forKey: "userProfileImage")!)
        //        }
        cell.skuHeadingLabel?.text=NSLocalizedText(key: "changePasswordProfile")
        cell.priceHeadingLabel?.text=NSLocalizedText(key: "notifications")
        cell.qunatityHeadingLabel?.text=NSLocalizedText(key: "changePasswordProfile")
        cell.typeHeadingLabel?.text=NSLocalizedText(key: "notifications")
        
        cell.productSkuLabel?.text=NSLocalizedText(key: "changePasswordProfile")
        cell.priceProductLabel?.text=NSLocalizedText(key: "notifications")
        cell.qunatityLabel?.text=NSLocalizedText(key: "changePasswordProfile")
        cell.typeLabel?.text=NSLocalizedText(key: "notifications")
        
        return cell
    }
    // MARK: - end
    
    // MARK: - IBActions
    @IBAction func backButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
    }
     // MARK: - end
}
