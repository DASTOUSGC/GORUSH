//
//  buzzsCollectionViewCell.swift
//  Buzzy
//
//  Created by Julien Levallois on 18-12-03.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Parse


class buzzCollectionViewCell.swift: UICollectionViewCell {
    
    
    
    var picture : PFImageView!
    var crowned : UIImageView!
    var buzz : PFObject!
    var circularView : progressViewCircular!
    var likeNumber : UILabel!
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        picture = PFImageView(frame: CGRect(x:(( Brain.kLargeurIphone/4) - 67) / 2, y: 32, width: 67, height: 67))
        picture.layer.cornerRadius = 67 / 2
        picture.backgroundColor = UIColor(hex:"F8F6F6")
        picture.clipsToBounds = true
        picture.contentMode = .scaleAspectFill
        self.addSubview(picture)
        
      

        
        self.circularView = progressViewCircular(frame: self.picture.frame)
        self.circularView.updateShape(color: Brain.kColorYellow, width: 3.5)
        self.addSubview(self.circularView)
        
        self.crowned = UIImageView(frame:CGRect(x: 4, y: 17, width: 23, height: 22))
        self.crowned.image = UIImage(named:"crowned2")?.withRenderingMode(.alwaysTemplate)
        self.crowned.tintColor = Brain.kColorYellow
        self.addSubview(self.crowned)
        
        self.likeNumber = UILabel(frame: CGRect(x: 0, y: 110, width: ( Brain.kLargeurIphone/4), height: 16))
        self.likeNumber.textAlignment = .center
        self.likeNumber.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.addSubview(self.likeNumber)


    }
    
    
   
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
