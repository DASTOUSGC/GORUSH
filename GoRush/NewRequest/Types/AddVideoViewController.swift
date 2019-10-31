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
import FBSDKLoginKit

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate{
    
    
    
    var displayOriginY: CGFloat!
    
    var flipCameraButton : UIButton!
    var flashButton      : UIButton!
    var libraryButton      : UIButton!
    var captureButton    : SwiftyRecordButton!
    var closeToTop : UIButton!
    
    var temperature : Float?
    
    
    var volumeView : MPVolumeView!
    
    var buzzLocation : PFGeoPoint!
    
    var presentingVC: UIViewController?  // use this variable to connect both view controllers
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    deinit {
        // perform the deinitialization
        print("dealloc camera \(Date())")
        
    }
    
    override func viewDidLoad() {
        cameraDelegate = self
        
        
        shouldPrompToAppSettings = false
        cameraDelegate = self
        maximumVideoDuration = 8.0
        shouldUseDeviceOrientation = false
        allowAutoRotate = false
        audioEnabled = true
        doubleTapCameraSwitch = true
        videoGravity = .resizeAspectFill
        videoQuality = .iframe1280x720
        
        
        
        
        if isIphoneXFamily() {
            
            captureButton = SwiftyRecordButton(frame: CGRect(x: (Brain.kLargeurIphone-80)/2, y: Brain.kHauteurIphone-130-80, width: 80, height: 80))
            
        }else{
            
            captureButton = SwiftyRecordButton(frame: CGRect(x: (Brain.kLargeurIphone-80)/2, y: Brain.kHauteurIphone-115, width: 80, height: 80))
            
        }
        
        self.view.addSubview(captureButton)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapCapture(_:)))
        self.captureButton.addGestureRecognizer(tap2)
        
        
        
        if isIphoneXFamily() {
            
            flipCameraButton = UIButton(frame: CGRect(x:70, y: Brain.kHauteurIphone-80-80, width: 50, height: 50))
            
        }else{
            
            flipCameraButton = UIButton(frame: CGRect(x:70, y: Brain.kHauteurIphone-65, width: 50, height: 50))
            
        }
        
        flipCameraButton.setImage(UIImage(named:"btnSwitch"), for: .normal)
        self.flipCameraButton.addTarget(self, action: #selector(cameraSwitchTapped(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        
        if isIphoneXFamily() {
            
            flashButton = UIButton(frame: CGRect(x:Brain.kLargeurIphone - 70 - 50, y: Brain.kHauteurIphone-80-80, width: 50, height: 50))
            
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
        
        
        
        if isIphoneXFamily() {
            
            self.closeToTop = UIButton(frame: CGRect(x: 5, y: 50, width: 60, height: 40))
            
        }else{
            
            self.closeToTop = UIButton(frame: CGRect(x: 5, y: 30, width: 60, height: 40))
            
        }
        
        self.closeToTop.setBackgroundImage(UIImage(named:"closeToTop"), for: .normal)
        self.closeToTop.addTarget(self, action: #selector(closeStory(_:)), for: .touchUpInside)
        self.view.addSubview(self.closeToTop)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        super.viewDidLoad()
        self.getTemperature()
        
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
        
        
        //        if CLLocationManager.locationServicesEnabled() {
        //            switch CLLocationManager.authorizationStatus() {
        //            case  .restricted, .denied:
        //
        //                let alert = UIAlertController(title: NSLocalizedString("Buzzy needs your location", comment: ""), message: NSLocalizedString("Activate your location in settings.", comment: ""), preferredStyle: .alert)
        //
        //                // Create the actions
        //                let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default) {
        //                    UIAlertAction in
        //
        //                    if #available(iOS 10.0, *) {
        //                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        //
        //                    } else {
        //                        if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
        //                            UIApplication.shared.openURL(appSettings)
        //                        }
        //                    }
        //
        //                }
        //                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel) {
        //                    UIAlertAction in
        //
        //                    self.dismiss()
        //                }
        //
        //                // Add the actions
        //                alert.addAction(okAction)
        //                alert.addAction(cancelAction)
        //
        //                self.present(alert, animated: true, completion: nil)
        //
        //                return
        //
        //            case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
        //                print("Access")
        //            }
        //        } else {
        //            print("Location services are not enabled")
        //        }
        //
        //        self.buzzLocation = PFGeoPoint(latitude: 48.850183, longitude:  2.318028)
        //
        //
        //        PFGeoPoint.geoPointForCurrentLocation { (currentLocation, error) in
        //
        //            if error == nil  && currentLocation != nil {
        //
        //                PFUser.current()?.setObject(Locale.preferredLanguages[0], forKey: Brain.kUserLanguage)
        //                PFUser.current()?.setObject(currentLocation!, forKey: Brain.kUserLocation)
        //                PFUser.current()?.saveInBackground()
        //
        //                let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //
        //
        //                if PFUser.current()?.object(forKey: "fakeLocation") != nil {
        //
        //                    if !appDelegate.ifLocationIsInKingdom(location: PFGeoPoint(latitude: 48.86570063424191 , longitude: 2.2808448504677794)) {
        //                        //                if !appDelegate.ifLocationIsInKingdom(location: currentLocation!) {
        //
        //                        self.popupErrorLocation()
        //                        return
        //
        //                    }
        //
        //                    self.buzzLocation = PFGeoPoint(latitude: 48.86570063424191, longitude:  2.2808448504677794)
        //
        //
        //
        //                }else{
        //
        ////                    if !appDelegate.ifLocationIsInKingdom(location: PFGeoPoint(latitude: 48.850183 , longitude: 2.318028)) {
        //                    if !appDelegate.ifLocationIsInKingdom(location: currentLocation!) {
        //
        //                        self.popupErrorLocation()
        //                        return
        //
        //                    }
        //
        //                    self.buzzLocation = currentLocation
        //
        //                }
        //
        //
        //
        //            }else{
        //
        //                if PFUser.current()?.object(forKey: Brain.kUserLocation) != nil {
        //
        //                    let location = PFUser.current()?.object(forKey: Brain.kUserLocation) as! PFGeoPoint
        //                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //
        //
        //                    if !appDelegate.ifLocationIsInKingdom(location: location) {
        //
        //                        self.popupErrorLocation()
        //                        return
        //                    }
        //
        //                    self.buzzLocation = location
        //
        //
        //                }
        //            }
        //
        //        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)),
                                               name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                               object: nil)
        
    }
    
    func getLast3Buzzs(){
        
        
        let query = PFQuery(className: Brain.kBuzzClassName)
        query.whereKey(Brain.kBuzzExpired, notEqualTo: true)
        query.whereKey(Brain.kBuzzAvailable, equalTo: true)
        query.whereKey(Brain.kBuzzUser, equalTo: PFUser.current()!)
        query.whereKeyExists(Brain.kBuzzKingdom)
        query.whereKey(Brain.kBuzzDeleted, notEqualTo: true)
        query.addDescendingOrder(Brain.kBuzzDate)
        query.cachePolicy = .networkOnly
        query.countObjectsInBackground { (number, error) in
            
            if number > 2 {
                
                let alert = UIAlertController(title: NSLocalizedString("Hold on", comment: ""), message: NSLocalizedString("You already posted 3 Buzzs in 24 hours 📸. Wait for one of your Buzz to expire or delete one of them.", comment: ""), preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: NSLocalizedString("Ok 😔", comment: ""), style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    
                    self.dismiss()
                    
                    
                }
                
                // Add the actions
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    
    
    func popupErrorLocation(){
        
        
        let schools = PFQuery(className: Brain.kSchoolsClassName)
        schools.whereKey(Brain.kSchoolsAvailable, equalTo: true)
        //        schools.whereKey(Brain.kSchoolsIsKingdom, equalTo: false)
        schools.limit = 1000
        schools.includeKey(Brain.kSchoolsVoteUsers)
        schools.addDescendingOrder(Brain.kSchoolsVote)
        schools.addDescendingOrder(Brain.kSchoolsName)
        schools.cachePolicy = .cacheThenNetwork
        schools.findObjectsInBackground { (schoolObjects, error) in
            
            
            
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Vote for your school", comment: ""), message: NSLocalizedString("Unfortunately, you can’t post a Buzz because there are no schools where you are", comment: ""), preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: NSLocalizedString("Ok 😔", comment: ""), style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
            self.dismiss()
            
            
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Vote 😎", comment: ""), style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            
            self.toCloseCamera = true
            UIView.animate(withDuration: 0.1, animations: {
                self.topCache.backgroundColor = UIColor.black.withAlphaComponent(0)
                
            })
            
            (self.presentingVC! as! MapViewController).showVote()
            
            
            self.dismiss(animated: true) {
                //                Intercom.presentMessageComposer("Je souhaite ouvrir un nouveau kingdom... :")
                
            }
            
            
        }
        
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func getTemperature(){
        
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
            
            if geopoint != nil && error == nil {
                
                
                URLSession.shared.dataTask(with: URL(string:  "https://api.openweathermap.org/data/2.5/weather?lat=\(geopoint!.latitude)&lon=\(geopoint!.longitude)&appid=3f41b97fd0366305ccb64ac4acfdcfd9&units=Metric")!) { data, URLResponse, requestError in
                    
                    guard let data = data else {
                        
                        print("err1")
                        
                        return
                    }
                    
                    do {
                        guard let JSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                            print("err2")
                            
                            return
                        }
                        
                        
                        if JSON["main"] != nil {
                            
                            let main = JSON["main"] as! [String : Any]
                            
                            if main["temp"] != nil {
                                
                                let temp = main["temp"] as! NSNumber
                                self.temperature = Float(truncating: temp)
                                
                            }
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                    } catch {
                    }
                    }.resume()
                
            }
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
        
        self.buzzLocation = PFGeoPoint(latitude: 0, longitude: 0)
        
        
        if currentCamera == .front {
            
            let newVC = PhotoViewController(image: photo, frontCamera : true, temperature : self.temperature, cameraVC : self, location : self.buzzLocation)
            
            let nav = UINavigationController(rootViewController: newVC)
            nav.isNavigationBarHidden = true
            nav.navigationBar.isTranslucent = false
            
            self.present(nav, animated: false) {
                
            }
        }else{
            
            let newVC = PhotoViewController(image: photo, frontCamera : false, temperature : self.temperature,  cameraVC : self, location : self.buzzLocation)
            
            let nav = UINavigationController(rootViewController: newVC)
            nav.isNavigationBarHidden = true
            nav.navigationBar.isTranslucent = false
            
            self.present(nav, animated: false) {
                
            }
            
        }
        
        
        
        
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
        
        self.buzzLocation = PFGeoPoint(latitude: 0, longitude: 0)
        
        
        if currentCamera == .front {
            
            let newVC = VideoViewController(videoURL: url, frontCamera : true, temperature : self.temperature,  cameraVC : self, location : self.buzzLocation)
            let nav = UINavigationController(rootViewController: newVC)
            nav.isNavigationBarHidden = true
            nav.navigationBar.isTranslucent = false
            
            self.present(nav, animated: false) {
                
            }
        }else{
            let newVC = VideoViewController(videoURL: url, frontCamera : false , temperature : self.temperature,  cameraVC : self, location : self.buzzLocation)
            
            let nav = UINavigationController(rootViewController: newVC)
            nav.isNavigationBarHidden = true
            nav.navigationBar.isTranslucent = false
            
            self.present(nav, animated: false) {
                
            }
            
        }
        
        
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
            let message = NSLocalizedString("Buzzy doesn't have permission to use the camera, please change privacy settings", comment: "")
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
        
        //        UploadBuzzs.shared().incrementkingdom()
        //
        //        return
        
        
        self.dismiss()
        
    }
    
    @objc func cameraSwitchTapped(_ sender: Any) {
        
        
        //        UploadBuzzs.shared().incrementuser()
        //        return
        switchCamera()
    }
    
    @objc func toggleFlashTapped(_ sender: Any) {
        
        
        //
        //        var config = YPImagePickerConfiguration()
        //        config.library.mediaType = .photo
        //        config.library.onlySquare  = false
        //        //        config.onlySquareImagesFromCamera = true
        //        config.targetImageSize = .original
        //        config.usesFrontCamera = true
        //        config.showsFilters = false
        //        //        config.filters = [YPFilterDescriptor(name: "Normal", filterName: ""),
        //        //                          YPFilterDescriptor(name: "Mono", filterName: "CIPhotoEffectMono")]
        //        config.shouldSaveNewPicturesToAlbum = false
        //        //        config.video.compression = AVAssetExportPresetHighestQuality
        //        config.albumName = NSLocalizedString("Buzzy", comment: "")
        //        //        config.screens = [.library, .photo, .video]
        //        config.screens = [.library]
        //        config.startOnScreen = .library
        //        //        config.video.recordingTimeLimit = 8
        //        //        config.video.libraryTimeLimit = 8
        //        //        config.showsCrop = .rectangle(ratio: (16/16))
        //        config.wordings.libraryTitle = NSLocalizedString("Gallery", comment: "")
        //        config.hidesStatusBar = false
        //        config.library.maxNumberOfItems = 1
        //        config.library.minNumberOfItems = 1
        //        config.library.numberOfItemsInRow = 3
        //        config.library.spacingBetweenItems = 2
        //        config.isScrollToChangeModesEnabled = true
        //
        //        // Build a picker with your configuration
        //        let picker = YPImagePicker(configuration: config)
        //        picker.didFinishPicking { [unowned picker] items, cancelled in
        //
        //            if cancelled {
        //                print("Picker was canceled")
        //                picker.dismiss(animated: true, completion: nil)
        //                UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: Brain.kItemNavBarFont, NSAttributedStringKey.foregroundColor:UIColor.black], for:.normal)
        //
        //                return
        //            }
        //
        //            if let firstItem = items.first {
        //                switch firstItem {
        //                case .photo(let photo):
        //
        //
        //
        //
        //
        //                    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: Brain.kItemNavBarFont, NSAttributedStringKey.foregroundColor:UIColor.black], for:.normal)
        //
        //                    picker.dismiss(animated: false, completion: {
        //
        //                        let newVC = PhotoViewController(image: photo.image, frontCamera : true, temperature : self.temperature, cameraVC : self, location : self.buzzLocation)
        //                        self.present(newVC, animated: false, completion: nil)
        //
        //                    })
        //
        //                case .video( _): break
        //
        //                }
        //            }
        //        }
        //
        //        present(picker, animated: true, completion: nil)
        //
        //        return
        
        flashEnabled = !flashEnabled
        toggleFlashAnimation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        //        self.getLast3Buzzs()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.removeAudioInput()
        
        super.viewDidDisappear(animated)
        
        
        
        
    }
    
    
    override open func viewWillDisappear(_ animated: Bool) {
        
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        
        if toCloseCamera == true {
            
            super.viewWillDisappear(animated)
            
        }
        
    }
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: false)
        
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
            self.closeToTop.alpha = 0.0
        }
    }
    
    fileprivate func showButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
            self.closeToTop.alpha = 1.0
            
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
