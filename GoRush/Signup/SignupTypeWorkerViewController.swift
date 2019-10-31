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



class SignupTypeWorkerViewController: UIViewController , UIGestureRecognizerDelegate, UITextFieldDelegate{
    
    
    var displayOriginY: CGFloat!
    
    
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
    
    var profileFile : PFFile?

    var name : UILabel!

    var selectedWorker = false
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .white
        
        
        displayOriginY = originY()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        
        self.backButtonNav = UIButton(frame:CGRect(x:10,y:displayOriginY + 35,width:40,height:40))
        self.backButtonNav.setBackgroundImage(UIImage.init(named:"backButtonWithoutNav"), for: UIControlState.normal)
        self.backButtonNav.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButtonNav)
        
        
        
        
        
        
        textA = UILabel(frame: CGRect(x: 0, y: displayOriginY+80, width: Brain.kLargeurIphone, height: 30))
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
                
                
                profilePicture.file = PFUser.current()?.object(forKey: Brain.kUserProfilePicture) as? PFFile
                profilePicture.loadInBackground()
                
                profileFile = PFUser.current()?.object(forKey: Brain.kUserProfilePicture) as? PFFile
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
            
            if PFUser.current()?.object(forKey: Brain.kUserFirstName) != nil &&  PFUser.current()?.object(forKey: Brain.kUserLastName) != nil{
                
                name.text = String(format: "%@ %@", PFUser.current()?.object(forKey: Brain.kUserFirstName) as! String, PFUser.current()?.object(forKey: Brain.kUserLastName) as! String)

            }else if PFUser.current()?.object(forKey: Brain.kUserFirstName) != nil {
                
                name.text = String(format: "%@", PFUser.current()?.object(forKey: Brain.kUserFirstName)  as! String)
                
            }else{
                
                name.text = ""
                
            }
            
        }else{
            
          
            if SignupProcess.shared().firstname != nil  &&  SignupProcess.shared().lastname != nil{
                
                name.text = String(format: "%@ %@", SignupProcess.shared().firstname!, SignupProcess.shared().lastname!)
                
            }else if SignupProcess.shared().firstname != nil {
                
                name.text = String(format: "%@", SignupProcess.shared().firstname!)
                
            }else{
                
                name.text = ""
                
            }
            
        }
        
        
        
        
        nextButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: Brain.kHauteurIphone-90, width:335, height: 60))
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.applyGradient()
        view.addSubview(nextButton)
        
        
        /////
        /////
        
        viewCustomer = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: nextButton.y() - 75, width:335, height: 60))
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
       
        let attrs1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .medium), NSAttributedStringKey.foregroundColor : UIColor(hex:"B7B7B7")]
        let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .bold), NSAttributedStringKey.foregroundColor : Brain.kColorMain]
        let attributedString1 = NSMutableAttributedString(string:"I wish to register as a ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"Customer", attributes:attrs2)
        attributedString1.append(attributedString2)
        customer.attributedText = attributedString1
        
        
        customerIcon = UIImageView(frame: CGRect(x: viewCustomer.w() - 34, y: 19, width: 22, height: 22))
        customerIcon.image = UIImage(named: "checkIcon")?.withRenderingMode(.alwaysTemplate)
        customerIcon.tintColor = UIColor(hex: "E1551B")
        viewCustomer.addSubview(customerIcon)
        
        /////
        /////
        
        viewWorker = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: viewCustomer.y() - 75, width:335, height: 60))
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
        
        let attrs3 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .medium), NSAttributedStringKey.foregroundColor : UIColor(hex:"B7B7B7")]
        let attrs4 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .bold), NSAttributedStringKey.foregroundColor : Brain.kColorMain]
        let attributedString3 = NSMutableAttributedString(string:"I wish to register as a  ", attributes:attrs3)
        let attributedString4 = NSMutableAttributedString(string:"Worker", attributes:attrs4)
        attributedString3.append(attributedString4)
        worker.attributedText = attributedString3
        
        
        
        workerIcon = UIImageView(frame: CGRect(x: viewCustomer.w() - 34, y: 19, width: 22, height: 22))
        workerIcon.image = UIImage(named: "checkIcon")?.withRenderingMode(.alwaysTemplate)
        workerIcon.tintColor = UIColor(hex: "E3E5E5")
        viewWorker.addSubview(workerIcon)
        
        /////
        /////
        
        
        
      
        
        
        
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
    
    
    
    @objc func changeProfilePic(_ sender: UIButton){
        
        //        self.updateProfilePictureActionSheet()
        
        self.updateProfilePictureActionSheet()
        
    }
    
    
    func updateProfilePictureActionSheet(){
        
        
        if profileFile != nil {
            
            
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            // create an action
            let firstAction: UIAlertAction = UIAlertAction(title:NSLocalizedString("Delete Profile Picture", comment: ""), style: .destructive) { action -> Void in
                
                self.profileFile = nil
                self.profilePicture.image = UIImage.init(named: "bigProfile")
                
                
            
                
            }
            
            let secondAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Update Profile Picture", comment: ""), style: .default) { action -> Void in
                
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
        config.library.mediaType = .photo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = true
        config.targetImageSize = .original
        config.usesFrontCamera = true
        config.showsFilters = false
        //        config.filters = [YPFilterDescriptor(name: "Normal", filterName: ""),
        //                          YPFilterDescriptor(name: "Mono", filterName: "CIPhotoEffectMono")]
        config.shouldSaveNewPicturesToAlbum = false
        //        config.video.compression = AVAssetExportPresetHighestQuality
        config.albumName = NSLocalizedString("GoRush", comment: "")
        //        config.screens = [.library, .photo, .video]
        config.screens = [.library]
        config.startOnScreen = .library
        //        config.video.recordingTimeLimit = 8
        //        config.video.libraryTimeLimit = 8
        //        config.showsCrop = .rectangle(ratio: (16/16))
        config.wordings.libraryTitle = NSLocalizedString("Photos", comment: "")
        config.hidesStatusBar = false
        config.preferredStatusBarStyle = .default
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 2
        config.library.spacingBetweenItems = 2
        config.isScrollToChangeModesEnabled = true
        
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                
                return
            }
            
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    
                    
                    let imageData = UIImageJPEGRepresentation(photo.image, 0.3)
                    let imageFile = PFFile(name:"profile.jpg", data:imageData!)
                    
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
        
        
        if self.profileFile != nil {
            
            SignupProcess.shared().profilePicture = self.profileFile!
            
        }
        
        
        
        if self.selectedWorker == false {
            
            SignupProcess.shared().type = "customer"

            
        }else{
            
            SignupProcess.shared().type = "worker"

        }
        
        
        SignupProcess.shared().nextProcess(navigationController: self.navigationController!)

        
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
}
