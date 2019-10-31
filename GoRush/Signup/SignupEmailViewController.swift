//
//  SignupEmailViewController.swift
//  templateProject
//
//  Created by Julien Levallois on 18-02-05.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//


import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit



class SignupEmailViewController: UIViewController , UIGestureRecognizerDelegate, UITextFieldDelegate{
    
    
    var displayOriginY: CGFloat!
    
    
    var textA: UILabel!
    var textB: UILabel!

    var textField: UITextField!

    
    
    var backButtonNav:UIButton!
    var nextButton:UIButton!

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        view.backgroundColor = Brain.kColorCustomGray

       
        displayOriginY = originY()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        

        
        self.backButtonNav = UIButton(frame:CGRect(x:10,y:displayOriginY + 35,width:40,height:40))
        self.backButtonNav.setBackgroundImage(UIImage.init(named:"backArrowWhite"), for: UIControlState.normal)
        self.backButtonNav.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButtonNav)
    
        
        textA = UILabel(frame: CGRect(x: 0, y: displayOriginY+80, width: Brain.kLargeurIphone, height: 30))
        textA.textAlignment = .center
        textA.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        textA.textColor = .white
        textA.text = NSLocalizedString("What's your email?", comment: "")
        view.addSubview(textA)
        
        
        textB = UILabel(frame: CGRect(x: 0, y: textA.frame.origin.y + 32, width: Brain.kLargeurIphone, height: 20))
        textB.textAlignment = .center
        textB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textB.text = NSLocalizedString("This will let you sign in to Salud", comment: "")
        textB.textColor = UIColor.white
        view.addSubview(textB)
        
        
        textField = UITextField(frame: CGRect(x: (Brain.kLargeurIphone-335)/2, y: textB.frame.origin.y + 70, width: 335, height: 60))
        textField.textAlignment = .center
        textField.layer.cornerRadius = 30
        textField.backgroundColor = UIColor(hex: "272727")
        textField.textColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        textField.tintColor = Brain.kColorMain
        textField.keyboardAppearance = .dark
        textField.keyboardType = .emailAddress
        textField.placeholder = NSLocalizedString("Email", comment: "")
        textField.placeholderColor(color: UIColor(hex: "8B898B"))
        textField.autocapitalizationType = .none
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
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        navigationController?.navigationBar.barStyle = .black
        
        textField.becomeFirstResponder()
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        

        super.viewWillDisappear(animated)
        
        textField.resignFirstResponder()

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)

       
    }
    
   
    
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController:parent)
        if parent == nil {
            SignupProcess.shared().email = nil
            
            if PFUser.current() != nil && self.navigationController!.viewControllers.count == 3{
                
                PFUser.logOut()
            }
            
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if nextButton.frame.origin.y == Brain.kHauteurIphone-60-20{
                nextButton.frame = CGRect(x:(Brain.kLargeurIphone-335)/2, y: Brain.kHauteurIphone-60-20 - keyboardSize.height, width:335, height: 60)

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
        
        
        nextButton.loadingIndicator(true)
        self.backButtonNav.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        PFCloud.callFunction(inBackground: "checkEmail",
                             withParameters:["email":textField.text!.lowercased()]) { (object:Any?, error:Error?) in
                  
        self.nextButton.loadingIndicator(false)
        self.backButtonNav.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

            if  error != nil{


                let alert = UIAlertController(title: NSLocalizedString("Email already used", comment: ""), message: "Sorry, this email is already registered", preferredStyle: UIAlertControllerStyle.alert)
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.permittedArrowDirections = []
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                }
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)


            }else{
                
                
                SignupProcess.shared().email = self.textField.text!.lowercased()
                SignupProcess.shared().nextProcess(navigationController: self.navigationController!)
                

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
