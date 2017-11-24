//
//  DashboardViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 02/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class CardsCell: UICollectionViewCell {
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var cardIconImage: UIImageView!
}


class DashboardViewController: GlobalViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIWebViewDelegate {
    @IBOutlet weak var reportsWebView: UIWebView!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    var dashboardArray:NSMutableDictionary = NSMutableDictionary()
    var groupID : Any?
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NSLocalizedText(key: "goPurpose")
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden=false;
         self.showSelectedTab(item: 1)
        AppDelegate().showIndicator()
        self.perform(#selector(getDashboardData), with: nil, afterDelay: 0.1)
    }
    // MARK: - end
    
    //MARK: - Webservices
    @objc func getDashboardData() {
        let productData = ProductDataModel()
        ProductDataModel().getDashboardListingData(productData, success: { (response) in
             AppDelegate().stopIndicator()
            self.dashboardArray=productData.dashboardDataArray.mutableCopy() as! NSMutableDictionary
            self.groupID=productData.groupId
            let reportURL = BASE_URL + UserDefaults().string(forKey: "Language")! + "/marketplace_report/graph/unfulfilled/?token=" + UserDefaults().string(forKey: "apiKey")!
            self.reportsWebView.loadRequest(URLRequest(url: URL(string: reportURL)!))
            self.cardsCollectionView.reloadData()
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    //MARK: - end
    
    // Mark: Webview delegates
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        AppDelegate().stopIndicator()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        AppDelegate().stopIndicator()
    }
    // Mark: end
    
    //MARK: UICollectionViewDataSource
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashboardArray.allKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CardsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardsCell
        cell.contentView.layer.borderWidth=1.0
        cell.contentView.layer.borderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor
        cell.cardImageView.layer.cornerRadius=17.5
        cell.cardImageView.layer.masksToBounds = true
        
        let groupId = groupID as! Int
        switch groupId {
        case 2:
            if ((dashboardArray.allKeys as NSArray).object(at: indexPath.row) as! String)=="totalProducts" {
                cell.headingLabel.text=NSLocalizedText(key: "totalProducts")
                cell.dataLabel.text=NSString(format:"%d", dashboardArray.object(forKey: (dashboardArray.allKeys as NSArray).object(at: indexPath.row)) as! Int) as String
                cell.cardImageView.backgroundColor = UIColor(red: 90.0/255.0, green: 161.0/255.0, blue: 228.0/255.0, alpha: 1.0)
                cell.cardIconImage.image=UIImage(named: "total-product")
            }
            else  if ((dashboardArray.allKeys as NSArray).object(at: indexPath.row) as! String)=="pendingApproval" {
                cell.headingLabel.text=NSLocalizedText(key: "pendingApproval")
                cell.dataLabel.text=NSString(format:"%d", dashboardArray.object(forKey: (dashboardArray.allKeys as NSArray).object(at: indexPath.row)) as! Int) as String
                cell.cardImageView.backgroundColor = UIColor(red: 245.0/255.0, green: 218.0/255.0, blue: 63.0/255.0, alpha: 1.0)
                cell.cardIconImage.image=UIImage(named: "pending-approval")
            }
        case 3:
            if ((dashboardArray.allKeys as NSArray).object(at: indexPath.row) as! String)=="totalProducts" {
                cell.headingLabel.text=NSLocalizedText(key: "totalProducts")
                cell.dataLabel.text=NSString(format:"%d", dashboardArray.object(forKey: (dashboardArray.allKeys as NSArray).object(at: indexPath.row)) as! Int) as String
                 cell.cardImageView.backgroundColor = UIColor(red: 90.0/255.0, green: 161.0/255.0, blue: 228.0/255.0, alpha: 1.0)
                cell.cardIconImage.image=UIImage(named: "total-product")
            }
        case 4:
            if ((dashboardArray.allKeys as NSArray).object(at: indexPath.row) as! String)=="lifeTimeSale" {
                cell.headingLabel.text=NSLocalizedText(key: "lifeTimeSale")
                cell.dataLabel.text=NSString(format:"%d", dashboardArray.object(forKey: (dashboardArray.allKeys as NSArray).object(at: indexPath.row)) as! Int) as String
                cell.cardImageView.backgroundColor = UIColor(red: 163.0/255.0, green: 217.0/255.0, blue: 131.0/255.0, alpha: 1.0)
                cell.cardIconImage.image=UIImage(named: "lifetime-sales")
            }
            else  if ((dashboardArray.allKeys as NSArray).object(at: indexPath.row) as! String)=="totalProducts" {
                cell.headingLabel.text=NSLocalizedText(key: "totalProducts")
                cell.dataLabel.text=NSString(format:"%d", dashboardArray.object(forKey: (dashboardArray.allKeys as NSArray).object(at: indexPath.row)) as! Int) as String
                 cell.cardImageView.backgroundColor = UIColor(red: 90.0/255.0, green: 161.0/255.0, blue: 228.0/255.0, alpha: 1.0)
                cell.cardIconImage.image=UIImage(named: "total-product")
            }
            else  if ((dashboardArray.allKeys as NSArray).object(at: indexPath.row) as! String)=="totalOrders" {
                cell.headingLabel.text=NSLocalizedText(key: "totalOrders")
                cell.dataLabel.text=NSString(format:"%d", dashboardArray.object(forKey: (dashboardArray.allKeys as NSArray).object(at: indexPath.row)) as! Int) as String
                cell.cardImageView.backgroundColor =  UIColor (red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1.0)
                cell.cardIconImage.image=UIImage(named: "total-payment")
            }
            else  if ((dashboardArray.allKeys as NSArray).object(at: indexPath.row) as! String)=="pendingApproval" {
                cell.headingLabel.text=NSLocalizedText(key: "pendingApproval")
                cell.dataLabel.text=NSString(format:"%d", dashboardArray.object(forKey: (dashboardArray.allKeys as NSArray).object(at: indexPath.row)) as! Int) as String
                cell.cardImageView.backgroundColor = UIColor(red: 245.0/255.0, green: 218.0/255.0, blue: 63.0/255.0, alpha: 1.0)
                cell.cardIconImage.image=UIImage(named: "pending-approval")
            }
        default:
            print("default data")
        }
        return cell
    }
    // MARK: - end
}
