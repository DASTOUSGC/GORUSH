//
//  SkillsViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-12-30.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse


class SkillsViewController: ParentLoadingViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    var titleViewController = NSLocalizedString("Skills", comment:"")
    var services = [PFObject]()

    var customTitle : UILabel!
    
    var collectionView : UICollectionView!

   
    
    var lightMode = false
    
    deinit {
        
        print("dealloc Skills")
        
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
        collectionView.register(skillCollectionViewCell.self, forCellWithReuseIdentifier: "Skill")
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
        
   
        
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
        
        
        
        self.getServices()
            
        
        self.collectionView.reloadData()

        
    }
    
 
  
   
   func getServices() {
       
       let queryservices = PFQuery(className: Brain.kServicesClassName)
       queryservices.whereKey(Brain.kServiceAvailable, equalTo: true)
       queryservices.whereKey(Brain.kServiceComingSoon, notEqualTo: true)
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
        
          
        return services.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Skill", for: indexPath as IndexPath) as! skillCollectionViewCell
               
               
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
                    
                       cell.cover.load { (image, error) in

                        if PFUser.current()?.object(forKey: Brain.kUserSkills) as? [PFObject] != nil {
                            
                            
                            let skills = PFUser.current()?.object(forKey: Brain.kUserSkills) as? [PFObject]

                            var index = -1
                            
                            for i in 0..<skills!.count {
                                
                                let skill = skills![i]
                                
                                if skill.objectId! == cell.service.objectId! {
                                    
                                    index = i
                                }
                                
                            }
                            
                            
                            if (index != -1) {

                                cell.cover.image = image!
                                cell.check.isHidden = false

                            }else{
                                
                                cell.cover.image = image!.noir!
                                cell.check.isHidden = true

                            }
                            

                        }else{
                            
                            
                            cell.cover.image = image!.noir!
                            cell.check.isHidden = true
                        }
                        
                      }
                       
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
        
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! skillCollectionViewCell
      
        if PFUser.current()?.object(forKey: Brain.kUserSkills) as? [PFObject] != nil {
                         
            
            var skills = PFUser.current()?.object(forKey: Brain.kUserSkills) as? [PFObject]

            var index = -1
            
            for i in 0..<skills!.count {
                
                let skill = skills![i]
                
                if skill.objectId! == cell.service.objectId! {
                    
                    index = i
                }
                
            }
            
            
                                   
            if (index != -1) {
              
            
                skills?.remove(at: index)
                PFUser.current()?.setObject(skills!, forKey: Brain.kUserSkills)
                PFUser.current()?.saveInBackground()


           }else{
               
                
                var skills = PFUser.current()?.object(forKey: Brain.kUserSkills) as? [PFObject]
                skills?.append(cell.service)
                PFUser.current()?.setObject(skills!, forKey: Brain.kUserSkills)
                PFUser.current()?.saveInBackground()
                

           }
           

       }else{
           
            var skills =  [PFObject]()
            skills.append(cell.service)
            PFUser.current()?.setObject(skills, forKey: Brain.kUserSkills)
            PFUser.current()?.saveInBackground()
       }

        
        cell.cover.load { (image, error) in

             
            if PFUser.current()?.object(forKey: Brain.kUserSkills) as? [PFObject] != nil {
                   
                   
                   if (PFUser.current()?.object(forKey: Brain.kUserSkills) as? [PFObject])!.contains(cell.service) {
                      
                       cell.cover.image = image!
                    cell.check.isHidden = false

                   }else{
                       
                       cell.cover.image = image!.noir!
                    cell.check.isHidden = true

                   }
                   

               }else{
                   
                           
                    cell.cover.image = image!.noir!
                    cell.check.isHidden = true

               }
       
        }
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tabBarController?.exploreViewController?.getRequests()
        



    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


extension UIImage {
    var noir: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}
