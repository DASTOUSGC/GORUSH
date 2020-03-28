//
//  settingsTableViewCell.swift
//  JFMC
//
//  Created by Julien Levallois on 19-09-08.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit


class settingsTableViewCell : UITableViewCell {
    
    var name = UILabel()
    var line = UIImageView()
    var icon = UIImageView()
    
    var switchNotif = UISwitch()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        self.line = UIImageView(frame: CGRect(x: 20, y: 60-1, width: Brain.kLargeurIphone-40, height: 1))
        self.line.backgroundColor = UIColor(hex: "4D4D4D")
        self.line.alpha = 0.1
        self.addSubview(self.line)
        
        
        self.name = UILabel(frame: CGRect(x: 20, y: 0, width: Brain.kLargeurIphone, height: 60))
        self.name.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.name.textColor = UIColor(hex: "4D4D4D")
        self.addSubview(self.name)
        
        self.icon = UIImageView(frame: CGRect(x: Brain.kLargeurIphone-20-30, y: 15, width: 30, height: 30))
        self.addSubview(self.icon)
        
        
        switchNotif = UISwitch(frame: CGRect(x: Brain.kLargeurIphone - 70, y: 16, width: 51, height: 32))
        switchNotif.isOn = true
        switchNotif.onTintColor = Brain.kColorMain
        switchNotif.isHidden = true
        
            self.addSubview(self.switchNotif)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




