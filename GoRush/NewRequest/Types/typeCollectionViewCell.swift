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
    
    
    var profil : PFObject!
    var cover : PFImageView!
    var filter : UIImageView!
    var name : UILabel!
    var subName : UILabel!
    var bg : UIView!
    var addProfil : UIImageView!
    
    var editProfil : UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor = .clear
        self.clipsToBounds = false
        
        bg = UIView(frame: CGRect(x: 0, y: 0, width: self.w(), height: self.h()))
        bg.contentMode = .scaleAspectFill
        bg.layer.cornerRadius = 20
        bg.backgroundColor = UIColor(hex: "F9F9F9")
        self.addSubview(bg)
        
        addProfil = UIImageView(frame: CGRect(x: (self.w() - 52) / 2 , y: (self.h() - 52) / 2, width: 52, height: 52))
        addProfil.image = UIImage(named: "addProfil")
        self.addSubview(addProfil)

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
        
      
        name = UILabel(frame: CGRect(x: 15, y: self.h() - 50, width: self.w() - 30, height: 21))
        name.textColor = .white
        name.textAlignment = .left
        name.numberOfLines = 2
        name.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.addSubview(name)
        
        subName = UILabel(frame: CGRect(x: 15, y: name.yBottom(), width: self.w() - 30, height: 16))
        subName.textColor = UIColor.white.withAlphaComponent(0.5)
        subName.textAlignment = .left
        subName.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.addSubview(subName)
        
        
        editProfil = UIButton(frame: CGRect(x: self.w() - 44, y: 0, width: 44, height: 44))
        editProfil.setBackgroundImage(UIImage(named: "editProfil"), for: .normal)
        self.addSubview(editProfil)

        ////editProfil
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
