//
//  SignupEmailViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 18-02-05.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//


import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit



class SignupEmailViewController: UIViewController , UIGestureRecognizerDelegate, UITextFieldDelegate{
    
    
    
    var textA: UILabel!
    var textB: UILabel!
    var textField: UITextField!

    var backButtonNav:UIButton!
    var nextButton:UIButton!

    
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
        textA.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        textA.textColor = .black
        textA.text = NSLocalizedString("What's your email?", comment: "")
        view.addSubview(textA)
        
        
        textB = UILabel(frame: CGRect(x: 0, y: textA.frame.origin.y + 32, width: Brain.kLargeurIphone, height: 20))
        textB.textAlignment = .center
        textB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textB.text = NSLocalizedString("This will let you sign in to GoRush", comment: "")
        textB.textColor = UIColor(hex:"ADADAD")
        view.addSubview(textB)
        
        
        textField = UITextField(frame: CGRect(x: 20, y: textB.yBottom() + 30, width: Brain.kLargeurIphone-40, height: 60))
        textField.textAlignment = .center
        textField.layer.cornerRadius = 30
        textField.backgroundColor = UIColor(hex: "FCFCFC")
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        textField.returnKeyType = .next
        textField.tintColor = Brain.kColorMain
        textField.keyboardType = .emailAddress
        textField.placeholder = NSLocalizedString("Email", comment: "")
        textField.placeholderColor(color: UIColor(hex: "ADADAD"))
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textField)

        nextButton = UIButton(frame: CGRect(x:20, y: textField.yBottom() + 10, width:Brain.kLargeurIphone-40, height: 60))
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

    }
    
   
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
   
    @objc func touchNext(_ sender: UIButton){
        
        
      next()


    }
    
    func next(){
        
        nextButton.loadingIndicatorWhite(true)

        PFCloud.callFunction(inBackground: "checkEmail",
                           withParameters:["email":textField.text!.lowercased()]) { (object:Any?, error:Error?) in

        self.nextButton.loadingIndicator(false)

          if  error != nil{

              let alert = UIAlertController(title: NSLocalizedString("Email already used", comment: ""), message: "Sorry, this email is already registered", preferredStyle: .alert)
             
              alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil))
              self.present(alert, animated: true, completion: nil)


          }else{


            if PFUser.current() != nil {
                
                PFUser.current()!.email = self.textField.text!.lowercased()
                self.navigationController?.pushViewController(SignupPhone1ViewController(user: PFUser.current()!), animated: true)

            }else{
                
                let user = PFUser()
                user.username = self.textField.text!.lowercased()
                user.email = self.textField.text!.lowercased()
                self.navigationController?.pushViewController(SignupFirstNameViewController(user: user), animated: true)
                
                    
            }
             

          }

        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        if (textField.text?.isValidEmail() ?? false) {
            
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
