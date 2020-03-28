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
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        
        self.backButtonNav = UIButton(frame:CGRect(x:10,y:yTop() + 35,width:40,height:40))
        self.backButtonNav.setBackgroundImage(UIImage.init(named:"backButtonWithoutNav"), for: UIControl.State.normal)
        self.backButtonNav.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButtonNav)
        
        
        textA = UILabel(frame: CGRect(x: 0, y: yTop()+80, width: Brain.kLargeurIphone, height: 30))
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
        
        
        textField = UITextField(frame: CGRect(x: 20, y: textB.frame.origin.y + 30, width: Brain.kLargeurIphone-40, height: 60))
        textField.textAlignment = .center
        textField.layer.cornerRadius = 30
        textField.backgroundColor = UIColor(hex: "FCFCFC")
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        textField.textColor = UIColor.black
        textField.tintColor = Brain.kColorMain
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.tag = 100
        textField.placeholder = NSLocalizedString("Email", comment: "")
        textField.autocapitalizationType = .none
        textField.placeholderColor(color: UIColor(hex: "ADADAD"))
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textField)
        
        textField2 = UITextField(frame: CGRect(x: 20, y: textField.yBottom() + 10, width: Brain.kLargeurIphone-40, height: 60))
        textField2.textAlignment = .center
        textField2.layer.cornerRadius = 30
        textField2.textColor = UIColor.black
        textField2.backgroundColor = UIColor(hex: "FCFCFC")
        textField2.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField2.delegate = self
        textField2.tag = 101
        textField2.returnKeyType = .next
        textField2.tintColor = Brain.kColorMain
        textField2.isSecureTextEntry = true
        textField2.placeholder = NSLocalizedString("Password", comment: "")
        textField2.autocapitalizationType = .none
        textField2.placeholderColor(color: UIColor(hex: "ADADAD"))
        textField2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textField2)
        
        
        
        nextButton = UIButton(frame: CGRect(x:20, y: textField2.yBottom() + 10, width:Brain.kLargeurIphone-40, height: 60))
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        nextButton.applyGradient()
        view.addSubview(nextButton)
        
        resetPasswordButton = UIButton(frame: CGRect(x: 0, y: nextButton.yBottom() + 20, width: Brain.kLargeurIphone, height: 30))
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
        textField.becomeFirstResponder()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        
        textField.resignFirstResponder()
        textField2.resignFirstResponder()
        
        
    }
    
    
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func touchNext(_ sender: UIButton){
        
        
        self.nextButton.loadingIndicatorWhite(true)
        
        
        PFUser.logInWithUsername(inBackground: textField.text!, password: textField2.text!) { (userlogin, error) -> Void in
            
            
            if let error = error {
                
                PFUser.logOut()
                self.nextButton.loadingIndicator(false)
                
                let alert = UIAlertController(title: NSLocalizedString("Sign in error", comment: ""), message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
               
                alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
            } else {
                
                
                UserDefaults.standard.set(self.textField.text!, forKey: "username")
                UserDefaults.standard.set(self.textField2.text!, forKey: "password")
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.updateInstallation()
                appDelegate.loginDone()
                self.nextButton.loadingIndicator(false)

                
            }
            
        }
        
        
    }
    
    @objc func touchResetPassword(_ sender: UIButton){
        
        if (self.textField.text?.count)! > 0 {
            
            PFUser.requestPasswordResetForEmail(inBackground: self.textField.text!)
            
            let alert = UIAlertController(title: NSLocalizedString("Reset password", comment: ""), message: NSLocalizedString("You will receive an email to reset your password.", comment: ""), preferredStyle: UIAlertController.Style.alert)
           
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            
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
    
    
}



