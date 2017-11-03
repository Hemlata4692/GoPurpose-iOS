//
//  DashboardViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 02/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class DashboardViewController: GlobalViewController {

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="GoPurpose";
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
    }
    // MARK: - end
    

}
