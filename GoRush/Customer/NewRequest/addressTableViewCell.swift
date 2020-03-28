//
//  addressTableViewCell.swift
//  Thanks
//
//  Created by Julien Levallois on 18-08-29.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//

import Foundation

import UIKit
import Parse
import MapboxGeocoder



class addressTableViewCell: UITableViewCell {
    
    var address : UILabel!
    var placemark : GeocodedPlacemark!
    var line : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.clipsToBounds = false
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        
        self.address = UILabel(frame:CGRect(x: 20, y: 0, width: Brain.kLargeurIphone-40 - 60, height: 40))
        self.address.numberOfLines = 2;
        self.address?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.address.textColor = UIColor(hex:"B5ABAB")
        self.addSubview(self.address)
        
        self.line = UIImageView(frame: CGRect(x:20, y: 45, width: Brain.kLargeurIphone - 20, height: 0.5))
        self.line.backgroundColor = UIColor(hex:"B5ABAB")
        self.line.alpha = 0.2
        self.addSubview(self.line)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
