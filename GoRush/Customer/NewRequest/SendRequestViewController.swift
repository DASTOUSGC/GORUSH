//
//  SendRequestViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-10-28.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//


import UIKit
import AVFoundation
import Parse
import Photos

class SendRequestViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    var overlayView : UIView!
    var frontCamera : Bool!
    
    var video: URL?
    var photo: UIImage?
    var photoView : UIImageView!
    
    
    var player: AVPlayer?
    var avPlayerLayer: AVPlayerLayer!
    
    var viewToCapture : UIView!
    
    var nextButton : UIButton!
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
    
    
    var imageCard : UIImageView!
    var fourpoints : UIImageView!
    var numberCard : UILabel!
    var check : UIImageView!
    
    var cardView : UIButton!
    
    var paymentMethodLabel : UILabel!
    var rightArrow : UIImageView!

    
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
    
    convenience init(photoTmp:UIImage?, videoTmp:URL?, frontCamera: Bool, request : PFObject)
    {
        
        self.init()
        
        
        if videoTmp != nil {
            
            self.video = videoTmp
        }
        
        if photoTmp != nil {
                   
            self.photo = photoTmp
        }
               
        
        self.frontCamera = frontCamera
        self.request = request

        self.service = self.request.object(forKey: Brain.kRequestService) as? PFObject
        
        if self.photo != nil {
            
            let imageData = UIImageJPEGRepresentation(self.photo!, 0.5)
            let imageFile = PFFile(name:"request.png", data:imageData!)
            imageFile!.saveInBackground()
            self.request.setObject(imageFile!, forKey: Brain.kRequestPhoto)

        }
        
        if self.video != nil {
            
          
           
            do {
                               
               let data = try Data(contentsOf: self.video!)

                let video = PFFile(name:"request.mov", data:data)
                video!.saveInBackground()
                self.request.setObject(video!, forKey: Brain.kRequestVideo)
                   
               } catch {
                   print("error ici : \(error)")
               }
            
            
            let image: UIImage? = thumbnailImageFor(fileUrl: self.video!)
            
            if image != nil {
                
                let imageData = UIImageJPEGRepresentation(image!, 0.5)
                let img = PFFile(name:"request.png", data:imageData!)
                img!.saveInBackground()
                self.request.setObject(img!, forKey: Brain.kRequestPhoto)
                
            }


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
        
        
        if self.video != nil {
            
            player = AVPlayer(url: video!)

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
              
        }
        
        
        self.photoView = UIImageView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
        self.photoView.backgroundColor = .clear
        self.photoView.contentMode = .scaleAspectFill
        self.view.addSubview(self.photoView)
        
        
        if self.photo != nil {
            
            self.photoView.image = self.photo!
            self.photoView.isHidden = false

        }else{
            
            self.photoView.isHidden = true

        }
      
        
        
        
        
        
        self.filter = UIImageView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
        self.filter.image = UIImage(named: "filterCamera")
        self.view.addSubview(filter)
        
        
        
        self.titleVC = UILabel(frame: CGRect(x: 0, y: yTop() + 26, width: Brain.kLargeurIphone, height: 20))
        self.titleVC.textAlignment = .center
        self.titleVC.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.titleVC.textColor = .white
        self.titleVC.text = NSLocalizedString("Send Request", comment: "")
        self.view.addSubview(titleVC)
        
        self.backButton = UIButton(frame: CGRect(x: 13, y: yTop() + 8, width: 44, height: 42))
        self.backButton.setBackgroundImage(UIImage(named: "backArrowWhite"), for: .normal)
        self.backButton.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        
        
        nextButton = UIButton(frame: CGRect(x:20, y: originYBottomButtonCTA(), width:Brain.kLargeurIphone-40, height: 60))
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Go Rush!", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.applyGradient()
        self.nextButton.loadingIndicatorWhite(true)
        self.nextButton.isEnabled = false
        view.addSubview(nextButton)
        
        
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
        self.view.addSubview(labelWhere)
        
        
        self.labelSize = UIButton(frame: CGRect(x: 20, y: self.labelWhere.yBottom() + 12, width: 120, height: 38))
        self.labelSize.backgroundColor = Brain.kColorMain
        self.labelSize.applyGradient()
        self.labelSize.layer.cornerRadius = 19
        self.labelSize.layer.masksToBounds = true
        self.labelSize.titleLabel?.font  = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.labelSize.setTitleColor(.white, for: .normal)
        self.view.addSubview(labelSize)
        
        self.labelPrice = UILabel(frame: CGRect(x: 20, y: self.labelSize.yBottom() + 10, width: Brain.kLargeurIphone - 40, height: 48))
        self.labelPrice.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        self.labelPrice.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelPrice.textColor = .white
        self.labelPrice.layer.applySketchShadow()
        self.view.addSubview(labelPrice)

        
        
        cardView = UIButton(frame: CGRect(x: 20, y: nextButton.y() - 43 , width: Brain.kLargeurIphone - 40, height: 43))
        cardView.addTarget(self, action: #selector(updatePaymentMethod(_:)), for: .touchUpInside)
        self.view.addSubview(cardView)

        imageCard = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 27))
        imageCard.image = UIImage(named: "cardMasterCard")
        imageCard.layer.cornerRadius = 4
        imageCard.contentMode = .scaleAspectFill
        imageCard.clipsToBounds = true
        cardView.addSubview(imageCard)


        fourpoints = UIImageView(frame: CGRect(x: imageCard.x() + imageCard.w() + 13, y: 12, width: 21, height: 3))
        fourpoints.image = UIImage(named: "fourpoints")?.withRenderingMode(.alwaysTemplate)
        fourpoints.tintColor = .white
        cardView.addSubview(fourpoints)

        numberCard = UILabel(frame: CGRect(x: fourpoints.x() + fourpoints.w() + 6, y: 0, width: 47, height: 27))
        numberCard.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        numberCard.textColor = .white
        numberCard.textAlignment = .left
        numberCard.text = "4343"
        cardView.addSubview(numberCard)
        
       
        check = UIImageView(frame: CGRect(x: numberCard.x() + numberCard.w() , y:  4.5, width: 18, height: 18))
        check.image = UIImage(named: "checkCard")?.withRenderingMode(.alwaysTemplate)
        check.tintColor = Brain.kColorMain
        cardView.addSubview(check)

        paymentMethodLabel = UILabel(frame: CGRect(x: Brain.kLargeurIphone - 60 - 150, y: 0, width: 150, height: 27))
        paymentMethodLabel.text = NSLocalizedString("Payment Method", comment: "")
        paymentMethodLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        paymentMethodLabel.textColor = .white
        paymentMethodLabel.textAlignment = .right
        cardView.addSubview(paymentMethodLabel)
        
        
        rightArrow = UIImageView(frame: CGRect(x: Brain.kLargeurIphone - 32 - 20, y: 7, width: 8, height: 14))
        rightArrow.image = UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate)
        rightArrow.tintColor = .white
        cardView.addSubview(rightArrow)

        self.updateRequest()
        
    }
    
    
    func updateRequest(){
        
        
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
              
        
    }
    
    
    
    @objc func updatePaymentMethod(_ sender: UIButton){
        
        
        let payment = PaymentsViewController()
       payment.hidesBottomBarWhenPushed = true
       self.navigationController?.pushViewController(payment, animated: true)

    }

    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func touchNext(_ sender: UIButton){
        
        if self.cardView.isHidden == true {
            
            
            ///New payment method
            let addCard = AddPaymentViewController()
            self.navigationController?.pushViewController(addCard, animated: true)

            
        }else{
            
         
            ////Send request
            self.nextButton.loadingIndicatorWhite(true)
            self.request.saveInBackground { (done, error) in
                
                self.dismiss(animated: true) {
                    
                }
            }
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
        
        if self.video != nil {

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
                  
            
        }
      
        
        self.checkPaymentsMethod()
        
    }
    
    func checkPaymentsMethod(){
        


            /////////
        
        if StripeCustomer.shared().stripeAccount != nil {
            
            self.nextButton.loadingIndicator(false)
            self.nextButton.isEnabled = true
            
            let sources = StripeCustomer.shared().stripeAccount!["sources"] as? Dictionary<String, Any>
            let cards = sources!["data"] as! [Any]
            
            if cards.count > 0 {
                
                let defaultCard = cards[0] as! Dictionary <String, Any>
                
                
                if defaultCard["brand"] as! String  == "Visa" {
                    
                    self.imageCard.image = UIImage(named: "cardVisa")
                    
                }else if defaultCard["brand"] as! String == "MasterCard" {
                    
                    self.imageCard.image = UIImage(named: "cardMasterCard")
                    
                    
                }else{
                    
                    self.imageCard.image = UIImage(named: "cardOther")
                    
                    
                }
                
                self.numberCard.text = defaultCard["last4"] as? String
                
                
                self.cardView.isHidden = false
                
               nextButton.setTitle(NSLocalizedString("Go Rush", comment: ""), for: .normal)

                
            }else{
                
              self.cardView.isHidden = true
              nextButton.setTitle(NSLocalizedString("Add Payment Method", comment: ""), for: .normal)



            }
            
        }else{
            
            self.nextButton.loadingIndicatorWhite(true)
            self.nextButton.isEnabled = false

            
            StripeCustomer.shared().refreshStripeAccount { (stripeAccount) in
                

                self.nextButton.loadingIndicator(false)
                self.nextButton.isEnabled = true

                
                
                if stripeAccount != nil {
                    
                    
                    let sources = StripeCustomer.shared().stripeAccount!["sources"] as? Dictionary<String, Any>
                    let cards = sources!["data"] as! [Any]
                    
                    if cards.count > 0 {
                        
                        let defaultCard = cards[0] as! Dictionary <String, Any>
                        
                        
                        if defaultCard["brand"] as! String  == "Visa" {
                            
                            self.imageCard.image = UIImage(named: "cardVisa")
                            
                        }else if defaultCard["brand"] as! String == "MasterCard" {
                            
                            self.imageCard.image = UIImage(named: "cardMasterCard")
                            
                            
                        }else{
                            
                            self.imageCard.image = UIImage(named: "cardOther")
                            
                            
                        }
                        
                        self.numberCard.text = defaultCard["last4"] as? String
                        self.cardView.isHidden = false
                        self.nextButton.setTitle(NSLocalizedString("Go Rush", comment: ""), for: .normal)

                        
                    }else{
                        
                        self.cardView.isHidden = true
                        self.nextButton.setTitle(NSLocalizedString("Add Payment Method", comment: ""), for: .normal)
                        
                    }
            }
            
        }
        
        
        }
        
    }
    
    
    
    @objc func applicationWillResignActive() {
        
        if self.video != nil {

                   player?.pause()

        }
    }
    @objc func appWillEnterForegroundNotification() {
        
        
        if self.video != nil {

            player?.play()

        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        
        
        if self.video != nil {
            
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
            
            player?.pause()
            player?.play()
        }
        
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        super.viewDidDisappear(animated)
        
        
        
        
       if self.video != nil {

            player?.pause()

       }
        
        NotificationCenter.default.removeObserver(self)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
}


func thumbnailImageFor(fileUrl:URL) -> UIImage? {

    let video = AVURLAsset(url: fileUrl, options: [:])
    let assetImgGenerate = AVAssetImageGenerator(asset: video)
    assetImgGenerate.appliesPreferredTrackTransform = true

    let videoDuration:CMTime = video.duration
    let _:Float64 = CMTimeGetSeconds(videoDuration)

    let numerator = Int64(1)
    let denominator = videoDuration.timescale
    let time = CMTimeMake(numerator, denominator)

    do {
        let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage: img)
        return thumbnail
    } catch {
        print(error)
        return nil
    }
}
