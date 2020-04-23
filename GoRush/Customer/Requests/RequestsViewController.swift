//
//  RequestsViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-10-13.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse
import ParseLiveQuery
import Intercom

class RequestsViewController: ParentLoadingViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    var subscriptionRequests: Subscription<PFObject>!
    var liveQueryRequests : PFQuery<PFObject>!

    
    var titleViewController = NSLocalizedString("Requests", comment:"")
    var requests = [PFObject]()
    var requestsPast = [PFObject]()

    
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
        
        print("dealloc Requests")
        
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
        collectionViewUpcoming.contentInset = UIEdgeInsets(top: 37, left: 0, bottom: 150, right: 0)
        collectionViewUpcoming.backgroundColor = .clear
        collectionViewUpcoming.delegate = self
        collectionViewUpcoming.showsVerticalScrollIndicator = false
        
        
        //        collectionView.backgroundColor = .yellow
        //        collectionView.isScrollEnabled = false
        
        
        collectionViewUpcoming.register(requestCollectionViewCell.self, forCellWithReuseIdentifier: "Request")
        collectionViewUpcoming.register(exploreCollectionViewCell.self, forCellWithReuseIdentifier: "Accepted")
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
        collectionViewPast.contentInset = UIEdgeInsets(top: 37, left: 0, bottom: 150, right: 0)
        collectionViewPast.backgroundColor = .clear
        collectionViewPast.delegate = self
        collectionViewPast.showsVerticalScrollIndicator = false
        collectionViewPast.register(requestCollectionViewCell.self, forCellWithReuseIdentifier: "Request")
        collectionViewPast.register(exploreCollectionViewCell.self, forCellWithReuseIdentifier: "Accepted")
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

        self.collectionViewUpcoming.reloadData()
        self.collectionViewPast.reloadData()


        Intercom.logEvent(withName: "customer_openRequestsView")

    }
    
    
    
 
    
    @objc func touchUpcoming (_ sender : UIButton){
        
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            self.mainScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
        }) { (done) in
 
        }
    }
    
    
    @objc func touchPast (_ sender : UIButton){
        
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            self.mainScroll.setContentOffset(CGPoint(x: Brain.kL, y: 0), animated: true)
            
            
        }) { (done) in

        }
    }
    
    
    func getRequests() {
        
      
        let requests = PFQuery(className: Brain.kRequestClassName)
        requests.whereKey(Brain.kRequestCustomer, equalTo: PFUser.current()!)
        requests.whereKey(Brain.kRequestState, notContainedIn: ["canceled","ended"])
        requests.whereKeyExists(Brain.kRequestPhoto)
        requests.includeKey(Brain.kRequestService)
        requests.includeKey(Brain.kRequestWorker)
        requests.limit = 1000
        requests.cachePolicy = .cacheThenNetwork
        requests.order(byDescending: "createdAt")

        requests.findObjectsInBackground { (requestsQuery, error) in
            
            
            if requestsQuery != nil {
                
                self.requests = requestsQuery!
            }else{
                
                self.requests = [PFObject]()
            }
            
            self.collectionViewUpcoming.reloadData()
            
        }
        
        
        let requestsPast = PFQuery(className: Brain.kRequestClassName)
        requestsPast.whereKey(Brain.kRequestCustomer, equalTo: PFUser.current()!)
        requestsPast.whereKey(Brain.kRequestState, notContainedIn : ["accepted","started","pending","canceled"])
        requestsPast.whereKeyExists(Brain.kRequestPhoto)
        requestsPast.includeKey(Brain.kRequestService)
        requestsPast.includeKey(Brain.kRequestWorker)
        requestsPast.limit = 1000
        requestsPast.cachePolicy = .cacheThenNetwork
        requestsPast.order(byDescending: "createdAt")

        requestsPast.findObjectsInBackground { (requestsQueryPast, error) in
          
          
          if requestsQueryPast != nil {
              
              self.requestsPast = requestsQueryPast!
          }else{
              
              self.requestsPast = [PFObject]()
          }
          
          self.collectionViewPast.reloadData()
          
        }
        
    }
    
    func updateLiveQueries(){
           
        print("GO LIVE QUERY")
        liveQueryRequests = PFQuery(className: Brain.kRequestClassName)
        liveQueryRequests.whereKey(Brain.kRequestCustomer, equalTo: PFUser.current()!)

        subscriptionRequests = Client.shared.subscribe(self.liveQueryRequests).handleEvent { query, event in

           print("live query Requests")

           DispatchQueue.main.async {
               self.getRequests()
           }
              
        }

    }
    
    
    
    func checkPendingReviews(){
        
        
        let requestPendingReviews = PFQuery(className: Brain.kRequestClassName)
        requestPendingReviews.whereKey(Brain.kRequestCustomer, equalTo: PFUser.current()!)
        requestPendingReviews.whereKey(Brain.kRequestState, equalTo: "ended")
        requestPendingReviews.whereKeyDoesNotExist(Brain.kRequestReviewFromCustomer)
        requestPendingReviews.includeKey(Brain.kRequestService)
        requestPendingReviews.includeKey(Brain.kRequestWorker)
        requestPendingReviews.limit = 1000
        requestPendingReviews.order(byDescending: "createdAt")
        requestPendingReviews.findObjectsInBackground { (requestsEnded, error) in
         
            if requestsEnded != nil {
                
                if requestsEnded!.count > 0 {
                    
                    let request = requestsEnded![0]
                    
                    if request.object(forKey: Brain.kRequestWorker) != nil {

                        let worker = request.object(forKey: Brain.kRequestWorker) as! PFUser
                        let name = worker.object(forKey: Brain.kUserFirstName) as! String


                        let alert = UIAlertController(title: NSLocalizedString("Pending review", comment: ""),
                                                     message: String(format:NSLocalizedString("Congratulations %@ has completed your request, you can now add a review regarding his work", comment: ""), name), preferredStyle: .alert)

                        let yesAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: { action in

                           let rateVC = NewReviewToUserViewController(user: worker, request : request , fromWorker: false)
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
        
        
    }

    
  
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.registerForPushNotifications()

        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
                  
            if geopoint != nil {
                
                PFUser.current()?.setObject(geopoint!, forKey: Brain.kUserLocation)
                PFUser.current()?.saveInBackground()

            }
            
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
        if self.liveQueryRequests != nil {
                
            Client.shared.unsubscribe(self.liveQueryRequests)

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
        
        
        if collectionView == self.collectionViewUpcoming {
          


             if requests.count == 0 {
                
                return 6
            
            }else{
                
                return max(0, requests.count)

            }
            
            
        }else{
            
            if requestsPast.count == 0 {
                           
                   return 6
               
               }else{
                   
                   return max(0, requestsPast.count)

               }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewUpcoming {

            
            if self.requests.count > indexPath.row  {

                    if self.requests[indexPath.row].object(forKey: Brain.kRequestState) as! String != "pending" {
                        
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Accepted", for: indexPath as IndexPath) as! exploreCollectionViewCell
                        cell.cover.image = nil
                        cell.cover.isHidden = true
                        cell.icon.isHidden = true
                        cell.icon.image = nil
                        cell.profilePicture.isHidden = true
                        cell.filter.isHidden = true
                        cell.timeAgo.isHidden = true
                        cell.name.isHidden = true
                        cell.loading.stopAnimating()

                        cell.request = self.requests[indexPath.row]
                        cell.service = cell.request.object(forKey: Brain.kRequestService) as? PFObject
                        cell.worker = cell.request.object(forKey: Brain.kRequestWorker) as? PFUser

                        cell.loading.startAnimating()

                        
                        
                        
                        
                        
                       
                        
                        if (cell.request.object(forKey: Brain.kRequestPhotoEnd) != nil) {
                                                                           
                                 cell.cover.file = cell.request.object(forKey: Brain.kRequestPhotoEnd)  as? PFFileObject
                                 cell.cover.load { (image, error) in
                                 cell.cover.isHidden = false
                                 cell.icon.isHidden = false
                                 cell.profilePicture.isHidden = false
                                 cell.filter.isHidden = false
                                 cell.timeAgo.isHidden = false
                                 cell.name.isHidden = false

                                 cell.loading.stopAnimating()

                            }

                        }else  if (cell.request.object(forKey: Brain.kRequestPhotoStart) != nil) {
                                                                            
                                  cell.cover.file = cell.request.object(forKey: Brain.kRequestPhotoStart)  as? PFFileObject
                                  cell.cover.load { (image, error) in
                                  cell.cover.isHidden = false
                                  cell.icon.isHidden = false
                                  cell.profilePicture.isHidden = false
                                  cell.filter.isHidden = false
                                  cell.timeAgo.isHidden = false
                                  cell.name.isHidden = false

                                  cell.loading.stopAnimating()

                            }

                        }else if (cell.request.object(forKey: Brain.kRequestPhoto) != nil) {
                                                         
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


                        
                        
                        if cell.worker != nil {
                            
                            if cell.worker.object(forKey: Brain.kUserProfilePicture) != nil {
                               
                               cell.profilePicture.file = cell.worker.object(forKey: Brain.kUserProfilePicture) as? PFFileObject
                               cell.profilePicture.loadInBackground()
                               
                            }else{
                               
                               cell.profilePicture.image = UIImage(named: "whiteProfilePicture")
                               
                            }
                            
                            
                           if cell.worker.object(forKey: Brain.kUserFirstName) != nil {
                               
                               cell.name.text = (cell.worker.object(forKey: Brain.kUserFirstName) as? String)?.capitalizingFirstLetter()

                           }else{
                               
                               cell.name.text = ""
                           }
                           
                      
                        }else{
                            
                            cell.profilePicture.image = UIImage(named: "whiteProfilePicture")
                            cell.name.text = ""

                            
                        }
                   
                                     
                       
                         
                       
                        

                        if cell.request.createdAt != nil {
                                                                            
                            cell.timeAgo.text = cell.request.createdAt!.timeAgo()

                        }
                        
                        if let icon = cell.service.object(forKey: Brain.kServiceIcon) as? PFFileObject {
                            
                            cell.icon.file = icon
                            cell.icon.loadInBackground()

                        }

            
            

                         
                         
                         return cell
                        
                    }else{
                        
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Request", for: indexPath as IndexPath) as! requestCollectionViewCell
                        cell.cover.image = nil
                        cell.cover.isHidden = true
                        cell.pendingView.isHidden = true
                        cell.filter.isHidden = true
                        cell.pendingView.isHidden = false
                        cell.request = self.requests[indexPath.row]
                          
                         if (cell.request.object(forKey: Brain.kRequestPhoto) != nil) {
                          
                             
                             cell.cover.file = cell.request.object(forKey: Brain.kRequestPhoto)  as? PFFileObject
                             cell.cover.loadInBackground()
                             cell.cover.isHidden = false

                         }


                        return cell

                        
                    }
                
            }else{
                
                
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Request", for: indexPath as IndexPath) as! requestCollectionViewCell
                cell.cover.image = nil
                cell.cover.isHidden = true
                cell.pendingView.isHidden = true
                cell.filter.isHidden = true

                
                return cell
            }
            
            
            
            
        }else{
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Accepted", for: indexPath as IndexPath) as! exploreCollectionViewCell
             cell.cover.image = nil
           cell.cover.isHidden = true
           cell.icon.isHidden = true
           cell.icon.image = nil
           cell.profilePicture.isHidden = true
           cell.filter.isHidden = true
           cell.timeAgo.isHidden = true
           cell.name.isHidden = true
           cell.loading.stopAnimating()
            

             if self.requestsPast.count > indexPath.row  {
                 
                
                cell.loading.startAnimating()

                
                cell.request = self.requestsPast[indexPath.row]
                cell.service = cell.request.object(forKey: Brain.kRequestService) as? PFObject
                cell.worker = cell.request.object(forKey: Brain.kRequestWorker) as? PFUser
                
             
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

                
                if cell.worker != nil {
                    
                    
                    if cell.worker.object(forKey: Brain.kUserProfilePicture) != nil {
                                                
                        cell.profilePicture.file = cell.worker.object(forKey: Brain.kUserProfilePicture) as? PFFileObject
                        cell.profilePicture.loadInBackground()
                        
                    }else{
                        
                        cell.profilePicture.image = UIImage(named: "whiteProfilePicture")
                        
                    }
                    
                    

                    if cell.worker.object(forKey: Brain.kUserFirstName) != nil {
                        
                        cell.name.text = (cell.worker.object(forKey: Brain.kUserFirstName) as? String)?.capitalizingFirstLetter()

                    }else{
                        
                        cell.name.text = ""
                    }
                    
                    
                    
                }else{
                    
                    cell.profilePicture.image = UIImage(named: "whiteProfilePicture")
                    cell.name.text = ""

                }

                
                
                
               

                

                
                
                if cell.request.createdAt != nil {
                                                                    
                    cell.timeAgo.text = cell.request.createdAt!.timeAgo()

                }
                
                if let icon = cell.service.object(forKey: Brain.kServiceIcon) as? PFFileObject {
                    
                    cell.icon.file = icon
                    cell.icon.loadInBackground()

                }
                                
                
                
            
                 
             }

            
             
             return cell
            
        }
        
        
    }
    
    
  
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        
        if collectionView == self.collectionViewUpcoming {

            
            if indexPath.row < self.requests.count {
                      
                      
                let request = RequestViewController(request: self.requests[indexPath.row])
                request.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(request, animated: true)
                      
                  
            }
              
        
        }else{
            
            if indexPath.row < self.requestsPast.count {
                                
                                
              let request = RequestViewController(request: self.requestsPast[indexPath.row])
              request.hidesBottomBarWhenPushed = true
              self.navigationController?.pushViewController(request, animated: true)
                    
                
          }
        }
      
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
