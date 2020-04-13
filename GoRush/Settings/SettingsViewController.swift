//
//  SettingsViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 19-09-08.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse
import MessageUI
import Intercom


class SettingsViewController: ParentLoadingViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    
    var titleViewController = NSLocalizedString("Settings", comment:"")

    var objects: NSMutableArray = NSMutableArray(array: [])

    var tableView : UITableView!
    
    var tableviewIdentifier = "MyCell"
    var tableViewHeightCell:CGFloat = 60

    
    
    var backButtonNav : UIButton!
    
    var textA: UILabel!
    var textB: UILabel!
    
    var switchText = NSLocalizedString("Switch To Worker", comment: "")
    
    deinit {
        
        print("dealloc Service")
        
    }
    
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        tabBarItem.title = "";
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        if isIphoneXFamily(){
            
            self.backButtonNav = UIButton(frame:CGRect(x:10,y:yTop() + 13,width:40,height:40))
            
        }else{
            
            self.backButtonNav = UIButton(frame:CGRect(x:10,y:yTop() + 25,width:40,height:40))
            
        }
        self.backButtonNav.setBackgroundImage(UIImage.init(named:"backArrowWhite")?.withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
        self.backButtonNav.tintColor = UIColor(hex: "4D4D4D")
        self.backButtonNav.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButtonNav)
        
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        

        textA = UILabel(frame: CGRect(x: 0, y: backButtonNav.y() + 11, width: Brain.kLargeurIphone, height: 30))
        textA.textAlignment = .center
        textA.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        textA.textColor = UIColor(hex: "4D4D4D")
        textA.text = NSLocalizedString("Settings", comment:"")
        view.addSubview(textA)
      
        
        
        
        //TableView
        tableView = UITableView(frame: CGRect(x: 0, y: textA.yBottom() + 10, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone - textA.yBottom() - 10))
        tableView.register(settingsTableViewCell.self, forCellReuseIdentifier: tableviewIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: 200))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: 0))
        view.addSubview(tableView)
        
        
    
        
        
      
        
      
        
    }
    
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func appbecomeActive() {
        
        
        print("become active App")
        
        
        
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        
        
        if PFUser.current()?.object(forKey: Brain.kUserType) as! String == "customer" {
            
            switchText = NSLocalizedString("Switch To Worker", comment: "")

            
        }else{
            
            switchText = NSLocalizedString("Switch To Customer", comment: "")

        }
        
        
        objects = [
                  [NSLocalizedString("Notifications", comment:""),"iconNotifs"],
                  [switchText,"iconSwitch"],
                  //            [NSLocalizedString("Invite friends", comment:""),"iconInviteFriends"],
                  [NSLocalizedString("Need help?", comment:""),"iconContact"],
                  [NSLocalizedString("Rate us!", comment:""),"iconRateUs"],
                  [NSLocalizedString("Terms & Privacy Policy", comment:""),"iconTerms"],
                  [NSLocalizedString("Log out", comment:""),"iconLogout"],
              ]
              
        
        self.tableView.reloadData()
        
        Intercom.logEvent(withName: "customer_openSettings")

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
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objects.count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableviewIdentifier, for: indexPath as IndexPath) as! settingsTableViewCell
        
        let content = objects[indexPath.row] as! NSArray
        
        
        cell.name.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        
      
        if (content[0] as! String == NSLocalizedString("Notifications", comment:"")) {
            
            
            cell.icon.isHidden = true
            cell.switchNotif.isHidden = false
            cell.switchNotif.addTarget(self, action: #selector(switchNotif(sender:)), for: .valueChanged)


        }else if (content[0] as! String == self.switchText) {
            
        
            cell.name.font = UIFont.systemFont(ofSize: 16, weight: .bold)

            

        }else{
            
            cell.icon.isHidden = false

            
        }
        
        
        cell.icon.image = UIImage(named: content[1] as! String)?.withRenderingMode(.alwaysTemplate)
        cell.icon.tintColor = UIColor(hex: "4D4D4D")
        
        cell.name.text = "\(content[0])"
        
        if indexPath.row == (objects.count - 1) {
            
            cell.line.isHidden = true
            
        }else{
            
            cell.line.isHidden = false
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let content = objects[indexPath.row] as! NSArray
        
        
        
        if (content[0] as! String == NSLocalizedString("Notifications", comment:"")) {
            
            
            
            
        }else if (content[0] as! String == switchText) {
            
        
            if PFUser.current()?.object(forKey: Brain.kUserType) as! String == "customer" {
                
                PFUser.current()?.setObject("worker", forKey: Brain.kUserType)

            }else{
                
                
                PFUser.current()?.setObject("customer", forKey: Brain.kUserType)
            }
            
            
            PFUser.current()?.saveInBackground()
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.updateIntercomData()

            appDelegate.addLoadingView()
            
            
        
            if PFUser.current()?.object(forKey: Brain.kUserType) as! String == "worker" {
                
                
                let stripeWorker =  PFUser.current()?.object(forKey: Brain.kUserStripeCustomer) as! PFObject
                                          
                stripeWorker.fetchInBackground { (stripeWorker, error) in
                    
                    if stripeWorker?.object(forKey: Brain.kStripeWorkerIdStripe) != nil {
                        
                                    appDelegate.tabBarController?.updateMode()
                                   appDelegate.tabBarController?.selectedIndex = 0
                                   
                                   self.navigationController?.popViewController(animated: true)
                                   
                                   
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Change `2.0` to the desired number of seconds.
                                      // Code you want to be delayed
                                       
                                       appDelegate.removeLoadingView()
                                       
                                   }
                        
                    }else{
                        
                        
                        appDelegate.removeLoadingView()
                        
                        // Pas de compte worker!
                        PFUser.current()?.setObject("customer", forKey: Brain.kUserType)
                        PFUser.current()?.saveInBackground()
                        
                        let typeVC = SignupAddressViewController(fromCustomerMode: true)
                        self.navigationController!.pushViewController(typeVC, animated: false)
                        
                    }
                }
                
            }else{
                
                appDelegate.tabBarController?.updateMode()
                           appDelegate.tabBarController?.selectedIndex = 0
                           
                           self.navigationController?.popViewController(animated: true)
                           
                           
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Change `2.0` to the desired number of seconds.
                              // Code you want to be delayed
                               
                               appDelegate.removeLoadingView()
                               
                           }
            }


            
           
            
        
        }else if (content[0] as! String == NSLocalizedString("Need help?", comment:"")) {

//
//            let composeVC = MFMailComposeViewController()
//            composeVC.mailComposeDelegate = self
//            // Configure the fields of the interface.
////            composeVC.setToRecipients([PFConfig.current().object(forKey: Brain.kConfigEmail) as! String ])
//            composeVC.setSubject("JMFC Contact : ")
//            // Present the view controller modally.
//            self.present(composeVC, animated: true, completion: nil)
//
            
            Intercom.presentMessenger()
            
        }else if (content[0] as! String == NSLocalizedString("Rate us!", comment:"")) {
            
            if #available( iOS 10.3,*){
                
                DispatchQueue.main.async {
                    SKStoreReviewController.requestReview()
                }
                
            }else{
                
                if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/id\(PFConfig.current().object(forKey: Brain.kConfigIdApp) ?? "")?action=write-review&mt=8"), UIApplication.shared.canOpenURL(reviewURL) {
                    
                    UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
                    
                }
                
            }
            
            
            
        }else if (content[0] as! String == NSLocalizedString("Invite friends", comment:"")) {
            
            
            
            if PFConfig.current().object(forKey: Brain.kConfigShareText) != nil {
                
                if PFConfig.current().object(forKey: Brain.kConfigAppStoreUrl) != nil {
                    
                    
                    let activity = UIActivityViewController(activityItems: [PFConfig.current().object(forKey: Brain.kConfigAppStoreUrl) as! String,
                                                                            PFConfig.current().object(forKey: Brain.kConfigShareText) as! String],
                                                            applicationActivities: nil)
                    
                    self.present(activity, animated: true, completion: nil)
                    
                }else{
                    
                    let activity = UIActivityViewController(activityItems: [PFConfig.current().object(forKey: Brain.kConfigShareText) as! String],
                                                            applicationActivities: nil)
                    
                    self.present(activity, animated: true, completion: nil)
                    
                }
                
                
            }
            
            
            
        }else if (content[0] as! String == NSLocalizedString("Terms & Privacy Policy", comment:"")) {
            
            if PFConfig.current().object(forKey: Brain.kConfigTerms) as? String != nil {
                
                
                let webview = WebViewController(link: PFConfig.current().object(forKey: Brain.kConfigTerms) as! String)

                self.present(webview, animated: true, completion: {
                    
                })
                
            }
            
            
            
        }else if (content[0] as! String == NSLocalizedString("Log out", comment:"")) {
            
            
            
            let alert = UIAlertController(title: NSLocalizedString("Log out", comment: ""), message: NSLocalizedString("Are you sure you want to log out?", comment: ""), preferredStyle: .alert)
            
           
            let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { action in
                
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.logout(animated: true)

        

                
            })
            alert.addAction(yesAction)
            
            
            
            let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)
            
            alert.addAction(noAction)
            
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
                
            }
            
            
        }else{
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableViewHeightCell
    }
    
    
    
    
    
    @objc func switchNotif(sender:UISwitch!)
    {
        if (sender.isOn == true){
            
            
            if((PFInstallation.current()?.object(forKey: Brain.kInstallationNotifications)) != nil){
                
                if(PFInstallation.current()?.object(forKey: Brain.kInstallationNotifications) as! Bool != true){
                    
                    PFInstallation.current()?.setObject(true, forKey: Brain.kInstallationNotifications)
                    PFInstallation.current()?.saveInBackground()
                    
                }
                
            }else{
                
                PFInstallation.current()?.setObject(true, forKey: Brain.kInstallationNotifications)
                PFInstallation.current()?.saveInBackground()
            }
            
        }
        else{
            
            
            if((PFInstallation.current()?.object(forKey: Brain.kInstallationNotifications)) != nil){
                
                if(PFInstallation.current()?.object(forKey: Brain.kInstallationNotifications) as! Bool == true){
                    
                    PFInstallation.current()?.setObject(false, forKey: Brain.kInstallationNotifications)
                    PFInstallation.current()?.saveInBackground()
                    
                }
            }else{
                
                PFInstallation.current()?.setObject(false, forKey: Brain.kInstallationNotifications)
                PFInstallation.current()?.saveInBackground()
            }
            
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
