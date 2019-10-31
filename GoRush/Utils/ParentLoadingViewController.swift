//
//  ParentLoadingViewController.swift
//  PictMee
//
//  Created by Julien Levallois on 19-04-17.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class ParentLoadingViewController: UIViewController {
    
    
    var loading : NVActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Brain.kColorCustomGray
       
        loading = NVActivityIndicatorView(frame: CGRect(x: Brain.kLargeurIphone/2-25 , y: Brain.kHauteurIphone/2-50 - 64, width: 50, height: 50), type: .ballPulse , color: .white, padding: 0.0)
        
        self.view.addSubview(self.loading)
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(appbecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        
    }
    
    @objc func appbecomeActive() {
        
        print("become Active")

    }
    
    @objc func appResignActive() {
        
        print("resign Active")
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
      
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        
    }
    
    
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
