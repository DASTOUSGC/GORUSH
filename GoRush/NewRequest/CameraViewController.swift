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

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate{
    
    
    
    var displayOriginY: CGFloat!
    
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
    
    
    deinit {
        // perform the deinitialization
        print("dealloc camera \(Date())")
        
    }
    
    override func viewDidLoad() {
        
        
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
        self.titleVC.text = NSLocalizedString("Precise Your Request", comment: "")
        self.view.addSubview(titleVC)
        
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
        
//        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapCapture(_:)))
//        self.captureButton.addGestureRecognizer(tap2)
        
        
        
        if isIphoneXFamily() {
            
            flipCameraButton = UIButton(frame: CGRect(x:70, y: Brain.kHauteurIphone-90, width: 50, height: 50))
            
        }else{
            
            flipCameraButton = UIButton(frame: CGRect(x:70, y: Brain.kHauteurIphone-65, width: 50, height: 50))
            
        }
        
        flipCameraButton.setImage(UIImage(named:"btnSwitch"), for: .normal)
        self.flipCameraButton.addTarget(self, action: #selector(cameraSwitchTapped(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        
        if isIphoneXFamily() {
            
            flashButton = UIButton(frame: CGRect(x:Brain.kLargeurIphone - 70 - 50, y: Brain.kHauteurIphone-90, width: 50, height: 50))
            
        }else{
            
            flashButton = UIButton(frame: CGRect(x:Brain.kLargeurIphone - 70 - 50, y: Brain.kHauteurIphone-65, width: 50, height: 50))
            
        }
        flashButton.setImage(UIImage(named:"btnFlash"), for: .normal)
        self.flashButton.addTarget(self, action: #selector(toggleFlashTapped(_:)), for: .touchUpInside)
        
        self.view.addSubview(flashButton)
        
        
        
        // disable capture button until session starts
        captureButton.buttonEnabled = false
        
        
        displayOriginY = originY()
        
        //        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        //        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
//
//        if isIphoneXFamily() {
//
//            self.closeToTop = UIButton(frame: CGRect(x: 5, y: 50, width: 60, height: 40))
//
//        }else{
//
//            self.closeToTop = UIButton(frame: CGRect(x: 5, y: 30, width: 60, height: 40))
//
//        }
//        
//        self.closeToTop.setBackgroundImage(UIImage(named:"closeToTop"), for: .normal)
//        self.closeToTop.addTarget(self, action: #selector(closeStory(_:)), for: .touchUpInside)
//        self.view.addSubview(self.closeToTop)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        
        
        super.viewDidLoad()
        
        volumeView = MPVolumeView(frame: CGRect(x: 0, y: 2400, width: 0, height: 0))
        volumeView.alpha = 0.01
        self.view.addSubview(volumeView)
        self.view.sendSubview(toBack: volumeView)
        
        //      volumeView.backgroundColor = UIColor.red
        
        
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
        
        print("tapme")
        if self.captureButton.buttonEnabled == true {
            
            self.captureButton.animateButton()
            self.buttonWasTapped()
            
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        captureButton.delegate = self
        self.addAudioInput()
        super.viewDidAppear(animated)
        
        
     
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)),
                                               name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                               object: nil)
        
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
        
        
        
//        if currentCamera == .front {
//
//            let newVC = PhotoViewController(image: photo, frontCamera : true, temperature : self.temperature, cameraVC : self, location : self.buzzLocation)
//
//            let nav = UINavigationController(rootViewController: newVC)
//            nav.isNavigationBarHidden = true
//            nav.navigationBar.isTranslucent = false
//
//            self.present(nav, animated: false) {
//
//            }
//        }else{
//
//            let newVC = PhotoViewController(image: photo, frontCamera : false, temperature : self.temperature,  cameraVC : self, location : self.buzzLocation)
//
//            let nav = UINavigationController(rootViewController: newVC)
//            nav.isNavigationBarHidden = true
//            nav.navigationBar.isTranslucent = false
//
//            self.present(nav, animated: false) {
//
//            }
//
//        }
        
        
        
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        captureButton.growButton()
        hideButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        showButtons()
        
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        
        
        self.request.setObject(url.absoluteString, forKey: Brain.kRequestUrl)
        
        if currentCamera == .front {

            self.request.setObject(true, forKey: Brain.kRequestFront)

        }else{
       
            self.request.setObject(false, forKey: Brain.kRequestFront)

        
        }

        
        let newVC = SendRequestViewController(request:  self.request)
        self.navigationController?.pushViewController(newVC, animated: true)
        
        

        
        print("on montre la video!")
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print("Did focus at point: \(point)")
        //        focusAnimationAt(point)
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to take buzz", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: NSLocalizedString("Buzzy", comment: ""), message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Alert Ok button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print("Zoom level did change. Level: \(zoom)")
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print("Camera did change to \(camera.rawValue)")
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    
    
    func dismiss(){
        
        toCloseCamera = true
        UIView.animate(withDuration: 0.1, animations: {
            self.topCache.backgroundColor = UIColor.black.withAlphaComponent(0)
            
        })
        
        
        self.dismiss(animated: true) {
            
        }
    }
    func swiftyCamNotAuthorized(_ swiftyCam: SwiftyCamViewController) {
        
        DispatchQueue.main.async(execute: { [unowned self] in
            let message = NSLocalizedString("GoRush doesn't have permission to use the camera, please change privacy settings", comment: "")
            let alertController = UIAlertController(title: NSLocalizedString("Buzzy", comment: ""), message: message, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: { action in
                
                
                
            })
            ok.setValue(Brain.kColorMain, forKey: "titleTextColor")
            alertController.addAction(ok)
            
            let settings = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default, handler: { action in
                
                self.dismiss()
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    
                } else {
                    if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(appSettings)
                    }
                }
            })
            settings.setValue(Brain.kColorMain, forKey: "titleTextColor")
            alertController.addAction(settings)
            
            self.present(alertController, animated: true, completion: nil)
        })
        
    }
    
    @objc func closeStory(_ sender: UIButton){
        
        
        self.dismiss()
        
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

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
//        self.removeAudioInput()
        
        super.viewDidDisappear(animated)
        
      
    }
    
    
    override open func viewWillDisappear(_ animated: Bool) {
        
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        
        super.viewWillDisappear(animated)
      
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
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
            flashButton.setImage(#imageLiteral(resourceName: "btnFlashOn"), for: UIControlState())
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "btnFlash"), for: UIControlState())
        }
    }
}
