//
//  SignupPhone2ViewController.swift
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



class SignupPhone2ViewController: UIViewController , UIGestureRecognizerDelegate, UITextFieldDelegate{
    
    
    var textA: UILabel!
    var textB: UILabel!
    
    var textField: UITextField!
    
    var backButtonNav:UIButton!
    var nextButton:UIButton!
    
    var notreceived:UIButton!

    var prefixe:String!
    var code:String!
    var updatePhone = false
    var editProfileVC : EditProfileViewController?
    var user : PFUser!

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    convenience init(user : PFUser, code:String)
    {
        
        self.init()
        self.code = code
        self.user = user

    }
    
    convenience init(code:String, phone:String, updatePhone : Bool, editProfileVC : EditProfileViewController!)
       {
           
           self.init()
           self.code = code
           self.updatePhone = updatePhone
           self.editProfileVC = editProfileVC
           
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
        textA.text = NSLocalizedString("Confirmation code", comment: "")
        textA.textColor = .black
        view.addSubview(textA)
        
        
        textB = UILabel(frame: CGRect(x: 0, y: textA.frame.origin.y + 32, width: Brain.kLargeurIphone, height: 20))
        textB.textAlignment = .center
        textB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textB.text = NSLocalizedString("You will receive a code by text message", comment: "")
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
        textField.placeholder = NSLocalizedString("Code", comment: "")
        textField.textColor = .black
        textField.placeholderColor(color: UIColor(hex: "ADADAD"))
        textField.keyboardType = .numberPad
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
        

//        notreceived = UIButton(frame: CGRect(x: 0, y: nextButton.yBottom() + 10, width: Brain.kLargeurIphone, height: 30))
//        notreceived.setTitle(NSLocalizedString("Code not received?", comment: ""), for: .normal)
//        notreceived.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//        notreceived.setTitleColor(UIColor.gray, for: .normal)
//        notreceived.setTitleColor(UIColor.lightGray, for: .highlighted)
//        notreceived.addTarget(self, action: #selector(notreceivedCode(_:)), for: .touchUpInside)
//        notreceived?.titleLabel?.textAlignment = NSTextAlignment.center
//        view.addSubview(notreceived)
        
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
    
    @objc func notreceivedCode(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @objc func touchNext(_ sender: UIButton){
     
 
        next()
       
    }
    
    func next(){
       
        self.textField.resignFirstResponder()
         
         if self.updatePhone == true {
             
             PFUser.current()?.saveInBackground()

             editProfileVC!.pushToEditPhone = false
             editProfileVC!.dismiss(animated: true, completion: {
             
             })
             
             
         }else{
             
             self.navigationController!.pushViewController(SignupTypeWorkerViewController(user: self.user), animated: true)

         }
        
    }
    
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        if(textField.text?.count == 4){
            
            
            if(textField.text == self.code){

                nextButton.isEnabled = true
                nextButton.alpha = 1.0

                
            }else{
                
                nextButton.isEnabled = false
                nextButton.alpha = 0.5

            }
            
        }else{
            
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 4 // Bool
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
