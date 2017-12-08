//
//  ReportsWebViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 23/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class ReportsWebViewController: GlobalBackViewController, UIWebViewDelegate {

    var reportsURL : String?
    var urlString : String?

    @IBOutlet weak var webViewReports: UIWebView!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title=NSLocalizedText(key: "salesReport")

        if reportsURL == NSLocalizedText(key: "completeOrder") {
            urlString = completeOrderURL
        }
        else  if reportsURL == NSLocalizedText(key: "pendingOrder") {
            urlString = pendingOrder
        }
        else  if reportsURL == NSLocalizedText(key: "compareOrder") {
            urlString = compareOrder
        }
        AppDelegate().showIndicator()
        let reportURL = BASE_URL + UserDefaults().string(forKey: "Language")! + urlString! + UserDefaults().string(forKey: "apiKey")!
        self.webViewReports.loadRequest(URLRequest(url: URL(string: reportURL)!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - end

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
