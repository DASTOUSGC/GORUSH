//
//  SignupTypeWorkerViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-10-13.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import YPImagePicker
import Intercom


class SignupTypeWorkerViewController: UIViewController , UIGestureRecognizerDelegate, UITextFieldDelegate{
    
    
    
    var textA: UILabel!
    var textB: UILabel!
    
    var textField: UITextField!
    
    var viewCustomer : UIButton!
    var customer : UILabel!
    var customerIcon : UIImageView!
    
    
    var viewWorker : UIButton!
    var worker : UILabel!
    var workerIcon : UIImageView!
    
    var backButtonNav:UIButton!
    var nextButton:UIButton!
    
    var backgroundProfile: UIImageView!
    var profilePicture: PFImageView!
    var selectProfilePicture: UIButton!
    
    var profileFile : PFFileObject?

    var name : UILabel!

    var selectedWorker = false
    
    
    var user : PFUser!

    convenience init(user:PFUser){

          self.init()
          self.user = user
          
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .white
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        
        self.backButtonNav = UIButton(frame:CGRect(x:10,y: yTop() + 35,width:40,height:40))
        self.backButtonNav.setBackgroundImage(UIImage.init(named:"backButtonWithoutNav"), for: UIControl.State.normal)
        self.backButtonNav.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButtonNav)
        
        
        
        textA = UILabel(frame: CGRect(x: 0, y: yTop() + 80, width: Brain.kLargeurIphone, height: 30))
        textA.textAlignment = .center
        textA.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        textA.textColor = .black
        textA.text = NSLocalizedString("User type", comment: "")
        view.addSubview(textA)
        
        
        textB = UILabel(frame: CGRect(x: 0, y: textA.frame.origin.y + 32, width: Brain.kLargeurIphone, height: 20))
        textB.textAlignment = .center
        textB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textB.text = NSLocalizedString("Choose the type of user you want", comment: "")
        textB.textColor = UIColor(hex:"ADADAD")
        view.addSubview(textB)
        
        
        
        if isIphoneXFamily() {
            
            backgroundProfile = PFImageView(frame: CGRect(x: ( Brain.kLargeurIphone - 150 )/2 , y: 160, width: 150 , height: 150))

            
        }else{
            
            backgroundProfile = PFImageView(frame: CGRect(x: ( Brain.kLargeurIphone - 150 )/2 , y: 220, width: 150 , height: 150))

        }
        
        
        backgroundProfile.layer.cornerRadius = 150 / 2
        backgroundProfile.backgroundColor = .white
        view.addSubview(backgroundProfile)
        
        if isIphoneXFamily() {
            
            profilePicture = PFImageView(frame: CGRect(x: ( Brain.kLargeurIphone - 142 )/2 , y: 220 + 4, width: 142 , height: 142))

            
        }else{
            
            profilePicture = PFImageView(frame: CGRect(x: ( Brain.kLargeurIphone - 142 )/2 , y: 160 + 4, width: 142 , height: 142))

        }
        
        profilePicture.layer.cornerRadius = 142 / 2
        profilePicture.clipsToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.image = UIImage.init(named: "bigProfile")
        view.addSubview(profilePicture)
        
     
        if PFUser.current() != nil {
            
            if PFUser.current()?.object(forKey: Brain.kUserProfilePicture) != nil {
                
                
                profilePicture.file = PFUser.current()?.object(forKey: Brain.kUserProfilePicture) as? PFFileObject
                profilePicture.loadInBackground()
                profileFile = PFUser.current()?.object(forKey: Brain.kUserProfilePicture) as? PFFileObject
            }
        }
        
        
        selectProfilePicture = UIButton(frame: profilePicture.frame)
        selectProfilePicture.addTarget(self, action: #selector(changeProfilePic(_:)), for: .touchUpInside)
        view.addSubview(selectProfilePicture)
        
        
        name = UILabel(frame: CGRect(x: 0, y: profilePicture.yBottom() + 20, width: Brain.kLargeurIphone, height: 30))
        name.textAlignment = .center
        name.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        name.textColor = .black
        view.addSubview(name)
        
        if PFUser.current() != nil {
            
            name.text = String(format: "%@ %@", PFUser.current()!.object(forKey: Brain.kUserFirstName) as! String, PFUser.current()!.object(forKey: Brain.kUserLastName) as! String)
            
        }else{
        
            name.text = String(format: "%@ %@", self.user.object(forKey: Brain.kUserFirstName) as! String, self.user.object(forKey: Brain.kUserLastName) as! String)
        }
        
        
        nextButton = UIButton(frame: CGRect(x:20, y: yTopBottomButtonCTA(), width:Brain.kLargeurIphone-40, height: 60))
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.applyGradient()
        view.addSubview(nextButton)
        
     
        viewCustomer = UIButton(frame: CGRect(x:20, y: nextButton.y() - 75, width:Brain.kLargeurIphone-40, height: 60))
        viewCustomer.layer.cornerRadius = 30;
        viewCustomer.clipsToBounds = true
        viewCustomer.addTarget(self, action: #selector(touchCustomer(_:)), for: .touchUpInside)
        viewCustomer.setBackgroundColor(color: UIColor(hex: "F8F8F8"), forState: .normal)
        viewCustomer.setBackgroundColor(color: UIColor(hex: "F8F8F8"), forState: .highlighted)
        view.addSubview(viewCustomer)
        
        
        customer = UILabel(frame: CGRect(x: 20, y: 0, width: viewCustomer.w() - 53, height: 60))
        customer.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        customer.textColor = UIColor(hex: "B7B7B7")
        viewCustomer.addSubview(customer)
       
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(hex:"B7B7B7")]
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .bold), NSAttributedString.Key.foregroundColor : Brain.kColorMain]
        let attributedString1 = NSMutableAttributedString(string:"I wish to register as a ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"Customer", attributes:attrs2)
        attributedString1.append(attributedString2)
        customer.attributedText = attributedString1
        
        
        customerIcon = UIImageView(frame: CGRect(x: viewCustomer.w() - 34, y: 19, width: 22, height: 22))
        customerIcon.image = UIImage(named: "checkIcon")?.withRenderingMode(.alwaysTemplate)
        customerIcon.tintColor = UIColor(hex: "E1551B")
        viewCustomer.addSubview(customerIcon)
      
        
        viewWorker = UIButton(frame: CGRect(x:20, y: viewCustomer.y() - 75, width:Brain.kLargeurIphone-40, height: 60))
        viewWorker.layer.cornerRadius = 30;
        viewWorker.clipsToBounds = true
        viewWorker.setBackgroundColor(color: UIColor(hex: "F8F8F8"), forState: .highlighted)
        viewWorker.addTarget(self, action: #selector(touchWorker(_:)), for: .touchUpInside)
        viewWorker.setBackgroundColor(color: UIColor(hex: "F8F8F8"), forState: .normal)
        view.addSubview(viewWorker)
        
        worker = UILabel(frame: CGRect(x: 20, y: 0, width: viewWorker.w() - 53, height: 60))
        worker.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        worker.textColor = UIColor(hex: "B7B7B7")
        viewWorker.addSubview(worker)
        
        let attrs3 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(hex:"B7B7B7")]
        let attrs4 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .bold), NSAttributedString.Key.foregroundColor : Brain.kColorMain]
        let attributedString3 = NSMutableAttributedString(string:"I wish to register as a  ", attributes:attrs3)
        let attributedString4 = NSMutableAttributedString(string:"Worker", attributes:attrs4)
        attributedString3.append(attributedString4)
        worker.attributedText = attributedString3
        
        
        workerIcon = UIImageView(frame: CGRect(x: viewCustomer.w() - 34, y: 19, width: 22, height: 22))
        workerIcon.image = UIImage(named: "checkIcon")?.withRenderingMode(.alwaysTemplate)
        workerIcon.tintColor = UIColor(hex: "E3E5E5")
        viewWorker.addSubview(workerIcon)
        
    
        
    }
   
    
    @objc func touchCustomer(_ sender: UIButton){

        selectedWorker = false
        workerIcon.tintColor = UIColor(hex: "E3E5E5")
        customerIcon.tintColor = UIColor(hex: "E1551B")

    }
    
    
    @objc func touchWorker(_ sender: UIButton){
        
        
        selectedWorker = true
        workerIcon.tintColor = UIColor(hex: "E1551B")
        customerIcon.tintColor = UIColor(hex: "E3E5E5")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
       
    }
    
    
    @objc func changeProfilePic(_ sender: UIButton){
        
        if profileFile != nil {
                   
           let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           
           // create an action
           let firstAction: UIAlertAction = UIAlertAction(title:NSLocalizedString("Delete current profile picture", comment: ""), style: .destructive) { action -> Void in
               
               self.profileFile = nil
               self.profilePicture.image = UIImage.init(named: "bigProfile")
               
           }
           
           let secondAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Update profile picture", comment: ""), style: .default) { action -> Void in
               
               self.showCameraPicker()
           }
           
           let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in }
           
           // add actions
           actionSheetController.addAction(firstAction)
           actionSheetController.addAction(secondAction)
           actionSheetController.addAction(cancelAction)
           
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
                    
                    self.profileFile = imageFile
                    self.profileFile!.saveInBackground()
                    
                    self.profilePicture.image = photo.image
                   
                    picker.dismiss(animated: true, completion: nil)
                    
                case .video( _): break
                    
                }
            }
        }
        
        present(picker, animated: true, completion: nil)
        
        
    }
    
    
    
   
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func touchNext(_ sender: UIButton){
        
        
       next()
    }
    
  
    func next(){
        
        
        self.nextButton.loadingIndicatorWhite(true)

        if PFUser.current() != nil {
            
            self.updateUser()

        }else{
            

            UserDefaults.standard.set(self.user.email, forKey: "username")
            UserDefaults.standard.set(self.user.password, forKey: "password")

             user.signUpInBackground(block: { (success:Bool, error:Error?) in
                 
                 if let error = error {
                     
                    PFUser.logOut()
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true) {
                    }
                     
                 } else {
                     
                   
                    self.updateUser()
                    
                 }

             })
            
        }

        
        
    }
    
    
    func updateUser(){
        
        
        print("Set user...")
        
            if self.profileFile != nil {
                            
               PFUser.current()!.setObject(self.profileFile!, forKey: Brain.kUserProfilePicture)
            }

            if self.selectedWorker == false {

               PFUser.current()!.setObject("customer", forKey: Brain.kUserType)

            }else{
              
               PFUser.current()!.setObject("worker", forKey: Brain.kUserType)
            }

          
            PFUser.current()!.setObject(0, forKey: Brain.kUserReviewsWorkerNumber)
            PFUser.current()!.setObject(0, forKey: Brain.kUserReviewsCustomerNumber)
            PFUser.current()!.setObject(5, forKey: Brain.kUserRateWorker)
            PFUser.current()!.setObject(5, forKey: Brain.kUserRateCustomer)


           //Update ACL
           PFUser.current()!.acl = PFACL(user: PFUser.current()!)
           PFUser.current()!.acl?.setReadAccess(true, forRoleWithName: "User")
           PFUser.current()!.saveInBackground()
            
           //Update Role
           let queryRole = PFRole.query()
           queryRole?.whereKey("name", equalTo: "User")
           queryRole?.getFirstObjectInBackground(block: { (object, error) in
              
              let role = object as! PFRole
              role.users.add(PFUser.current()!)
              role.saveInBackground()
              
           })
           
           
            
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           appDelegate.updateInstallation()
           appDelegate.updateIntercomData()
          

            
           PFCloud.callFunction(inBackground: "CreateStripeCustomerAccount", withParameters:
           ["email":PFUser.current()!.object(forKey: Brain.kUserEmail)!,
            "firstname":PFUser.current()?.object(forKey: Brain.kUserFirstName) as! String,
            "lastname":PFUser.current()?.object(forKey: Brain.kUserLastName) as! String]) { (customer, error) in
                
                
                if (customer != nil) {
                    
                       let stripeCustomer = PFObject(className: Brain.kStripeCustomerClassName)
                       let acl = PFACL()
                       acl.setReadAccess(true, for: PFUser.current()!)
                       acl.setWriteAccess(true, for: PFUser.current()!)
                       
                       stripeCustomer.acl = acl
                       stripeCustomer.setObject((customer as! Dictionary)["id"]!, forKey: Brain.kStripeCustomerIdStripe)
                       stripeCustomer.setObject(PFUser.current()!, forKey: Brain.kStripeCustomerUser)
                       stripeCustomer.saveInBackground(block: { (success, error) in
                      
                       PFUser.current()?.setObject(stripeCustomer, forKey: Brain.kUserStripeCustomer)
                       PFUser.current()?.saveInBackground(block: { (success, error3) in

                           
                           if self.selectedWorker == true {
                               
                            Intercom.logEvent(withName: "signupAsWorker")

                                self.navigationController!.pushViewController(SignupAddressViewController(), animated: true)

                           }else{
                            
                            Intercom.logEvent(withName: "signupAsCustomer")

                               appDelegate.loginDone()

                           }

                       })
                                                              
                        
                    })
                    
                }
                
            }

    }
    
  

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let textTag = textField.tag+1
        let nextResponder = textField.superview?.viewWithTag(textTag) as? UITextField
        if(nextResponder != nil)
        {
            //textField.resignFirstResponder()
            nextResponder!.becomeFirstResponder()
        }
        else{
            // stop editing on pressing the done button on the last text field.

            next()

        }
        return true
    }
        
    
    
}
