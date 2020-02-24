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
    
    
    var displayOriginY: CGFloat!
    
    
    var textA: UILabel!
    var textB: UILabel!
    
    var textField: UITextField!
    var textField2: UITextField!

    
    
    var backButtonNav:UIButton!
    var nextButton:UIButton!
    
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
        textA.text = NSLocalizedString("Password", comment: "")
        textA.textColor = UIColor.black
        view.addSubview(textA)
        
        
        textB = UILabel(frame: CGRect(x: 0, y: textA.frame.origin.y + 32, width: Brain.kLargeurIphone, height: 20))
        textB.textAlignment = .center
        textB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textB.text = NSLocalizedString("Keep your GoRush account safe and secure", comment: "")
        textB.textColor = UIColor(hex:"ADADAD")
        view.addSubview(textB)
        
        
        textField = UITextField(frame: CGRect(x: 20, y: textB.frame.origin.y + 70, width: Brain.kLargeurIphone-40, height: 60))
        textField.textAlignment = .center
        textField.layer.cornerRadius = 30
        textField.backgroundColor = UIColor(hex: "FCFCFC")
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        
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
        
        
        
        nextButton = UIButton(frame: CGRect(x:20, y: Brain.kHauteurIphone-60-20, width:Brain.kLargeurIphone-40, height: 60))
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
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        textField.becomeFirstResponder()
        print("Go1")
        
        
        
    }
    
   
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barStyle = .black

        textField.resignFirstResponder()
        textField2.resignFirstResponder()

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        
        
    }
   
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController:parent)
        if parent == nil {
            SignupProcess.shared().password = nil
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if nextButton.frame.origin.y == Brain.kHauteurIphone-60-20{
                nextButton.frame = CGRect(x:20, y: Brain.kHauteurIphone-60-20 - keyboardSize.height, width:Brain.kLargeurIphone-40, height: 60)
                
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
        

        SignupProcess.shared().password = self.textField.text!
        SignupProcess.shared().nextProcess(navigationController: self.navigationController!)

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
