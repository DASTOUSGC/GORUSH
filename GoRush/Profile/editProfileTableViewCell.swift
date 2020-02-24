//
//  profileTableViewCell.swift
//  Buzzy
//
//  Created by Julien Levallois on 18-12-04.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit



class editProfileTableViewCell : UITableViewCell {
    
    var name = UILabel()
    var line = UIImageView()
    
    var value = UITextField()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        self.line = UIImageView(frame: CGRect(x: 110, y: 49, width: Brain.kLargeurIphone-110, height: 0.5))
        self.line.backgroundColor = .white
//        self.addSubview(self.line)
        
        
        
        self.name = UILabel(frame: CGRect(x: 20, y: 0, width: Brain.kLargeurIphone - 40, height: 20))
        self.name.font = UIFont.systemFont(ofSize: 15)
        self.name.textColor = .black
        self.name.alpha = 0.4
        self.addSubview(self.name)
        
        self.value = UITextField(frame: CGRect(x: 20, y: 15, width: Brain.kLargeurIphone - 40, height: 40))
        self.value.font = UIFont.systemFont(ofSize: 17)
        self.value.textColor = .black
        self.value.keyboardAppearance = .default
        self.value.returnKeyType = .done
        self.addSubview(self.value)
     
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



