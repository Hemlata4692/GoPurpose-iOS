//
//  SalesViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 03/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class SalesViewController: GlobalViewController,UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets and declarations
    @IBOutlet weak var salesTableView: UITableView!
    var tableCellDataArray: [String] = []
    var tableCellKeyArray: [String] = ["completeOrder", "pendingOrder", "compareOrder"]
    // MARK: - end
    
    // MARK: - View life cyce
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NSLocalizedText(key: "salesReport")
        // Do any additional setup after loading the view.
        tableCellDataArray = [NSLocalizedText(key: "completeOrder"), NSLocalizedText(key: "pendingOrder"), NSLocalizedText(key: "compareOrder")]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - end
    

    // MARK: - Table view delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCellKeyArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellKeyArray[indexPath.row], for: indexPath)
        let nameLabel = cell.contentView.viewWithTag(1) as? UILabel
        nameLabel?.text=tableCellDataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondViewController = storyBoard.instantiateViewController(withIdentifier: "ReportsWebViewController") as! ReportsWebViewController
        secondViewController.reportsURL=tableCellDataArray[indexPath.row]
        self.navigationController?.pushViewController(secondViewController, animated: true)    }
    // MARK: - end
}
