//
//  VideoPostView.swift
//  Salud
//
//  Created by Julien Levallois on 19-08-01.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation

import UIKit
import Parse



class videoPostView: UIView {
    
    
    var infiniteCamera : UIImageView!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = false
        self.backgroundColor = .clear
        
        self.infiniteCamera = UIImageView(frame: CGRect(x: self.w() - 30 - 15, y: 15, width: 30 , height: 30))
        infiniteCamera.image = UIImage(named: "iconCamera")
        self.addSubview(infiniteCamera)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
