//
//  WebViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 19-08-17.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation


import UIKit
import Parse
import FBSDKCoreKit
import AVKit
import WebKit

class WebViewController: UIViewController , UIGestureRecognizerDelegate, WKNavigationDelegate{
    
    
    var closeIndicator : UIImageView!
    var webView: WKWebView!
    var link : String!
    
  
    
    convenience init(link:String)
    {
        
        self.init()
        self.link = link

    }
    
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        
        return .lightContent
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        
       return false

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.view.clipsToBounds = false
        
        view.backgroundColor = UIColor.clear
        self.title = ""
        
        
     
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.w(), height: self.view.h()))
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        view.addSubview(webView)
     
        
        webView.load(URLRequest(url: URL(string: link)!))
        webView.allowsBackForwardNavigationGestures = true

        
        closeIndicator = UIImageView(frame: CGRect(x: ( Brain.kL - 60 ) / 2, y: 12, width: 60, height: 5))
        closeIndicator.layer.cornerRadius = 2.5
        closeIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(closeIndicator)
        
        
        
    }
    
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
      

    }
    
    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        
      

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
        super.viewWillDisappear(animated)
        
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
    }
    
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: false)
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    

}
