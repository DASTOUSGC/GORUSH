//
//  timeCollectionViewCell.swift
//  Salud
//
//  Created by Julien Levallois on 19-07-21.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation

import UIKit
import Parse

class grassHeightCollectionViewCell: UICollectionViewCell {
    
    
   
    var bg : UIView!
    var bg2 : UIView!
    var height : UILabel!
    var value : String!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundView?.backgroundColor = .clear
        self.backgroundColor = .clear
        
        
        self.bg = UIView(frame: CGRect(x: 5, y: 0, width: self.w() - 10, height: self.h()))
        self.bg.layer.cornerRadius = self.h() / 2
        self.bg.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.bg.layer.borderWidth = 1
        self.bg.layer.borderColor = UIColor.white.cgColor
        self.addSubview(self.bg)
        
        self.bg2 = UIView(frame: CGRect(x: 5, y: 0, width: self.w() - 10, height: self.h()))
        self.bg2.layer.cornerRadius = self.h() / 2
        self.bg2.backgroundColor = UIColor(hex: "333333")
        self.bg2.isHidden = true
        self.bg2.applyGradient()
        self.addSubview(self.bg2)
        
        self.height = UILabel(frame: CGRect(x: 0, y: 0, width: self.w(), height: self.h()))
        self.height.textAlignment = .center
        self.height.textColor = .white
        self.height.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.addSubview(self.height)
       
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
              
                self.bg2.isHidden = false
                
            } else {
              
                self.bg2.isHidden = true

            }
        }
    }
    
    
    func removeSublayer(_ view: UIView, layerIndex index: Int) {
        guard let sublayers = view.layer.sublayers else {
            print("The view does not have any sublayers.")
            return
        }
        if sublayers.count > index {
            view.layer.sublayers!.remove(at: index)
        } else {
            print("There are not enough sublayers to remove that index.")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
