//
//  SDGViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 03/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class SDGViewController: GlobalViewController, UIWebViewDelegate {
    @IBOutlet weak var sdgWebView: UIWebView!
    
    @IBOutlet weak var noRecordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NSLocalizedText(key: "sdg")
         self.noRecordLabel.text=NSLocalizedText(key: "norecord")
        self.noRecordLabel.isHidden=true
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
            if  (userData.cmsContentData?.isEmpty)! {
                AppDelegate().stopIndicator()
                self.noRecordLabel.isHidden=false
            }
            else {
                self.sdgWebView.loadHTMLString(userData.cmsContentData!, baseURL: nil)
            }
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    
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
}
