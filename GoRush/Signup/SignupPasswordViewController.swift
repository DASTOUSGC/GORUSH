//
//  SignupPasswordViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 18-02-05.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//


import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit


class SignupPasswordViewController: UIViewController , UIGestureRecognizerDelegate, UITextFieldDelegate{
    
    
    
    var textA: UILabel!
    var textB: UILabel!
    var textField: UITextField!
    var textField2: UITextField!

    
    var backButtonNav:UIButton!
    var nextButton:UIButton!
    
    var user : PFUser!
    
    convenience init(user:PFUser){

           self.init()
           self.user = user
           
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        
        self.backButtonNav = UIButton(frame:CGRect(x:10, y: yTop() + 35,width:40,height:40))
        self.backButtonNav.setBackgroundImage(UIImage.init(named:"backButtonWithoutNav"), for: UIControl.State.normal)
        self.backButtonNav.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButtonNav)
        
        
        textA = UILabel(frame: CGRect(x: 0, y: yTop() + 80, width: Brain.kLargeurIphone, height: 30))
        textA.textAlignment = .center
        textA.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        textA.text = NSLocalizedString("Password", comment: "")
        textA.textColor = UIColor.black
        view.addSubview(textA)
        
        
        textB = UILabel(frame: CGRect(x: 0, y: textA.frame.origin.y + 32, width: Brain.kLargeurIphone, height: 20))
        textB.textAlignment = .center
        textB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textB.text = NSLocalizedString("Keep your account safe", comment: "")
        textB.textColor = UIColor(hex:"ADADAD")
        view.addSubview(textB)
        
        
        textField = UITextField(frame: CGRect(x: 20, y: textB.yBottom() + 30, width: Brain.kLargeurIphone-40, height: 60))
        textField.textAlignment = .center
        textField.layer.cornerRadius = 30
        textField.backgroundColor = UIColor(hex: "FCFCFC")
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        textField.tag = 10
        textField.returnKeyType = .next
        textField.tintColor = Brain.kColorMain
        textField.isSecureTextEntry = true
        textField.placeholder = NSLocalizedString("Password", comment: "")
        textField.placeholderColor(color: UIColor(hex: "ADADAD"))
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textField)
        
        
        textField2 = UITextField(frame: CGRect(x: 20, y: textField.yBottom() + 10, width: Brain.kLargeurIphone-40, height: 60))
        textField2.textAlignment = .center
        textField2.layer.cornerRadius = 30
        textField2.textColor = UIColor.black
        textField2.tag = 11
        textField2.returnKeyType = .next
        textField2.backgroundColor = UIColor(hex: "FCFCFC")
        textField2.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField2.delegate = self
        textField2.tintColor = Brain.kColorMain

        textField2.isSecureTextEntry = true
        textField2.placeholder = NSLocalizedString("Confirm Password", comment: "")
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
   
    
    
    @objc func touchNext(_ sender: UIButton){
        
        next()
    }
    
    
    func next(){
        
        self.user.password = textField.text!
        self.navigationController?.pushViewController(SignupPhone1ViewController(user: user), animated: true)
    }
    
    @objc func touchBackNav(_ sender: UIButton){
           
           
           self.navigationController?.popViewController(animated: true)
           
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        if (self.textField.text!.count > 0 && self.textField.text! == self.textField2.text!  ) {
            
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
            
        }else{
            
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
            
        }
    }
    
    
     
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let textTag = textField.tag+1
        let nextResponder = textField.superview?.viewWithTag(textTag) as? UITextField
        if(nextResponder != nil)
        {
            //textField.resignFirstResponder()
            nextResponder!.becomeFirstResponder()
        }
        else{
            // stop editing on pressing the done button on the last text field.

            next()

        }
        return true
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
}
