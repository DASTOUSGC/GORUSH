//
//  SelectTypeViewController
//  GoRush
//
//  Created by Julien Levallois on 19-09-08.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse


class SelectServiceViewController: ParentLoadingViewController , UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate{
    
    
    var services = [PFObject]()
    var titleViewController = NSLocalizedString("Select Your Service", comment:"")

    
    var collectionView : UICollectionView!
    
    var backButtonNav : UIButton!
    

    
    
    deinit {
        
        print("dealloc Service")
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        
        
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        self.title = self.titleViewController
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .done, target: self, action: #selector(touchBack(_:)))

        
        
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize(width: ( Brain.kLargeurIphone - 45 ) / 2, height: ( Brain.kLargeurIphone - 45 ) / 2)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0 , width: Brain.kLargeurIphone , height: self.view.h() ) , collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(20, 0, 150, 0)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(serviceCollectionViewCell.self, forCellWithReuseIdentifier: "Service")
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
        
       
        
    }
    
    
   
    @objc func touchBack(_ sender: UIButton){
        
        
        self.dismiss(animated: true) {
        
            
        }
        
    }
    
    
    override func appbecomeActive() {
        
        print("become active App")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barStyle = .black

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        
        
        self.getServices()
        self.collectionView.reloadData()
       
        
    }
    
    
    
    func getServices() {
        
        let queryservices = PFQuery(className: Brain.kServicesClassName)
        queryservices.whereKey(Brain.kServiceAvailable, equalTo: true)
        queryservices.order(byAscending: Brain.kServiceOrder)
        queryservices.limit = 1000
        queryservices.cachePolicy = .cacheThenNetwork
        queryservices.findObjectsInBackground { (servicesFetched, error) in

            if error == nil {

                self.services = servicesFetched!

            }else {

                self.services = [PFObject]()

            }

            self.collectionView.reloadData()

        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
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
        
        
        return self.services.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Service", for: indexPath as IndexPath) as! serviceCollectionViewCell
        
        
        cell.cover.isHidden = true
        cell.filter.isHidden = true
        cell.name.isHidden = true
        cell.comingSoon.isHidden = true
        cell.icon.isHidden = true
        cell.service = nil
        
        
        if indexPath.row < self.services.count {
            
          
            cell.cover.isHidden = false
            cell.filter.isHidden = false
            cell.name.isHidden = false
            cell.comingSoon.isHidden = false
            cell.icon.isHidden = false

            cell.cover.image = nil
            cell.icon.image = nil
            cell.filter.backgroundColor = UIColor.black.withAlphaComponent(0.47)
            cell.icon.alpha = 1
            cell.name.alpha = 1
            cell.comingSoon.isHidden = true

            
            cell.service = self.services[indexPath.row]
            
            if let cover = cell.service.object(forKey: Brain.kServiceCover) as? PFFile {
                
                cell.cover.file = cover
                cell.cover.loadInBackground()
                
            }
            
            if let icon = cell.service.object(forKey: Brain.kServiceIcon) as? PFFile {
                
                cell.icon.file = icon
                cell.icon.loadInBackground()
                
            }
            
            cell.name.text = cell.service.object(forKey: Brain.kServicesName) as? String
            
            
            if let comingSoon = cell.service.object(forKey: Brain.kServiceComingSoon) as? Bool {
                
                if comingSoon == true {
                    
                    cell.filter.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                    cell.icon.alpha = 0.5
                    cell.name.alpha = 0.5
                    cell.comingSoon.isHidden = false
                    

                }
                
            }
            
            
            
        }
        
        return cell
        
    }
    
    
 
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if indexPath.row < self.services.count {
            
            
            if self.services[indexPath.row].object(forKey: Brain.kServiceComingSoon) as! Bool != true {
                
                let request = PFObject(className: Brain.kRequestClassName)
                 request.setObject("pending", forKey: Brain.kRequestState)
                 request.setObject(PFUser.current()!, forKey: Brain.kRequestCustomer)
                 request.setObject(self.services[indexPath.row], forKey: Brain.kRequestService)
                request.setObject(self.services[indexPath.row].objectId!, forKey: Brain.kRequestServiceId)

                             
                 let whereVC = WhereViewController(request: request)
                 self.navigationController?.pushViewController(whereVC, animated: true)
        
            }
            
         
            
        }
        
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
