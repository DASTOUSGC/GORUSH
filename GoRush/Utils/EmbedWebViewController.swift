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
//import ParseLiveQuery
import WebKit

class EmbedWebViewController: UIViewController , UIGestureRecognizerDelegate, WKNavigationDelegate{
    
    
    
    var displayOriginY: CGFloat!
    
    var container : UIView!

    var frontLayer : UIView!
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    var topCache : UIView!
    var bottomCache : UIView!
    
    var presentingVC: UIViewController?  // use this variable to connect both view controllers
    
    var webView: WKWebView!
    
    var lineA : UIView!
    
    
    var shareWeb : UIButton!
    var closeWeb : UIButton!
   
    var link = ""
    var titleView : String?
    
    var label : UILabel!
    
    


    // MARK: - Private properties
    /// Progress view reflecting the current loading progress of the web view.
    var progressView = UIProgressView(progressViewStyle: .default)
    
    /// The observation object for the progress of the web view (we only receive notifications until it is deallocated).
    var estimatedProgressObserver: NSKeyValueObservation?

    
    
    
  
    
    convenience init(link:String, title: String)
    {
        
        self.init()
        
        self.link = link
        self.titleView = title

        
    }
    
    
    
    deinit {
        
        print("dealloc Story ViewController :\(Date())")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        
        return .lightContent
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        
        if isIphoneXFamily(){
            
            return false
            
        }else{
            
            return true
            
        }
    }
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.view.clipsToBounds = false
        
        view.backgroundColor = UIColor.clear
        self.title = ""
        
        
        topCache = UIView(frame: CGRect(x: 0, y: -Brain.kHauteurIphone, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone + 50))
        topCache?.backgroundColor = UIColor.black.withAlphaComponent(1)
        self.view.addSubview(topCache!)
        
        
        if isIphoneXFamily() {
            
            bottomCache = UIView(frame: CGRect(x: 0, y: Brain.kHauteurIphone - ( Brain.kHauteurIphone - Utils.getHeightOfStory() + 44 ) , width: Brain.kLargeurIphone, height: ( Brain.kHauteurIphone - Utils.getHeightOfStory() + 44 )))
            bottomCache?.backgroundColor = .black
            self.view.addSubview(bottomCache!)
            
            container = UIView(frame: CGRect(x: 0, y: 44, width: Brain.kLargeurIphone, height:  Utils.getHeightOfStory()))
            container.layer.cornerRadius = 12
            container.layer.masksToBounds = true
            
            self.frontLayer = UIView(frame: CGRect(x: 0, y: 44, width: Brain.kLargeurIphone, height:  Utils.getHeightOfStory()))
            frontLayer.backgroundColor = .clear
            
        }else{
            
            self.container = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
            self.container.layer.masksToBounds = true

            self.frontLayer = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
            frontLayer.backgroundColor = .clear
            
        }
        
  
        self.container.backgroundColor = UIColor(hex:"FAFAFA")
       
        self.view.addSubview(self.container)
        
        
        
        displayOriginY = originY()
        
        //        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        //        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
   
       
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panBackgroundView(sender:)))
        self.frontLayer.addGestureRecognizer(pan)
        pan.delegate = self
        
       
        
        container.addSubview(self.frontLayer)
//
//        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: container.w(), height: container.h()))
//        webView.backgroundColor = .white
//        webView.navigationDelegate = self
//        container.addSubview(webView)
//
//        let url = URL(string: "https://www.google.com")!
//        webView.load(URLRequest(url: url))
//        webView.allowsBackForwardNavigationGestures = true

      
        
        webView = WKWebView(frame: CGRect(x: 0, y: 44, width: container.w(), height: container.h() - 44))
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        container.addSubview(webView)
        
        lineA = UIView(frame: CGRect(x: 0, y: 44, width: Brain.kLargeurIphone, height: 1))
        lineA.backgroundColor = UIColor(hex: "DBDBDB")
        container.addSubview(lineA)

        progressView = UIProgressView(frame: CGRect(x: 0, y: 44, width: Brain.kLargeurIphone, height: 2))
        progressView.isHidden = true
        progressView.progressTintColor  = Brain.kColorMain
        progressView.trackTintColor  = UIColor(hex: "DBDBDB")
        container.addSubview(progressView)

//        var transform : CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 6.0)
//        progressView.transform = transform

        
        print("llll \(link)")
        
        if link.hasPrefix("https://") || link.hasPrefix("http://"){
          
        }else {
            link = "https://\(link)"
           
        }
        
        
        
        webView.load(URLRequest(url: URL(string: link)!))
        webView.allowsBackForwardNavigationGestures = true

        
        setupEstimatedProgressObserver()
        
        
        
        
        shareWeb = UIButton(frame: CGRect(x: Brain.kLargeurIphone - 47, y: 3, width: 40, height: 40))
        shareWeb.setBackgroundImage(UIImage(named: "shareWeb"), for: .normal)
        shareWeb.addTarget(self, action: #selector(shareAction(_:)), for: .touchUpInside)
        container.addSubview(shareWeb)
        
        closeWeb = UIButton(frame: CGRect(x: 7, y: 3, width: 40, height: 40))
        closeWeb.setBackgroundImage(UIImage(named: "closeWeb"), for: .normal)
        closeWeb.addTarget(self, action: #selector(closeAction(_:)), for: .touchUpInside)
        container.addSubview(closeWeb)

        
        label = UILabel(frame: CGRect(x: 80, y: 3, width: Brain.kLargeurIphone - 160, height: 40))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hex: "262626")
        self.container.addSubview(label)
        
        
       
        updateTitle()
        
        
    }
    
    func updateTitle(){
        
      
        
        if titleView != nil {
            
            label.text = titleView
            
        }
        
    }
    @objc func closeAction (_ sender : UIButton){
        
        UIView.animate(withDuration: 0.1, animations: {
            self.topCache.backgroundColor = UIColor.black.withAlphaComponent(0)
            
        })
        
        
       
        
        self.dismiss(animated: true) {
            
        }
    }
   
    @objc func shareAction (_ sender : UIButton){

        let shareAll = [URL(string: self.link)] as! [URL]

        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        if progressView.isHidden {
            // Make sure our animation is visible.
            progressView.isHidden = false
        }
        
        
        UIView.animate(withDuration: 0.33,
                       animations: {
                        self.progressView.alpha = 1.0
        })
        
        label.text = NSLocalizedString("Loading...", comment: "")

    }
    
    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        
        
        
        UIView.animate(withDuration: 0.33,
                       animations: {
                        self.progressView.alpha = 0.0
        },
                       completion: { isFinished in
                        // Update `isHidden` flag accordingly:
                        //  - set to `true` in case animation was completly finished.
                        //  - set to `false` in case animation was interrupted, e.g. due to starting of another animation.
                        self.progressView.isHidden = isFinished
                        self.updateTitle()

        })
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
      
        if isMovingToParentViewController
        {
            
        }else{
         
            
        }
        
       
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
        super.viewWillDisappear(animated)
        
        
        if isMovingToParentViewController
        {
            self.navigationController?.setNavigationBarHidden(false, animated: animated);
            
        }
        else
        {
            
            
            print("View controller was popped")
            
        }
       
        
        
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
    
    @objc func panBackgroundView(sender:UIPanGestureRecognizer) {
        
        if self.frontLayer == nil {
            
            
            return
            
        }
        
        let touchPoint = sender.location(in: self.frontLayer!.window)
        
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            
            if touchPoint.y - initialTouchPoint.y > 0 {
                
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                let distance = touchPoint.y - initialTouchPoint.y
                let alpha = 1 -   (2.5 * distance / Brain.kHauteurIphone)
                
                self.topCache.backgroundColor = UIColor.black.withAlphaComponent(alpha)
                
                if !isIphoneXFamily() {
                    
                    let cornerRadius =  12 * (distance / 100)
                    self.container.layer.cornerRadius = min(cornerRadius, 12)
                }
                
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                
                
                //                UIView.animate(withDuration: 0.1, animations: {
                self.topCache.backgroundColor = UIColor.black.withAlphaComponent(0)
                //
                //                }) { (done) in
                //
                //
                //                }
                
               
                
                
                self.dismiss(animated: true, completion: nil)
                
                
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    
                    self.topCache.backgroundColor = UIColor.black.withAlphaComponent(1)
                    
                    if !isIphoneXFamily() {
                        
                        
                        self.container.layer.cornerRadius = 0
                        
                    }
                    
                })
            }
        }
        
    }
    
    

}
