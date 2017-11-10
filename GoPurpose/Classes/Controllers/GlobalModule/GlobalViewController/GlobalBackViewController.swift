//
//  GlobalBackViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 10/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class GlobalBackViewController: UIViewController {

    //MARK: - IBOutlets
    var controller: BottomTabViewController = BottomTabViewController()
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
        self.addBackButton()
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
    
    func addBackButton() {
        let backBtn = UIButton(type: .custom)
        backBtn.addTarget(self, action:#selector(backButtonAction(sender:)), for: .touchUpInside)
        backBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backBtnItem
    }
    
    func showSelectedTab(item: Int) {
        controller.showSelectedTab(item: item)
    }
    
    @objc func backButtonAction(sender: UIButton) {
        //pop view
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - end
}
