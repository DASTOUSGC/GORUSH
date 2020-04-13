//
//  ProfileViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-10-13.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse
import YPImagePicker
import Cosmos
import Intercom


class ProfilViewController: ParentLoadingViewController {
    
    
    var titleViewController = NSLocalizedString("Profil", comment:"")
    
    var settingsButton : UIButton!
    var customTitle : UILabel!
    
 
    
    
    var backgroundProfile: UIImageView!
    var profilePicture: PFImageView!
    var buttonUpdate : UIButton!
    var selectProfilePicture: UIButton!
    
    var firstName: UILabel!
    var lastName: UILabel!
    var email: UILabel!
    var phone: UILabel!
    
    var editInfos : UIButton!
    var payments : UIButton!
    
    var review : CosmosView!
  
    
    var lightMode = false
    
    deinit {
        
        print("dealloc Service")
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        
        print("GOOOO 11")

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
        
        
        settingsButton = UIButton(frame: CGRect(x: Brain.kL - 65, y: customTitle.y() + 3, width: 50, height: 44))
        settingsButton.setImage(UIImage(named: "settingsButton"), for: .normal)
        settingsButton.addTarget(self, action: #selector(touchSettings), for: .touchUpInside)
        view.addSubview(settingsButton)
        
        
        ///////
        
    
        
        backgroundProfile = PFImageView(frame: CGRect(x: ( Brain.kLargeurIphone - 150 )/2 , y: 120, width: 150 , height: 150))
        backgroundProfile.layer.cornerRadius = 150 / 2
        backgroundProfile.backgroundColor = .white
        view.addSubview(backgroundProfile)
        
        profilePicture = PFImageView(frame: CGRect(x: ( Brain.kLargeurIphone - 142 )/2 , y: backgroundProfile.y() + 4, width: 142 , height: 142))
        profilePicture.layer.cornerRadius = 142 / 2
        profilePicture.clipsToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.image = UIImage.init(named: "bigProfile")
        view.addSubview(profilePicture)
        
        selectProfilePicture = UIButton(frame: profilePicture.frame)
        selectProfilePicture.addTarget(self, action: #selector(changeProfilePic(_:)), for: .touchUpInside)
        view.addSubview(selectProfilePicture)
        
        buttonUpdate = UIButton(frame: CGRect(x: 0, y: 100, width: 138, height: 43))
        buttonUpdate.setBackgroundColor(color: UIColor.black.withAlphaComponent(0.68), forState: .normal)
        buttonUpdate.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        buttonUpdate.titleEdgeInsets.bottom = 5; // add bottom padding.
        profilePicture.addSubview(buttonUpdate)
        
        
        firstName = UILabel(frame: CGRect(x: 0, y: profilePicture.yBottom() + 20 , width: Brain.kLargeurIphone, height: 25))
        firstName.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        firstName.textColor = .black
        firstName.textAlignment = .center
        view.addSubview(firstName)
        
        
        
        email = UILabel(frame: CGRect(x: 0, y: firstName.yBottom() + 4 , width: Brain.kLargeurIphone, height: 20))
        email.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        email.textColor = .black
        email.textAlignment = .center
        view.addSubview(email)
        
        phone = UILabel(frame: CGRect(x: 0, y: email.yBottom() + 2 , width: Brain.kLargeurIphone, height: 20))
        phone.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        phone.textColor = .black
        phone.textAlignment = .center
        view.addSubview(phone)
        
        self.review = CosmosView(frame: CGRect(x: 0, y: phone.yBottom() + 10, width: Brain.kLargeurIphone, height: 50))
        self.review.settings.updateOnTouch = true
        self.review.settings.fillMode = .precise
        self.review.settings.starSize = 22
        // Set the distance between review
        self.review.settings.starMargin = 5
        // Set the color of a filled star
        self.review.settings.filledColor = Brain.kColorMain
        // Set the border color of an empty star
        self.review.settings.emptyBorderColor = Brain.kColorMain
        // Set the border color of a filled star
        self.review.settings.filledBorderColor = Brain.kColorMain
        // Set image for the filled star
        self.review.settings.filledImage = UIImage(named: "starFull")?.withRenderingMode(.alwaysTemplate)
        // Set image for the empty star
        self.review.settings.emptyImage = UIImage(named: "starEmpty")?.withRenderingMode(.alwaysTemplate)
        self.review.settings.totalStars = 5
        self.review.settings.updateOnTouch = false
        self.review.center.x = self.view.center.x
        self.view.addSubview(self.review)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapReview(_:)))
        self.review.addGestureRecognizer(tap)


        
        
        
        editInfos = UIButton(frame: CGRect(x: (Brain.kL-288)/2, y: review.yBottom() + 50, width: 288, height: 40))
        editInfos.setBackgroundColor(color: Brain.kColorMain, forState: .normal)
        editInfos.layer.cornerRadius = 20
        editInfos.clipsToBounds = true
        editInfos.applyGradient()
        editInfos.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        editInfos.setTitleColor(.white, for: .normal)
        editInfos.setTitle(NSLocalizedString("Edit Profile", comment: ""), for: .normal)
        editInfos.addTarget(self, action: #selector(editInfosAction(_:)), for: .touchUpInside)
        
        view.addSubview(editInfos)
        
        payments = UIButton(frame: CGRect(x: (Brain.kL-288)/2, y: editInfos.yBottom() + 7, width: 288, height: 40))
        payments.setBackgroundColor(color: UIColor(hex: "3A3838"), forState: .normal)
        payments.layer.cornerRadius = 20
        payments.clipsToBounds = true
        payments.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        payments.setTitleColor(.white, for: .normal)
        payments.setTitle(NSLocalizedString("Payment Methods", comment: ""), for: .normal)
        payments.addTarget(self, action: #selector(paymentsAction(_:)), for: .touchUpInside)
        view.addSubview(payments)
        
        
    }
    
   
    @objc func tapReview(_ sender: UITapGestureRecognizer? = nil) {
          
        
        if PFUser.current()?.object(forKey: Brain.kUserType) as! String == "customer" {
            
            let reviews = ReviewsViewController(user: PFUser.current()!, fromWorker: true)
            self.present(reviews, animated: true) {
                   }
        }else{
            
            let reviews = ReviewsViewController(user: PFUser.current()!, fromWorker: false)
            self.present(reviews, animated: true) {
                   }
        }
        
    }
    
    
    @objc func editInfosAction(_ sender: UIButton){
        
        let edit = EditProfileViewController()
        let nav = UINavigationController(rootViewController: edit)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true) {

        }
    }
    
    
    
    func updateProfil(){
        
        if ((PFUser.current()?.object(forKey: Brain.kUserProfilePicture)) != nil ) {
            
            self.profilePicture.file = PFUser.current()?.object(forKey: Brain.kUserProfilePicture) as? PFFileObject
            self.profilePicture.loadInBackground()
            
            buttonUpdate.setTitle(NSLocalizedString("Change", comment: ""), for: .normal)
            
            
        }else{
            
            self.profilePicture.image = UIImage.init(named: "bigProfile")
            buttonUpdate.setTitle(NSLocalizedString("Add", comment: ""), for: .normal)
            
        }
        
        
        if PFUser.current() != nil {
            
            if PFUser.current()?.object(forKey: Brain.kUserEmail) != nil {
                
                email.text = PFUser.current()?.object(forKey: Brain.kUserEmail) as? String
            }
            
            if PFUser.current()?.object(forKey: Brain.kUserPhone) != nil {
                
                phone.text = PFUser.current()?.object(forKey: Brain.kUserPhone) as? String
            }
            
            if PFUser.current()?.object(forKey: Brain.kUserFirstName) != nil && PFUser.current()?.object(forKey: Brain.kUserLastName) != nil {
                
                firstName.text = "\(PFUser.current()?.object(forKey: Brain.kUserFirstName) as! String) \(PFUser.current()?.object(forKey: Brain.kUserLastName) as! String)"
                
            }else if PFUser.current()?.object(forKey: Brain.kUserFirstName) != nil {
                
                firstName.text = "\(PFUser.current()?.object(forKey: Brain.kUserFirstName) as! String)"
                
            }
        }
        
        
        
        if PFUser.current()?.object(forKey: Brain.kUserType) as! String == "customer" {
            
            self.review.rating = Double(truncating: PFUser.current()?.object(forKey: Brain.kUserRateCustomer) as! NSNumber)
            payments.setTitle(NSLocalizedString("Payment Methods", comment: ""), for: .normal)

            
        }else{
            
            self.review.rating = Double(truncating: PFUser.current()?.object(forKey: Brain.kUserRateWorker) as! NSNumber)
            payments.setTitle(NSLocalizedString("Bank account", comment: ""), for: .normal)

        }
        

        
        
        
    }
    
    
    
    @objc func touchSettings(_ sender: UIButton){
        
        let settings = SettingsViewController()
        settings.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settings, animated: true)
        
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    
        
        updateProfil()

        PFUser.current()?.fetchInBackground(block: { (user, error) in
            
            self.updateProfil()

        })
        
        
        
        if PFUser.current()?.object(forKey: Brain.kUserType) as! String == "customer" {
            
            Intercom.logEvent(withName: "customer_openProfileView")

        }else{
            
            Intercom.logEvent(withName: "worker_openProfileView")

        }
        

    }
    
    
    @objc func paymentsAction(_ sender: UIButton){
        
        
        
        if PFUser.current()?.object(forKey: Brain.kUserType) as! String == "customer" {
           
            let payment = PaymentsViewController()
            payment.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(payment, animated: true)
        
        }else{
            
            let bank = BankAccountViewController()
            bank.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(bank, animated: true)

            
        }
          
                    
    }
      @objc func changeProfilePic(_ sender: UIButton){
          
          //        self.updateProfilePictureActionSheet()
          
          self.updateProfilePictureActionSheet()
          
      }
      
      
      func updateProfilePictureActionSheet(){
          
          
          if ((PFUser.current()?.object(forKey: Brain.kUserProfilePicture)) != nil ) {

              
              let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
              
              // create an action
              let firstAction: UIAlertAction = UIAlertAction(title:NSLocalizedString("Delete current profile picture", comment: ""), style: .destructive) { action -> Void in
                  
                  PFUser.current()?.remove(forKey: Brain.kUserProfilePicture)
                  PFUser.current()?.saveInBackground()
                  
                  self.updateProfil()
              }
              
              let secondAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Update profile picture", comment: ""), style: .default) { action -> Void in
                  
                  print("Second Action pressed")
                  
                  
                  self.showCameraPicker()
                  
              }
              
              let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in }
              
              // add actions
              actionSheetController.addAction(firstAction)
              actionSheetController.addAction(secondAction)
              actionSheetController.addAction(cancelAction)
              
              // present an actionSheet...
              present(actionSheetController, animated: true, completion: nil)
              
          }else{
              
              
              self.showCameraPicker()
              
              
          }
          
          
          
          
      }
      
      
      func showCameraPicker() {
          
            var config = YPImagePickerConfiguration()
           config.usesFrontCamera = false
           config.showsPhotoFilters = false
           config.shouldSaveNewPicturesToAlbum = false
           config.screens = [.library]
           config.showsCrop = .none
           config.targetImageSize = YPImageSize.cappedTo(size: 512)
           config.hidesStatusBar = false
           config.hidesBottomBar = true

           // Build a picker with your configuration
           let picker = YPImagePicker(configuration: config)
           picker.modalPresentationStyle = .formSheet
           picker.didFinishPicking { [unowned picker] items, cancelled in
               
               if cancelled {
                   print("Picker was canceled")
                   picker.dismiss(animated: true, completion: nil)
                   
                   return
               }
               
               if let firstItem = items.first {
                   switch firstItem {
                   case .photo(let photo):
                       
                       
                      let imageData = photo.image.jpegData(compressionQuality: 0.3)
                        let imageFile = PFFileObject(name:"profile.jpg", data:imageData!)
                        
                       
                        PFUser.current()?.setObject(imageFile!, forKey: Brain.kUserProfilePicture)
                        PFUser.current()?.saveInBackground()
                        
                        self.profilePicture.image = photo.image
                        
                        self.buttonUpdate.setTitle(NSLocalizedString("Change", comment: ""), for: .normal)
                        
                        self.updateProfil()
                        
                        
                        
                        picker.dismiss(animated: true, completion: nil)
                       
                   case .video( _): break
                       
                   }
               }
           }
           
           present(picker, animated: true, completion: nil)
               
          
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
    
    

    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
