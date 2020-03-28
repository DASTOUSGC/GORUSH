//
//  SignupPhone1ViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 18-02-05.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//


import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import CoreTelephony
import PhoneNumberKit



class SignupPhone1ViewController: UIViewController , UIGestureRecognizerDelegate, UITextFieldDelegate{
    
    
    
    var textA: UILabel!
    var textB: UILabel!
    
    var textField: UITextField!
    
    
    
    var backButtonNav:UIButton!
    var nextButton:UIButton!
    
    var prefixe:String!

    
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
        
        
        
        self.backButtonNav = UIButton(frame:CGRect(x:10,y: yTop() + 35,width:40,height:40))
        self.backButtonNav.setBackgroundImage(UIImage.init(named:"backButtonWithoutNav"), for: UIControl.State.normal)
        self.backButtonNav.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButtonNav)
        
        
        textA = UILabel(frame: CGRect(x: 0, y: yTop() + 80, width: Brain.kLargeurIphone, height: 30))
        textA.textAlignment = .center
        textA.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        textA.text = NSLocalizedString("What's your phone number?", comment: "")
        textA.textColor = .black
        view.addSubview(textA)
        
        
        textB = UILabel(frame: CGRect(x: 0, y: textA.frame.origin.y + 32, width: Brain.kLargeurIphone, height: 20))
        textB.textAlignment = .center
        textB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textB.text = NSLocalizedString("This will confirm your identity", comment: "")
        textB.textColor =  UIColor(hex:"ADADAD")
        view.addSubview(textB)
        
        
        textField = UITextField(frame: CGRect(x: 20, y: textB.yBottom() + 30, width: Brain.kLargeurIphone-40, height: 60))
        textField.textAlignment = .center
        textField.layer.cornerRadius = 30
        textField.backgroundColor = UIColor(hex: "FCFCFC")
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        textField.returnKeyType = .next
        textField.tintColor = Brain.kColorMain
        textField.textColor = .black
        textField.keyboardType = .numberPad
        selectCountry()
        textField.placeholderColor(color: UIColor(hex: "ADADAD"))
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textField)

        
        
        nextButton = UIButton(frame: CGRect(x:20, y: textField.yBottom() + 10,  width:Brain.kLargeurIphone-40, height: 60))
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        textField.resignFirstResponder()

        if isMovingToParent && PFUser.current() != nil{
                   
                   PFUser.logOut()
        }
               
    }
    
  
    @objc func touchNext(_ sender: UIButton){
        

        next()
    }
    
    
    func next(){
        
        nextButton.loadingIndicatorWhite(true)

         let code = String(Utils.randomNumber(inRange: 1000...9999))
         var phone = self.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
         do {
         
             let phoneNumberKit = PhoneNumberKit()
             let phoneNumber =  try phoneNumberKit.parse(self.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
             phone = phoneNumberKit.format(phoneNumber, toType: .e164) // +61236618300
             
        }
        catch {}


         PFCloud.callFunction(inBackground: "checkPhoneNumber",
                          withParameters:["phoneNumber":phone]) { (object:Any?, error:Error?) in

                             
             if  error != nil   {

                self.nextButton.loadingIndicator(false)

                 let alert = UIAlertController(title: NSLocalizedString("Phone number already used", comment: ""), message: "Sorry, this phone number is already registered", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                 
                 self.present(alert, animated: true, completion: nil)


             }else{


                 PFCloud.callFunction(inBackground: "sendSMSVerificationNumber",
                  withParameters:["code":code,
                                  "to":self.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                  "firstName":self.user.object(forKey: Brain.kUserFirstName)!]) { (object:Any?, error:Error?) in

                     self.nextButton.loadingIndicator(false)

                     if  error == nil {
                        
                        
                        if PFUser.current() != nil {
                            
                            print("set phone...")
                            
                            PFUser.current()!.setObject(phone, forKey: Brain.kUserPhone)
                            PFUser.current()?.saveInBackground()
                            
                            
                        }else{
                            
                            self.user.setObject(phone, forKey: Brain.kUserPhone)

                        }
                        
                         self.navigationController!.pushViewController(SignupPhone2ViewController(user: self.user, code: code), animated: true)
                         self.nextButton.loadingIndicator(false)

                     }else{
                         
                        self.nextButton.loadingIndicator(false)

                         let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                           self.present(alert, animated: true, completion: nil)

                     }

                 }
             }
         }
         
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        var validePhone = false
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", "^((\\+)|(00))[0-9]{6,14}$")
        
        if phoneTest.evaluate(with: textField.text) {
            
            validePhone = true
        }
        
        
        if (textField.text!.count > prefixe.count && validePhone == true) {
            
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        }else{
            
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    func selectCountry() {
        
        prefixe = "+"+getCountryCode()
        textField.text = prefixe
        textField.placeholder = prefixe
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func touchBackNav(_ sender: UIButton){
         
         
         self.navigationController?.popViewController(animated: true)
         
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
        
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        

        if (range.location <= prefixe.count - 1) {
            return false
        }
        
        return true
    }
    
}
