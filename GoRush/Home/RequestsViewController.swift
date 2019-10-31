//
//  RequestsViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-10-13.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse


class RequestsViewController: ParentLoadingViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    var titleViewController = NSLocalizedString("Requests", comment:"")
    var requests = [PFObject]()

    
    var customTitle : UILabel!
    
  
    var collectionViewUpcoming : UICollectionView!
    var collectionViewPast : UICollectionView!

    var backgroundSlider : UIView!
    var slider : UIView!
    var pastButton : UIButton!
    var upcomingButton : UIButton!
    
    var mainScroll : UIScrollView!
    
    
    var lightMode = false
    
    deinit {
        
        print("dealloc Service")
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if lightMode == false {
            
            return .default
            
        }else{
            
            return .lightContent
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = titleViewController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        
        
        if isIphoneXFamily(){
            
            customTitle = UILabel(frame: CGRect(x: 15, y: yTop() + 15, width: Brain.kL - 30, height: 50))
            
        }else{
            
            customTitle = UILabel(frame: CGRect(x: 15, y: yTop() + 25, width: Brain.kL - 30, height: 50))
            
        }
        customTitle.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        customTitle.text = titleViewController
        customTitle.textColor = UIColor(hex: "4D4D4D")
        view.addSubview(customTitle)
        
      
        
        mainScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: Brain.kL, height: Brain.kH))
        mainScroll.contentSize = CGSize(width: Brain.kL * 2, height: Brain.kH)
        mainScroll.isPagingEnabled = true
        mainScroll.delegate = self
        view.addSubview(mainScroll)
        
        ////////
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize(width: ( Brain.kLargeurIphone - 45 ) / 2, height: ( Brain.kLargeurIphone - 45 ) / 2)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        
        
        collectionViewUpcoming = UICollectionView(frame: CGRect(x: 0, y: customTitle.yBottom() + 5 + 18.5, width: Brain.kLargeurIphone , height: Brain.kHauteurIphone - customTitle.yBottom() - 5 - 18.5 ) , collectionViewLayout: layout)
        collectionViewUpcoming.dataSource = self
        collectionViewUpcoming.contentInset = UIEdgeInsetsMake(37, 0, 150, 0)
        collectionViewUpcoming.backgroundColor = .clear
        collectionViewUpcoming.delegate = self
        collectionViewUpcoming.showsVerticalScrollIndicator = false
        //        collectionView.backgroundColor = .yellow
        //        collectionView.isScrollEnabled = false
        collectionViewUpcoming.register(requestCollectionViewCell.self, forCellWithReuseIdentifier: "Request")
        collectionViewUpcoming.showsHorizontalScrollIndicator = false
        self.mainScroll.addSubview(collectionViewUpcoming)
        
        
        //////
        let layoutPast: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutPast.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layoutPast.itemSize = CGSize(width: ( Brain.kLargeurIphone - 45 ) / 2, height: ( Brain.kLargeurIphone - 45 ) / 2)
        layoutPast.scrollDirection = .vertical
        layoutPast.minimumInteritemSpacing = 15
        layoutPast.minimumLineSpacing = 15
        
        
        collectionViewPast = UICollectionView(frame: CGRect(x: Brain.kL, y: customTitle.yBottom() + 5 + 18.5, width: Brain.kLargeurIphone , height: Brain.kHauteurIphone - customTitle.yBottom() - 5 - 18.5 ) , collectionViewLayout: layoutPast)
        collectionViewPast.dataSource = self
        collectionViewPast.contentInset = UIEdgeInsetsMake(37, 0, 150, 0)
        collectionViewPast.backgroundColor = .clear
        collectionViewPast.delegate = self
        collectionViewPast.showsVerticalScrollIndicator = false
        collectionViewPast.register(requestCollectionViewCell.self, forCellWithReuseIdentifier: "Request")
        collectionViewPast.showsHorizontalScrollIndicator = false
        self.mainScroll.addSubview(collectionViewPast)
        
      
        
        backgroundSlider = UIView(frame: CGRect(x: 15, y: customTitle.yBottom() + 5, width: Brain.kL - 30, height: 37))
        backgroundSlider.layer.cornerRadius = 37 / 2
        backgroundSlider.backgroundColor = UIColor(hex: "F7F7F7")
        self.view.addSubview(backgroundSlider)
        
        
        slider = UIView(frame: CGRect(x: 0, y: 0, width: backgroundSlider.w()/2, height: backgroundSlider.h()))
        slider.applyGradient()
        slider.layer.cornerRadius = backgroundSlider.h() / 2
        slider.layer.applySketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        backgroundSlider.addSubview(slider)
        
        
        upcomingButton = UIButton(frame: CGRect(x: 0, y: 0, width: backgroundSlider.w()/2, height: backgroundSlider.h()))
        upcomingButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        upcomingButton.setTitleColor(.white, for: .normal)
        upcomingButton.setTitle(NSLocalizedString("Upcoming", comment: ""), for: .normal)
        upcomingButton.addTarget(self, action: #selector(touchUpcoming(_:)), for: .touchUpInside)
        backgroundSlider.addSubview(upcomingButton)
        
        pastButton = UIButton(frame: CGRect(x: backgroundSlider.w()/2, y: 0, width: backgroundSlider.w()/2, height: backgroundSlider.h()))
        pastButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        pastButton.setTitleColor(UIColor(hex: "BDBDBD"), for: .normal)
        pastButton.setTitle(NSLocalizedString("Past", comment: ""), for: .normal)
        pastButton.addTarget(self, action: #selector(touchPast(_:)), for: .touchUpInside)
        backgroundSlider.addSubview(pastButton)
        
        
    }
    
    
  
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if scrollView == mainScroll {
        
            
            var originX = mainScroll.contentOffset.x
            
            
            if originX < Brain.kLargeurIphone / 2 {
                
                self.upcomingButton.setTitleColor(.white, for: .normal)
                self.pastButton.setTitleColor(UIColor(hex: "BDBDBD"), for: .normal)
                
            }else{
                
                self.pastButton.setTitleColor(.white, for: .normal)
                self.upcomingButton.setTitleColor(UIColor(hex: "BDBDBD"), for: .normal)
                
            }
            
            if originX < 0 {
                
                originX = 0
            }
            
            if originX > Brain.kLargeurIphone{
                
                originX = Brain.kLargeurIphone
            }
            
            self.slider.frame.origin.x = (originX / Brain.kLargeurIphone) * self.slider.w()
            
        }
        
        
        
        
    }
    
    
    
    
    override func appbecomeActive() {
        
        print("become active App")
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        
        
        self.getRequests()
            
        
        self.collectionViewUpcoming.reloadData()
        self.collectionViewPast.reloadData()

        
    }
    
    
    
 
    
    @objc func touchUpcoming (_ sender : UIButton){
        
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            self.mainScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
            self.upcomingButton.setTitleColor(.white, for: .normal)
            self.pastButton.setTitleColor(UIColor(hex: "BDBDBD"), for: .normal)
            
            
        }) { (done) in
            
            
        }
    }
    
    
    @objc func touchPast (_ sender : UIButton){
        
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            self.mainScroll.setContentOffset(CGPoint(x: Brain.kL, y: 0), animated: true)
            
            self.upcomingButton.setTitleColor(UIColor(hex: "BDBDBD"), for: .normal)
            self.pastButton.setTitleColor(.white, for: .normal)
            
        }) { (done) in
            
            
        }
    }
    
    
    func getRequests() {
        
      
        
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    ////COLLECTIONVIEW
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        
        return CGSize(width: ( Brain.kLargeurIphone - 45 ) / 2, height: ( Brain.kLargeurIphone - 45 ) / 2)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return max(6, requests.count + 1)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Request", for: indexPath as IndexPath) as! requestCollectionViewCell
        
        
        return cell
        
    }
    
    
  
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if indexPath.row < self.requests.count + 1 {
            
            
         
            
            
        }else if indexPath.row == 0 {
            
         
            
        } else{
            
            
            
            
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
