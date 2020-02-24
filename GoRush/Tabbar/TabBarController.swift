//
//  TabBarController.swift
// GoRush
//
//  Created by Julien Levallois on 18-01-23.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//

import UIKit
import UserNotifications
import Parse

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
  
    var tabBarImage1 = "request"
    var tabBarImage2 = "createIcon"
    var tabBarImage2B = "createIconB"
    var tabBarImage3 = "profil"

    var tabBarImageSelected1 = "requestOn"
    var tabBarImageSelected2 = "createIcon"
    var tabBarImageSelected2B = "createIconB"
    var tabBarImageSelected3 = "profilOn"

    var navigationViewController1 : UINavigationController?
    var navigationViewController2 : UINavigationController?
    var navigationProfileViewController : UINavigationController?

    var requestsViewController : RequestsViewController?
    var createRequestViewController : UIViewController?
    var profileViewController : ProfilViewController?

    var previousController: UIViewController?

    
    
    var tabBarWorkerImage1 = "search"
    var tabBarWorkerImage2 = "request"
    var tabBarWorkerImage3 = "skills"

    var tabBarWorkerImageSelected1 = "searchOn"
    var tabBarWorkerImageSelected2 = "requestOn"
    var tabBarWorkerImageSelected3 = "skillsOn"

    var navigationWorkerViewController1 : UINavigationController?
    var navigationWorkerViewController2 : UINavigationController?
    var navigationWorkerViewController3 : UINavigationController?

    var exploreViewController : ExploreViewController?
    var jobsViewController : JobsViewController?
    var skillsViewController : SkillsViewController?
    
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.tabBar.barTintColor =  UIColor.white
        self.tabBar.isTranslucent=false

        self.delegate = self
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = true

        self.requestsViewController = RequestsViewController()
        self.requestsViewController?.tabBarItem.image = UIImage(named: self.tabBarImage1)?.withRenderingMode(.alwaysOriginal)
        self.requestsViewController?.tabBarItem.selectedImage = UIImage(named: self.tabBarImageSelected1)?.withRenderingMode(.alwaysOriginal)
        if isIphoneXFamily() {
                                      
              self.requestsViewController?.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)

        }
        self.requestsViewController?.tabBarItem.title = ""


        self.createRequestViewController = UIViewController()
        
        if isIphoneXFamily(){
            
            self.createRequestViewController?.tabBarItem.image = UIImage(named: self.tabBarImage2)?.withRenderingMode(.alwaysOriginal)
            self.createRequestViewController?.tabBarItem.selectedImage = UIImage(named: self.tabBarImageSelected2)?.withRenderingMode(.alwaysOriginal)

        }else{
            
            self.createRequestViewController?.tabBarItem.image = UIImage(named: self.tabBarImage2B)?.withRenderingMode(.alwaysOriginal)
            self.createRequestViewController?.tabBarItem.selectedImage = UIImage(named: self.tabBarImageSelected2B)?.withRenderingMode(.alwaysOriginal)

        }

                                
        self.createRequestViewController?.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)

        self.createRequestViewController?.tabBarItem.title = nil
       
        
        self.profileViewController = ProfilViewController()
        self.profileViewController?.tabBarItem.image = UIImage(named: self.tabBarImage3)?.withRenderingMode(.alwaysOriginal)
        self.profileViewController?.tabBarItem.selectedImage = UIImage(named: self.tabBarImageSelected3)?.withRenderingMode(.alwaysOriginal)
        if isIphoneXFamily() {

            self.profileViewController?.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)

        }
        self.profileViewController?.tabBarItem.title = ""
        
        self.tabBar.unselectedItemTintColor = UIColor(hex:"A7A7A7")
        self.tabBar.tintColor = Brain.kColorMain


        self.navigationViewController1 = UINavigationController(rootViewController: self.requestsViewController!)
        self.navigationViewController1?.navigationBar.isTranslucent=false

        self.navigationViewController2 = UINavigationController(rootViewController: self.createRequestViewController!)
        self.navigationViewController2?.navigationBar.isTranslucent=false
        
        self.navigationProfileViewController = UINavigationController(rootViewController: self.profileViewController!)
        self.navigationProfileViewController?.navigationBar.isTranslucent=false

   
        ////workers
        self.exploreViewController = ExploreViewController()
        self.exploreViewController?.tabBarItem.image = UIImage(named: self.tabBarWorkerImage1)?.withRenderingMode(.alwaysOriginal)
        self.exploreViewController?.tabBarItem.selectedImage = UIImage(named: self.tabBarWorkerImageSelected1)?.withRenderingMode(.alwaysOriginal)
        
        if isIphoneXFamily() {
            
            self.exploreViewController?.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)

        }
        self.exploreViewController?.tabBarItem.title = ""

        self.navigationWorkerViewController1 = UINavigationController(rootViewController: self.exploreViewController!)
        self.navigationWorkerViewController1?.navigationBar.isTranslucent=false
        
        
        ///////
        
        self.jobsViewController = JobsViewController()
        self.jobsViewController?.tabBarItem.image = UIImage(named: self.tabBarWorkerImage2)?.withRenderingMode(.alwaysOriginal)
        self.jobsViewController?.tabBarItem.selectedImage = UIImage(named: self.tabBarWorkerImageSelected2)?.withRenderingMode(.alwaysOriginal)
        if isIphoneXFamily() {

        self.jobsViewController?.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)

        }
        self.jobsViewController?.tabBarItem.title = ""

        self.navigationWorkerViewController2 = UINavigationController(rootViewController: self.jobsViewController!)
        self.navigationWorkerViewController2?.navigationBar.isTranslucent=false
        
        
        ///////
         
         self.skillsViewController = SkillsViewController()
         self.skillsViewController?.tabBarItem.image = UIImage(named: self.tabBarWorkerImage3)?.withRenderingMode(.alwaysOriginal)
         self.skillsViewController?.tabBarItem.selectedImage = UIImage(named: self.tabBarWorkerImageSelected3)?.withRenderingMode(.alwaysOriginal)
        if isIphoneXFamily() {
                         
             self.skillsViewController?.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)

         }
         self.skillsViewController?.tabBarItem.title = ""

         self.navigationWorkerViewController3 = UINavigationController(rootViewController: self.skillsViewController!)
         self.navigationWorkerViewController3?.navigationBar.isTranslucent=false
        

      
        self.updateMode()
      
    }
    
    
    func updateMode(){
        
        
        
        if PFUser.current()?.object(forKey: Brain.kUserType) as! String == "customer" {
                  
          self.viewControllers = [navigationViewController1! , navigationViewController2!, navigationProfileViewController! ]

      }else{
          
          
          self.viewControllers = [navigationWorkerViewController1! , navigationWorkerViewController2!, navigationWorkerViewController3! , navigationProfileViewController! ]

      }
        
 
       for viewController in self.viewControllers!
       {
           _ = viewController.view
       }

        
    }
    
  override func viewWillAppear(_ animated: Bool) {
       
       super.viewWillAppear(animated)
       
       navigationController?.setNavigationBarHidden(true, animated: animated)
       self.navigationController?.navigationBar.prefersLargeTitles = true
       
       self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       self.navigationController?.navigationBar.layoutIfNeeded()
       
       
     
       
   }
   
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       
        
        let index = tabBarController.viewControllers?.index(of: viewController)

        if index == 1 && PFUser.current()?.object(forKey: Brain.kUserType) as! String == "customer"{
            
            
            let createRequest = SelectServiceViewController()
            let nav = UINavigationController(rootViewController: createRequest)
            nav.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

            self.present(nav, animated: true) {
                
            }
            
            
            return false
        }
        
        

       
        if self.previousController == viewController || self.previousController == nil {
            
            if self.selectedIndex == 0 {
                
//                self.feedViewController?.tableView.setContentOffset(.zero, animated: true)

                
            }else if selectedIndex == 1{
                
                
              
                        
               
            }else if selectedIndex == 2{
             
              
            }
        }
        self.previousController = viewController;
        return true
    }
}
