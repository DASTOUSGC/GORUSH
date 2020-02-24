//
//  RequestViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-12-28.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Parse
import Photos

class RequestViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    var overlayView : UIView!
    var frontCamera : Bool!
    
    var photoView : PFImageView!
    var profilePicture : PFImageView!

    var player: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    
    var viewToCapture : UIView!
    
    var cancelButton : UIButton!
    var timeButton : UIButton!
    var request : PFObject!
    var service : PFObject!
    
    
    var filter : UIImageView!
    
    var titleVC : UILabel!
    var backButton : UIButton!
    
    
    var iconService : PFImageView!
    var labelService : UILabel!
    
    var iconWhere : UIImageView!
    var labelWhere : UILabel!
    var labelSize : UIButton!
    var labelPrice : UILabel!
    
    var loadingVideo : UIActivityIndicatorView!
    
    
    var mediaButton : UIButton!
    
    var medias = [[PFFile]]()
    var currentMedia = 0
    var oldMedia = -1
    
    
    var timeJob : Timer!
    
    var worker : PFUser?
    
    var reviewButton : UIButton!
    
    var profileButton : UIButton!
    
    var timer: Timer?

    
//
//    enum State: String {
//        case pending = "pending"
//        case accepted = "accepted"
//        case finished = "finished"
//        case canceled = "canceled"
//    }
    
    
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
        
        
        self.updateMedias()

        self.currentMedia = self.medias.count - 1
     
        
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

        
        
        self.titleVC = UILabel(frame: CGRect(x: 0, y: yTop() + 26, width: Brain.kLargeurIphone, height: 20))
        self.titleVC.textAlignment = .center
        self.titleVC.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.titleVC.textColor = .white
        self.titleVC.text = NSLocalizedString("Pending Request", comment: "")
        self.view.addSubview(titleVC)
        
        self.profilePicture = PFImageView(frame: CGRect(x: Brain.kLargeurIphone / 2 - 80, y: yTop() + 22, width: 28, height: 28))
        self.profilePicture.layer.cornerRadius = 14
        self.profilePicture.layer.masksToBounds = true
        self.view.addSubview(profilePicture)


        self.backButton = UIButton(frame: CGRect(x: 13, y: yTop() + 8, width: 44, height: 42))
        self.backButton.setBackgroundImage(UIImage(named: "backArrowWhite"), for: .normal)
        self.backButton.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        
        
        self.loadingVideo = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.loadingVideo.center = CGPoint(x: Brain.kLargeurIphone - 34, y: yTop() + 34)
        self.view.addSubview(loadingVideo)

        
        
        cancelButton = UIButton(frame: CGRect(x:20, y: originYBottomButtonCTA(), width:Brain.kLargeurIphone-40, height: 60))
        cancelButton.layer.cornerRadius = 30;
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 1.5
        cancelButton.setTitle(NSLocalizedString("Cancel Request", comment: ""), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitleColor(UIColor.gray, for: .highlighted)
        cancelButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        
        timeButton = UIButton(frame: CGRect(x:20, y: originYBottomButtonCTA(), width:Brain.kLargeurIphone-40, height: 60))
        timeButton.layer.cornerRadius = 30;
        timeButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        timeButton.layer.borderColor = UIColor.white.cgColor
        timeButton.layer.borderWidth = 1.5
        timeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        timeButton.setTitleColor(UIColor.white, for: .normal)
        timeButton.setTitleColor(UIColor.gray, for: .highlighted)
        view.addSubview(timeButton)
        
        
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
        self.labelSize.isUserInteractionEnabled = true
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
                 
                 self.updateRequest()
        }
    }

    
    
    @objc func touchSize(_ sender: UIButton){

        
        let mowing = LandViewController(request: self.request)
        mowing.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mowing, animated: true)

    }
    
    @objc func touchProfile(_ sender: UIButton){

    
        print("profile")
        let reviews = ReviewsViewController(user: PFUser.current()!, fromWorker: false)
        reviews.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(reviews, animated: true)

    }
    
    
    @objc func touchReview(_ sender: UIButton){

        let rateVC = NewReviewToUserViewController(user: self.worker!, request : self.request , fromWorker: false)
        self.navigationController?.pushViewController(rateVC, animated: true)
    }
    
    @objc func tapView(_ sender: UITapGestureRecognizer? = nil) {
        
        self.currentMedia = self.currentMedia + 1

        if self.medias.count > self.currentMedia {
            
        }else{
            
            self.currentMedia = 0
            
        }
        
        self.updateRequest()
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
    
    
    func updateRequest(){
        
        
        self.updateMedias()
        
        
        if self.medias.count > self.currentMedia {
            
            self.photoView.file = self.medias[self.currentMedia][0]
            self.photoView.loadInBackground()
            
            
            if self.medias[self.currentMedia].count > 1 {
                
                

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
        
        

        self.iconService.file = self.service.object(forKey: Brain.kServiceIcon) as? PFFile
        self.iconService.loadInBackground()


        self.labelService.text = self.service.object(forKey: Brain.kServicesName) as? String
        self.labelWhere.text = self.request.object(forKey: Brain.kRequestAddress) as? String



        self.labelSize.setTitle(String(format: NSLocalizedString("≅%dpi²", comment: ""), self.request.object(forKey: Brain.kRequestSurface) as! Int), for: .normal)


        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 40), NSAttributedStringKey.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.white]


        let attributedString1 = NSMutableAttributedString(string:String(format: "%.2f", self.request.object(forKey: Brain.kRequestPriceCustomer) as! Double), attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"$", attributes:attrs2)

        attributedString1.append(attributedString2)
        self.labelPrice.attributedText = attributedString1
        
        self.cancelButton.isHidden = true
        self.timeButton.isHidden = true

        if timeJob != nil {
                          
            timeJob.invalidate()

        }

        
        self.profilePicture.isHidden = true
        self.titleVC.frame.origin.x = 0
        self.titleVC.frame.size.width = Brain.kLargeurIphone

        if self.request.object(forKey: Brain.kRequestWorker) != nil {
            
            self.worker = self.request.object(forKey: Brain.kRequestWorker) as? PFUser
        }

        
       if self.worker != nil {
                      
              if self.worker!.object(forKey: Brain.kUserProfilePicture) != nil {
                                  
                  self.titleVC.frame.origin.x = 25
                  self.profilePicture.file = self.worker!.object(forKey: Brain.kUserProfilePicture) as? PFFile
                  self.profilePicture.loadInBackground()
                  self.profilePicture.isHidden = false

               }else{
                  
                  
                  self.titleVC.frame.origin.x = 0
                  self.profilePicture.isHidden = true

               }
          }
              
        
        self.profileButton.frame = CGRect(x: self.profilePicture.x(), y: self.profilePicture.y() - 10, width: Brain.kLargeurIphone - (self.profilePicture.x() * 2), height: 50)

        
        self.reviewButton.isHidden = true
        

        if self.request.object(forKey: Brain.kRequestState) as! String == "pending" {
            
            
            self.cancelButton.isHidden = false
            
           
            self.titleVC.text = NSLocalizedString("Pending Request", comment: "")

        }else if self.request.object(forKey: Brain.kRequestState) as! String == "accepted" {
            
            self.cancelButton.isHidden = false

            if self.worker != nil {
               
               self.titleVC.text = String(format: "Accepted By %@", self.worker!.object(forKey: Brain.kUserFirstName) as! String)

           }else{
               
               self.titleVC.text = NSLocalizedString("Pending Request", comment: "")

           }

            
        }else if self.request.object(forKey: Brain.kRequestState) as! String == "started" {
            
            self.timeButton.isHidden = false
           
            if self.worker != nil {
                         
                 self.titleVC.text = String(format: "Started By %@", self.worker!.object(forKey: Brain.kUserFirstName) as! String)

             }else{
                 
                 self.titleVC.text = NSLocalizedString("Started Job", comment: "")

             }
            
            self.updateTime()
                      
            timeJob = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)

            
            
        }else if self.request.object(forKey: Brain.kRequestState) as! String == "ended" {
            
            
            if self.worker != nil {
                         
                 self.titleVC.text = String(format: "Ended By %@", self.worker!.object(forKey: Brain.kUserFirstName) as! String)
                 self.reviewButton.setTitle(String(format: "Review %@", self.worker!.object(forKey: Brain.kUserFirstName) as! String), for: .normal)
                
                if self.request.object(forKey: Brain.kRequestReviewFromCustomer) != nil {
                    
                    self.reviewButton.isHidden = true

                }else{
                    
                    
                    self.reviewButton.isHidden = false

                }

             }else{
                 
                 self.titleVC.text = NSLocalizedString("Ended Job", comment: "")

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
              self.timeButton.setTitle(String(format: "Since %.2d:%.2d:%.2d", components.hour!,components.minute!,components.second!), for: .normal)
         
          }
          
      }
    

    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func touchNext(_ sender: UIButton){
        
        
        
        if self.request.object(forKey: Brain.kRequestState) as! String == "pending" {
            

            let alert = UIAlertController(title: NSLocalizedString("Cancel Request", comment: ""), message: NSLocalizedString("Are you sure you want to cancel this request?", comment: ""), preferredStyle: .alert)
                  
            if let popoverController = alert.popoverPresentationController {
              popoverController.sourceView = self.view
              popoverController.permittedArrowDirections = []
              popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }


            let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { action in
              
                
                self.cancelButton.loadingIndicatorWhite(true)
                self.request.setObject("canceled", forKey: Brain.kRequestState)
                self.request.saveInBackground { (done, error) in
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.tabBarController?.requestsViewController?.getRequests()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                        self.navigationController?.popViewController(animated: true)
                    }
                    

                }
                
                
            })
            alert.addAction(yesAction)



            let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)

            alert.addAction(noAction)


            DispatchQueue.main.async {
              self.present(alert, animated: true)
              
            }
    
    
        }else if self.request.object(forKey: Brain.kRequestState) as! String == "accepted"{
            
            
            
            let cancellationFee = self.service.object(forKey: Brain.kServiceCancellationFee) as! Int
            print("cc \(self.request.object(forKey: Brain.kRequestPriceCustomer) as! Double)")
            let total = Double(cancellationFee)/100 * (self.request.object(forKey: Brain.kRequestPriceCustomer) as! Double)
            
            
            let alert = UIAlertController(title: NSLocalizedString("Cancel Request", comment: ""),
                                          message: String(format: NSLocalizedString("Are you sure you want to cancel this request?\n\nA worker has already accepted your request. You will therefore have to pay him %.2f$, %d%% of the total cost of the mission. The rest will be refunded to you on your initial payment method.", comment: ""), total,cancellationFee), preferredStyle: .alert)
                         
                   if let popoverController = alert.popoverPresentationController {
                     popoverController.sourceView = self.view
                     popoverController.permittedArrowDirections = []
                     popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                   }


                   let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { action in
                     
                                           
                      self.cancelButton.loadingIndicatorWhite(true)
                    
                        PFCloud.callFunction(inBackground: "CancelChargeAndApplyCancellationFee", withParameters: ["requestId":self.request.objectId!], block: { (object, error) in
                                    
                                    
                                   self.request.setObject("canceled", forKey: Brain.kRequestState)
                                    self.request.saveInBackground { (done, error) in
                                        
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        appDelegate.tabBarController?.requestsViewController?.getRequests()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                                            self.navigationController?.popViewController(animated: true)
                                        }
                                        

                                    }
                                     
                        })
                    
                    
                       
                   })
                   alert.addAction(yesAction)



                   let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)

                   alert.addAction(noAction)


                   DispatchQueue.main.async {
                     self.present(alert, animated: true)
                     
                   }
                   
                   
        }
        
        
        
         
           
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
        

            NotificationCenter.default.addObserver(self,
                                                         selector: #selector(appWillEnterForegroundNotification),
                                                         name: .UIApplicationWillEnterForeground, object: nil)
                  
                  NotificationCenter.default.addObserver(self,
                                                         selector: #selector(applicationWillResignActive),
                                                         name: NSNotification.Name.UIApplicationWillResignActive,
                                                         object: nil)
                  
                  
                  NotificationCenter.default.addObserver(self,
                                                         selector: #selector(appWillEnterForegroundNotification),
                                                         name: NSNotification.Name.UIApplicationDidBecomeActive,
                                                         object: nil)
                  
       
        
                self.updateRequest()

        
        if timer == nil {
                        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
                    }

        
        
    }
    
    
    @objc func applicationWillResignActive() {
        

            player?.pause()

    }
    @objc func appWillEnterForegroundNotification() {
        
        
        self.updateRequest()

    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        
        
        
    }
    
    
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        super.viewDidDisappear(animated)
        
        
            player?.pause()

        self.stopTimer()

        
        NotificationCenter.default.removeObserver(self)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
                

        self.tapView()
        
    }
}
