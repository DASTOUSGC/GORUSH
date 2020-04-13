//
//  typeCollectionViewCell
//  GoRush
//
//  Created by Julien Levallois on 19-09-08.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Parse


class serviceCollectionViewCell: UICollectionViewCell {
    
    
    var service : PFObject!
    
    var profil : PFObject!
    var cover : PFImageView!
    var icon : PFImageView!
    var filter : UIImageView!
    var name : UILabel!
    var comingSoon : UILabel!
    var bg : UIView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor = .clear
        self.clipsToBounds = false
        
        bg = UIView(frame: CGRect(x: 0, y: 0, width: self.w(), height: self.h()))
        bg.contentMode = .scaleAspectFill
        bg.layer.cornerRadius = 20
        bg.backgroundColor = UIColor(hex: "F9F9F9")
        self.addSubview(bg)
        
        cover = PFImageView(frame: CGRect(x: 0, y: 0, width: self.w(), height: self.h()))
        cover.contentMode = .scaleAspectFill
        cover.layer.cornerRadius = 20
        cover.layer.masksToBounds = true
        cover.isHidden = true
        self.addSubview(cover)
        
        filter = PFImageView(frame: CGRect(x: 0, y: 0, width: self.w(), height: self.h()))
        filter.contentMode = .scaleAspectFill
        filter.layer.cornerRadius = 20
        filter.layer.masksToBounds = true
        filter.backgroundColor = UIColor.black.withAlphaComponent(0.47)
        filter.isHidden = true
        self.addSubview(filter)
        
        
        icon = PFImageView(frame: CGRect(x: (self.w()-80)/2, y: (self.h()-80)/2 - 14, width: 80, height: 80))
        icon.contentMode = .scaleAspectFill
        icon.isHidden = true
        self.addSubview(icon)
        
        
        
        
      
        name = UILabel(frame: CGRect(x: 5, y: icon.yBottom() - 2, width: self.w() - 10, height: 24))
        name.textColor = .white
        name.textAlignment = .center
        name.numberOfLines = 0
        name.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.addSubview(name)
        
        comingSoon = UILabel(frame: CGRect(x: 0, y: name.yBottom() - 2, width: self.w(), height: 16))
        comingSoon.textColor = UIColor.white.withAlphaComponent(0.5)
        comingSoon.textAlignment = .center
        comingSoon.text = NSLocalizedString("Coming soon", comment: "")
        comingSoon.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        self.addSubview(comingSoon)
     

    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
