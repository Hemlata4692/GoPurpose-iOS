//
//  SDGViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 03/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class SDGViewController: GlobalViewController {

    @IBOutlet weak var noRecordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NSLocalizedText(key: "sdg")
        // Do any additional setup after loading the view.
        AppDelegate().showIndicator()
        self.perform(#selector(cmsBlockService), with: nil, afterDelay: 0.1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func cmsBlockService() {
        let userData = LoginDataModel()
        LoginDataModel().getCMSBlockData(userData, success: { (response) in
            AppDelegate().stopIndicator()
            print(userData as AnyObject)
           self.noRecordLabel.text=NSLocalizedText(key: "norecord")
            // Successfully logged in, move to next screen
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    

}
