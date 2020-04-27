//
//  ExploreViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-12-30.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse
import ParseLiveQuery
import Intercom

class ExploreViewController: ParentLoadingViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    var subscriptionExplore: Subscription<PFObject>!
    var liveQueryExplore : PFQuery<PFObject>!
    
    var titleViewController = NSLocalizedString("Explore", comment:"")
    var requests = [PFObject]()
    var customTitle : UILabel!
    var collectionView : UICollectionView!

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
        
      
    
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize(width: ( Brain.kLargeurIphone - 45 ) / 2, height: ( Brain.kLargeurIphone - 45 ) / 2)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: customTitle.yBottom() + 10, width: Brain.kLargeurIphone , height: Brain.kHauteurIphone - customTitle.yBottom() - 90) , collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(exploreCollectionViewCell.self, forCellWithReuseIdentifier: "Request")
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
        
      
        
    }
    
    
    
    override func appbecomeActive() {
        
        print("become active App")
        self.getRequests()
        self.checkPendingReviews()

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        
        self.getRequests()
        self.checkPendingReviews()
        self.updateLiveQueries()

        
        self.collectionView.reloadData()

        Intercom.logEvent(withName: "worker_openExploreView")

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
                
                PFUser.current()?.setObject(geopoint!, forKey: Brain.kUserLocation)
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
            
            if PFUser.current()?.object(forKey: Brain.kUserDebug) != nil {

                if PFUser.current()?.object(forKey: Brain.kUserDebug) as! Bool != true {
                   
                    requests.whereKey(Brain.kRequestDebug, notEqualTo: true)

                }
            }else{
                
                requests.whereKey(Brain.kRequestDebug, notEqualTo: true)

            }
            
            
            if self.currentLocation != nil && PFUser.current()?.object(forKey: Brain.kUserExploreDistance) != nil{
                
                requests.whereKey(Brain.kRequestCenter, nearGeoPoint:self.currentLocation!, withinKilometers: Double(PFUser.current()?.object(forKey: Brain.kUserExploreDistance) as! Int))
            }

            requests.includeKey(Brain.kRequestService)
            requests.includeKey(Brain.kRequestCustomer)
            requests.limit = 1000
            requests.cachePolicy = .cacheThenNetwork
            requests.order(byAscending: "createdAt")
            requests.findObjectsInBackground { (requestsQuery, error) in

                if requestsQuery != nil {
                   
                    if self.currentLocation != nil {
                      
                        self.requests = requestsQuery!.sorted(by: { (requestA: PFObject, requestB: PFObject) -> Bool in
                        
                                            let distanceA = self.currentLocation!.distanceInKilometers(to: requestA.object(forKey: Brain.kRequestCenter) as? PFGeoPoint)
                                            let distanceB = self.currentLocation!.distanceInKilometers(to: requestB.object(forKey: Brain.kRequestCenter) as? PFGeoPoint)

                                            return distanceA < distanceB
                                       
                                        })
                        
                    }else{
                        
                        self.requests = requestsQuery!

                    }
                
                }else{
                   
                   self.requests = [PFObject]()
                }

                self.collectionView.reloadData()

            }


        }
        
        
       
        
    }
    
    func updateLiveQueries(){
           
        print("GO LIVE QUERY")
        liveQueryExplore = PFQuery(className: Brain.kRequestClassName)
        liveQueryExplore.whereKey(Brain.kRequestState, equalTo: "pending")
        liveQueryExplore.whereKey(Brain.kRequestCustomer, notEqualTo: PFUser.current()!.objectId!)
        liveQueryExplore.whereKeyExists(Brain.kRequestPhoto)
        liveQueryExplore.whereKey(Brain.kRequestRefuseWorkerId, notEqualTo: PFUser.current()!.objectId!)

        subscriptionExplore = Client.shared.subscribe(self.liveQueryExplore).handleEvent { query, event in

           print("live query Explore")

           DispatchQueue.main.async {
               self.getRequests()
           }
              
        }

    }
    
    
    
    
    func checkPendingReviews(){
        
        
        let requestPendingReviews = PFQuery(className: Brain.kRequestClassName)
        requestPendingReviews.whereKey(Brain.kRequestWorker, equalTo: PFUser.current()!)
        requestPendingReviews.whereKey(Brain.kRequestState, equalTo: "ended")
        requestPendingReviews.whereKeyDoesNotExist(Brain.kRequestReviewFromWorker)
        requestPendingReviews.includeKey(Brain.kRequestService)
        requestPendingReviews.includeKey(Brain.kRequestCustomer)
        requestPendingReviews.limit = 1000
        requestPendingReviews.order(byDescending: "createdAt")
        requestPendingReviews.findObjectsInBackground { (requestsEnded, error) in
         
            if requestsEnded != nil {
                
                if requestsEnded!.count > 0 {
                    
                    let request = requestsEnded![0]
                    let customer = request.object(forKey: Brain.kRequestCustomer) as! PFUser
                    let name = customer.object(forKey: Brain.kUserFirstName) as! String
                    
                    
                    let alert = UIAlertController(title: NSLocalizedString("Pending review", comment: ""),
                                                  message: String(format:NSLocalizedString("Congratulations %@ has completed your request, you can now add a review regarding his work", comment: ""), name), preferredStyle: .alert)

                    let yesAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: { action in

                        let rateVC = NewReviewToUserViewController(user: customer, request : request , fromWorker: true)
                        rateVC.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(rateVC, animated: true)
                        
                    })
                    alert.addAction(yesAction)

                    DispatchQueue.main.async {
                    self.present(alert, animated: true)
                    }
                }
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
        
        if self.liveQueryExplore != nil {
           
            Client.shared.unsubscribe(self.liveQueryExplore)

        }
        
        
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
            cell.request = nil
            cell.service = nil
            cell.customer = nil
            
            
             if self.requests.count > indexPath.row  {
                 
                cell.request = self.requests[indexPath.row]
                cell.service = cell.request.object(forKey: Brain.kRequestService) as? PFObject
                cell.customer = cell.request.object(forKey: Brain.kRequestCustomer) as? PFUser

                cell.loading.startAnimating()

                
                if self.currentLocation != nil {
                    
                    
                    let distance = self.currentLocation!.distanceInKilometers(to: cell.request.object(forKey: Brain.kRequestCenter) as? PFGeoPoint)
                    cell.timeAgo.text = String(format: NSLocalizedString("%.0fkm", comment: ""), distance)
                
                }else{
                    
                    if cell.request.createdAt != nil {
                                      
                          cell.timeAgo.text = cell.request.createdAt!.timeAgo()

                      }
                    
                }
                
                

                
                
                if cell.customer.object(forKey: Brain.kUserProfilePicture) != nil {
                    
                    cell.profilePicture.file = cell.customer.object(forKey: Brain.kUserProfilePicture) as? PFFileObject
                    cell.profilePicture.loadInBackground()
                    
                }else{
                    
                    cell.profilePicture.image = UIImage(named: "whiteProfilePicture")
                    
                }
                
                
                if cell.customer.object(forKey: Brain.kUserFirstName) != nil {
                    
                    cell.name.text = (cell.customer.object(forKey: Brain.kUserFirstName) as? String)?.capitalizingFirstLetter()

                }else{
                    
                    cell.name.text = ""
                }

                
                
                 if cell.service.object(forKey: Brain.kServiceIcon) != nil  {
                      
                    cell.icon.file =  cell.service.object(forKey: Brain.kServiceIcon) as? PFFileObject
                    cell.icon.loadInBackground()

                  }
                  
                  
                 if (cell.request.object(forKey: Brain.kRequestPhoto) != nil) {
                  
                     cell.cover.file = cell.request.object(forKey: Brain.kRequestPhoto)  as? PFFileObject
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
