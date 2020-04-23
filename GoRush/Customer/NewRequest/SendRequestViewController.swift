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
import FBSDKCoreKit
import FBSDKLoginKit
import Intercom

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
    
    var iconBoost : UIImageView!
    var labelBoost : UILabel!
    
    var iconWhere : UIImageView!
    var labelWhere : UILabel!
    
    var iconWhen : UIImageView!
    var labelWhen : UILabel!
    
    var iconPhotos : UIImageView!
    var labelPhotos : UILabel!
    
    var labelSize : UIButton!
    var labelPrice : UILabel!
    
    var imageCard : UIImageView!
    var fourpoints : UIImageView!
    var numberCard : UILabel!
    var check : UIImageView!
    
    var cardView : UIButton!
    
    var paymentMethodLabel : UILabel!
    var rightArrow : UIImageView!

    var timer : Timer!
    
    
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
            
            let imageData = self.photo!.jpegData(compressionQuality: 0.5)
            let imageFile = PFFileObject(name:"request.png", data:imageData!)
            imageFile!.saveInBackground()
            self.request.setObject(imageFile!, forKey: Brain.kRequestPhoto)

        }
        
        if self.video != nil {
          
           
            do {
                               
               let data = try Data(contentsOf: self.video!)

                let video = PFFileObject(name:"request.mov", data:data)
                video!.saveInBackground()
                self.request.setObject(video!, forKey: Brain.kRequestVideo)
                   
               } catch {
                   print("error ici : \(error)")
               }
            
            
            let image: UIImage? = thumbnailImageFor(fileUrl: self.video!)
            
            if image != nil {
                
                let imageData = image!.jpegData(compressionQuality: 0.5)
                let img = PFFileObject(name:"request.png", data:imageData!)
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
        
        
        nextButton = UIButton(frame: CGRect(x:20, y: yTopBottomButtonCTA(), width:Brain.kLargeurIphone-40, height: 60))
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Go Rush!", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.applyGradient()
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
        
        self.labelSize = UIButton(frame: CGRect(x: 20, y: self.labelPhotos.yBottom() + 12, width: 120, height: 38))
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
        self.cardView.isHidden = true
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
        
        
        
        
    if (self.request.object(forKey: Brain.kRequestService) as! PFObject).object(forKey: Brain.kServicePendingPrice) as! Bool == true {
          
        let alert = UIAlertController(title: NSLocalizedString("Information", comment: ""), message: NSLocalizedString("For this service, you will receive a personalized price proposal in a few minutes that you can accept or refuse. In the meantime your request will remain pending.", comment: ""), preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

      }
     
      
        
    }
    
    
    @objc func updateTime(){



        if self.request.object(forKey: Brain.kRequestTimeLimit) as! Date > Date() {
           

            //Timer decroissant
            let cal = Calendar.current
            let d1 = self.request.object(forKey: Brain.kRequestTimeLimit) as! Date
            let d2 = Date()
            let components = cal.dateComponents([.hour,.minute,.second], from: d2, to: d1)
            
            self.labelWhen.text = String(format: "%.2d:%.2d:%.2d", components.hour!,components.minute!,components.second!).firstCapitalized

        }else{


            //Static
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "EEEE dd MMMM"
            self.labelWhen.text = String(format: "%@", dateFormat.string(from: Date())).firstCapitalized

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
        
        self.iconWhen.frame.origin.y = self.labelWhere.yBottom() + 12
        self.labelWhen.frame.origin.y = self.iconWhen.frame.origin.y
        
        
        self.iconPhotos.frame.origin.y = self.labelWhen.yBottom() + 12
        self.labelPhotos.frame.origin.y = self.iconPhotos.frame.origin.y

        if self.request.object(forKey: Brain.kRequestPhotos) != nil {
           
           self.labelPhotos.isHidden = false
           self.iconPhotos.isHidden = false
           self.labelSize.frame.origin.y = self.labelPhotos.yBottom() + 12
            
            self.labelPhotos.text = String(format:"%d", (self.request.object(forKey: Brain.kRequestPhotos) as! [PFFileObject]).count)

        }else{
           
           self.labelPhotos.isHidden = true
           self.iconPhotos.isHidden = true
           self.labelSize.frame.origin.y = self.labelWhen.yBottom() + 12

        }

        
        if self.request.object(forKey: Brain.kRequestSurface) != nil {

            self.labelPrice.frame.origin.y = self.labelSize.yBottom() + 10

        }else{
            
            
            self.labelSize.isHidden = true
            
            if self.labelPhotos.isHidden == true {
                
                self.labelPrice.frame.origin.y = self.labelWhen.yBottom() + 5

                
            }else{
                
                self.labelPrice.frame.origin.y = self.labelPhotos.yBottom() + 5

            }
            

        }
        
        
        
        
        self.iconService.file = self.service.object(forKey: Brain.kServiceIcon) as? PFFileObject
        self.iconService.loadInBackground()

        
        self.labelService.text = Utils.returnCodeLangageEnFr() == "fr" ?  self.service.object(forKey: Brain.kServicesNameFr) as? String : self.service.object(forKey: Brain.kServicesName) as? String

        self.labelWhere.text = self.request.object(forKey: Brain.kRequestAddress) as? String

        
        
        if self.request.object(forKey: Brain.kRequestSurface) != nil {
            
            self.labelSize.setTitle(String(format: NSLocalizedString("≅%dpi²", comment: ""), self.request.object(forKey: Brain.kRequestSurface) as! Int), for: .normal)

            
        }
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 40), NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.white]
         
        
        var customerPrice = Double(0)
        
        if self.request.object(forKey: Brain.kRequestPriceCustomer)  != nil {
            
            customerPrice = self.request.object(forKey: Brain.kRequestPriceCustomer) as! Double + priceBoost

        }
        
        let attributedString1 = NSMutableAttributedString(string:String(format: "%.2f", customerPrice), attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"$ + tx", attributes:attrs2)

        attributedString1.append(attributedString2)
        self.labelPrice.attributedText = attributedString1
        
        if customerPrice == 0 {
            
            let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25), NSAttributedString.Key.foregroundColor : UIColor.white]
            let attributedString1 = NSMutableAttributedString(string:NSLocalizedString("Price to be defined", comment: ""), attributes:attrs1)
            self.labelPrice.attributedText = attributedString1

        }
              
        
    }
    
    
    @objc func updatePaymentMethod(_ sender: UIButton){
        
        
        Intercom.logEvent(withName: "customer_openPaymentMethodFromSendRequest")

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
            
         
            var priceBoost = Double(0)
            
            var boost = false

            
            if self.request.object(forKey: Brain.kRequestBoost) != nil {
                
                boost = true
                
                let boosts = self.request.object(forKey: Brain.kRequestBoost) as! [[String:Any]]

                
                for i in 0..<boosts.count {
                    
                    let boost = boosts[i]
                    priceBoost = priceBoost + Double(truncating: boost[Brain.kBoostPrice] as! NSNumber)
                    
                }
                
                //Customer price
                let priceWithoutBoost = Double(truncating: self.request.object(forKey: Brain.kRequestPriceCustomer) as! NSNumber)
                var priceWithBoost = priceWithoutBoost + priceBoost
                
                self.request.setObject(priceWithBoost.rounded(toPlaces: 2), forKey: Brain.kRequestPriceCustomer)
              
                
                //Worker price
                priceWithBoost = priceWithBoost * (1 - (Double(self.service.object(forKey: Brain.kServiceFee) as! Int) / 100))
                self.request.setObject(priceWithBoost.rounded(toPlaces: 2), forKey: Brain.kRequestPriceWorker)

            }
            
            
            
            var price = Double(0)
            
            
            if self.request.object(forKey: Brain.kRequestPriceCustomer)  != nil {

                price = Double(truncating: self.request.object(forKey: Brain.kRequestPriceCustomer) as! NSNumber)
            }
          
            
            
            AppEvents.logPurchase(price, currency: "cad")

            let serviceName = (self.request.object(forKey: Brain.kRequestService) as! PFObject).object(forKey: Brain.kServicesName) as! String
            let serviceId = (self.request.object(forKey: Brain.kRequestService) as! PFObject).objectId!
            
            
            
            Intercom.logEvent(withName: "customer_purchase", metaData:
                [   "service":serviceName,
                    "serviceId":serviceId,
                    "price":price,
                    "boost":boost])

            self.nextButton.loadingIndicatorWhite(true)
            
            
            if PFUser.current()?.object(forKey: Brain.kUserDebug) != nil {

                 if PFUser.current()?.object(forKey: Brain.kUserDebug) as! Bool == true {
                    
                    self.request.setObject(true, forKey: Brain.kRequestDebug)
                }
            }
            
            
           
            
            self.request.saveInBackground { (done, error) in
                
                self.dismiss(animated: true) {
                    
                }
            }
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
        self.updateTime()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)

        
        
        if self.video != nil {

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
                  
            
        }
      
        
        self.checkPaymentsMethod()
        
        Intercom.logEvent(withName: "customer_openSendRequestView")

    }
    
    func checkPaymentsMethod(){
        

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
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
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
        
        if timer != nil {
            timer.invalidate()
        }
    }
    
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: .zero)
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
    let time = CMTimeMake(value: numerator, timescale: denominator)

    do {
        let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage: img)
        return thumbnail
    } catch {
        print(error)
        return nil
    }
}
