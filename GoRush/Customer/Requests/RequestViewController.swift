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
import Intercom

class RequestViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    var overlayView : UIView!
    var frontCamera : Bool!
    
    var photoView : PFImageView!
    var profilePicture : PFImageView!

    var player: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    
    var viewToCapture : UIView!
    
    var cancelButton : UIButton!
    var request : PFObject!
    var service : PFObject!
    
    
    var filter : UIImageView!
    
    var titleVC : UILabel!
    var backButton : UIButton!
    
    
    var iconService : PFImageView!
    var labelService : UILabel!
    
    var iconBoost : UIImageView!
    var labelBoost : UILabel!
    
    var iconWhere : UIImageView!
    var labelWhere : UILabel!
    var buttonWhere : UIButton!
    
    
    var iconWhen : UIImageView!
    var labelWhen : UILabel!
    
    var iconPhotos : UIImageView!
    var labelPhotos : UILabel!
    var buttonPhotos : UIButton!

    var labelSize : UIButton!
    var labelPrice : UILabel!
    
    var loadingVideo : UIActivityIndicatorView!
    
    
    var mediaButton : UIButton!
    
    var medias = [[PFFileObject]]()
    var currentMedia = 0
    var oldMedia = -1
    
    
    var timer : Timer!
    
    var worker : PFUser?
    
    var reviewButton : UIButton!
    
    var profileButton : UIButton!
    

    

    
    
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

        self.loadingVideo = UIActivityIndicatorView(style: .white)
        self.loadingVideo.center = CGPoint(x: Brain.kLargeurIphone - 34, y: yTop() + 34)
        self.view.addSubview(loadingVideo)

        cancelButton = UIButton(frame: CGRect(x:20, y: yTopBottomButtonCTA(), width:Brain.kLargeurIphone-40, height: 60))
        cancelButton.layer.cornerRadius = 30;
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 1.5
        cancelButton.setTitle(NSLocalizedString("Cancel request", comment: ""), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitleColor(UIColor.gray, for: .highlighted)
        cancelButton.addTarget(self, action: #selector(touchCancel(_:)), for: .touchUpInside)
        view.addSubview(cancelButton)



        self.iconService = PFImageView(frame: CGRect(x: 20, y: yTop() + 80, width: 20, height: 20))
        self.iconService.layer.applySketchShadow()
        view.addSubview(iconService)


        self.labelService = UILabel(frame: CGRect(x: 48, y: iconService.y(), width: Brain.kLargeurIphone  - 70, height: 20))
        self.labelService.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelService.textColor = .white
        self.labelService.layer.applySketchShadow()
        self.view.addSubview(labelService)


        //Boost
        self.iconBoost = PFImageView(frame: CGRect(x: 20, y: self.labelService.yBottom() + 12, width: 20, height: 20))
        self.iconBoost.image = UIImage(named: "iconBoost")
        self.iconBoost.layer.applySketchShadow()
        view.addSubview(iconBoost)
        
        self.labelBoost = UILabel(frame: CGRect(x: 48, y: iconBoost.y(), width: Brain.kLargeurIphone  - 70, height: 20))
        self.labelBoost.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelBoost.textColor = .white
        self.labelBoost.layer.applySketchShadow()
        self.view.addSubview(labelBoost)
        
        //Where
        self.iconWhere = UIImageView(frame: CGRect(x: 20, y: self.labelBoost.yBottom() + 12, width: 20, height: 20))
        self.iconWhere.image = UIImage(named: "iconWhere")
        self.iconWhere.layer.applySketchShadow()
        view.addSubview(iconWhere)

        self.labelWhere = UILabel(frame: CGRect(x: 48, y: iconWhere.y(), width: Brain.kLargeurIphone - 70, height: 20))
        self.labelWhere.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelWhere.textColor = .white
        self.labelWhere.layer.applySketchShadow()
        self.view.addSubview(labelWhere)
        
        self.buttonWhere = UIButton(frame: CGRect(x: 20, y: self.iconWhere.y() - 10, width: 200, height: 40))
        self.buttonWhere.addTarget(self, action: #selector(touchWhere(_:)), for: .touchUpInside)
        self.view.addSubview(buttonWhere)

        
        //When
        self.iconWhen = PFImageView(frame: CGRect(x: 20, y:  self.labelWhere.yBottom() + 12, width: 20, height: 20))
        self.iconWhen.image = UIImage(named: "iconWhen")
        self.iconWhen.layer.applySketchShadow()
        view.addSubview(iconWhen)

        self.labelWhen = UILabel(frame: CGRect(x: 48, y: iconWhen.y(), width: Brain.kLargeurIphone  - 70, height: 20))
        self.labelWhen.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelWhen.textColor = .white
        self.labelWhen.layer.applySketchShadow()
        self.view.addSubview(labelWhen)
        
        
        //Photos
        self.iconPhotos = PFImageView(frame: CGRect(x: 20, y: self.labelWhen.yBottom() + 12, width: 20, height: 20))
        self.iconPhotos.image = UIImage(named: "iconPhotos")
        self.iconPhotos.layer.applySketchShadow()
        view.addSubview(iconPhotos)

        self.labelPhotos = UILabel(frame: CGRect(x: 48, y: iconPhotos.y(), width: Brain.kLargeurIphone  - 70, height: 20))
        self.labelPhotos.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelPhotos.textColor = .white
        self.labelPhotos.layer.applySketchShadow()
        self.view.addSubview(labelPhotos)

        self.buttonPhotos = UIButton(frame: CGRect(x: 20, y: self.iconPhotos.y() - 10, width: 200, height: 40))
        self.buttonPhotos.addTarget(self, action: #selector(touchPhotos(_:)), for: .touchUpInside)
        self.view.addSubview(buttonPhotos)

        self.labelSize = UIButton(frame: CGRect(x: 20, y: self.labelPhotos.yBottom() + 12, width: 120, height: 38))
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
        self.mediaButton.layer.applySketchShadow()
        self.mediaButton.isUserInteractionEnabled = false
        self.view.addSubview(mediaButton)

        reviewButton = UIButton(frame: CGRect(x:20, y: yTopBottomButtonCTA(), width:Brain.kLargeurIphone-40, height: 60))
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

    @objc func touchPhotos(_ sender: UIButton){

        
        let photos = PhotosViewController(request: self.request)
        photos.modalPresentationStyle = .overCurrentContext
        self.present(photos, animated: false) {
            
        }
        print("OPEN PHOTOS")
    }
    @objc func touchWhere(_ sender: UIButton){

        var adress =  ""
        if self.request.object(forKey: Brain.kRequestAddress) != nil {

            adress = self.request.object(forKey: Brain.kRequestAddress) as! String

        }else{

            return

        }

        let alert = UIAlertController(title: adress, message: nil, preferredStyle: .actionSheet)
        adress = adress.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        let maps = UIAlertAction(title: NSLocalizedString("Open in Maps", comment: ""), style: .default, handler: { action in
           
           UIApplication.shared.open(URL(string: "http://maps.apple.com/?q=\(adress)")!, options: [:], completionHandler: nil)
           
        })
        alert.addAction(maps)


        let googlemaps = UIAlertAction(title: NSLocalizedString("Open in Google Maps", comment: ""), style: .default, handler: { action in
           
           UIApplication.shared.open(URL(string: "comgooglemaps://?q=\(adress)")!, options: [:], completionHandler: nil)
           
        })
        alert.addAction(googlemaps)


        let noAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(noAction)

        DispatchQueue.main.async {
           self.present(alert, animated: true)
           
        }
    }
    
    @objc func touchSize(_ sender: UIButton){

        
        let mowing = LandViewController(request: self.request)
        mowing.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mowing, animated: true)

    }
    
    @objc func touchProfile(_ sender: UIButton){

        if self.request.object(forKey: Brain.kRequestWorker) != nil {
            
            let reviews = ReviewsViewController(user: self.request.object(forKey: Brain.kRequestWorker) as! PFUser, fromWorker: false)
            self.present(reviews, animated: true) {}

        }
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
        
           self.medias = [[PFFileObject]]()
               
            if self.request.object(forKey: Brain.kRequestPhoto) != nil {

                            
                if self.request.object(forKey: Brain.kRequestVideo) != nil {

                    self.medias.append([self.request.object(forKey: Brain.kRequestPhoto) as! PFFileObject,self.request.object(forKey: Brain.kRequestVideo) as! PFFileObject])

                    
                }else{
                    
                    self.medias.append([self.request.object(forKey: Brain.kRequestPhoto) as! PFFileObject])

                }
            }
         
         

          if self.request.object(forKey: Brain.kRequestPhotoStart) != nil {


              if self.request.object(forKey: Brain.kRequestVideoStart) != nil {

                self.medias.append([self.request.object(forKey: Brain.kRequestPhotoStart) as! PFFileObject,self.request.object(forKey: Brain.kRequestVideoStart) as! PFFileObject])

                
              }else{
                
                self.medias.append([self.request.object(forKey: Brain.kRequestPhotoStart) as! PFFileObject])

              }
          }
      
      
          if self.request.object(forKey: Brain.kRequestPhotoEnd) != nil {


             if self.request.object(forKey: Brain.kRequestVideoEnd) != nil {

               self.medias.append([self.request.object(forKey: Brain.kRequestPhotoEnd) as! PFFileObject,self.request.object(forKey: Brain.kRequestVideoEnd) as! PFFileObject])

               
             }else{
               
               self.medias.append([self.request.object(forKey: Brain.kRequestPhotoEnd) as! PFFileObject])

             }
          }
        
    }
    
    
    func updateRequest(){
        
        
        self.iconBoost.frame.origin.y = self.labelService.yBottom() + 12
        self.labelBoost.frame.origin.y = self.iconBoost.frame.origin.y

        var priceBoost = Double(0)


        if self.request.object(forKey: Brain.kRequestBoost) != nil {
           
           self.labelBoost.isHidden = false
           self.iconBoost.isHidden = false
           self.iconWhere.frame.origin.y = self.labelBoost.yBottom() + 12
           
           var boostName = ""
           let boosts = self.request.object(forKey: Brain.kRequestBoost) as! [[String:Any]]
           
           
           for i in 0..<boosts.count {
               
               let boost = boosts[i]
              
               if i == boosts.count - 1 {
                  
                   boostName = boostName + String(format:"%@", boost[Brain.kName.localizableName()] as! String)

               }else{
                   
                   boostName = boostName + String(format:"%@ & ", boost[Brain.kName.localizableName()] as! String)
               }
               
               priceBoost = priceBoost + Double(truncating: boost[Brain.kBoostPrice] as! NSNumber)
               
           }
           
           self.labelBoost.text = boostName


        }else{
           
           self.labelBoost.isHidden = true
           self.iconBoost.isHidden = true
           self.iconWhere.frame.origin.y = self.labelService.yBottom() + 12

        }
        self.labelWhere.frame.origin.y = self.iconWhere.frame.origin.y
        self.buttonWhere.frame.origin.y = self.iconWhere.y() - 10

        self.iconWhen.frame.origin.y = self.labelWhere.yBottom() + 12
        self.labelWhen.frame.origin.y = self.iconWhen.frame.origin.y


        self.iconPhotos.frame.origin.y = self.labelWhen.yBottom() + 12
        self.labelPhotos.frame.origin.y = self.iconPhotos.frame.origin.y
        self.buttonPhotos.frame.origin.y = self.iconPhotos.y() - 10

        if self.request.object(forKey: Brain.kRequestPhotos) != nil {
          
          self.labelPhotos.isHidden = false
          self.iconPhotos.isHidden = false
          self.buttonPhotos.isHidden = false

          self.labelSize.frame.origin.y = self.labelPhotos.yBottom() + 12
           
           self.labelPhotos.text = String(format:"%d", (self.request.object(forKey: Brain.kRequestPhotos) as! [PFFileObject]).count)

        }else{
          
          self.labelPhotos.isHidden = true
          self.buttonPhotos.isHidden = true
          self.iconPhotos.isHidden = true
          self.labelSize.frame.origin.y = self.labelWhen.yBottom() + 12

        }

           
        self.labelPrice.frame.origin.y = self.labelSize.yBottom() + 10

        self.mediaButton.frame.origin.y = self.labelPrice.yBottom() + 10

        
        self.updateMedias()
        
        
        if self.medias.count > self.currentMedia {
            
            self.photoView.file = self.medias[self.currentMedia][0]
            self.photoView.loadInBackground()
            
            
            if self.medias[self.currentMedia].count > 1 {
                
                

                NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
                
                
                // Allow background audio to continue to play
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
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
                        
                        self.player!.seek(to: CMTime.zero)
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
            
            self.mediaButton.setBackgroundImage(UIImage(named: "step2"), for: .normal)

        }else if self.currentMedia == 2 {
            
            self.mediaButton.setBackgroundImage(UIImage(named: "step3"), for: .normal)

        }else{
            
            self.mediaButton.setBackgroundImage(UIImage(named: "step0"), for: .normal)

        }
        

        self.iconService.file = self.service.object(forKey: Brain.kServiceIcon) as? PFFileObject
        self.iconService.loadInBackground()


        self.labelService.text = Utils.returnCodeLangageEnFr() == "fr" ?  self.service.object(forKey: Brain.kServicesNameFr) as? String : self.service.object(forKey: Brain.kServicesName) as? String
        
        
        
        self.labelWhere.text = self.request.object(forKey: Brain.kRequestAddress) as? String



        self.labelSize.setTitle(String(format: NSLocalizedString("≅%dpi²", comment: ""), self.request.object(forKey: Brain.kRequestSurface) as! Int), for: .normal)


        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 40), NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.white]


        let attributedString1 = NSMutableAttributedString(string:String(format: "%.2f", self.request.object(forKey: Brain.kRequestPriceCustomer) as! Double), attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"$", attributes:attrs2)

        attributedString1.append(attributedString2)
        self.labelPrice.attributedText = attributedString1
        
        self.cancelButton.isHidden = true
        
        self.profilePicture.isHidden = true
        self.titleVC.frame.origin.x = 0
        self.titleVC.frame.size.width = Brain.kLargeurIphone

        if self.request.object(forKey: Brain.kRequestWorker) != nil {
            
            self.worker = self.request.object(forKey: Brain.kRequestWorker) as? PFUser
        }

        
       if self.worker != nil {
                      
              if self.worker!.object(forKey: Brain.kUserProfilePicture) != nil {
                                  
                  self.titleVC.frame.origin.x = 25
                  self.profilePicture.file = self.worker!.object(forKey: Brain.kUserProfilePicture) as? PFFileObject
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
            
           
            self.titleVC.text = NSLocalizedString("Pending request", comment: "")

        }else if self.request.object(forKey: Brain.kRequestState) as! String == "accepted" {
            
            self.cancelButton.isHidden = false

            if self.worker != nil {
               
               self.titleVC.text = String(format: NSLocalizedString("Accepted by %@", comment: ""), self.worker!.object(forKey: Brain.kUserFirstName) as! String)

           }else{
               
               self.titleVC.text = NSLocalizedString("Pending request", comment: "")

           }

            
        }else if self.request.object(forKey: Brain.kRequestState) as! String == "started" {
            
           
            if self.worker != nil {
                         
                 self.titleVC.text = String(format: NSLocalizedString("Started by %@", comment: ""), self.worker!.object(forKey: Brain.kUserFirstName) as! String)

             }else{
                 
                 self.titleVC.text = NSLocalizedString("Started request", comment: "")

             }
            
        }else if self.request.object(forKey: Brain.kRequestState) as! String == "ended" {
            
            
            if self.worker != nil {
                         
                 self.titleVC.text = String(format: NSLocalizedString("Ended by %@", comment: ""), self.worker!.object(forKey: Brain.kUserFirstName) as! String)
                 self.reviewButton.setTitle(String(format: "Review %@", self.worker!.object(forKey: Brain.kUserFirstName) as! String), for: .normal)
                
                if self.request.object(forKey: Brain.kRequestReviewFromCustomer) != nil {
                    
                    self.reviewButton.isHidden = true

                }else{
                    
                    
                    self.reviewButton.isHidden = false

                }

             }else{
                 
                 self.titleVC.text = NSLocalizedString("Ended request", comment: "")

             }
            

            
            
        }else {
            
            
        }

        
        if self.profilePicture.isHidden == false {
            
            self.titleVC.sizeToFit()
            
            let largeur = self.profilePicture.w() + 8 + self.titleVC.w()
            self.profilePicture.frame.origin.x = (Brain.kLargeurIphone - largeur ) / 2
            self.titleVC.frame.origin.x = self.profilePicture.w() + self.profilePicture.x() + 8
            
        }
          
        
    }
    
    @objc func updateTime(){

        if self.request.object(forKey: Brain.kRequestTimeEnd) != nil {
             
             //Static
             let dateFormat = DateFormatter()
             dateFormat.dateFormat = "EEEE dd MMMM"
             self.labelWhen.text = String(format: "%@", dateFormat.string(from: self.request.object(forKey: Brain.kRequestTimeEnd) as! Date)).firstCapitalized

             
         }else if self.request.object(forKey: Brain.kRequestTimeStart) != nil {
             
             //Timer croissant
             let cal = Calendar.current
             let d1 = Date()
             let d2 = self.request.object(forKey: Brain.kRequestTimeStart) as! Date
             let components = cal.dateComponents([.hour,.minute,.second], from: d2, to: d1)

             self.labelWhen.text = String(format: "%.2d:%.2d:%.2d", components.hour!,components.minute!,components.second!)
             
         }else if self.request.object(forKey: Brain.kRequestTimeLimit) != nil {
             
             if self.request.object(forKey: Brain.kRequestTimeLimit) as! Date > Date() {
                 

                  //Timer decroissant
                  let cal = Calendar.current
                  let d1 = self.request.object(forKey: Brain.kRequestTimeLimit) as! Date
                  let d2 = Date()
                  let components = cal.dateComponents([.hour,.minute,.second], from: d2, to: d1)
                  
                  self.labelWhen.text = String(format: "%.2d:%.2d:%.2d", components.hour!,components.minute!,components.second!)

             }else{
                 
                 
                 //Static
                 let dateFormat = DateFormatter()
                 dateFormat.dateFormat = "EEEE dd MMMM"
                self.labelWhen.text = String(format: "%@", dateFormat.string(from: self.request.createdAt!)).firstCapitalized

             }
          
         }else{
             

             //Static
             let dateFormat = DateFormatter()
             dateFormat.dateFormat = "EEEE dd MMMM"
             self.labelWhen.text = String(format: "%@", dateFormat.string(from: self.request.createdAt!)).firstCapitalized


         }
          
    }
    

    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func touchCancel(_ sender: UIButton){
        
        
        if self.request.object(forKey: Brain.kRequestState) as! String == "pending" {
            
            let alert = UIAlertController(title: NSLocalizedString("Cancel request", comment: ""), message: NSLocalizedString("Are you sure you want to cancel this request?", comment: ""), preferredStyle: .alert)
                  
            let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { action in
              
                
                Intercom.logEvent(withName: "customer_cancelRequest")

                
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
            let total = Double(cancellationFee)/100 * (self.request.object(forKey: Brain.kRequestPriceCustomer) as! Double)
            
            Intercom.logEvent(withName: "customer_cancelRequestAfterAccepted", metaData: ["fees":total])

            
            let alert = UIAlertController(title: NSLocalizedString("Cancel request", comment: ""),
                                          message: String(format: NSLocalizedString("A worker has already accepted your request. So you will have to pay %.2f$, %d%% of the request. The rest will be refunded to you.\n\nAre you sure you want to cancel this request?", comment: ""), total,cancellationFee), preferredStyle: .alert)
                         
                 
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
        name: UIApplication.willEnterForegroundNotification, object: nil)

        NotificationCenter.default.addObserver(self,
        selector: #selector(applicationWillResignActive),
        name: UIApplication.willResignActiveNotification,
        object: nil)


        NotificationCenter.default.addObserver(self,
        selector: #selector(appWillEnterForegroundNotification),
        name: UIApplication.didBecomeActiveNotification,
        object: nil)



        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        self.updateTime()


        self.updateRequest()

        Intercom.logEvent(withName: "customer_openRequestView")

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


        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
     
       
        if timer != nil {
                  
          timer.invalidate()

        }
        
        
    }
    
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
                

        self.tapView()
        
    }
}
