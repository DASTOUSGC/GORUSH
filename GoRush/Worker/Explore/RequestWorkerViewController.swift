//
//  RequestWorkerViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-12-30.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Parse
import Photos

class RequestWorkerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    var overlayView : UIView!
    var frontCamera : Bool!
    
    var photoView : PFImageView!
    
    var player: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    
    var viewToCapture : UIView!
    
    
    var cancelButton : UIButton!
    var sendButton : UIButton!
    
    var cancelStartButton : UIButton!
    var confirmStartButton : UIButton!

    var cancelFinishButton : UIButton!
    var confirmFinishButton : UIButton!

    
   
    var refuseButton : UIButton!
    var acceptButton : UIButton!
    
    var kms : UIButton!
    var time : UIButton!
    var startJob : UIButton!
    var finishJob : UIButton!

    var request : PFObject!
    var service : PFObject!
    var customer : PFUser!

    
    var filter : UIImageView!
    
    var titleVC : UILabel!
    var profilePicture : PFImageView!
    var backButton : UIButton!
    
    
    var iconService : PFImageView!
    var labelService : UILabel!
    
    var iconWhere : UIImageView!
    var labelWhere : UILabel!
    var labelSize : UIButton!
    var labelPrice : UILabel!
   
    
    var loadingVideo : UIActivityIndicatorView!
    
    var modeToAcceptJob = false
    var toAcceptJobVideo : URL?
    var toAcceptJobPhoto : UIImage?
  
    var modeToStartJob = false
    var toStartJobVideo : URL?
    var toStartJobPhoto : UIImage?
    
    
    var modeToFinishJob = false
    var toFinishJobVideo : URL?
    var toFinishJobPhoto : UIImage?


    var timerKm : Timer!
    var timeJob : Timer!


    var reviewButton : UIButton!

    var mediaButton : UIButton!

    var medias = [[PFFile]]()
    var currentMedia = 0
    var oldMedia = -1
    
    
    var profileButton : UIButton!
    
    
    var timer: Timer?


    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    deinit {
        // perform the deinitialization
        print("dealloc video view \(Date())")
        
    }
    
    convenience init(request : PFObject)
    {
        
        self.init()
        
       
        self.request = request
        self.service = self.request.object(forKey: Brain.kRequestService) as? PFObject
        
        self.customer = self.request.object(forKey: Brain.kRequestCustomer) as! PFUser
        
        
        self.updateMedias()

        self.currentMedia = self.medias.count - 1
        
    }
    
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }

    @objc func loop() {
       
        

        
        let query = PFQuery(className: Brain.kRequestClassName)
        query.whereKey("objectId", equalTo: self.request.objectId!)
        query.includeKey(Brain.kRequestService)
        query.includeKey(Brain.kRequestCustomer)
        query.includeKey(Brain.kRequestWorker)
        query.getFirstObjectInBackground { (request, error) in
            
            self.updateRequest(withMedia: false)
        }

       
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
     
        
        self.view.clipsToBounds = true
        
        
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        tabBarItem.title = "";
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        
        
        
        
        
          player = AVPlayer()

          viewToCapture = UIView(frame: view.frame)
          viewToCapture.backgroundColor = .black
          view.addSubview(viewToCapture)
          
          
          avPlayerLayer = AVPlayerLayer(player: player)
          
          avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
          
          if isIphoneXFamily() {
              
              avPlayerLayer.frame = CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height:  Brain.kHauteurIphone)
              
              
          }else{
              
              avPlayerLayer.frame = view.layer.bounds
              
          }
          view.backgroundColor = .black
          viewToCapture.layer.insertSublayer(avPlayerLayer, at: 0)
              
       
        
        self.photoView = PFImageView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
        self.photoView.backgroundColor = .clear
        self.photoView.contentMode = .scaleAspectFill
        self.view.addSubview(self.photoView)
        
        
        
        self.filter = UIImageView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
        self.filter.image = UIImage(named: "filterCamera")
        self.view.addSubview(filter)
        self.filter.isUserInteractionEnabled = true
              let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
              self.filter.addGestureRecognizer(tap)

              
        
        
        self.profilePicture = PFImageView(frame: CGRect(x: Brain.kLargeurIphone / 2 - 80, y: yTop() + 22, width: 28, height: 28))
        self.profilePicture.layer.cornerRadius = 14
        self.profilePicture.layer.masksToBounds = true
        self.view.addSubview(profilePicture)

        self.titleVC = UILabel(frame: CGRect(x: 20, y: yTop() + 26, width: Brain.kLargeurIphone, height: 20))
        self.titleVC.textAlignment = .center
        self.titleVC.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.titleVC.textColor = .white
        self.view.addSubview(titleVC)
        
        self.backButton = UIButton(frame: CGRect(x: 13, y: yTop() + 8, width: 44, height: 42))
        self.backButton.setBackgroundImage(UIImage(named: "backArrowWhite"), for: .normal)
        self.backButton.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        
        
      self.loadingVideo = UIActivityIndicatorView(activityIndicatorStyle: .white)
      self.loadingVideo.center = CGPoint(x: Brain.kLargeurIphone - 34, y: yTop() + 34)
      self.view.addSubview(loadingVideo)


       refuseButton = UIButton(frame: CGRect(x:20, y: originYBottomButtonCTA(), width:135, height: 60))
       refuseButton.layer.cornerRadius = 30;
       refuseButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
       refuseButton.layer.borderColor = UIColor.white.cgColor
       refuseButton.layer.borderWidth = 1.5
       refuseButton.setTitle(NSLocalizedString("Refuse", comment: ""), for: .normal)
       refuseButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
       refuseButton.setTitleColor(UIColor.white, for: .normal)
       refuseButton.setTitleColor(UIColor.gray, for: .highlighted)
       refuseButton.addTarget(self, action: #selector(touchRefuse(_:)), for: .touchUpInside)
       view.addSubview(refuseButton)
       
       
        let originxAccept = refuseButton.x() + refuseButton.w() + 20
        

        acceptButton = UIButton(frame: CGRect(x:originxAccept, y: originYBottomButtonCTA(), width:Brain.kLargeurIphone-originxAccept-20, height: 60))
        acceptButton.layer.cornerRadius = 30;
        acceptButton.setTitle(NSLocalizedString("Accept Job", comment: ""), for: .normal)
        acceptButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        acceptButton.setTitleColor(UIColor.white, for: .normal)
        acceptButton.setTitleColor(UIColor.gray, for: .highlighted)
        acceptButton.applyGradient()
        acceptButton.addTarget(self, action: #selector(touchAccept(_:)), for: .touchUpInside)
        view.addSubview(acceptButton)
        
        
        cancelButton = UIButton(frame: CGRect(x:20, y: originYBottomButtonCTA(), width:135, height: 60))
        cancelButton.layer.cornerRadius = 30;
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 1.5
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitleColor(UIColor.gray, for: .highlighted)
        cancelButton.isHidden = true
        cancelButton.addTarget(self, action: #selector(touchCancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
         sendButton = UIButton(frame: CGRect(x:originxAccept, y: originYBottomButtonCTA(), width:Brain.kLargeurIphone-originxAccept-20, height: 60))
         sendButton.layer.cornerRadius = 30;
         sendButton.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
         sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
         sendButton.setTitleColor(UIColor.white, for: .normal)
         sendButton.setTitleColor(UIColor.gray, for: .highlighted)
         sendButton.applyGradient()
         sendButton.isHidden = true
         sendButton.addTarget(self, action: #selector(touchSend), for: .touchUpInside)
         view.addSubview(sendButton)
        
        
        cancelStartButton = UIButton(frame: CGRect(x:20, y: originYBottomButtonCTA(), width:135, height: 60))
        cancelStartButton.layer.cornerRadius = 30;
        cancelStartButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        cancelStartButton.layer.borderColor = UIColor.white.cgColor
        cancelStartButton.layer.borderWidth = 1.5
        cancelStartButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelStartButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cancelStartButton.setTitleColor(UIColor.white, for: .normal)
        cancelStartButton.setTitleColor(UIColor.gray, for: .highlighted)
        cancelStartButton.isHidden = true
        cancelStartButton.addTarget(self, action: #selector(touchCancelStart), for: .touchUpInside)
        view.addSubview(cancelStartButton)
        
        
        confirmStartButton = UIButton(frame: CGRect(x:originxAccept, y: originYBottomButtonCTA(), width:Brain.kLargeurIphone-originxAccept-20, height: 60))
        confirmStartButton.layer.cornerRadius = 30;
        confirmStartButton.setTitle(NSLocalizedString("Confirm", comment: ""), for: .normal)
        confirmStartButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        confirmStartButton.setTitleColor(UIColor.white, for: .normal)
        confirmStartButton.setTitleColor(UIColor.gray, for: .highlighted)
        confirmStartButton.applyGradient()
        confirmStartButton.isHidden = true
        confirmStartButton.addTarget(self, action: #selector(touchConfirmStart), for: .touchUpInside)
        view.addSubview(confirmStartButton)



        
        cancelFinishButton = UIButton(frame: CGRect(x:20, y: originYBottomButtonCTA(), width:135, height: 60))
        cancelFinishButton.layer.cornerRadius = 30;
        cancelFinishButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        cancelFinishButton.layer.borderColor = UIColor.white.cgColor
        cancelFinishButton.layer.borderWidth = 1.5
        cancelFinishButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelFinishButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cancelFinishButton.setTitleColor(UIColor.white, for: .normal)
        cancelFinishButton.setTitleColor(UIColor.gray, for: .highlighted)
        cancelFinishButton.isHidden = true
        cancelFinishButton.addTarget(self, action: #selector(touchCancelFinish), for: .touchUpInside)
        view.addSubview(cancelFinishButton)
       
        confirmFinishButton = UIButton(frame: CGRect(x:originxAccept, y: originYBottomButtonCTA(), width:Brain.kLargeurIphone-originxAccept-20, height: 60))
        confirmFinishButton.layer.cornerRadius = 30;
        confirmFinishButton.setTitle(NSLocalizedString("Confirm", comment: ""), for: .normal)
        confirmFinishButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        confirmFinishButton.setTitleColor(UIColor.white, for: .normal)
        confirmFinishButton.setTitleColor(UIColor.gray, for: .highlighted)
        confirmFinishButton.applyGradient()
        confirmFinishButton.isHidden = true
        confirmFinishButton.addTarget(self, action: #selector(touchConfirmFinish), for: .touchUpInside)
        view.addSubview(confirmFinishButton)
       


        
        kms = UIButton(frame: CGRect(x:20, y: originYBottomButtonCTA(), width:135, height: 60))
        kms.layer.cornerRadius = 30;
        kms.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        kms.layer.borderColor = UIColor.white.cgColor
        kms.layer.borderWidth = 1.5
        kms.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        kms.setTitleColor(UIColor.white, for: .normal)
        kms.setTitleColor(UIColor.gray, for: .highlighted)
        kms.isHidden = true
        kms.addTarget(self, action: #selector(touchKms), for: .touchUpInside)
        view.addSubview(kms)
        
        
        time = UIButton(frame: CGRect(x:20, y: originYBottomButtonCTA(), width:135, height: 60))
        time.layer.cornerRadius = 30;
        time.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        time.layer.borderColor = UIColor.white.cgColor
        time.layer.borderWidth = 1.5
        time.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        time.setTitleColor(UIColor.white, for: .normal)
        time.setTitleColor(UIColor.gray, for: .highlighted)
        time.isHidden = true
        view.addSubview(time)

        startJob = UIButton(frame: CGRect(x:originxAccept, y: originYBottomButtonCTA(), width:Brain.kLargeurIphone-originxAccept-20, height: 60))
        startJob.layer.cornerRadius = 30;
        startJob.setTitle(NSLocalizedString("Start Job", comment: ""), for: .normal)
        startJob.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        startJob.setTitleColor(UIColor.white, for: .normal)
        startJob.setTitleColor(UIColor.gray, for: .highlighted)
        startJob.applyGradient()
        startJob.isHidden = true
        startJob.addTarget(self, action: #selector(touchStartJob), for: .touchUpInside)
        view.addSubview(startJob)
        
        
        finishJob = UIButton(frame: CGRect(x:originxAccept, y: originYBottomButtonCTA(), width:Brain.kLargeurIphone-originxAccept-20, height: 60))
        finishJob.layer.cornerRadius = 30;
        finishJob.setTitle(NSLocalizedString("Finish Job", comment: ""), for: .normal)
        finishJob.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        finishJob.setTitleColor(UIColor.white, for: .normal)
        finishJob.setTitleColor(UIColor.gray, for: .highlighted)
        finishJob.applyGradient()
        finishJob.isHidden = true
        finishJob.addTarget(self, action: #selector(touchFinishJob), for: .touchUpInside)
        view.addSubview(finishJob)

        
        
        
        self.iconService = PFImageView(frame: CGRect(x: 20, y: yTop() + 80, width: 20, height: 20))
        self.iconService.layer.applySketchShadow()
        view.addSubview(iconService)
        
        
        self.labelService = UILabel(frame: CGRect(x: 48, y: iconService.y(), width: Brain.kLargeurIphone  - 70, height: 20))
        self.labelService.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelService.textColor = .white
        self.labelService.layer.applySketchShadow()
        self.view.addSubview(labelService)
        
        
        
        self.iconWhere = UIImageView(frame: CGRect(x: 20, y: self.iconService.yBottom() + 12, width: 20, height: 20))
        self.iconWhere.image = UIImage(named: "iconWhere")
        self.iconWhere.layer.applySketchShadow()
        view.addSubview(iconWhere)

        self.labelWhere = UILabel(frame: CGRect(x: 48, y: iconWhere.y(), width: Brain.kLargeurIphone - 70, height: 20))
        self.labelWhere.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelWhere.textColor = .white
        self.labelWhere.layer.applySketchShadow()
        let tapAddress = UITapGestureRecognizer(target: self, action: #selector(self.openAddress(_:)))
        
        labelWhere.isUserInteractionEnabled = true
        labelWhere.addGestureRecognizer(tapAddress)
        self.view.addSubview(labelWhere)
        
        
        self.labelSize = UIButton(frame: CGRect(x: 20, y: self.labelWhere.yBottom() + 12, width: 120, height: 38))
        self.labelSize.backgroundColor = Brain.kColorMain
        self.labelSize.applyGradient()
        self.labelSize.layer.cornerRadius = 19
        self.labelSize.layer.masksToBounds = true
        self.labelSize.addTarget(self, action: #selector(touchSize(_:)), for: .touchUpInside)
        self.labelSize.titleLabel?.font  = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.labelSize.setTitleColor(.white, for: .normal)
        self.view.addSubview(labelSize)
        
        self.labelPrice = UILabel(frame: CGRect(x: 20, y: self.labelSize.yBottom() + 10, width: Brain.kLargeurIphone - 40, height: 48))
        self.labelPrice.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        self.labelPrice.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelPrice.textColor = .white
        self.labelPrice.layer.applySketchShadow()
        self.view.addSubview(labelPrice)

            
        self.mediaButton = UIButton(frame: CGRect(x: 20, y: self.labelPrice.yBottom() + 10, width: 30, height: 30))
        self.mediaButton.layer.cornerRadius = 12.5
        self.mediaButton.backgroundColor = .clear
        self.mediaButton.setBackgroundImage(UIImage(named: "step0"), for: .normal)
        //        self.mediaButton.layer.borderWidth = 2
        //        self.mediaButton.layer.borderColor = UIColor.white.cgColor
        //        self.mediaButton.setTitle(NSLocalizedString("1", comment: ""), for: .normal)
        //        self.mediaButton.titleLabel!.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        self.mediaButton.layer.applySketchShadow()
        self.mediaButton.isUserInteractionEnabled = false
        self.view.addSubview(mediaButton)
                
                   
         reviewButton = UIButton(frame: CGRect(x:20, y: originYBottomButtonCTA(), width:Brain.kLargeurIphone-40, height: 60))
         reviewButton.layer.cornerRadius = 30;
         reviewButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
         reviewButton.setTitleColor(UIColor.white, for: .normal)
         reviewButton.setTitleColor(UIColor.gray, for: .highlighted)
         reviewButton.applyGradient()
         reviewButton.addTarget(self, action: #selector(touchReview(_:)), for: .touchUpInside)
         view.addSubview(reviewButton)
         
        
    
        profileButton = UIButton(frame: CGRect(x:00, y:0, width:0, height: 0))
        profileButton.addTarget(self, action: #selector(touchProfile(_:)), for: .touchUpInside)
        view.addSubview(profileButton)
        
        
        
        
//        self.updateRequest(withMedia: true)
        
    }
    
    
    
    @objc func touchSize(_ sender: UIButton){

        
        let mowing = LandViewController(request: self.request)
        mowing.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mowing, animated: true)

    }
    
    
    
    @objc func openAddress(_ sender: UITapGestureRecognizer? = nil) {


           
               var adress =  ""
                  
               if self.request.object(forKey: Brain.kRequestAddress) != nil {
                      
                      adress = self.request.object(forKey: Brain.kRequestAddress) as! String
                      
                  }else{
                      
                      return
                      
                  }
                  
           let alert = UIAlertController(title: NSLocalizedString(adress, comment: ""), message: nil, preferredStyle: .actionSheet)
                  
                  if let popoverController = alert.popoverPresentationController {
                      popoverController.sourceView = self.view
                      popoverController.permittedArrowDirections = []
                      popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                  }
                  
                  adress = adress.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                  
                  
                  let maps = UIAlertAction(title: NSLocalizedString("Open in Maps", comment: ""), style: .default, handler: { action in
                      
                      
                      UIApplication.shared.open(URL(string: "http://maps.apple.com/?q=\(adress)")!, options: [:], completionHandler: nil)
                      
                      
                  })
                  maps.setValue(UIColor.black, forKey: "titleTextColor")
                  alert.addAction(maps)
                  
                  
                  let googlemaps = UIAlertAction(title: NSLocalizedString("Open in Google Maps", comment: ""), style: .default, handler: { action in
                      
                      
                      UIApplication.shared.open(URL(string: "comgooglemaps://?q=\(adress)")!, options: [:], completionHandler: nil)
                      
                      
                  })
                  googlemaps.setValue(UIColor.black, forKey: "titleTextColor")
                  alert.addAction(googlemaps)
                  
                  
                  
                  
                  let noAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                  noAction.setValue(Brain.kColorMain, forKey: "titleTextColor")
                  alert.addAction(noAction)
                  
                  
                  DispatchQueue.main.async {
                      self.present(alert, animated: true)
                      
                  }
           
           
           

       }
    
    
    
    @objc func touchProfile(_ sender: UIButton){

    
        print("profile")
        let reviews = ReviewsViewController(user: PFUser.current()!, fromWorker: true)
        reviews.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(reviews, animated: true)

    }
    
    
    @objc func touchReview(_ sender: UIButton){

           let rateVC = NewReviewToUserViewController(user: self.customer!, request : self.request , fromWorker: true)
           self.navigationController?.pushViewController(rateVC, animated: true)
    
    }
    
    
    @objc func tapView(_ sender: UITapGestureRecognizer? = nil) {
           // handling code
           
           print("ttapp")
           
           
           self.currentMedia = self.currentMedia + 1
           
           

           if self.medias.count > self.currentMedia {
               
               
           }else{
               
               self.currentMedia = 0
               
           }
           

           self.updateRequest(withMedia: true)
       }
       
       func updateMedias(){
           
              self.medias = [[PFFile]]()
                  
              if self.request.object(forKey: Brain.kRequestPhoto) != nil {

                  
                  if self.request.object(forKey: Brain.kRequestVideo) != nil {

                      self.medias.append([self.request.object(forKey: Brain.kRequestPhoto) as! PFFile,self.request.object(forKey: Brain.kRequestVideo) as! PFFile])

                      
                  }else{
                      
                      self.medias.append([self.request.object(forKey: Brain.kRequestPhoto) as! PFFile])

                  }
              }
           
           
               if self.request.object(forKey: Brain.kRequestPhotoWelcome) != nil {


                   if self.request.object(forKey: Brain.kRequestVideoWelcome) != nil {

                     self.medias.append([self.request.object(forKey: Brain.kRequestPhotoWelcome) as! PFFile,self.request.object(forKey: Brain.kRequestVideoWelcome) as! PFFile])

                     
                   }else{
                     
                     self.medias.append([self.request.object(forKey: Brain.kRequestPhotoWelcome) as! PFFile])

                   }
               }
        
        

            if self.request.object(forKey: Brain.kRequestPhotoStart) != nil {


                if self.request.object(forKey: Brain.kRequestVideoStart) != nil {

                  self.medias.append([self.request.object(forKey: Brain.kRequestPhotoStart) as! PFFile,self.request.object(forKey: Brain.kRequestVideoStart) as! PFFile])

                  
                }else{
                  
                  self.medias.append([self.request.object(forKey: Brain.kRequestPhotoStart) as! PFFile])

                }
            }
        
        
            if self.request.object(forKey: Brain.kRequestPhotoEnd) != nil {


               if self.request.object(forKey: Brain.kRequestVideoEnd) != nil {

                 self.medias.append([self.request.object(forKey: Brain.kRequestPhotoEnd) as! PFFile,self.request.object(forKey: Brain.kRequestVideoEnd) as! PFFile])

                 
               }else{
                 
                 self.medias.append([self.request.object(forKey: Brain.kRequestPhotoEnd) as! PFFile])

               }
            }
           
       }
       
    
    
    func updateRequest(withMedia:Bool){
        
        
        
        if modeToAcceptJob == true || modeToStartJob == true || modeToFinishJob == true {
            
            return
        }
        
        self.titleVC.text = String(format: "%@'s Request", self.customer.object(forKey: Brain.kUserFirstName) as! String)

        if self.customer.object(forKey: Brain.kUserProfilePicture) != nil {
            
            self.titleVC.frame.origin.x = 20
            self.profilePicture.file = self.customer.object(forKey: Brain.kUserProfilePicture) as? PFFile
            self.profilePicture.loadInBackground()
            self.profilePicture.isHidden = false

        }else{
            
            
            self.titleVC.frame.origin.x = 0
            self.profilePicture.isHidden = true

        }
        
        
           self.profileButton.frame = CGRect(x: self.profilePicture.x(), y: self.profilePicture.y() - 10, width: Brain.kLargeurIphone - (self.profilePicture.x() * 2), height: 50)
        
        
        
        
        
        if withMedia == true{
            
            updateMedias()
            
            print("BOUMMM ON REMET")
            
            if self.medias.count > self.currentMedia {
                     
                     self.photoView.file = self.medias[self.currentMedia][0]
                     self.photoView.loadInBackground()
                     
                     
                     if self.medias[self.currentMedia].count > 1 {
                         
                         

                         
                         
                     
                         if self.currentMedia == self.oldMedia {
                             
                             
                             if self.player != nil {
                                 
                                 self.player!.seek(to: kCMTimeZero)
                             }
                             self.player.play()
                            
                            self.photoView.isHidden = true

                             
                         }else{
                             
                             
                             
                             

                             ///self.medias[0].count
                             
                             let videoFile = self.medias[self.currentMedia][1]
                             
                             if !videoFile.isDataAvailable  {
                                 
                                 self.loadingVideo.startAnimating()

                             }
                             
                             
                             videoFile.getDataInBackground(block: { (data, error) in
                                
                                 
                                 if data != nil {
                                     
                                     let url = try! FileManager.default.url(for: .documentDirectory,
                                                                            in: .userDomainMask, appropriateFor: nil,
                                                                            create: false).appendingPathComponent(String(format: "request_%d.mp4", self.currentMedia))
                                     
                                     do {
                                      
                                         try data?.write(to: url, options: .atomic)
                                         self.player.pause()
                                         self.player = AVPlayer(url: url)
                                         
                                         self.avPlayerLayer = AVPlayerLayer(player: self.player)
                                         self.avPlayerLayer.frame = self.viewToCapture.frame
                                         self.avPlayerLayer.videoGravity = .resizeAspectFill
                                         self.viewToCapture.layer.sublayers = nil
                                         self.viewToCapture.layer.addSublayer(self.avPlayerLayer)
                                         
                                         self.enableEndLoopVideoAndSoundOn()

                                         self.player.play()
                                         
                                         
                                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                             self.photoView.isHidden = true
                                             self.loadingVideo.stopAnimating()

                                         })
                                         

                                         
                                     } catch {
                                         print(error)
                                     }
                                     
                                     
                                 }
                                 
                               
                                 
                                 
                             })
                             
                         }
                         
                         
                         self.oldMedia = self.currentMedia

                     
                     }else{
                         
                         
                         self.photoView.isHidden = false
                         self.player.pause()


                     }
                        
                     
                 }
                 
                 
                 if self.medias.count > 1 {
                     
                     self.mediaButton.isHidden = false

                 }else{
                     
                     self.mediaButton.isHidden = true
                 }
                 
                 if self.currentMedia == 0 {
                     
                     self.mediaButton.setBackgroundImage(UIImage(named: "step0"), for: .normal)

                     
                 }else if self.currentMedia == 1 {
                     
                     self.mediaButton.setBackgroundImage(UIImage(named: "step1"), for: .normal)

                 }else if self.currentMedia == 2 {
                     
                     self.mediaButton.setBackgroundImage(UIImage(named: "step2"), for: .normal)

                 }else if self.currentMedia == 3 {
                     
                     self.mediaButton.setBackgroundImage(UIImage(named: "step3"), for: .normal)

                     
                 }else{
                     
                     self.mediaButton.setBackgroundImage(UIImage(named: "step0"), for: .normal)

                 }
                 
            
            
        }
           

        self.iconService.file = self.service.object(forKey: Brain.kServiceIcon) as? PFFile
        self.iconService.loadInBackground()


        self.labelService.text = self.service.object(forKey: Brain.kServicesName) as? String
        self.labelWhere.text = self.request.object(forKey: Brain.kRequestAddress) as? String



        self.labelSize.setTitle(String(format: NSLocalizedString("≅%dpi²", comment: ""), self.request.object(forKey: Brain.kRequestSurface) as! Int), for: .normal)


        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 40), NSAttributedStringKey.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.white]


        let attributedString1 = NSMutableAttributedString(string:String(format: "%.2f", self.request.object(forKey: Brain.kRequestPriceWorker) as! Double), attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"$", attributes:attrs2)

        attributedString1.append(attributedString2)
        self.labelPrice.attributedText = attributedString1
        
        
        if timerKm != nil {
            
            timerKm.invalidate()

        }
        
        
        if timeJob != nil {
                   
           timeJob.invalidate()

       }

        
        
        
        self.cancelStartButton.isHidden = true
        self.confirmStartButton.isHidden = true
        self.cancelFinishButton.isHidden = true
        self.confirmFinishButton.isHidden = true
        self.reviewButton.isHidden = true

        
        if self.request.object(forKey: Brain.kRequestState) as! String == "pending" {
            
            
            self.refuseButton.isHidden = false
            self.acceptButton.isHidden = false
            
            self.cancelButton.isHidden = true
            self.sendButton.isHidden = true
            
            self.kms.isHidden = true
            self.startJob.isHidden = true
            

        }else if self.request.object(forKey: Brain.kRequestState) as! String == "accepted" {
            
            
            self.refuseButton.isHidden = true
            self.acceptButton.isHidden = true

            self.cancelButton.isHidden = true
            self.sendButton.isHidden = true

            self.kms.isHidden = false
            self.startJob.isHidden = false

            
            
            updateDistance()
            
            timerKm = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDistance), userInfo: nil, repeats: true)

            
            
        }else if self.request.object(forKey: Brain.kRequestState) as! String == "started" {
            
            self.refuseButton.isHidden = true
            self.acceptButton.isHidden = true


            self.cancelButton.isHidden = true
            self.sendButton.isHidden = true

            self.kms.isHidden = true
            self.startJob.isHidden = true
            
            self.time.isHidden = false
            self.finishJob.isHidden = false


            self.updateTime()
            
            timeJob = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)

            
        }else if self.request.object(forKey: Brain.kRequestState) as! String == "ended" {
            
            
            self.refuseButton.isHidden = true
            self.acceptButton.isHidden = true

            self.cancelButton.isHidden = true
            self.sendButton.isHidden = true

            self.kms.isHidden = true
            self.startJob.isHidden = true
            
            self.time.isHidden = true
            self.finishJob.isHidden = true

          
            self.reviewButton.setTitle(String(format: "Review %@", self.customer.object(forKey: Brain.kUserFirstName) as! String), for: .normal)
                                      
              if self.request.object(forKey: Brain.kRequestReviewFromWorker) != nil {
                  
                  self.reviewButton.isHidden = true

              }else{
                  
                  
                  self.reviewButton.isHidden = false

              }


            
        }else {
            
            
        }

        
        if self.profilePicture.isHidden == false {
                   
           self.titleVC.sizeToFit()
           
           var largeur = self.profilePicture.w() + 8 + self.titleVC.w()
           self.profilePicture.frame.origin.x = (Brain.kLargeurIphone - largeur ) / 2
           self.titleVC.frame.origin.x = self.profilePicture.w() + self.profilePicture.x() + 8
           
       }

    }
    
    @objc func updateTime(){

        if self.request.object(forKey: Brain.kRequestTimeStart) != nil {
            
            let cal = Calendar.current
            let d1 = Date()
            let d2 = self.request.object(forKey: Brain.kRequestTimeStart) as! Date
            let components = cal.dateComponents([.hour,.minute,.second], from: d2, to: d1)

            self.time.setTitle(String(format: "%.2d:%.2d:%.2d", components.hour!,components.minute!,components.second!), for: .normal)
       
        }
        
    }
    
    @objc func updateDistance(){
        

        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
                  
              if geopoint != nil && error == nil {
                  
                
                let distance = geopoint!.distanceInKilometers(to: self.request.object(forKey: Brain.kRequestCenter) as? PFGeoPoint)
                
                self.kms.setTitle(String(format: NSLocalizedString("%.1fkm", comment: ""), distance), for: .normal)

              }
        }
        
        
    }
    
    
   
    
    

    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @objc func touchRefuse(_ sender: UIButton){

        let alert = UIAlertController(title: NSLocalizedString("Refuse Job", comment: ""), message: NSLocalizedString("Are you sure you want to refuse this job?", comment: ""), preferredStyle: .alert)
              
        if let popoverController = alert.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.permittedArrowDirections = []
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }


        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { action in
          
            
            if self.request.object(forKey: Brain.kRequestRefuseWorkerId) != nil {
                
                var refuseIds = self.request.object(forKey: Brain.kRequestRefuseWorkerId) as! [String]
                refuseIds.append(PFUser.current()!.objectId!)

                var refuse = self.request.object(forKey: Brain.kRequestRefuseWorker) as! [PFUser]
                refuse.append(PFUser.current()!)


                self.request.setObject(refuseIds, forKey: Brain.kRequestRefuseWorkerId)
                self.request.setObject(refuse, forKey: Brain.kRequestRefuseWorker)



            }else{
                
                var refuseIds = [String]()
                refuseIds.append(PFUser.current()!.objectId!)
                
                var refuse = [PFUser]()
                refuse.append(PFUser.current()!)
                
                
                self.request.setObject(refuseIds, forKey: Brain.kRequestRefuseWorkerId)
                self.request.setObject(refuse, forKey: Brain.kRequestRefuseWorker)
                
               

            }
            
            
            sender.loadingIndicatorWhite(true)

            self.request.saveInBackground { (done, error) in

                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.tabBarController?.exploreViewController?.getRequests()
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {

                    sender.loadingIndicatorWhite(false)
                    self.navigationController?.popViewController(animated: true)
                    
                })



            }
            
            
        })
        alert.addAction(yesAction)



        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)

        alert.addAction(noAction)


        DispatchQueue.main.async {
          self.present(alert, animated: true)
          
        }
        
        
    }
    
    
    func viewToAcceptJob(photo:UIImage?, video : URL?){
        
        self.sendButton.isHidden = false
        self.cancelButton.isHidden = false
        self.refuseButton.isHidden = true
        self.acceptButton.isHidden = true
        self.modeToAcceptJob = true
        
        self.mediaButton.isHidden = true

        if photo != nil {

            self.player.pause()
            toAcceptJobPhoto = photo!
            self.photoView.isHidden = false
            self.photoView.image = photo!
            
        }
        
        
        if video != nil {
            
            

            self.player.pause()
            self.player = AVPlayer(url: video!)

            self.avPlayerLayer = AVPlayerLayer(player: self.player)
            self.avPlayerLayer.frame = self.viewToCapture.frame
            self.avPlayerLayer.videoGravity = .resizeAspectFill
            self.viewToCapture.layer.sublayers = nil
            self.viewToCapture.layer.addSublayer(self.avPlayerLayer)


            self.player.play()

            self.photoView.isHidden = true
            
            
            toAcceptJobVideo = video!


        }

    }
    
    ///viewToStartJob
    func viewToStartJob(photo:UIImage?, video : URL?){
          
        
        
        
          self.confirmStartButton.isHidden = false
          self.cancelStartButton.isHidden = false
          self.refuseButton.isHidden = true
          self.startJob.isHidden = true
          self.kms.isHidden = true
          self.acceptButton.isHidden = true
          self.modeToStartJob = true
          
         self.mediaButton.isHidden = true
          
          if photo != nil {

              self.player.pause()
              toStartJobPhoto = photo!
              self.photoView.isHidden = false
              self.photoView.image = photo!
              
          }
          
          
          if video != nil {
              
              

              self.player.pause()
              self.player = AVPlayer(url: video!)

              self.avPlayerLayer = AVPlayerLayer(player: self.player)
              self.avPlayerLayer.frame = self.viewToCapture.frame
              self.avPlayerLayer.videoGravity = .resizeAspectFill
              self.viewToCapture.layer.sublayers = nil
              self.viewToCapture.layer.addSublayer(self.avPlayerLayer)


              self.player.play()

              self.photoView.isHidden = true
              
              
              toStartJobVideo = video!


          }

      }
    
    
    func viewToFinishJob(photo:UIImage?, video : URL?){
        
       
        self.confirmFinishButton.isHidden = false
        self.cancelFinishButton.isHidden = false
      
        self.time.isHidden = true
        self.finishJob.isHidden = true
        self.modeToFinishJob = true
        
        self.mediaButton.isHidden = true

        if photo != nil {

            self.player.pause()
            toFinishJobPhoto = photo!
            self.photoView.isHidden = false
            self.photoView.image = photo!
            
        }
        
        
        if video != nil {
            
            

            self.player.pause()
            self.player = AVPlayer(url: video!)

            self.avPlayerLayer = AVPlayerLayer(player: self.player)
            self.avPlayerLayer.frame = self.viewToCapture.frame
            self.avPlayerLayer.videoGravity = .resizeAspectFill
            self.viewToCapture.layer.sublayers = nil
            self.viewToCapture.layer.addSublayer(self.avPlayerLayer)


            self.player.play()

            self.photoView.isHidden = true
            
            
            toFinishJobVideo = video!


        }

    }
    
    
    @objc func touchAccept(_ sender: UIButton){
        
        
      
        let alert = UIAlertController(title: NSLocalizedString("Accept Job", comment: ""), message: NSLocalizedString("Are you sure you want to accept this job?", comment: ""), preferredStyle: .alert)
                    
              if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.permittedArrowDirections = []
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
              }


              let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { action in
                
                  sender.loadingIndicatorWhite(true)
                
                
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {

                    sender.loadingIndicatorWhite(false)

                    let takeVideo = CameraViewController(videoToAcceptJob: true, requestWorkerVC: self)
                    self.navigationController?.pushViewController(takeVideo, animated: true)


                })
                
                
                

                  
              })
              alert.addAction(yesAction)



              let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)

              alert.addAction(noAction)


              DispatchQueue.main.async {
                self.present(alert, animated: true)
                
              }
         
           
      
        
    }
    
    
    
    
    @objc func touchCancelFinish(_ sender: UIButton){

           
           self.modeToStartJob = false
             self.modeToFinishJob = false
             self.modeToAcceptJob = false
        self.oldMedia = -1
        
           self.updateMedias()
            self.updateRequest(withMedia: true)

            self.toFinishJobVideo = nil
            self.toFinishJobPhoto = nil
        
        

    }
       
    
    
    @objc func touchCancelStart(_ sender: UIButton){

        
        self.modeToStartJob = false
        self.modeToFinishJob = false
        self.modeToAcceptJob = false
        self.oldMedia = -1

        self.updateMedias()
        self.updateRequest(withMedia: true)
        
        self.toStartJobVideo = nil
        self.toStartJobPhoto = nil

    }
    
    
    @objc func touchCancel(_ sender: UIButton){

        self.modeToStartJob = false
        self.modeToFinishJob = false
        self.modeToAcceptJob = false
        self.oldMedia = -1

        
        self.updateMedias()
        self.updateRequest(withMedia: true)
        
        self.sendButton.isHidden = true
        self.cancelButton.isHidden = true
        self.refuseButton.isHidden = false
        self.acceptButton.isHidden = false
        
        self.toAcceptJobPhoto = nil
        self.toAcceptJobVideo = nil
        
        
    }
    
    
    
    
    @objc func touchSend(_ sender: UIButton){

        sender.loadingIndicatorWhite(true)

        self.request.fetchInBackground() { (requestFetched, error) in


            if self.request.object(forKey: Brain.kRequestState) as! String == "pending" {

               
                
                if self.toAcceptJobPhoto != nil {
                    
                    let imageData = UIImageJPEGRepresentation(self.toAcceptJobPhoto!, 0.5)
                    let imageFile = PFFile(name:"welcome.png", data:imageData!)
                    imageFile!.saveInBackground()
                    self.request.setObject(imageFile!, forKey: Brain.kRequestPhotoWelcome)

                }
                
                if self.toAcceptJobVideo != nil {
                    
                   
                    do {
                                       
                       let data = try Data(contentsOf: self.toAcceptJobVideo!)

                        let video = PFFile(name:"welcome.mov", data:data)
                        video!.saveInBackground()
                        self.request.setObject(video!, forKey: Brain.kRequestVideoWelcome)
                           
                       } catch {
                           print("error ici : \(error)")
                       }
                    
                    
                    let image: UIImage? = thumbnailImageFor(fileUrl: self.toAcceptJobVideo!)
                    
                    if image != nil {
                        
                        let imageData = UIImageJPEGRepresentation(image!, 0.5)
                        let img = PFFile(name:"welcome.png", data:imageData!)
                        img!.saveInBackground()
                        self.request.setObject(img!, forKey: Brain.kRequestPhotoWelcome)
                        
                    }


                }
                
                
                
                self.request.setObject("accepted", forKey: Brain.kRequestState)
                                       self.request.setObject(PFUser.current()!, forKey: Brain.kRequestWorker)
                                       self.request.saveInBackground { (object, error) in

                                       
                                           

                  
                               PFCloud.callFunction(inBackground: "ChargeCustomForRequestAccepted", withParameters: ["requestId":self.request.objectId!], block: { (object, error) in
                                  
                                  
                                  if error != nil {
                                      
                                    
                                               sender.loadingIndicatorWhite(false)


                                                  let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                  appDelegate.tabBarController?.exploreViewController?.getRequests()


                                                  let alert = UIAlertController(title: NSLocalizedString("Job Not Available", comment: ""), message: NSLocalizedString("Sorry, this work is unfortunately no longer available", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                                                 if let popoverController = alert.popoverPresentationController {
                                                     popoverController.sourceView = self.view
                                                     popoverController.permittedArrowDirections = []
                                                     popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                                                 }



                                                  let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { action in


                                                      self.navigationController?.popViewController(animated: true)


                                                  })

                                                  alert.addAction(okAction)

                                                 self.present(alert, animated: true, completion: nil)
                                   
                                   
                                      
                                  }else{
                                      
                                     let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                       appDelegate.tabBarController?.exploreViewController?.getRequests()
                                                       appDelegate.tabBarController?.jobsViewController?.getRequests()
                                                       appDelegate.tabBarController?.selectedIndex = 1

                                                       
                                                       self.modeToAcceptJob = false
                                                       
                                                       self.currentMedia = 1
                                                       self.enableEndLoopVideoAndSoundOn()
                                                       self.updateRequest(withMedia: true)

                                                       sender.loadingIndicatorWhite(false)

                                                      
                                      
                                   
                                   
                                  }
                                  
                                  
                              })
                               




               }

                
                
                
             
             


            }else{


                sender.loadingIndicatorWhite(false)


                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.tabBarController?.exploreViewController?.getRequests()


                let alert = UIAlertController(title: NSLocalizedString("Job Not Available", comment: ""), message: NSLocalizedString("Sorry, this work is unfortunately no longer available", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
               if let popoverController = alert.popoverPresentationController {
                   popoverController.sourceView = self.view
                   popoverController.permittedArrowDirections = []
                   popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
               }



                let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { action in


                    self.navigationController?.popViewController(animated: true)


                })

                alert.addAction(okAction)

               self.present(alert, animated: true, completion: nil)

            }

        }



    }
    
    
    
    @objc func touchConfirmStart(_ sender: UIButton){

        
        
        sender.loadingIndicatorWhite(true)


            
            if self.toStartJobPhoto != nil {
                
                let imageData = UIImageJPEGRepresentation(self.toStartJobPhoto!, 0.5)
                let imageFile = PFFile(name:"start.png", data:imageData!)
                imageFile!.saveInBackground()
                self.request.setObject(imageFile!, forKey: Brain.kRequestPhotoStart)

            }
            
            if self.toStartJobVideo != nil {
                
               
                do {
                                   
                   let data = try Data(contentsOf: self.toStartJobVideo!)

                    let video = PFFile(name:"start.mov", data:data)
                    video!.saveInBackground()
                    self.request.setObject(video!, forKey: Brain.kRequestVideoStart)
                       
                   } catch {
                       print("error ici : \(error)")
                   }
                
                
                let image: UIImage? = thumbnailImageFor(fileUrl: self.toStartJobVideo!)
                
                if image != nil {
                    
                    let imageData = UIImageJPEGRepresentation(image!, 0.5)
                    let img = PFFile(name:"start.png", data:imageData!)
                    img!.saveInBackground()
                    self.request.setObject(img!, forKey: Brain.kRequestPhotoStart)
                    
                }


            }
            

            self.request.setObject("started", forKey: Brain.kRequestState)
            self.request.setObject(Date(), forKey: Brain.kRequestTimeStart)
            self.request.saveInBackground { (object, error) in

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.tabBarController?.exploreViewController?.getRequests()
                appDelegate.tabBarController?.jobsViewController?.getRequests()
                appDelegate.tabBarController?.selectedIndex = 1

                
                
                self.modeToStartJob = false
                
                self.currentMedia = 2
                self.updateRequest(withMedia: true)
                self.enableEndLoopVideoAndSoundOn()

                sender.loadingIndicatorWhite(false)


            }



      
        

    }
    
    
    @objc func touchConfirmFinish(_ sender: UIButton){

        
        sender.loadingIndicatorWhite(true)


        
        if self.toFinishJobPhoto != nil {
            
            let imageData = UIImageJPEGRepresentation(self.toFinishJobPhoto!, 0.5)
            let imageFile = PFFile(name:"end.png", data:imageData!)
            imageFile!.saveInBackground()
            self.request.setObject(imageFile!, forKey: Brain.kRequestPhotoEnd)

        }
        
        if self.toFinishJobVideo != nil {
            
           
            do {
                               
               let data = try Data(contentsOf: self.toFinishJobVideo!)

                let video = PFFile(name:"end.mov", data:data)
                video!.saveInBackground()
                self.request.setObject(video!, forKey: Brain.kRequestVideoEnd)
                   
               } catch {
                   print("error ici : \(error)")
               }
            
            let image: UIImage? = thumbnailImageFor(fileUrl: self.toFinishJobVideo!)
            
            if image != nil {
                
                let imageData = UIImageJPEGRepresentation(image!, 0.5)
                let img = PFFile(name:"end.png", data:imageData!)
                img!.saveInBackground()
                self.request.setObject(img!, forKey: Brain.kRequestPhotoEnd)
                
            }


        }
        
        
        
                  
                  
          PFCloud.callFunction(inBackground: "CaptureChargeForRequestDone", withParameters: ["requestId":self.request.objectId!], block: { (object, error) in
             
             
             self.request.setObject("ended", forKey: Brain.kRequestState)
                    self.request.saveInBackground { (object, error) in

                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.tabBarController?.exploreViewController?.getRequests()
                        appDelegate.tabBarController?.jobsViewController?.getRequests()
                        appDelegate.tabBarController?.selectedIndex = 1

                        
                        self.modeToFinishJob = false
                        
                        self.currentMedia = 3
                        self.updateRequest(withMedia: true)
                        self.enableEndLoopVideoAndSoundOn()

                        sender.loadingIndicatorWhite(false)


                    }
             
         })
          

       

       


        
    }
    
    
    
    @objc func touchKms(_ sender: UIButton){

        
        
        var adress = self.request.object(forKey: Brain.kRequestAddress) as! String
        
        
        let alert = UIAlertController(title: NSLocalizedString(adress, comment: ""), message: nil, preferredStyle: .actionSheet)
              
              if let popoverController = alert.popoverPresentationController {
                  popoverController.sourceView = self.view
                  popoverController.permittedArrowDirections = []
                  popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
              }
              
              adress = adress.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
              
              
              let maps = UIAlertAction(title: NSLocalizedString("Open in Maps", comment: ""), style: .default, handler: { action in
                  
                  
                  UIApplication.shared.open(URL(string: "http://maps.apple.com/?q=\(adress)")!, options: [:], completionHandler: nil)
                  
                  
              })
              maps.setValue(UIColor.black, forKey: "titleTextColor")
              alert.addAction(maps)
              
              
              let googlemaps = UIAlertAction(title: NSLocalizedString("Open in Google Maps", comment: ""), style: .default, handler: { action in
                  
                  
                  UIApplication.shared.open(URL(string: "comgooglemaps://?q=\(adress)")!, options: [:], completionHandler: nil)
                  
                  
              })
              googlemaps.setValue(UIColor.black, forKey: "titleTextColor")
              alert.addAction(googlemaps)
              
              
              
              
              let noAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
              alert.addAction(noAction)
              
              
              DispatchQueue.main.async {
                  self.present(alert, animated: true)
                  
              }

    }


    @objc func touchStartJob(_ sender: UIButton){


          let alert = UIAlertController(title: NSLocalizedString("Start Job", comment: ""), message: NSLocalizedString("You must be at the place of the request in order to start this job.", comment: ""), preferredStyle: .alert)
                      
                if let popoverController = alert.popoverPresentationController {
                  popoverController.sourceView = self.view
                  popoverController.permittedArrowDirections = []
                  popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                }


                let yesAction = UIAlertAction(title: NSLocalizedString("Yes, I'm here", comment: ""), style: .default, handler: { action in
                  
                   sender.loadingIndicatorWhite(true)
                                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {

                      sender.loadingIndicatorWhite(false)

                      let takeVideo = CameraViewController(videoToStartJob: true, requestWorkerVC: self)
                      self.navigationController?.pushViewController(takeVideo, animated: true)


                  })
                                  
                    
                    
                })
                alert.addAction(yesAction)



                let noAction = UIAlertAction(title: NSLocalizedString("Not yet", comment: ""), style: .cancel, handler: nil)

                alert.addAction(noAction)


                DispatchQueue.main.async {
                  self.present(alert, animated: true)
                  
                }
           
             
        
        

    }


    @objc func touchFinishJob(_ sender: UIButton){


             let alert = UIAlertController(title: NSLocalizedString("Finish Job", comment: ""), message: NSLocalizedString("Are you sure you have completed the request in its entirety by providing quality work?", comment: ""), preferredStyle: .alert)
                         
                   if let popoverController = alert.popoverPresentationController {
                     popoverController.sourceView = self.view
                     popoverController.permittedArrowDirections = []
                     popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                   }


                   let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { action in
                     
                      sender.loadingIndicatorWhite(true)
                                     
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {

                         sender.loadingIndicatorWhite(false)

                         let takeVideo = CameraViewController(videoToFinishJob: true, requestWorkerVC: self)
                         self.navigationController?.pushViewController(takeVideo, animated: true)


                     })
                                     
                       
                       
                   })
                   alert.addAction(yesAction)



                   let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)

                   alert.addAction(noAction)


                   DispatchQueue.main.async {
                     self.present(alert, animated: true)
                     
                   }
              
                
           
           

       }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
        if timer == nil {
                 timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
             }

        
      self.updateRequest(withMedia: true)

        
      self.enableEndLoopVideoAndSoundOn()

        
    }
    
    
    
    func enableEndLoopVideoAndSoundOn(){
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        
        // Allow background audio to continue to play
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch let error as NSError {
            print(error)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error)
        }
        

    }
    
    
    @objc func applicationWillResignActive() {
        
        
       player?.pause()

        
    }
    @objc func appWillEnterForegroundNotification() {
        
        self.enableEndLoopVideoAndSoundOn()
        self.updateRequest(withMedia: true)

    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        
        
       

    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        super.viewDidDisappear(animated)
        
        self.stopTimer()

        
        

            player?.pause()

       
        
        NotificationCenter.default.removeObserver(self)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    
   @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
                
    
        print("ENNND")

        if self.modeToAcceptJob == true || self.modeToStartJob == true || self.modeToFinishJob == true{
            
            self.player.pause()
            self.player!.seek(to: kCMTimeZero)
            self.player.play()
            
        }else{
            
            self.tapView()

            
        }
        
    }
}
