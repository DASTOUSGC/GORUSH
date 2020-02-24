//
//  GrassHeight.swift
//  GoRush
//
//  Created by Julien Levallois on 19-07-21.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation

import UIKit
import Parse

protocol GrassHeightDelegate : class {
    
    func updateSelectedHeight(height: String)
    
    
}

class GrassHeight: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
  
    
    
    open weak var delegate: GrassHeightDelegate?
    
    var collectionView : UICollectionView!
    
    
    var heights = ["5″","6″","7″","8″","9″","10″","11″","12″","13″","14″","15″"]
    
    var selectedHeights : [String]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = false
        self.backgroundColor = .clear
        
        ///54
        
        self.selectedHeights = heights
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 105, height: self.h())
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.w() , height: self.h() ) , collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(grassHeightCollectionViewCell.self, forCellWithReuseIdentifier: "Grass")
        collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView)
        
        
      
        
    }
    
  
   
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 105, height: self.h())
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return self.heights.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Grass", for: indexPath as IndexPath) as! grassHeightCollectionViewCell
        
        
        if self.selectedHeights.contains(self.heights[indexPath.row]) {
            
            
            cell.isUserInteractionEnabled = true
            cell.alpha = 1
            
        }else{
            
            
            cell.isUserInteractionEnabled = false
            cell.alpha = 0.3
        }
        
        
        cell.value = self.heights[indexPath.row]
        cell.height.text = cell.value
        return cell
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //        collectionView.deselectItem(at: indexPath, animated: false)
        
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! grassHeightCollectionViewCell
     
        self.delegate?.updateSelectedHeight(height: cell.value)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
