//
//  requestAcceptedCollectionViewCell.swift
//  GoRush
//
//  Created by Julien Levallois on 2020-01-15.
//  Copyright © 2020 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Parse



class requestAcceptedCollectionViewCell: UICollectionViewCell {
    
    
    var request : PFObject!
    var service : PFObject!
    var worker : PFUser!
    var cover : PFImageView!
    var filter : UIImageView!
    var bg : UIView!
    var by : UILabel!
    var day : UILabel!
    var month : UILabel!

    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor = .clear
        self.clipsToBounds = false
        
        bg = UIView(frame: CGRect(x: 0, y: 0, width: self.w(), height: self.h()))
        bg.contentMode = .scaleAspectFill
        bg.layer.cornerRadius = 20
        bg.clipsToBounds = true
        bg.backgroundColor = UIColor(hex: "F9F9F9")
        self.addSubview(bg)
     
        cover = PFImageView(frame: CGRect(x: 0, y: 0, width: self.w(), height: self.h()))
        cover.contentMode = .scaleAspectFill
        cover.layer.cornerRadius = 20
        cover.layer.masksToBounds = true
        cover.isHidden = true
        bg.addSubview(cover)
        
        filter = PFImageView(frame: CGRect(x: 0, y: 0, width: self.w(), height: self.h()))
        filter.contentMode = .scaleAspectFill
        filter.layer.cornerRadius = 20
        filter.layer.masksToBounds = true
        filter.backgroundColor = UIColor.black.withAlphaComponent(0.31)
        filter.isHidden = true
        self.addSubview(filter)
        
        
        day = UILabel(frame: CGRect(x: 0, y: 45, width: self.w()  , height: 48))
        day.textColor = UIColor.white
        day.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        day.textAlignment = .center
        bg.addSubview(day)
        
        month = UILabel(frame: CGRect(x: 0, y: 87, width: self.w()  , height: 33))
        month.textColor = UIColor.white
        month.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        month.textAlignment = .center
        bg.addSubview(month)
        
        
        by = UILabel(frame: CGRect(x: 0, y: self.h() - 8 - 25, width: self.w()  , height: 20))
        by.textColor = UIColor.white.withAlphaComponent(0.55)
        by.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        by.textAlignment = .center
        bg.addSubview(by)

      
       
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
