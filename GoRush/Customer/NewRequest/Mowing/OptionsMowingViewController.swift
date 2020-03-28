//
//  OptionsMowingViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 28/03/2020.
//  Copyright © 2020 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Mapbox
import Parse
import MapboxGeocoder
import YPImagePicker
import Intercom

class OptionsMowingViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    
    let titleViewController = NSLocalizedString("Options", comment:"")
    
    var request : PFObject!
    var service : PFObject!
    
    var nextButton : UIButton!
    
    var iconPhotos : UIImageView!
    var labelPhotos : UILabel!
    
    var iconBoost : UIImageView!
    var labelBoost : UILabel!
    var switchsBoost = [UISwitch]()
    
    var media1 : UIButton!
    var media2 : UIButton!
    var media3 : UIButton!
    var media4 : UIButton!
    var media1Photo : PFImageView!
    var media2Photo : PFImageView!
    var media3Photo : PFImageView!
    var media4Photo : PFImageView!
    var removePhoto1 : UIButton!
    var removePhoto2 : UIButton!
    var removePhoto3 : UIButton!
    var removePhoto4 : UIButton!
    
    var image1: PFFileObject?
    var image2: PFFileObject?
    var image3: PFFileObject?
    var image4: PFFileObject?

    
    convenience init( request : PFObject)
    {
        
        self.init()
        
        self.request = request
        self.service =  self.request.object(forKey: Brain.kRequestService) as! PFObject
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = titleViewController
        tabBarItem.title = "";
        
        
    
        
        self.view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        
        
        iconPhotos = UIImageView(frame: CGRect(x: 15, y: 16, width: 30, height: 30))
        iconPhotos.image = UIImage(named: "iconPhotosOptions")
        view.addSubview(iconPhotos)
        
        labelPhotos = UILabel(frame: CGRect(x: 46, y: iconPhotos.y(), width: Brain.kL - 66, height: 30))
        labelPhotos.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        labelPhotos.textColor = UIColor(hex: "9D9D9D")
        labelPhotos.text = NSLocalizedString("Photos", comment: "")
        view.addSubview(labelPhotos)
        
        
        let widthImage =  ( Brain.kLargeurIphone - 55 )  / 2
        
        
        var heightImage = CGFloat(160)
        
        if !isIphoneXFamily() {
            
            heightImage = CGFloat(140)
        }
        
     
        
        //
        media1 = UIButton(frame: CGRect(x: 20, y: 57, width: widthImage, height: heightImage))
        media1.backgroundColor = UIColor.white
        media1.layer.cornerRadius = 18
        media1.addTarget(self, action: #selector(touchPic1(_:)), for: .touchUpInside)
        media1.layer.applySketchShadow(color: UIColor(hex: "1D1D1D"), alpha: 0.04, x: 2, y: 0, blur: 11, spread: 3)
        view.addSubview(media1)
        
        media1Photo = PFImageView(frame: CGRect(x: 0, y: 0, width: widthImage, height: heightImage))
        media1Photo.image = UIImage(named: "iconBigPhotos")
        media1Photo.layer.masksToBounds = true
        media1Photo.contentMode = .scaleAspectFill
        media1Photo.layer.cornerRadius = 18
        media1.addSubview(media1Photo)
        
        removePhoto1 = UIButton(frame: CGRect(x: self.media1.w() - 35, y: 5, width: 30, height: 30))
        removePhoto1.setBackgroundImage(UIImage(named: "removePhoto"), for: .normal)
        removePhoto1.layer.cornerRadius = 18
        removePhoto1.isHidden = true
        removePhoto1.addTarget(self, action: #selector(removePic1(_:)), for: .touchUpInside)
        media1.addSubview(removePhoto1)

        
        
        //
        media2 = UIButton(frame: CGRect(x: media1.x() + media1.w() + 15, y: 57, width: widthImage, height: heightImage))
        media2.backgroundColor = UIColor.white
        media2.layer.cornerRadius = 18
        media2.addTarget(self, action: #selector(touchPic2(_:)), for: .touchUpInside)
        media2.layer.applySketchShadow(color: UIColor(hex: "1D1D1D"), alpha: 0.04, x: 2, y: 0, blur: 11, spread: 3)
        view.addSubview(media2)

        media2Photo = PFImageView(frame: CGRect(x: 0, y: 0, width: widthImage, height: heightImage))
        media2Photo.image = UIImage(named: "iconBigPhotos")
        media2Photo.layer.masksToBounds = true
        media2Photo.layer.cornerRadius = 18
        media2Photo.contentMode = .scaleAspectFill
        media2.addSubview(media2Photo)
        
        removePhoto2 = UIButton(frame: CGRect(x: self.media2.w() - 35, y: 5, width: 30, height: 30))
        removePhoto2.setBackgroundImage(UIImage(named: "removePhoto"), for: .normal)
        removePhoto2.layer.cornerRadius = 18
        removePhoto2.isHidden = true
        removePhoto2.addTarget(self, action: #selector(removePic2(_:)), for: .touchUpInside)
        media2.addSubview(removePhoto2)
        
        //
        media3 = UIButton(frame: CGRect(x: 20, y: media1.yBottom() + 15, width: widthImage, height: heightImage))
        media3.backgroundColor = UIColor.white
        media3.layer.cornerRadius = 18
        media3.addTarget(self, action: #selector(touchPic3(_:)), for: .touchUpInside)
        media3.layer.applySketchShadow(color: UIColor(hex: "1D1D1D"), alpha: 0.04, x: 2, y: 0, blur: 11, spread: 3)
        view.addSubview(media3)

        media3Photo = PFImageView(frame: CGRect(x: 0, y: 0, width: widthImage, height: heightImage))
        media3Photo.image = UIImage(named: "iconBigPhotos")
        media3Photo.layer.masksToBounds = true
        media3Photo.layer.cornerRadius = 18
        media3Photo.contentMode = .scaleAspectFill
        media3.addSubview(media3Photo)
        
        removePhoto3 = UIButton(frame: CGRect(x: self.media3.w() - 35, y: 5, width: 30, height: 30))
        removePhoto3.setBackgroundImage(UIImage(named: "removePhoto"), for: .normal)
        removePhoto3.layer.cornerRadius = 18
        removePhoto3.isHidden = true
        removePhoto3.addTarget(self, action: #selector(removePic3(_:)), for: .touchUpInside)
        media3.addSubview(removePhoto3)

        //
        media4 = UIButton(frame: CGRect(x: media3.x() + media3.w() + 15, y: media1.yBottom() + 15, width: widthImage, height: heightImage))
        media4.backgroundColor = UIColor.white
        media4.layer.cornerRadius = 18
        media4.addTarget(self, action: #selector(touchPic4(_:)), for: .touchUpInside)
        media4.layer.applySketchShadow(color: UIColor(hex: "1D1D1D"), alpha: 0.04, x: 2, y: 0, blur: 11, spread: 3)
        view.addSubview(media4)

        media4Photo = PFImageView(frame: CGRect(x: 0, y: 0, width: widthImage, height: heightImage))
        media4Photo.image = UIImage(named: "iconBigPhotos")
        media4Photo.layer.masksToBounds = true
        media4Photo.layer.cornerRadius = 18
        media4Photo.contentMode = .scaleAspectFill
        media4.addSubview(media4Photo)
        
        removePhoto4 = UIButton(frame: CGRect(x: self.media4.w() - 35, y: 5, width: 30, height: 30))
        removePhoto4.setBackgroundImage(UIImage(named: "removePhoto"), for: .normal)
        removePhoto4.layer.cornerRadius = 18
        removePhoto4.isHidden = true
        removePhoto4.addTarget(self, action: #selector(removePic4(_:)), for: .touchUpInside)
        media4.addSubview(removePhoto4)


        
        if isIphoneXFamily() {
          
          nextButton = UIButton(frame: CGRect(x:20, y: Brain.kHauteurIphone - 90 - 85, width:Brain.kLargeurIphone-40, height: 60))

          
        }else{
          
          nextButton = UIButton(frame: CGRect(x:20, y: Brain.kHauteurIphone - 55 - 85, width:Brain.kLargeurIphone-40, height: 60))

        }
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.applyGradient()
        view.addSubview(nextButton)
        
        
        if self.service.object(forKey: Brain.kServiceBoost) != nil {
            
            self.addBoostMode()

                  
        }
        
    }
    
    func addBoostMode(){
        
            
        iconBoost = UIImageView(frame: CGRect(x: 15, y: media3.yBottom() + 30, width: 30, height: 30))
        iconBoost.image = UIImage(named: "iconBoostOptions")
        view.addSubview(iconBoost)

        labelBoost = UILabel(frame: CGRect(x: 48, y: iconBoost.y(), width: Brain.kL - 66, height: 30))
        labelBoost.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        labelBoost.textColor = UIColor(hex: "9D9D9D")
        labelBoost.text = NSLocalizedString("Boost mode", comment: "")
        view.addSubview(labelBoost)


        let boosts = self.service.object(forKey: Brain.kServiceBoost) as! [[String:Any]]

        for i in 0..<boosts.count {
            
            let boost = boosts[i]
            
            let boostDescription = UILabel(frame: CGRect(x: 20, y: labelBoost.yBottom() + 5 + CGFloat(i * 60), width: Brain.kL - 80, height: 30))
            boostDescription.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            boostDescription.textColor = .black
            boostDescription.numberOfLines = 0
            boostDescription.text = boost[Brain.kName.localizableName()] as? String
            view.addSubview(boostDescription)

            var price = Double(0)
            
            if boost[Brain.kBoostFixedPrice] != nil {
                
                price = price + Double(truncating: boost[Brain.kBoostFixedPrice]  as! NSNumber)
            }

            if boost[Brain.kBoostVariablePrice] != nil {
               
                let mowing = self.request[Brain.kRequestMowing] as! [String:Any]
                let area = mowing[Brain.kUserMowingAreaResult] as! Int
                price = price + Double(area) * Double(truncating: boost[Brain.kBoostVariablePrice]  as! NSNumber)
            }
            
            price = price + (price * Double(self.service.object(forKey: Brain.kServiceFee) as! Int) / 100)

            
            let boostPrice = UILabel(frame: CGRect(x: 20, y: boostDescription.yBottom() , width: Brain.kL - 80, height: 17))
            boostPrice.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            boostPrice.textColor = .black
            boostPrice.numberOfLines = 0
            boostPrice.text = String(format: NSLocalizedString("%.2f$", comment: ""), price)
            view.addSubview(boostPrice)

            let switchBoost = UISwitch()
            switchBoost.frame.origin.y = boostDescription.y() + 10
            switchBoost.frame.origin.x = Brain.kL - 20 - switchBoost.w()
            switchBoost.isOn = false
            switchBoost.onTintColor = Brain.kColorMain
            switchBoost.tintColor = Brain.kColorMain
            view.addSubview(switchBoost)
            
            switchsBoost.append(switchBoost)
            
            
        }


       

        
    }
    
    @objc func touchNext(_ sender: UIButton){
         
        self.nextButton.loadingIndicatorWhite(true)

        if self.service.object(forKey: Brain.kServiceBoost) != nil {

            let boosts = self.service.object(forKey: Brain.kServiceBoost) as! [[String:Any]]
            var boostsObject = [[String:Any]]()
            
            for i in 0..<boosts.count {
                
                let boost = boosts[i]
                let switchBoost = switchsBoost[i]
                
                if switchBoost.isOn == true {
                    
                    var price = Double(0)

                    if boost[Brain.kBoostFixedPrice] != nil {
                       
                       price = price + Double(truncating: boost[Brain.kBoostFixedPrice]  as! NSNumber)
                    }

                    if boost[Brain.kBoostVariablePrice] != nil {
                      
                       let mowing = self.request[Brain.kRequestMowing] as! [String:Any]
                       let area = mowing[Brain.kUserMowingAreaResult] as! Int
                       price = price + Double(area) * Double(truncating: boost[Brain.kBoostVariablePrice]  as! NSNumber)
                    }

                    var boostObject = [String:Any]()
                    boostObject[Brain.kName] = boost[Brain.kName] as! String
                    boostObject[Brain.kNameFr] = boost[Brain.kNameFr] as! String
                    boostObject[Brain.kBoostPrice] = price
                    boostsObject.append(boostObject)
                   
                }
                
            }
            
            if boostsObject.count > 0 {
                
                Intercom.logEvent(withName: "customer_AddBoostMode")

                self.request.setObject(boostsObject, forKey: Brain.kRequestBoost)
            
            }else{
                
                self.request.remove(forKey: Brain.kRequestBoost)

            }

            
        }else{
            
            self.request.remove(forKey: Brain.kRequestBoost)
        }


        var arrayOptionsPics = [PFFileObject]()

        if self.image1 != nil {
            
            arrayOptionsPics.append(self.image1!)
        }
        if self.image2 != nil {
            
            arrayOptionsPics.append(self.image2!)
        }
        if self.image3 != nil {
            
            arrayOptionsPics.append(self.image3!)
        }
        if self.image4 != nil {
            
            arrayOptionsPics.append(self.image4!)
        }

       
        
        
        
        if arrayOptionsPics.count > 0 {
            
            Intercom.logEvent(withName: "customer_AddOptionsPhotos")

            self.request.setObject(arrayOptionsPics, forKey: Brain.kRequestPhotos)
        }else{
            
            self.request.remove(forKey: Brain.kRequestPhotos)
        }

            
            
            
            
            
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
               
                let takeVideo = CameraViewController(request:self.request)
                self.navigationController?.pushViewController(takeVideo, animated: true)
               
               self.nextButton.loadingIndicatorWhite(false)

           })
           
       }
    
    
    
    @objc func removePic1(_ sender : UIButton){

        self.removePhoto1.isHidden = true
        self.image1 = nil
        self.media1Photo.image = UIImage(named: "iconBigPhotos")
    }
    
    @objc func removePic2(_ sender : UIButton){

        self.removePhoto2.isHidden = true
        self.image2 = nil
        self.media2Photo.image = UIImage(named: "iconBigPhotos")
    }
    
    @objc func removePic3(_ sender : UIButton){

        self.removePhoto3.isHidden = true
        self.image3 = nil
        self.media3Photo.image = UIImage(named: "iconBigPhotos")
    }
    
    @objc func removePic4(_ sender : UIButton){

        self.removePhoto4.isHidden = true
        self.image4 = nil
        self.media4Photo.image = UIImage(named: "iconBigPhotos")
    }
   
    
    @objc func touchPic1(_ sender : UIButton){
        
        let picker = self.showCameraPicker()
        picker.modalPresentationStyle = .formSheet
        present(picker, animated: true, completion: nil)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
              
                
                return
            }
            
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):

                     self.media1Photo.image = photo.image

                      let imageData = photo.image.jpegData(compressionQuality: 0.3)
                      self.image1 = PFFileObject(name:"profile.jpg", data:imageData!)
                      self.image1?.saveInBackground()
                     
                     self.removePhoto1.isHidden = false


                    picker.dismiss(animated: true, completion: nil)
                    
                case .video( _): break
                    
                }
            }
            
        }
        
    }
        
    
    @objc func touchPic2(_ sender : UIButton){
        
        let picker = self.showCameraPicker()
        picker.modalPresentationStyle = .formSheet
        present(picker, animated: true, completion: nil)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
              
                
                return
            }
            
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):

                     self.media2Photo.image = photo.image

                      let imageData = photo.image.jpegData(compressionQuality: 0.3)
                      self.image2 = PFFileObject(name:"profile.jpg", data:imageData!)
                      self.image2?.saveInBackground()

                     self.removePhoto2.isHidden = false

                 
                    picker.dismiss(animated: true, completion: nil)
                    
                case .video( _): break
                    
                }
            }
            
        }
        
    }
    
    @objc func touchPic3(_ sender : UIButton){
        
        let picker = self.showCameraPicker()
        picker.modalPresentationStyle = .formSheet
        present(picker, animated: true, completion: nil)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
              
                
                return
            }
            
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):

                     self.media3Photo.image = photo.image

                      let imageData = photo.image.jpegData(compressionQuality: 0.3)
                      self.image3 = PFFileObject(name:"profile.jpg", data:imageData!)
                      self.image3?.saveInBackground()

                     self.removePhoto3.isHidden = false

                 
                    picker.dismiss(animated: true, completion: nil)
                    
                case .video( _): break
                    
                }
            }
            
        }
        
    }
    
    
    @objc func touchPic4(_ sender : UIButton){
        
        let picker = self.showCameraPicker()
        picker.modalPresentationStyle = .formSheet
        present(picker, animated: true, completion: nil)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
              
                
                return
            }
            
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):

                     self.media4Photo.image = photo.image

                     let imageData = photo.image.jpegData(compressionQuality: 0.3)
                     self.image4 = PFFileObject(name:"profile.jpg", data:imageData!)
                     self.image4?.saveInBackground()

                     self.removePhoto4.isHidden = false

                    picker.dismiss(animated: true, completion: nil)
                    
                case .video( _): break
                    
                }
            }
            
        }
        
    }
    
    func showCameraPicker() -> YPImagePicker {
           

            var config = YPImagePickerConfiguration()
            config.usesFrontCamera = false
            config.showsPhotoFilters = false
            config.startOnScreen = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.screens = [.library, .photo]
            config.showsCrop = .none
            config.targetImageSize = YPImageSize.cappedTo(size: 512)
            config.hidesStatusBar = false
            config.hidesBottomBar = false

            return  YPImagePicker(configuration: config)
        
        }
    
  
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barStyle = .black

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        
        Intercom.logEvent(withName: "customer_openOptionsView")

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
