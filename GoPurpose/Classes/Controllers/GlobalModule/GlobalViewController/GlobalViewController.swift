//
//  GlobalViewController.swift
//  SideBarBottomBarSwift
//
//  Created by Hemlata Khajanchi on 30/10/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class GlobalViewController: UIViewController,SWRevealViewControllerDelegate {
    
    //MARK: - IBOutlets
    var controller: BottomTabViewController = BottomTabViewController()
    var sideBarButton:UIBarButtonItem=UIBarButtonItem()
    //MARK: - end
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.isNavigationBarHidden = false
        self.addNavigationBottomImage()
        self.addBottomTab()
        self.addMenuButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        controller.willMove(toParentViewController: self)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    //MARK: - end
    
    //MARK: - Custom methods to add navigation image, bottom tab and menu button
    func addNavigationBottomImage()  {
        let bottomImage = UIImageView(frame: CGRect(x:self.view.frame.origin.x, y:UIScreen.main.bounds.origin.y-1, width:kScreenWidth, height:7))
        bottomImage.contentMode=UIViewContentMode.scaleAspectFit
        bottomImage.image=UIImage(named:"color-strip")
        self.view.addSubview(bottomImage)
    }
    
    func addBottomTab() {
        controller = BottomTabViewController(nibName: "BottomTabViewController", bundle: nil)
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints=true
        controller.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height-129, width: self.view.frame.size.width, height: 65);
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    func addMenuButton() {
        let menuBtn = UIButton(type: .custom)
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        menuBtn.setImage(UIImage(named: "sideminu"), for: .normal)
        let menuBtnItem = UIBarButtonItem(customView: menuBtn)
        menuBtnItem.target = self.revealViewController()
        menuBtnItem.action = #selector(SWRevealViewController.revealToggle(_:))
        self.navigationItem.leftBarButtonItem = menuBtnItem
    }
    
    func showSelectedTab(item: Int) {
        controller.showSelectedTab(item: item)
    }
    //MARK: - end
}
