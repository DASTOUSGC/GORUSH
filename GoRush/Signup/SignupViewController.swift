//
//  SignupViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 18-01-24.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import AVKit



class SignupViewController: UIViewController , UIGestureRecognizerDelegate, UIScrollViewDelegate{
    
    

   
    var displayOriginY: CGFloat!

    var loginButtonFacebook:UIButton!
    var loginButton:UIButton!
    var signupButton:UIButton!

    var logo : UIImageView!

    var terms:UIButton!

    var videoContainer : UIView!
    var filter : UIImageView!
    var videoLayer : AVPlayerLayer!
    var player: AVPlayer!



    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        displayOriginY = originY()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

     
        videoContainer = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kL, height: Brain.kH - 230 ))
        view.addSubview(videoContainer)
        
        
        
        //// Video Background
        guard let path = Bundle.main.path(forResource: "videoGoRush", ofType:"mov") else {
            debugPrint("videoGoRush not found")
            return
        }
        self.player = AVPlayer(url: URL(fileURLWithPath: path))
        self.videoLayer = AVPlayerLayer(player: self.player)
        self.videoLayer.frame = self.videoContainer.frame
        self.videoLayer.videoGravity = .resizeAspectFill
        self.videoContainer.layer.sublayers = nil
        self.videoContainer.layer.addSublayer(self.videoLayer)
        
        
        
        /// Overlay video
        filter = UIImageView(frame: CGRect(x: 0, y: 0, width:  self.videoContainer.w(), height: self.videoContainer.h() ))
        filter.backgroundColor = UIColor.black
        filter.alpha = 0.5
        videoContainer.addSubview(filter)

        
        
        /// Logo
        if isIphoneXFamily() {
            logo = UIImageView(frame: CGRect(x: ( Brain.kL - 168 ) / 2, y: displayOriginY+170, width: 168, height: 210))
        }else{
            logo = UIImageView(frame: CGRect(x: ( Brain.kL - 168 ) / 2, y: displayOriginY+140, width: 168, height: 210))
        }

        logo.image = UIImage.init(named:"logo")
        view.addSubview(logo)
        
      
        
        //// Login signup btns
        if isIphoneXFamily() {
            
            loginButtonFacebook = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-328)/2, y: yBottom() - 160-15, width:328, height: 60))

        }else{
            
            loginButtonFacebook = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-328)/2, y: yBottom()  - 160-25, width:328, height: 60))

        }

        loginButtonFacebook.layer.cornerRadius = 30
        loginButtonFacebook.clipsToBounds = true

        loginButtonFacebook.setBackgroundImage(UIImage.init(named:NSLocalizedString("connectFb", comment: "")), for: UIControlState.normal)
        loginButtonFacebook.setBackgroundImage(UIImage.init(named:NSLocalizedString("connectFbOn", comment: ""))?.alpha(0.6), for: UIControlState.highlighted)
        loginButtonFacebook.addTarget(self, action: #selector(touchLoginFacebook(_:)), for: .touchUpInside)
        view.addSubview(loginButtonFacebook)
        
  
        
        if isIphoneXFamily() {
            
            signupButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-328)/2, y: loginButtonFacebook.frame.origin.y+loginButtonFacebook.frame.size.height+15, width:328/2 - 10, height: 60))

        }else{
            
            signupButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-328)/2, y: loginButtonFacebook.frame.origin.y+loginButtonFacebook.frame.size.height+15, width:328/2 - 10, height: 60))

        }
        
        signupButton.layer.cornerRadius = 30
        signupButton.applyGradient()
        signupButton.setTitle(NSLocalizedString("Sign up", comment: ""), for: .normal)
        signupButton.addTarget(self, action: #selector(touchSignup(_:)), for: .touchUpInside)

        signupButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.setTitleColor(UIColor.white, for: .highlighted)
        view.addSubview(signupButton)
        
    
        if isIphoneXFamily() {
            
            loginButton = UIButton(frame: CGRect(x:signupButton.x() + signupButton.w() + 20, y: loginButtonFacebook.frame.origin.y+loginButtonFacebook.frame.size.height+15, width:328/2 - 10, height: 60))
            
        }else{
            
            loginButton = UIButton(frame: CGRect(x:signupButton.x() + signupButton.w() + 20, y: loginButtonFacebook.frame.origin.y+loginButtonFacebook.frame.size.height+15, width:328/2 - 10, height: 60))
            
        }
        
        loginButton.layer.cornerRadius = 30
        loginButton.backgroundColor = UIColor.clear
        loginButton.layer.borderColor = Brain.kColorMain.cgColor
        loginButton.layer.borderWidth = 1.2
        loginButton.setTitle(NSLocalizedString("Sign in", comment: ""), for: .normal)
        loginButton.addTarget(self, action: #selector(touchSignin(_:)), for: .touchUpInside)
        
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        loginButton.setTitleColor(Brain.kColorMain, for: .normal)
        loginButton.setTitleColor(Brain.kColorMain, for: .highlighted)
        view.addSubview(loginButton)
        
        
        
        if isIphoneXFamily() {
            
            terms = UIButton(frame: CGRect(x: 20, y: yBottom()  - 30, width:Brain.kLargeurIphone-40, height: 30))

        }else{
            
            terms = UIButton(frame: CGRect(x: 20, y: yBottom()  - 40, width:Brain.kLargeurIphone-40, height: 30))

        }
        
        terms.setTitle(NSLocalizedString("By signing up, you agree to our Terms and Conditions", comment: ""), for: .normal)
        terms.titleLabel?.font = UIFont.systemFont(ofSize: 9)
        terms.setTitleColor(UIColor.gray, for: .normal)
        terms.setTitleColor(UIColor(hex:"4A4A4A"), for: .highlighted)
        terms.addTarget(self, action: #selector(touchTerms(_:)), for: .touchUpInside)
        terms?.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        terms?.titleLabel?.textAlignment = NSTextAlignment.center
        view.addSubview(terms)
        
     

    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        loginButtonFacebook.loadingIndicatorFbButton(false)
        
        
        player?.play()
        self.player.isMuted = true

        

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForegroundNotification),
                                               name: .UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterBackground),
                                               name: .UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loopVideo),
                                               name: .AVPlayerItemDidPlayToEndTime, object: nil)
        

    }
    
  
    @objc func loopVideo() {
        self.player.seek(to: kCMTimeZero)
        self.player.play()
        self.player.isMuted = true

    }
  
    @objc func appWillEnterForegroundNotification() {
        
        player?.play()
        self.player.isMuted = true

    }
    
    
    @objc func appWillEnterBackground() {
        
        player?.pause()
            
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
     
        super.viewWillDisappear(animated)
        
        
      

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        player.isMuted = true
        player.pause()
        
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    @objc func touchTerms (_ sender : UIButton){
        
        
        
        if PFConfig.current().object(forKey: Brain.kConfigTerms) as? String != nil {
            
            
            let webview = EmbedWebViewController(link: PFConfig.current().object(forKey: Brain.kConfigTerms) as! String, title: NSLocalizedString("Terms & conditions", comment:""))
            
            let nav = UINavigationController(rootViewController: webview)
            nav.isNavigationBarHidden = true
            nav.navigationBar.isTranslucent = false
            
            self.present(nav, animated: true) {
                
                
            }
            
        }
        
    }
    
    func loginfb(){
        
        
        
        
        
        PFFacebookUtils.logInInBackground(withReadPermissions: Brain.kFacebookPermissions) { (user, error) in
            
            self.player.play()
            self.player.isMuted = true

            
            if let error = error{
                
                print("ici123 \(error)")
                
            }else if let user = user{
                
                self.loginButtonFacebook.loadingIndicatorFbButton(true)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                
                
                if user.isNew == true {
                    
                  
                    PFUser.current()?.acl = PFACL(user: PFUser.current()!)
                    PFUser.current()?.acl?.setReadAccess(true, forRoleWithName: "User")
                    

                    PFUser.current()?.setObject(0, forKey: Brain.kUserReviewsWorkerNumber)
                    PFUser.current()?.setObject(0, forKey: Brain.kUserReviewsCustomerNumber)
                    PFUser.current()?.setObject(5, forKey: Brain.kUserRateWorker)
                    PFUser.current()?.setObject(5, forKey: Brain.kUserRateCustomer)
                    
                }
                
                if (!user.isNew) && Brain.kLoginFacebookGetDataEachTime == false {
                    
                    
                    self.loginFacebookDone()
                    
                    return;
                }
                
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": Brain.kFacebookData])
                    .start(completionHandler: { (connection, result, error) -> Void in
                        
                        if let error = error {
                            
                            print("ici453 \(error)")
                            
                            print(error.localizedDescription)
                            return
                        }
                        
                        
                        if let fields = result as? [String:Any] {
                            
                            
                            if let firstName = fields["first_name"] as? String {
                                
                                PFUser.current()?.setObject(firstName, forKey: Brain.kUserFirstName)
                            }
                            
                            if let lastName = fields["last_name"] as? String {
                                
                                PFUser.current()?.setObject(lastName, forKey: Brain.kUserLastName)
                            }
                            
                            
                            if let email = fields["email"] as? String {
                                
                                PFUser.current()?.setObject(email, forKey: Brain.kUserEmail)
                            }
                            
                            if let fbId = fields["id"] as? String {
                                
                                PFUser.current()?.setObject(fbId, forKey: Brain.kUserFacebookId)
                            }
                            
                           
                            
                            
                            if let imageURL = ((fields["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                                
                                
                                let url = URL(string: imageURL)
                                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                    
                                    
                                    if let error = error {
                                        
                                        print(error)
                                        
                                    }else if let data = data {
                                        
                                        
                                        
                                        let file = PFFile(name:"profile.jpg", data:data)
                                        
                                        PFUser.current()?.setObject(file!, forKey: Brain.kUserProfilePicture)
                                        
                                        

                                        PFUser.current()?.saveInBackground(block: { (success:Bool, error:Error?) in
                                            
                                            self.loginFacebookDone()
                                            
                                        })
                                        
                                        
                                    }
                                    
                                    
                                    
                                }).resume()
                                
                                
                            }
                            
                            
                        }
                    })
                
                
            }
        }
        

        
    }
    
    
    
    @objc func touchLoginFacebook(_ sender: UIButton){
        
            self.loginfb()
      
    }
    
    func loginFacebookDone(){
        
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        SignupProcess.shared().nextProcess(navigationController: self.navigationController!)
        loginButtonFacebook.loadingIndicatorFbButton(false)
       
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
   
    
    @objc func touchSignup(_ sender: UIButton){
        
        SignupProcess.shared().nextProcess(navigationController: self.navigationController!)
    }
    
    @objc func touchSignin(_ sender: UIButton){
        
        
        let emailVC = SigninEmailViewController()
        navigationController?.pushViewController(emailVC, animated: true)
//
//        let typeVC = SignupAddressViewController(firstname: "tst", lastname:  "test" , email:  "ss")
//        
//        self.navigationController!.pushViewController(typeVC, animated: true)
        
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


extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
