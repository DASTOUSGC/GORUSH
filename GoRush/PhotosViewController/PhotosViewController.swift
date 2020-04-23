//
//  DetailViewController.swift
//  PhotosViewController
//
//  Created by Julien Levallois on 19-06-12.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse
import Intercom


class PhotosViewController: ParentLoadingViewController, UIScrollViewDelegate {
    
    
    var cancelButton : UIButton!
    var horizontalScrollView : UIScrollView!
    
    var request : PFObject!
    
    var photo1 : PFImageView!
    var photo2 : PFImageView!
    var photo3 : PFImageView!
    var photo4 : PFImageView!
    
    var user : PFUser!
    var initIndex = 0


    var pageControl1 : UIImageView!
    var pageControl2 : UIImageView!
    var pageControl3 : UIImageView!
    var pageControl4 : UIImageView!
    
    
    convenience init(request:PFObject)
    {
        
        self.init()
        self.request = request
       
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        
        self.view.backgroundColor =  UIColor.black.withAlphaComponent(0)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true

        
        
        horizontalScrollView = UIScrollView(frame: CGRect(x: 0, y: Brain.kH + 100, width: Brain.kL, height: Brain.kL))
        horizontalScrollView.isPagingEnabled = true
        horizontalScrollView.delegate = self
        horizontalScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(horizontalScrollView)
        
        photo1 = PFImageView(frame: CGRect(x: 25, y: 0, width: Brain.kL - 50, height: Brain.kL - 50))
        photo1.contentMode = .scaleAspectFill
        photo1.isUserInteractionEnabled = true
        photo1.clipsToBounds = true
        photo1.layer.cornerRadius = 14
        horizontalScrollView.addSubview(photo1)
        
      
        
        photo2 = PFImageView(frame: CGRect(x: 25 +  1 * Brain.kL, y: 0, width: Brain.kL - 50, height:   photo1.h()))
        photo2.contentMode = .scaleAspectFill
        photo2.isUserInteractionEnabled = true
        photo2.clipsToBounds = true
        photo2.layer.cornerRadius = 14
        
        
        horizontalScrollView.addSubview(photo2)
        photo3 = PFImageView(frame: CGRect(x:25 + 2 * Brain.kL, y: 0, width: Brain.kL - 50, height:   photo1.h()))
        photo3.contentMode = .scaleAspectFill
        photo3.isUserInteractionEnabled = true
        photo3.clipsToBounds = true
        photo3.layer.cornerRadius = 14

        
     
        
        horizontalScrollView.addSubview(photo3)
        photo4 = PFImageView(frame: CGRect(x: 25 +  3 * Brain.kL, y: 0, width: Brain.kL - 50, height:  photo1.h()))
        photo4.contentMode = .scaleAspectFill
        photo4.clipsToBounds = true
        photo4.isUserInteractionEnabled = true
        horizontalScrollView.addSubview(photo4)
        photo4.layer.cornerRadius = 14

      
        
        pageControl1 = UIImageView(frame: CGRect(x: 10, y: horizontalScrollView.y() - 35, width: 9, height: 9))
        pageControl1.layer.cornerRadius = 4.5
        pageControl1.backgroundColor = .white
//        pageControl1.layer.applySketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        pageControl1.isHidden = true
        self.view.addSubview(pageControl1)
        
        pageControl2 = UIImageView(frame: CGRect(x: 26, y: horizontalScrollView.y()  - 35, width: 9, height: 9))
        pageControl2.layer.cornerRadius = 4.5
        pageControl2.backgroundColor = .white
        pageControl2.isHidden = true
//        pageControl2.layer.applySketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        self.view.addSubview(pageControl2)
        
        pageControl3 = UIImageView(frame: CGRect(x: 42, y: horizontalScrollView.y()  - 35, width: 9, height: 9))
        pageControl3.layer.cornerRadius = 4.5
        pageControl3.backgroundColor = .white
        pageControl3.isHidden = true
//        pageControl3.layer.applySketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        self.view.addSubview(pageControl3)
        
        pageControl4 = UIImageView(frame: CGRect(x: 58, y: horizontalScrollView.y()  - 35, width: 9, height: 9))
        pageControl4.layer.cornerRadius = 4.5
        pageControl4.backgroundColor = .white
        pageControl4.isHidden = true
//        pageControl4.layer.applySketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        self.view.addSubview(pageControl4)
        
        
        
        var nb = 0
        
        let photos = self.request.object(forKey: Brain.kRequestPhotos) as! [PFFileObject]
        
        if photos.count > 0 {
            
            self.photo1.file = photos[0]
            self.photo1.loadInBackground()
            
            nb = nb + 1
            
            pageControl1.isHidden = false
        }
        
        
        if photos.count > 1 {
            
            self.photo2.file = photos[1]
            self.photo2.loadInBackground()
            
            nb = nb + 1
            
            pageControl2.isHidden = false
        }
        
        if photos.count > 2 {
           
           self.photo3.file = photos[2]
           self.photo3.loadInBackground()
           
           nb = nb + 1
           
           pageControl3.isHidden = false
        }
        
        if photos.count > 3 {
          
          self.photo4.file = photos[3]
          self.photo4.loadInBackground()
          
          nb = nb + 1
          
          pageControl4.isHidden = false
       
        }
       
        
        
        
        let largeurP = 16 * nb - 9
        let originP = (Brain.kLargeurIphone - CGFloat(largeurP) ) / 2

        pageControl1.frame.origin.x = originP
        pageControl2.frame.origin.x = pageControl1.frame.origin.x + 16
        pageControl3.frame.origin.x = pageControl2.frame.origin.x + 16
        pageControl4.frame.origin.x = pageControl3.frame.origin.x + 16

        horizontalScrollView.contentSize = CGSize(width: Brain.kL * CGFloat(nb), height: photo1.h())
        horizontalScrollView.setContentOffset(CGPoint(x: Brain.kL * CGFloat(initIndex), y: 0), animated: false)
        
        
        
        
        cancelButton = UIButton(frame: CGRect(x: ( Brain.kL - 240 ) / 2, y: horizontalScrollView.yBottom() - 10, width: 240 , height: 55))
        cancelButton.layer.cornerRadius = 44 / 2
        cancelButton.layer.masksToBounds = true
        cancelButton.setBackgroundColor(color: .clear, forState: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cancelButton.setTitleColor(UIColor.white.withAlphaComponent(0.55), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        
        
        
        self.updatePageControl()
        
    }
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        cancelPage()

    }
    
    
    
    @objc func showPicture(_ sender: UIButton){

        
        
        self.cancelPage()

                  
    }
    
    @objc func cancelAction(_ sender: UIButton){
        
       
        
        cancelPage()
    }
    
    
    
    func cancelPage(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {

            self.horizontalScrollView.frame.origin.y = Brain.kH + 100
            self.cancelButton.frame.origin.y =  self.horizontalScrollView.yBottom() + 20

            self.view.backgroundColor =  UIColor.black.withAlphaComponent(0)

            self.pageControl1.frame.origin.y =  self.horizontalScrollView.y() +  self.horizontalScrollView.h() - 35
            self.pageControl2.frame.origin.y =  self.horizontalScrollView.y() +  self.horizontalScrollView.h() - 35
            self.pageControl3.frame.origin.y =  self.horizontalScrollView.y() +  self.horizontalScrollView.h() - 35
            self.pageControl4.frame.origin.y =  self.horizontalScrollView.y() +  self.horizontalScrollView.h() - 35

          
               }) { (done) in
                   
                   self.dismiss(animated: false) {
                       
                   }
               }
    }
    
    
    
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == horizontalScrollView {
            
            self.updatePageControl()
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.horizontalScrollView {
            
            self.stopScroll()

        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == self.horizontalScrollView {
            
            
            self.stopScroll()
            
        }
    }
    
    func stopScroll(){
        
      
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
       
    }
    
  
    
    func updatePageControl(){
        
        if (self.horizontalScrollView.contentOffset.x / CGFloat(Brain.kL)) == 0 {
            
            self.pageControl1.alpha = 1
            self.pageControl2.alpha = 0.5
            self.pageControl3.alpha = 0.5
            self.pageControl4.alpha = 0.5

        }else if (self.horizontalScrollView.contentOffset.x / CGFloat(Brain.kL)) == 1 {
            
            self.pageControl1.alpha = 0.5
            self.pageControl2.alpha = 1
            self.pageControl3.alpha = 0.5
            self.pageControl4.alpha = 0.5
            
            
        }else if (self.horizontalScrollView.contentOffset.x / CGFloat(Brain.kL)) == 2 {
            
            
            self.pageControl1.alpha = 0.5
            self.pageControl2.alpha = 0.5
            self.pageControl3.alpha = 1
            self.pageControl4.alpha = 0.5
            
        }else if (self.horizontalScrollView.contentOffset.x / CGFloat(Brain.kL)) == 3 {
            
            
            self.pageControl1.alpha = 0.5
            self.pageControl2.alpha = 0.5
            self.pageControl3.alpha = 0.5
            self.pageControl4.alpha = 1
            
        }
        
    }
    
    
    @objc func dismissVC(_ sender: UIButton){
        
        
        self.dismiss(animated: true) {
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        
        Intercom.logEvent(withName: "customer_openPhotosView")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
               UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                   
                   if isIphoneXFamily(){
                       
                    self.horizontalScrollView.frame.origin.y = Brain.kH - Brain.kL + 20
                       
                   }else{
                       
                       self.horizontalScrollView.frame.origin.y = Brain.kH - Brain.kL  + 20
                       
                   }
                   self.cancelButton.frame.origin.y =  self.horizontalScrollView.yBottom() + 20
                   self.view.backgroundColor =  UIColor.black.withAlphaComponent(0.8)
                   
                
                self.pageControl1.frame.origin.y =  self.horizontalScrollView.y()  - 35
                self.pageControl2.frame.origin.y =  self.horizontalScrollView.y()  - 35
                self.pageControl3.frame.origin.y =  self.horizontalScrollView.y()  - 35
                self.pageControl4.frame.origin.y =  self.horizontalScrollView.y()  - 35

            
                
               }) { (done) in
                   
                   
               }
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    
    @objc func touchLeftButton(_ sender: UIButton){
        
        
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
