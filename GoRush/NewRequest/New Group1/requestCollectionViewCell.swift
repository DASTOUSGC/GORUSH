//
//  requestCollectionViewCell
//  GoRush
//
//  Created by Julien Levallois on 19-09-08.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Parse


class requestCollectionViewCell: UICollectionViewCell {
    
    
    var profil : PFObject!
    var cover : PFImageView!
    var filter : UIImageView!
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
        filter.backgroundColor = UIColor.black.withAlphaComponent(0.31)
        filter.isHidden = true
        self.addSubview(filter)
        
      
        

    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
