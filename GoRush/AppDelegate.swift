//
//  AppDelegate.swift
//  GoRush
//
//  Created by Julien Levallois on 18-01-23.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications
import Intercom
import CoreLocation
import NVActivityIndicatorView
import AVKit
import GoogleMaps
import Stripe



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?
   
    var tabBarController : TabBarController?
   
    var homeViewController : SignupViewController?

    var locationManager: CLLocationManager!

    var launchScreenView : UIView!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
       
        
        //Gestion audio
        let audioSession = AVAudioSession.sharedInstance()
        _ = try? audioSession.setCategory(.ambient, options: .mixWithOthers)
        _ = try? audioSession.setActive(true)

        
        
        
    
        //Init des settings de design
        updateAppSettings()
        
        //Init Parse - Backend
        initParse()
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        
        
        
        //Config
        if PFConfig.current().object(forKey: Brain.kConfigStripe) != nil {
            
            PFConfig.getInBackground()

            
            Stripe.setDefaultPublishableKey(PFConfig.current().object(forKey: Brain.kConfigStripe) as! String)
            self.setupStripeAccount()

            GMSServices.provideAPIKey(PFConfig.current().object(forKey: Brain.kConfigGoogleMap) as! String)

            Intercom.setApiKey(PFConfig.current().object(forKey: Brain.kConfigIntecomApiKey) as! String,
                               forAppId: PFConfig.current().object(forKey: Brain.kConfigIntercomAppId) as! String)

            
        }else{
            
            PFConfig.getInBackground { (config, error) in
                
                Stripe.setDefaultPublishableKey(PFConfig.current().object(forKey: Brain.kConfigStripe) as! String)
                self.setupStripeAccount()

                GMSServices.provideAPIKey(PFConfig.current().object(forKey: Brain.kConfigGoogleMap) as! String)


                Intercom.setApiKey(PFConfig.current().object(forKey: Brain.kConfigIntecomApiKey) as! String,
                                   forAppId: PFConfig.current().object(forKey: Brain.kConfigIntercomAppId) as! String)

            }
        }

        
    
        
        
        //Init location
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self

     
        self.preloadServices()
        
        //Screen de chargement
        launchScreenView = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()!.view!
        launchScreenView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        launchScreenView.frame = CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone)
        launchScreenView.backgroundColor = UIColor(hex: "E5511A")
        let loading = NVActivityIndicatorView(frame: CGRect(x: Brain.kLargeurIphone/2-25 , y: Brain.kHauteurIphone/2-50 - 64, width: 50, height: 50), type: .ballPulse , color: .white, padding: 0.0)
        loading.startAnimating()
        
        launchScreenView.addSubview(loading)
        
        
        if PFUser.current() != nil && PFUser.current()?.object(forKey: Brain.kUserPhone) != nil {

            Intercom.registerUser(withUserId: (PFUser.current()?.objectId)!)

            homeViewController = SignupViewController()
            
            
            if homeViewController?.player != nil {
                
                homeViewController?.player.isMuted = true
                homeViewController?.player.pause()
                          
            }
          
            PFUser.current()?.fetchInBackground()
            
            
        
            let homeNav = UINavigationController(rootViewController: homeViewController!)

            window = UIWindow(frame: UIScreen.main.bounds)
            window!.rootViewController = homeNav
            window?.rootViewController?.view.addSubview(launchScreenView)
            window!.makeKeyAndVisible()

            

            self.tabBarController = TabBarController()

            let navTabbar = UINavigationController(rootViewController: tabBarController!)
            navTabbar.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

            self.homeViewController?.present(navTabbar, animated: false, completion: {
                
                
                
                self.launchScreenView.removeFromSuperview()
                
                if self.homeViewController?.player != nil {
                   
                   self.homeViewController?.player.isMuted = true
                   self.homeViewController?.player.pause()
                             
                }
                
            })

        }else{
            
          
            
            PFUser.logOut()
            Intercom.logout()
            
            homeViewController = SignupViewController()

            let homeNav = UINavigationController(rootViewController: homeViewController!)

            window = UIWindow(frame: UIScreen.main.bounds)
            window!.rootViewController = homeNav
            window!.makeKeyAndVisible()

        }
        
        
       
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        
        
        self.getNotificationSettings()
        


    
        return true
    }

    
    func setupStripeAccount(){
        
        StripeCustomer.shared().refreshStripeAccount { (stripeAccount) in
            
            
        }
    }
    
    
   
    func updateAppSettings(){
        
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowWhite")
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrowWhite")
        UINavigationBar.appearance().tintColor = UIColor(hex: "EE5210")
        UINavigationBar.appearance().barTintColor = UIColor(hex: "EE5210")

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: Brain.kNavbarFont, NSAttributedString.Key.foregroundColor:UIColor(hex: "FFFFFF")]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: Brain.kItemNavBarFont, NSAttributedString.Key.foregroundColor:UIColor(hex: "FFFFFF")], for:.normal)

        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = Brain.kColorMain

        UINavigationBar.appearance().isTranslucent = false


        
        UIBarButtonItem.appearance().tintColor = Brain.kBarbuttonItemColor


    }
    
   
    
    func preloadServices() {
        
        let queryservices = PFQuery(className: Brain.kServicesClassName)
        queryservices.whereKey(Brain.kServiceAvailable, equalTo: true)
        queryservices.order(byAscending: Brain.kServiceOrder)
        queryservices.limit = 1000
        queryservices.cachePolicy = .cacheThenNetwork
        queryservices.findObjectsInBackground { (servicesFetched, error) in
            
            if servicesFetched != nil {
                

                for i in 0..<servicesFetched!.count {
                    
                    let service = servicesFetched![i]
                    
                    if let cover = service.object(forKey: Brain.kServiceCover) as? PFFileObject {
                        
                        cover.getDataInBackground()
                        
                    }
                    
                    if let icon = service.object(forKey: Brain.kServiceIcon) as? PFFileObject {
                        
                        icon.getDataInBackground()

                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    
   
    func addLoadingView(){
        
        self.launchScreenView.alpha = 1

        let window = UIApplication.shared.keyWindow!
        window.addSubview(self.launchScreenView)

    }
    
    func removeLoadingView(){
        
        UIView.animate(withDuration: 1.0, delay:0.0, options:.curveEaseInOut,
                       animations: {
                        
            self.launchScreenView.alpha = 0
                    
        },
                       completion: { _ in

                self.launchScreenView.removeFromSuperview()

        }
        )
        
        
    }
    
    func initParse(){
        
     
        Parse.initialize(with: ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = Brain.kParseAppId
            ParseMutableClientConfiguration.clientKey = Brain.kParseClientKey
            ParseMutableClientConfiguration.server = Brain.kParseServer
        }))

        
    }
    
    func updateIntercomData(){
        
        Intercom.registerUser(withUserId: (PFUser.current()?.objectId)!)

             
         let userAttributes = ICMUserAttributes()
         
        if PFUser.current()?[Brain.kUserFirstName] != nil && PFUser.current()?.object(forKey: Brain.kUserLastName) != nil{
             
             userAttributes.name = String(format: "%@ %@", (PFUser.current()?[Brain.kUserFirstName] as! String),(PFUser.current()?[Brain.kUserLastName] as! String))

        }else if  PFUser.current()?[Brain.kUserFirstName] != nil{
            
            userAttributes.name = String(format: "%@", (PFUser.current()?[Brain.kUserFirstName] as! String))

        }
        
        
         userAttributes.email = (PFUser.current()?[Brain.kUserEmail] as! String)

         let customDic = NSMutableDictionary()
         
         
         if PFUser.current()?[Brain.kUserFacebookId] != nil{
             
             customDic.setValue(PFUser.current()?[Brain.kUserFacebookId] , forKey: Brain.kUserFacebookId)
         }
        
        if PFUser.current()?[Brain.kUserPhone] != nil{
            
            userAttributes.phone = PFUser.current()?[Brain.kUserPhone] as? String
        }
        
     
        if PFUser.current()?[Brain.kUserType] != nil{
            
            customDic.setValue(PFUser.current()?[Brain.kUserPhone] , forKey: Brain.kUserType)
        }
        
        if PFUser.current()?[Brain.kUserType] != nil{
                   
            customDic.setValue(PFUser.current()?[Brain.kUserPhone] , forKey: Brain.kUserType)
        }
        
        
             
         userAttributes.customAttributes = customDic as? [String : Any]
         
         Intercom.updateUser(userAttributes)

      }
      
    func updateInstallation() {
             
             
             if(PFUser.current() != nil){
                 
                 let installation = PFInstallation.current()
                 let user = PFUser.current()!

                 if ((user.object(forKey: Brain.kUserFirstName)) != nil){
                     
                     installation?.setObject(user.object(forKey: Brain.kUserFirstName)!, forKey: Brain.kUserFirstName)
                 }
                
                 
                 installation?.setObject(PFUser.current()!, forKey: "user")
                 installation?.setObject(Locale.preferredLanguages[0], forKey: "language")
                 installation?.addUniqueObject("Global", forKey: "channels")
                 installation?.setObject(PFUser.current()?.object(forKey: Brain.kUserType)!, forKey: Brain.kUserType)
                 installation?.saveInBackground()

             }

    }
    
    
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            PFInstallation.current()?.setObject(true, forKey: Brain.kInstallationNotifications)
            PFInstallation.current()?.saveInBackground()
            
        
            print("Go on register les pushss..")
            
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })
            
        }
    }
    
    func registerForPushNotifications() {
        
        // On affiche la notif
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func registerForLocation() {
        
        
        
        let authstate = CLLocationManager.authorizationStatus()

        if(authstate == CLAuthorizationStatus.notDetermined){
            
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func showLocationRequest() -> Bool{
        
        let authstate = CLLocationManager.authorizationStatus()
        
        if(authstate == CLAuthorizationStatus.notDetermined){
            
            return true
        }else{
            
            return false

        }

    }
    
  
    func queryParameters(from url: URL) -> [String: String] {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryParams = [String: String]()
        for queryItem: URLQueryItem in (urlComponents?.queryItems)! {
            if queryItem.value == nil {
                continue
            }
            queryParams[queryItem.name] = queryItem.value
        }
        return queryParams
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       
        
        let isHandled = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[.sourceApplication] as! String?, annotation: options[.annotation])
        return isHandled
    }
    
   
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      
        
        
        
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground()
        
        Intercom.setDeviceToken(deviceToken)
       
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
       
        if (Intercom.isIntercomPushNotification(userInfo)) {
              
            Intercom.handlePushNotification(userInfo)
        
        }
        
        let installation = PFInstallation.current()
        installation?.badge = 0
        installation?.saveInBackground()
        PFPush.handle(userInfo)
    }
    
    
    func loginDone(){
        
        tabBarController = TabBarController()
        
        self.updateIntercomData()

        self.setupStripeAccount()

        

        let navTabbar = UINavigationController(rootViewController: tabBarController!)
        navTabbar.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        
        homeViewController?.present(navTabbar, animated: true, completion: {
            
        })

    }

    func logout(animated: Bool){
        
        
        let installation = PFInstallation.current()
        installation?.remove(forKey:"user")
        installation?.saveInBackground()
        
        
        self.addLoadingView()
        self.homeViewController?.navigationController?.popToRootViewController(animated: false)

        tabBarController?.dismiss(animated: true, completion: {
            
            
            PFUser.logOut()
            Intercom.logout()
            self.removeLoadingView()
            
        })
      
      
        
    }

    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0;
        
        let installation = PFInstallation.current()
        installation?.badge = 0
        installation?.saveInBackground()

        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEvents.activateApp()
        
        
        PFUser.current()?.fetchInBackground()
        PFConfig.getInBackground()
   
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print("Handle push from foreground")
        
        let installation = PFInstallation.current()
        installation?.badge = 0
        installation?.saveInBackground()
        
       
        completionHandler([.alert, .badge, .sound])
        
    }
    
    
    func receivePush(content : UNNotificationContent){
        
        if PFUser.current() == nil {

            return
        }
        if content.userInfo["reservationId"] != nil{
            
            
            if PFUser.current()?.object(forKey: Brain.kUserType) as! String == "customer" {
                
                self.tabBarController?.selectedIndex = 0

            }else{
                
                self.tabBarController?.selectedIndex = 1

                
            }


            
            self.addLoadingView()

            
            self.resetAllNavigations()
            
            
            let request = PFQuery(className: Brain.kRequestClassName)
            request.includeKey(Brain.kRequestService)
            request.includeKey(Brain.kRequestCustomer)
            request.includeKey(Brain.kRequestWorker)

            request.getObjectInBackground(withId: content.userInfo["requestId"] as! String) { (request, error) in
                
                
                if request != nil{
                    

                if PFUser.current()?.object(forKey: Brain.kUserType) as! String == "customer" {


                    let request = RequestViewController(request: request!)
                    request.hidesBottomBarWhenPushed = true
                    self.tabBarController?.navigationController!.pushViewController(request, animated: true)

                    
                }else{

                    let request = RequestWorkerViewController(request: request!)
                  request.hidesBottomBarWhenPushed = true
                      
                  self.tabBarController?.navigationController!.pushViewController(request, animated: true)

                }


                    self.removeLoadingView()

                }else{
                    
                    self.removeLoadingView()
                }
                
                
            }
            
           
        }
        
        
        
    }
    
    func resetAllNavigations(){
        
        self.tabBarController?.exploreViewController?.navigationController?.popToRootViewController(animated: false)
        self.tabBarController?.jobsViewController?.navigationController?.popToRootViewController(animated: false)
        self.tabBarController?.requestsViewController?.navigationController?.popToRootViewController(animated: false)
        self.tabBarController?.profileViewController?.navigationController?.popToRootViewController(animated: false)
    }
    
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        print("\(response.notification.request.content.userInfo)")
        
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        let installation = PFInstallation.current()
        installation?.badge = 0
        installation?.saveInBackground()
        
        
        if (Intercom.isIntercomPushNotification(response.notification.request.content.userInfo)) {
             
            Intercom.handlePushNotification(response.notification.request.content.userInfo)
           
        }else{
            
            self.receivePush(content: response.notification.request.content)

        }
        
        

      
        completionHandler()
        
        
    }
    
    
    
    
}

