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
    
    var videoURL: URL!
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
    
    convenience init( request : PFObject)
    {
        
        self.init()
        
        self.videoURL = URL(string: request.object(forKey: Brain.kRequestUrl) as! String)
        self.frontCamera = request.object(forKey: Brain.kRequestFront) as? Bool
        self.request = request
        self.service = self.request.object(forKey: Brain.kRequestService) as? PFObject
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        player = AVPlayer(url: videoURL)
        
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        self.title = NSLocalizedString("New Request", comment: "")
        tabBarItem.title = "";
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        
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
        
        
        nextButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: Brain.kHauteurIphone-90, width:335, height: 60))
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Go Rush!", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.applyGradient()
        view.addSubview(nextButton)
        
        
        self.iconService = PFImageView(frame: CGRect(x: 20, y: yTop() + 80, width: 20, height: 20))
        self.iconService.file = self.service.object(forKey: Brain.kServiceIcon) as? PFFile
        self.iconService.loadInBackground()
        view.addSubview(iconService)
        
        
        self.labelService = UILabel(frame: CGRect(x: 48, y: iconService.y(), width: Brain.kLargeurIphone  - 70, height: 20))
        self.labelService.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelService.textColor = .white
        self.labelService.text = self.service.object(forKey: Brain.kServicesName) as? String
        self.view.addSubview(labelService)
        
        
        
        self.iconWhere = UIImageView(frame: CGRect(x: 20, y: self.iconService.yBottom() + 12, width: 20, height: 20))
        self.iconWhere.image = UIImage(named: "iconWhere")
        view.addSubview(iconWhere)

        self.labelWhere = UILabel(frame: CGRect(x: 48, y: iconWhere.y(), width: Brain.kLargeurIphone - 70, height: 20))
        self.labelWhere.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelWhere.textColor = .white
        self.labelWhere.text = self.request.object(forKey: Brain.krequestAddress) as? String
        self.view.addSubview(labelWhere)
        
        
        self.labelSize = UIButton(frame: CGRect(x: 20, y: self.labelWhere.yBottom() + 12, width: 120, height: 38))
        self.labelSize.backgroundColor = Brain.kColorMain
        self.labelSize.applyGradient()
        self.labelSize.layer.cornerRadius = 19
        self.labelSize.layer.masksToBounds = true
        self.labelSize.titleLabel?.font  = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.labelSize.setTitleColor(.white, for: .normal)
        self.labelSize.setTitle("≅28 072pi²", for: .normal)
        self.view.addSubview(labelSize)
        
        self.labelPrice = UILabel(frame: CGRect(x: 20, y: self.labelSize.yBottom() + 10, width: 120, height: 48))
        self.labelPrice.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        self.labelPrice.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.labelPrice.textColor = .white

        
        
        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 40), NSAttributedStringKey.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.white]
        
        let attributedString1 = NSMutableAttributedString(string:"60", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"$", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        self.labelPrice.attributedText = attributedString1
        
        self.view.addSubview(labelPrice)
        
        
    }
    
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func touchNext(_ sender: UIButton){
        
      
        
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
        
        
        
        
    }
    
    
    
    @objc func applicationWillResignActive() {
        
        player?.pause()
        
    }
    @objc func appWillEnterForegroundNotification() {
        
        
        
        player?.play()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        
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
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        super.viewDidDisappear(animated)
        
        
        
        
        player?.pause()
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
