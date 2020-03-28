//
//  AddVideoViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-10-23.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//


import Foundation

import UIKit
import Parse
import FBSDKCoreKit
import AVKit
import MediaPlayer
import Intercom
import YPImagePicker
import Intercom

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate{
    
    

    var flipCameraButton : UIButton!
    var flashButton      : UIButton!
    var libraryButton      : UIButton!
    var captureButton    : SwiftyRecordButton!
    var closeToTop : UIButton!
    
    var filter : UIImageView!
    
    
    
    var volumeView : MPVolumeView!
    var request : PFObject!
    
    
    var titleVC : UILabel!
    var backButton : UIButton!

    var videoToStartJob = false
    var videoToFinishJob = false
    var requestWorkerVC : RequestWorkerViewController?
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    convenience init(request: PFObject)
    {
        
        self.init()
        
        self.request = request
        
    }
    
   
    
    convenience init(videoToStartJob: Bool, requestWorkerVC : RequestWorkerViewController)
    {
        
        self.init()
        self.defaultCamera = .rear

        self.videoToStartJob = videoToStartJob
        self.requestWorkerVC = requestWorkerVC
        
    }
    
    convenience init(videoToFinishJob: Bool, requestWorkerVC : RequestWorkerViewController)
    {
       
       self.init()
       self.defaultCamera = .rear

       self.videoToFinishJob = videoToFinishJob
       self.requestWorkerVC = requestWorkerVC
       
    }
    
    
    
    deinit {
        // perform the deinitialization
        print("dealloc camera \(Date())")
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = NSLocalizedString("What", comment: "")
        tabBarItem.title = "";
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        
        cameraDelegate = self
        
        shouldPrompToAppSettings = false
        cameraDelegate = self
        maximumVideoDuration = 15.0
        shouldUseDeviceOrientation = false
        allowAutoRotate = false
        audioEnabled = true
        doubleTapCameraSwitch = true
        videoGravity = .resizeAspectFill
        videoQuality = .iframe1280x720
        
        
        self.filter = UIImageView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
        self.filter.image = UIImage(named: "filterCamera")
        self.view.addSubview(filter)

        
        self.titleVC = UILabel(frame: CGRect(x: 0, y: yTop() + 26, width: Brain.kLargeurIphone, height: 20))
        self.titleVC.textAlignment = .center
        self.titleVC.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.titleVC.textColor = .white
        self.titleVC.text = NSLocalizedString("Precise request", comment: "")
        self.view.addSubview(titleVC)
        
        
        if self.videoToStartJob == true {
            
            self.titleVC.text = NSLocalizedString("Start request", comment: "")

        }
        
        if self.videoToFinishJob == true {
            
            self.titleVC.text = NSLocalizedString("Finish request", comment: "")

        }
        
        self.backButton = UIButton(frame: CGRect(x: 13, y: yTop() + 8, width: 44, height: 42))
        self.backButton.setBackgroundImage(UIImage(named: "backArrowWhite"), for: .normal)
        self.backButton.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)

        self.view.addSubview(backButton)
        

        
        if isIphoneXFamily() {
            
            captureButton = SwiftyRecordButton(frame: CGRect(x: (Brain.kLargeurIphone-80)/2, y: Brain.kHauteurIphone-115-25, width: 80, height: 80))
            
        }else{
            
            captureButton = SwiftyRecordButton(frame: CGRect(x: (Brain.kLargeurIphone-80)/2, y: Brain.kHauteurIphone-115, width: 80, height: 80))
            
        }
        
        self.view.addSubview(captureButton)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapCapture(_:)))
        self.captureButton.addGestureRecognizer(tap2)
        
        
        
        if isIphoneXFamily() {
            
            flipCameraButton = UIButton(frame: CGRect(x:70, y: yTopBottomButtonCTA(), width: 50, height: 50))
            
        }else{
            
            flipCameraButton = UIButton(frame: CGRect(x:70, y: Brain.kHauteurIphone-65, width: 50, height: 50))
            
        }
        
        flipCameraButton.setImage(UIImage(named:"btnSwitch"), for: .normal)
        self.flipCameraButton.addTarget(self, action: #selector(cameraSwitchTapped(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        
        if isIphoneXFamily() {
            
            flashButton = UIButton(frame: CGRect(x:Brain.kLargeurIphone - 70 - 50, y: yTopBottomButtonCTA(), width: 50, height: 50))
            
        }else{
            
            flashButton = UIButton(frame: CGRect(x:Brain.kLargeurIphone - 70 - 50, y: Brain.kHauteurIphone-65, width: 50, height: 50))
            
        }
        flashButton.setImage(UIImage(named:"btnFlash"), for: .normal)
        self.flashButton.addTarget(self, action: #selector(toggleFlashTapped(_:)), for: .touchUpInside)
        
        self.view.addSubview(flashButton)
        
        
        
        // disable capture button until session starts
        captureButton.buttonEnabled = false
        
                
        //        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        //        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
  
        
        
        volumeView = MPVolumeView(frame: CGRect(x: 0, y: 2400, width: 0, height: 0))
        volumeView.alpha = 0.01
        self.view.addSubview(volumeView)
        self.view.sendSubviewToBack(volumeView)
        
         showSendRequestPopup()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        captureButton.delegate = self
        self.addAudioInput()
        super.viewDidAppear(animated)
        
     
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)),
                                               name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                               object: nil)
        
        
        if self.videoToStartJob == true {
                   
           showStartJobPopup()
        }
        
        if self.videoToFinishJob == true {
                   
           showFinishJobPopup()
        }
    
    }
    
    func showSendRequestPopup(){
        
        //If objectId == nil, its a new request
        if self.request != nil {
            
            let alert = UIAlertController(title: NSLocalizedString("Precise request", comment: ""), message: NSLocalizedString("Specify your request taking a photo or video of your land, or a video explaining the request in few seconds", comment: ""), preferredStyle: UIAlertController.Style.alert)
                          
           alert.addAction(UIAlertAction(title: NSLocalizedString("Let's go", comment: ""), style: UIAlertAction.Style.default, handler: nil))
           self.present(alert, animated: true, completion: nil)
                           
        }
    }
    
    
    func showStartJobPopup(){
        
        let alert = UIAlertController(title: NSLocalizedString("Start request", comment: ""), message: NSLocalizedString("Send a short video to your client to let him know you are getting started the job at his place", comment: ""), preferredStyle: UIAlertController.Style.alert)
       
        let okAction = UIAlertAction(title: NSLocalizedString("Let's go", comment: ""), style: .default, handler: { action in


        })
        alert.addAction(okAction)

        let noAction = UIAlertAction(title: NSLocalizedString("Not yet", comment: ""), style: .cancel, handler: { action in

            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(noAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showFinishJobPopup(){
        
        let alert = UIAlertController(title: NSLocalizedString("Finish request", comment: ""), message: NSLocalizedString("Send a short video to your client showing them that the quality work you have provided", comment: ""), preferredStyle: UIAlertController.Style.alert)
       
        let okAction = UIAlertAction(title: NSLocalizedString("Let's go", comment: ""), style: .default, handler: { action in


        })
        alert.addAction(okAction)
        
        let noAction = UIAlertAction(title: NSLocalizedString("Not yet", comment: ""), style: .cancel, handler: { action in

            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(noAction)

        self.present(alert, animated: true, completion: nil)
    }
    
  
    
   @objc func volumeChanged(notification: NSNotification) {
       
       
       if let userInfo = notification.userInfo {
           if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
               if volumeChangeType == "ExplicitVolumeChange" {
                   // your code goes here
                   print("volume change...")
                   if self.captureButton.buttonEnabled == true {
                       
                       self.captureButton.animateButton()
                       self.buttonWasTapped()
                       
                   }
               }
           }
       }
       
       
   }
   
   
   @objc func tapCapture(_ sender:UITapGestureRecognizer!){
       
       if self.captureButton.buttonEnabled == true {
           
           self.captureButton.animateButton()
           self.buttonWasTapped()
           print("tapme")

       }
       
   }

    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did stop running")
        captureButton.buttonEnabled = false
    }
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
       
        print("done photo! ")
        
        self.captureButton.shrinkButton()
        self.updateRequest(photo: photo, video: nil)
         
    }
    
    
    func updateRequest(photo: UIImage?, video : URL?){
        
      
        if self.videoToStartJob == true{
            
            self.requestWorkerVC!.viewToStartJob(photo: photo, video: video)
            self.navigationController?.popViewController(animated: true)
            
        }else if self.videoToFinishJob == true{
            
            self.requestWorkerVC!.viewToFinishJob(photo: photo, video: video)
            self.navigationController?.popViewController(animated: true)
            
        } else{
            
             if currentCamera == .front {

                 let newVC = SendRequestViewController(photoTmp: photo, videoTmp: video, frontCamera: true, request: self.request)
              self.navigationController?.pushViewController(newVC, animated: true)
              
             }else{
                 

                 let newVC = SendRequestViewController(photoTmp: photo, videoTmp: video, frontCamera: false, request: self.request)
                 self.navigationController?.pushViewController(newVC, animated: true)

                 
             }
            
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        captureButton.growButton()
        hideButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        captureButton.shrinkButton()
        showButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        
        print("YESS1")
        self.updateRequest(photo: nil, video: url)

    }
    
   
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to take video", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: NSLocalizedString("GoRush", comment: ""), message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Alert Ok button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
   
    func swiftyCamNotAuthorized(_ swiftyCam: SwiftyCamViewController) {
        
        DispatchQueue.main.async(execute: { [unowned self] in
            let message = NSLocalizedString("GoRush doesn't have permission to use the camera, please change privacy settings", comment: "")
            let alertController = UIAlertController(title: NSLocalizedString("GoRush", comment: ""), message: message, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .cancel, handler: { action in
                
                
            })
            alertController.addAction(ok)
            
            let settings = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default, handler: { action in
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    
                } else {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.openURL(appSettings)
                    }
                }
            })
            alertController.addAction(settings)
            self.present(alertController, animated: true, completion: nil)
        })
        
    }
    

    
    @objc func cameraSwitchTapped(_ sender: Any) {
        
        
        switchCamera()
    }
    
    @objc func toggleFlashTapped(_ sender: Any) {
        
        
        flashEnabled = !flashEnabled
        toggleFlashAnimation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)

        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        Intercom.logEvent(withName: "customer_CameraView")

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
//        self.removeAudioInput()
        
        super.viewDidDisappear(animated)
        
      
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)

        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        
      
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    
    
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
}

extension CameraViewController {
    
    fileprivate func hideButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
//            self.closeToTop.alpha = 0.0
        }
    }
    
    fileprivate func showButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
//            self.closeToTop.alpha = 1.0
            
        }
    }
    
    fileprivate func focusAnimationAt(_ point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    
    fileprivate func toggleFlashAnimation() {
        if flashEnabled == true {
            flashButton.setImage(#imageLiteral(resourceName: "btnFlashOn"), for: UIControl.State())
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "btnFlash"), for: UIControl.State())
        }
    }
}
