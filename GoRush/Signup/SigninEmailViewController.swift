//
//  SigninEmailViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 18-02-06.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//


import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit



class SigninEmailViewController: UIViewController , UIGestureRecognizerDelegate, UITextFieldDelegate{
    
    
    
    
    var displayOriginY: CGFloat!
    
    
    var textA: UILabel!
    var textB: UILabel!
    
    var textField: UITextField!
    var textField2: UITextField!

    
    
    var backButtonNav:UIButton!
    var nextButton:UIButton!
    
    var resetPasswordButton:UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .white

      
        displayOriginY = originY()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        
        self.backButtonNav = UIButton(frame:CGRect(x:10,y:displayOriginY + 35,width:40,height:40))
        self.backButtonNav.setBackgroundImage(UIImage.init(named:"backButtonWithoutNav"), for: UIControlState.normal)
        self.backButtonNav.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButtonNav)
        
        
        textA = UILabel(frame: CGRect(x: 0, y: displayOriginY+80, width: Brain.kLargeurIphone, height: 30))
        textA.textAlignment = .center
        textA.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        textA.text = NSLocalizedString("Sign in with email", comment: "")
        textA.textColor = .black

        view.addSubview(textA)
        
        
        textB = UILabel(frame: CGRect(x: 0, y: textA.frame.origin.y + 32, width: Brain.kLargeurIphone, height: 20))
        textB.textAlignment = .center
        textB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textB.text = NSLocalizedString("Enter your email", comment: "")
        textB.textColor = UIColor(hex:"ADADAD")
        view.addSubview(textB)
        
        
        textField = UITextField(frame: CGRect(x: (Brain.kLargeurIphone-335)/2, y: textB.frame.origin.y + 70, width: 335, height: 60))
        textField.textAlignment = .center
        textField.layer.cornerRadius = 30
        textField.backgroundColor = UIColor(hex: "FCFCFC")
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        textField.textColor = UIColor.black
        textField.tintColor = Brain.kColorMain
        textField.keyboardType = .emailAddress
        textField.placeholder = NSLocalizedString("Email", comment: "")
        textField.autocapitalizationType = .none
        textField.placeholderColor(color: UIColor(hex: "ADADAD"))
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textField)
        
        textField2 = UITextField(frame: CGRect(x: (Brain.kLargeurIphone-335)/2, y: textField.yBottom() + 10, width: 335, height: 60))
        textField2.textAlignment = .center
        textField2.layer.cornerRadius = 30
        textField2.textColor = UIColor.black
        textField2.backgroundColor = UIColor(hex: "FCFCFC")
        textField2.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField2.delegate = self
        textField2.tintColor = Brain.kColorMain
        textField2.isSecureTextEntry = true
        textField2.placeholder = NSLocalizedString("Password", comment: "")
        textField2.autocapitalizationType = .none
        textField2.placeholderColor(color: UIColor(hex: "ADADAD"))
        textField2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textField2)
        
        
        
        nextButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: Brain.kHauteurIphone-60-20, width:335, height: 60))
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        nextButton.applyGradient()
        view.addSubview(nextButton)
        
        resetPasswordButton = UIButton(frame: CGRect(x: 0, y: nextButton.frame.origin.y-40, width: Brain.kLargeurIphone, height: 30))
        resetPasswordButton.setTitle(NSLocalizedString("Can't sign in? Reset Password", comment: ""), for: .normal)
        resetPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        resetPasswordButton.setTitleColor(UIColor.gray, for: .normal)
        resetPasswordButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        resetPasswordButton.addTarget(self, action: #selector(touchResetPassword(_:)), for: .touchUpInside)
        resetPasswordButton?.titleLabel?.textAlignment = NSTextAlignment.center
        view.addSubview(resetPasswordButton)
        
        
        if UserDefaults.standard.object(forKey: "username") != nil {
            
            self.textField.text = UserDefaults.standard.object(forKey: "username") as? String
            
        }
        
        if UserDefaults.standard.object(forKey: "password") != nil {
            
            self.textField2.text = UserDefaults.standard.object(forKey: "password") as? String
            
        }
        
        
        if self.textField.text!.isValidEmail()  {
            
            resetPasswordButton.isHidden = false
            
            
        }else{
            
            resetPasswordButton.isHidden = true
            
        }
        
        if (self.textField.text!.isValidEmail() && self.textField2.text!.count > 0 ) {
            
            
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
            
        }else{
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.barStyle = .black

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        textField.becomeFirstResponder()
        
        
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        
        textField.resignFirstResponder()
        textField2.resignFirstResponder()

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        
        
    }
    
   
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController:parent)
        if parent == nil {
            
            if PFUser.current() != nil {
                
                PFUser.logOut()
            }
            
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if nextButton.frame.origin.y == Brain.kHauteurIphone-60-20{
                nextButton.frame = CGRect(x:(Brain.kLargeurIphone-335)/2, y: Brain.kHauteurIphone-60-20 - keyboardSize.height, width:335, height: 60)
                self.resetPasswordButton.frame = CGRect(x: 0, y: nextButton.frame.origin.y-40, width: Brain.kLargeurIphone, height: 30)

            }
        }
    }
    
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func touchNext(_ sender: UIButton){
        
        
        self.nextButton.loadingIndicator(true)
        self.backButtonNav.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        PFUser.logInWithUsername(inBackground: textField.text!, password: textField2.text!) { (userlogin, error) -> Void in
            
            
            if let error = error {
                
                PFUser.logOut()
                let alert = UIAlertController(title: NSLocalizedString("Signin error", comment: ""), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.permittedArrowDirections = []
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                }
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                
                self.nextButton.loadingIndicator(false)
                self.present(alert, animated: true, completion: nil)
                self.backButtonNav.isHidden = false
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                
                
            } else {
                
                
                UserDefaults.standard.set(self.textField.text!, forKey: "username")
                UserDefaults.standard.set(self.textField2.text!, forKey: "password")

                
                self.nextButton.loadingIndicator(false)
                self.backButtonNav.isHidden = false
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                
                SignupProcess.shared().updateInstallation()
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.loginDone(animated: true)
                
            }
            
        }
        
        
    }
    
    @objc func touchResetPassword(_ sender: UIButton){
        
        if (self.textField.text?.count)! > 0 {
            
            PFUser.requestPasswordResetForEmail(inBackground: self.textField.text!)
            
            let alert = UIAlertController(title: NSLocalizedString("Reset Pasword", comment: ""), message: NSLocalizedString("You will receive an email to reset your password.", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.permittedArrowDirections = []
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            
            self.nextButton.loadingIndicator(false)
            self.backButtonNav.isHidden = false
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
       
    }
    
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        if self.textField.text!.isValidEmail()  {
          
            resetPasswordButton.isHidden = false

            
        }else{
          
            resetPasswordButton.isHidden = true

        }
        
        if (self.textField.text!.isValidEmail() && self.textField2.text!.count > 0 ) {
            
            
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
            
        }else{
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
            
        }
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
