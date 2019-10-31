//
//  ParentLoadingViewController.swift
//  Salud
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
        
        self.view.backgroundColor = .white
       
        loading = NVActivityIndicatorView(frame: CGRect(x: Brain.kLargeurIphone/2-25 , y: Brain.kHauteurIphone/2-50 - 64, width: 50, height: 50), type: .ballPulse , color: Brain.kColorMain, padding: 0.0)

        
        self.view.addSubview(self.loading)
        
    }
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
