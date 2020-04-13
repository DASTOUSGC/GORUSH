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
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

     
        videoContainer = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kL, height: Brain.kH - 230 ))
        view.addSubview(videoContainer)
        
        
        
        //Video Background
        guard let path = Bundle.main.path(forResource: "videoGoRush", ofType:"mov") else {
            debugPrint("videoGoRush not found")
            return
        }
        self.player = AVPlayer(url: URL(fileURLWithPath: path))
        self.player.isMuted = true
        self.videoLayer = AVPlayerLayer(player: self.player)
        self.videoLayer.frame = self.videoContainer.frame
        self.videoLayer.videoGravity = .resizeAspectFill
        self.videoContainer.layer.sublayers = nil
        self.videoContainer.layer.addSublayer(self.videoLayer)
        
        
        
        //Overlay video
        filter = UIImageView(frame: CGRect(x: 0, y: 0, width:  self.videoContainer.w(), height: self.videoContainer.h() ))
        filter.backgroundColor = UIColor.black
        filter.alpha = 0.1
        videoContainer.addSubview(filter)

        
        
        //Logo
        if isIphoneXFamily() {
            logo = UIImageView(frame: CGRect(x: ( Brain.kL - 168 ) / 2, y: yTop()+170, width: 168, height: 210))
        }else{
            logo = UIImageView(frame: CGRect(x: ( Brain.kL - 168 ) / 2, y: yTop()+140, width: 168, height: 210))
        }

        logo.image = UIImage.init(named:"logo")
        view.addSubview(logo)
        
      
        
        //Login signup btns
        if isIphoneXFamily() {
            loginButtonFacebook = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-328)/2, y: yBottom() - 160-15, width:328, height: 60))
        }else{
            
            loginButtonFacebook = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-328)/2, y: yBottom()  - 160-25, width:328, height: 60))
        }

        loginButtonFacebook.layer.cornerRadius = 30
        loginButtonFacebook.clipsToBounds = true
        loginButtonFacebook.layer.borderWidth = 1.3
        loginButtonFacebook.layer.borderColor = Brain.kColorMain.cgColor
        loginButtonFacebook.setBackgroundImage(UIImage.init(named:NSLocalizedString("connectFb", comment: "")), for: UIControl.State.normal)
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

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForegroundNotification),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterBackground),
                                               name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loopVideo),
                                               name: .AVPlayerItemDidPlayToEndTime, object: nil)
        

    }
    
  
    @objc func loopVideo() {
        self.player.seek(to: .zero)
        self.player.play()

    }
  
    @objc func appWillEnterForegroundNotification() {
        
        player?.play()

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
        
        player.pause()
        
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    @objc func touchTerms (_ sender : UIButton){
        
        
        
        if PFConfig.current().object(forKey: Brain.kConfigTerms) as? String != nil {
            
            
            let webview = WebViewController(link: PFConfig.current().object(forKey: Brain.kConfigTerms) as! String)
            
            
            self.present(webview, animated: true) {
                
                
            }
            
        }
        
    }
   
    @objc func touchLoginFacebook(_ sender: UIButton){
        
        self.loginButtonFacebook.loadingIndicatorLetsgoButton(true, image: NSLocalizedString("connectFb", comment: ""))

        self.loginButton.isEnabled = false
        self.signupButton.isEnabled = false

        PFFacebookUtils.logInInBackground(withReadPermissions: Brain.kFacebookPermissions) { (user, error) in
               
               
                self.loginButton.isEnabled = true
                self.signupButton.isEnabled = true
                self.player.play()

            
               if  error != nil{
                   
                    self.loginButtonFacebook.loadingIndicatorLetsgoButton(false, image: NSLocalizedString("connectFb", comment: ""))

               }else if let user = user{
                   
                   
                if user.isNew == true || user.object(forKey: Brain.kUserPhone) == nil{
                       
                    self.player.play()
                 
                    PFUser.current()?.acl = PFACL(user: PFUser.current()!)
                    PFUser.current()?.acl?.setReadAccess(true, forRoleWithName: "User")
                    PFUser.current()?.setObject(0, forKey: Brain.kUserReviewsWorkerNumber)
                    PFUser.current()?.setObject(0, forKey: Brain.kUserReviewsCustomerNumber)
                    PFUser.current()?.setObject(5, forKey: Brain.kUserRateWorker)
                    PFUser.current()?.setObject(5, forKey: Brain.kUserRateCustomer)
                   
                   
                    GraphRequest(graphPath: "me", parameters: ["fields": Brain.kFacebookData])
                       .start(completionHandler: { (connection, result, error) -> Void in
                           
                           if let error = error {
                               
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
                               
                               
                               
                               if let fbId = fields["id"] as? String {
                                   
                                   PFUser.current()?.setObject(fbId, forKey: Brain.kUserFacebookId)
                               }
                               
                               
                            
                               
                               if let imageURL = ((fields["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                                   
                                   
                                   let url = URL(string: imageURL)
                                   URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                       
                                       
                                       if let error = error {
                                           
                                           print(error)
                                           
                                       }else if let data = data {
                                           
                                           
                                            DispatchQueue.main.async {
                                             
                                                let file = PFFileObject(name:"profile.jpg", data:data)
                                                 
                                                 PFUser.current()?.setObject(file!, forKey: Brain.kUserProfilePicture)
                                                 PFUser.current()?.saveInBackground()
                                              
                                              
                                                 if PFUser.current()?.object(forKey: Brain.kUserEmail) != nil {
                                                     
                                                     self.navigationController?.pushViewController(SignupPhone1ViewController(user: PFUser.current()!), animated: true)

                                                 }else{
                                                     
                                                     self.navigationController?.pushViewController(SignupEmailViewController(), animated: true)

                                                 }
                                                
                                            }
                                        

                                       }
                                       
                                       
                                       
                                   }).resume()
                                   
                                   
                               }
                               
                            
                            
                               
                                    
                                    

                           }
                       })
                   
                
                    
                }else{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.loginDone()


                }
                   
                  
                   
               }else{

                    self.loginButtonFacebook.loadingIndicatorLetsgoButton(false, image: NSLocalizedString("connectFb", comment: ""))
                    self.loginButton.isEnabled = true
                    self.signupButton.isEnabled = true
                    self.player.play()

               }
        }
           
        
    }
    
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
   
    
    @objc func touchSignup(_ sender: UIButton){
        
        navigationController?.pushViewController(SignupEmailViewController(), animated: true)

    }
    
    @objc func touchSignin(_ sender: UIButton){
        
        navigationController?.pushViewController(SigninEmailViewController(), animated: true)

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
