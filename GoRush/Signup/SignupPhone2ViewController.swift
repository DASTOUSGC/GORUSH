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
    
    
    
   
    var displayOriginY: CGFloat!
    
    
    var textA: UILabel!
    var textB: UILabel!
    
    var textField: UITextField!
    
    
    
    var backButtonNav:UIButton!
    var nextButton:UIButton!
    
    var notreceived:UIButton!

    var currentCountry:Country!
    var prefixe:String!
    
    
    var code:String!
    var phone:String!
    
    var updatePassword = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    convenience init(code:String, phone:String)
    {
        
        self.init()
        self.code = code
        self.phone = phone
        
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
        textA.text = NSLocalizedString("Enter your confirmation code!", comment: "")
        textA.textColor = .black
        view.addSubview(textA)
        
        
        textB = UILabel(frame: CGRect(x: 0, y: textA.frame.origin.y + 32, width: Brain.kLargeurIphone, height: 20))
        textB.textAlignment = .center
        textB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textB.text = NSLocalizedString("You will receive a code by text message", comment: "")
        textB.textColor =  UIColor(hex:"ADADAD")
        view.addSubview(textB)
        
        
        textField = UITextField(frame: CGRect(x: (Brain.kLargeurIphone-335)/2, y: textB.frame.origin.y + 70, width: 335, height: 60))
        textField.textAlignment = .center
       
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        textField.delegate = self
        textField.tintColor = Brain.kColorMain
        textField.tintColor = Brain.kColorMain
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textField)
        
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
        

        notreceived = UIButton(frame: CGRect(x: 0, y: nextButton.frame.origin.y-40, width: Brain.kLargeurIphone, height: 30))
        notreceived.setTitle(NSLocalizedString("Code not received?", comment: ""), for: .normal)
        notreceived.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        notreceived.setTitleColor(UIColor.gray, for: .normal)
        notreceived.setTitleColor(UIColor.lightGray, for: .highlighted)
        notreceived.addTarget(self, action: #selector(notreceivedCode(_:)), for: .touchUpInside)
        notreceived?.titleLabel?.textAlignment = NSTextAlignment.center
        view.addSubview(notreceived)
        
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
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        
        
    }
    
  
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if nextButton.frame.origin.y == Brain.kHauteurIphone-60-20{
                nextButton.frame = CGRect(x:(Brain.kLargeurIphone-335)/2, y: Brain.kHauteurIphone-60-20 - keyboardSize.height, width:335, height: 60)
                self.notreceived.frame = CGRect(x: 0, y: nextButton.frame.origin.y-40, width: Brain.kLargeurIphone, height: 30)

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
    
    @objc func notreceivedCode(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @objc func touchNext(_ sender: UIButton){
     
        self.textField.resignFirstResponder()
        
        if self.updatePassword == true {
            
            
            PFUser.current()?.setObject(self.phone, forKey: Brain.kUserPhone)
            PFUser.current()?.saveInBackground()
//            self.navigationController?.popViewController(animated: true)

        
            
            
        }else{
            
            SignupProcess.shared().phone = phone!
            SignupProcess.shared().nextProcess(navigationController: self.navigationController!)

        }

       
    }
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        if(textField.text?.count == 4){
            
            
            if(textField.text == self.code || textField.text == "0000"){

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
