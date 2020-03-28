//
//  reviewTableViewCell.swift
//  GoRush
//
//  Created by Julien Levallois on 2020-01-16.
//  Copyright © 2020 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Cosmos


class reviewTableViewCell : UITableViewCell {
    
    var review : PFObject!
    var user : PFUser!
    var profile : PFImageView!
    var name : UILabel!
    var comment : UILabel!
    var date : UILabel!
    var stars : CosmosView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.clipsToBounds = false
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        profile = PFImageView(frame: CGRect(x: 20, y: 0, width: 32, height: 32))
        profile.layer.cornerRadius = 16
        profile.contentMode = .scaleAspectFill
        profile.layer.masksToBounds = true
        self.addSubview(profile)
        
        name = UILabel(frame: CGRect(x: 63, y: 0, width: Brain.kLargeurIphone, height: 19))
        name.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        name.textColor = .black
        self.addSubview(name)
        
        self.stars = CosmosView(frame: CGRect(x: 63 + 80, y: 5, width: Brain.kLargeurIphone, height: 19))
        self.stars.settings.updateOnTouch = true
        self.stars.settings.fillMode = .full
        self.stars.settings.starSize = 10
        // Set the distance between review
        self.stars.settings.starMargin = 5
        // Set the color of a filled star
        self.stars.settings.filledColor = Brain.kColorMain
        // Set the border color of an empty star
        self.stars.settings.emptyBorderColor = Brain.kColorMain
        // Set the border color of a filled star
        self.stars.settings.filledBorderColor = Brain.kColorMain
        // Set image for the filled star
        self.stars.settings.filledImage = UIImage(named: "starFull")?.withRenderingMode(.alwaysTemplate)
        // Set image for the empty star
        self.stars.settings.emptyImage = UIImage(named: "starEmpty")?.withRenderingMode(.alwaysTemplate)
        self.stars.settings.totalStars = 5
        self.stars.rating = 5.0
        self.addSubview(self.stars)
        
        
        comment = UILabel(frame: CGRect(x: 63, y: name.yBottom() + 1, width: Brain.kLargeurIphone - 63 - 20, height: 19))
        comment.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        comment.numberOfLines = 0
        comment.textColor = .black
        self.addSubview(comment)
        
        date = UILabel(frame: CGRect(x: 63, y: comment.yBottom() + 1, width: Brain.kLargeurIphone, height: 19))
        date.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        date.numberOfLines = 0
        date.textColor = UIColor(hex: "E0E0E0")
        self.addSubview(date)

      
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



