//
//  exploreCollectionViewCell.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-12-30.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Parse


class exploreCollectionViewCell: UICollectionViewCell {
    
    
    var request : PFObject!
    var service : PFObject!
    var customer : PFUser!
    var worker : PFUser!
    var cover : PFImageView!
    var filter : UIImageView!
    var bg : UIView!
    var timeAgo : UILabel!
    var name : UILabel!

    var icon : PFImageView!
    
    var profilePicture : PFImageView!
    var firstname : UILabel!
    
    var loading : UIActivityIndicatorView!
    
    
    
    
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
        filter.backgroundColor = UIColor.black.withAlphaComponent(0.21)
        filter.isHidden = false
        bg.addSubview(filter)
        
        profilePicture = PFImageView(frame: CGRect(x: 15, y:  15, width: 25, height: 25))
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = 12.5
        profilePicture.layer.masksToBounds = true
        profilePicture.isHidden = true
        bg.addSubview(profilePicture)
        
        name = UILabel(frame: CGRect(x: 47, y: 15, width: self.w() - 30 , height: 25))
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        bg.addSubview(name)
        
        
        icon = PFImageView(frame: CGRect(x: 15, y: self.h() - 10 - 25, width: 25, height: 25))
        icon.contentMode = .scaleAspectFill
        icon.layer.masksToBounds = true
        bg.addSubview(icon)

        timeAgo = UILabel(frame: CGRect(x: 15, y: self.h() - 8 - 25, width: self.w() - 30 , height: 25))
        timeAgo.textColor = .white
        timeAgo.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        timeAgo.textAlignment = .right
        bg.addSubview(timeAgo)
        
        loading = UIActivityIndicatorView(style: .gray)
        loading.center = bg.center
        loading.hidesWhenStopped = true
        bg.addSubview(loading)


      
       
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
