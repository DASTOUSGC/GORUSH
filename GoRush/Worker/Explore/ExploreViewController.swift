//
//  ExploreViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-12-30.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse


class ExploreViewController: ParentLoadingViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    var titleViewController = NSLocalizedString("Explore", comment:"")
    var requests = [PFObject]()

    var customTitle : UILabel!
    
    var collectionView : UICollectionView!

   
    var timer: Timer?

    
    var lightMode = false
    var currentLocation : PFGeoPoint?
    
    deinit {
        
        print("dealloc Explore")
        
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
        
      
    
        ////////
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize(width: ( Brain.kLargeurIphone - 45 ) / 2, height: ( Brain.kLargeurIphone - 45 ) / 2)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: customTitle.yBottom() + 10, width: Brain.kLargeurIphone , height: Brain.kHauteurIphone - customTitle.yBottom() - 10 ) , collectionViewLayout: layout)
        collectionView.dataSource = self
//        collectionView.contentInset = UIEdgeInsetsMake(37, 0, 0, 0)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        //        collectionView.backgroundColor = .yellow
        //        collectionView.isScrollEnabled = false
        collectionView.register(exploreCollectionViewCell.self, forCellWithReuseIdentifier: "Request")
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
        
   
       
        
        
    }
    
    
  
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }

    @objc func loop() {
       
        self.getRequests()
        
    }
    
    
    
    
    
    override func appbecomeActive() {
        
        print("become active App")
        self.getRequests()

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        
        
       if timer == nil {
           timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
       }
        
        
        self.getRequests()
            
        
        self.collectionView.reloadData()

        
    }
    
 
   
    func getRequests() {
        
        
        
        var skillsIds = [String]()
        
        if PFUser.current()?.object(forKey: Brain.kUserSkills) as? [PFObject] != nil {
                                
            let skills = PFUser.current()?.object(forKey: Brain.kUserSkills) as? [PFObject]

            for i in 0..<skills!.count {
               
               let skill = skills![i]
               skillsIds.append(skill.objectId!)
            
            }
                
            
        }
      
        
        
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
                              
            if geopoint != nil {
                
                PFUser.current()?.setObject(geopoint, forKey: Brain.kUserLocation)
                PFUser.current()?.saveInBackground()

                self.currentLocation = geopoint
                
            }else{
                
                self.currentLocation = nil
            }
        
            let requests = PFQuery(className: Brain.kRequestClassName)
            requests.whereKey(Brain.kRequestState, equalTo: "pending")
            requests.whereKey(Brain.kRequestCustomer, notEqualTo: PFUser.current()!.objectId!)
            requests.whereKeyExists(Brain.kRequestPhoto)
            requests.whereKey(Brain.kRequestServiceId, containedIn: skillsIds)
            requests.whereKey(Brain.kRequestRefuseWorkerId, notEqualTo: PFUser.current()!.objectId!)
            requests.includeKey(Brain.kRequestService)
            requests.includeKey(Brain.kRequestCustomer)
            requests.limit = 1000
            requests.cachePolicy = .cacheThenNetwork
            requests.order(byAscending: "createdAt")
            requests.findObjectsInBackground { (requestsQuery, error) in

            if requestsQuery != nil {
               
               self.requests = requestsQuery!
            
            }else{
               
               self.requests = [PFObject]()
            }

                self.collectionView.reloadData()

            }


        }
        
        
       
        
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.registerForPushNotifications()


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.stopTimer()

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
        
        
        if requests.count == 0 {
            
            return 6
        
        }else{
            
            return max(0, requests.count)

        }
          
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {

            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Request", for: indexPath as IndexPath) as! exploreCollectionViewCell
            cell.cover.image = nil
            cell.cover.isHidden = true
            cell.icon.isHidden = true
            cell.icon.image = nil
            cell.profilePicture.isHidden = true
            cell.filter.isHidden = true
            cell.timeAgo.isHidden = true
            cell.name.isHidden = true
            cell.loading.stopAnimating()


             if self.requests.count > indexPath.row  {
                 
                cell.request = self.requests[indexPath.row]
                cell.service = cell.request.object(forKey: Brain.kRequestService) as? PFObject
                cell.customer = cell.request.object(forKey: Brain.kRequestCustomer) as? PFUser

                cell.loading.startAnimating()

                
                if self.currentLocation != nil {
                    
                    
                    let distance = self.currentLocation!.distanceInKilometers(to: cell.request.object(forKey: Brain.kRequestCenter) as? PFGeoPoint)
                    cell.timeAgo.text = String(format: NSLocalizedString("%.1fkm", comment: ""), distance)
                
                }else{
                    
                    if cell.request.createdAt != nil {
                                      
                          cell.timeAgo.text = cell.request.createdAt!.timeAgo()

                      }
                    
                }
                
                

                
                
                if cell.customer.object(forKey: Brain.kUserProfilePicture) != nil {
                    
                    cell.profilePicture.file = cell.customer.object(forKey: Brain.kUserProfilePicture) as? PFFile
                    cell.profilePicture.loadInBackground()
                    
                }else{
                    
                    cell.profilePicture.image = UIImage(named: "whiteProfilePicture")
                    
                }
                
                
                if cell.customer.object(forKey: Brain.kUserFirstName) != nil {
                    
                    cell.name.text = (cell.customer.object(forKey: Brain.kUserFirstName) as? String)?.capitalizingFirstLetter()

                }else{
                    
                    cell.name.text = ""
                }
                

                
                
              

                
                 if let icon = cell.service.object(forKey: Brain.kServiceIcon) as? PFFile {
                      
                      cell.icon.file = icon
                      cell.icon.loadInBackground()

                  }
                  
                  
                 if (cell.request.object(forKey: Brain.kRequestPhoto) != nil) {
                  
                     cell.cover.file = cell.request.object(forKey: Brain.kRequestPhoto)  as? PFFile
                     cell.cover.load { (image, error) in
                        
                        cell.cover.isHidden = false
                        cell.icon.isHidden = false
                        cell.profilePicture.isHidden = false
                        cell.filter.isHidden = false
                        cell.timeAgo.isHidden = false
                        cell.name.isHidden = false
                        
                        cell.loading.stopAnimating()


                    }

                 }
            
                 
             }
             
             
             return cell
            
            
        }else{
            
            
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Request", for: indexPath as IndexPath) as! requestCollectionViewCell
             cell.cover.image = nil
             cell.cover.isHidden = true
             cell.pendingView.isHidden = true
             cell.filter.isHidden = true 

             
             return cell
            
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        
        if indexPath.row < self.requests.count {

          
            let request = RequestWorkerViewController(request: self.requests[indexPath.row])
            request.hidesBottomBarWhenPushed = true
                
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.tabBarController?.navigationController!.pushViewController(request, animated: true)

            
            
        }
      
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
