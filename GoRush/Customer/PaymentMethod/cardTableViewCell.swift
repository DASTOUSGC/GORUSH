//
//  cardTableViewCell.swift
//  Tabby
//
//  Created by Julien Levallois on 18-07-01.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//


import Foundation
import UIKit
import Parse

class cardTableViewCell: UITableViewCell {
    
    
    var container : UIView!
    
    var number : UILabel!
    var expiration : UILabel!
    var imageCard : UIImageView!
    var fourpoints : UIImageView!
    var check : UIImageView!
    var line : UIImageView!
    
    var card : Dictionary <String, Any>!
    
    
  
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        self.container = UIView(frame: CGRect(x: 15, y: 0, width: Brain.kL - 30 , height: 55))
        self.container.backgroundColor = UIColor(hex: "F6F6F6")
        self.container.layer.cornerRadius = 30
        self.addSubview(self.container)
        
        
        
        
        imageCard = UIImageView(frame: CGRect(x: 20, y: (55-27)/2, width: 44, height: 27))
        imageCard.image = UIImage(named: "cardMasterCard")
        imageCard.layer.cornerRadius = 4
        imageCard.contentMode = .scaleAspectFill
        imageCard.clipsToBounds = true
        container.addSubview(imageCard)
        
        
        fourpoints = UIImageView(frame: CGRect(x: 77, y: (55-3)/2, width: 21, height: 3))
        fourpoints.image = UIImage(named: "fourpoints")?.withRenderingMode(.alwaysTemplate)
        fourpoints.tintColor = .black
        container.addSubview(fourpoints)

        number = UILabel(frame: CGRect(x: 104, y: (55-16)/2, width: 40, height: 16))
        number.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        number.textColor = .black
        container.addSubview(number)
        
        expiration = UILabel(frame: CGRect(x: container.w() - 20 - 130, y:  (55-16)/2, width: 130, height: 16))
        expiration.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        expiration.textColor = .black
        expiration.textAlignment = .right
        container.addSubview(expiration)
        
        
        check = UIImageView(frame: CGRect(x: 150, y: (55-18)/2, width: 18, height: 18))
        check.image = UIImage(named: "checkCard")?.withRenderingMode(.alwaysTemplate)
        check.tintColor = Brain.kColorMain
        container.addSubview(check)
      
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
