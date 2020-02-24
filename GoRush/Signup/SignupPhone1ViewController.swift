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



class SignupPhone1ViewController: UIViewController , UIGestureRecognizerDelegate, UITextFieldDelegate, CountryListDelegate{
    
    
    
   
    var displayOriginY: CGFloat!
    
    
    var textA: UILabel!
    var textB: UILabel!
    
    var textField: UITextField!
    
    
    
    var backButtonNav:UIButton!
    var nextButton:UIButton!
    
    var currentCountry:Country!
    var prefixe:String!

    var openCountries : UIButton!
    
    
    
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
        textA.text = NSLocalizedString("What's your phone number?", comment: "")
        textA.textColor = .black
        view.addSubview(textA)
        
        
        textB = UILabel(frame: CGRect(x: 0, y: textA.frame.origin.y + 32, width: Brain.kLargeurIphone, height: 20))
        textB.textAlignment = .center
        textB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textB.text = NSLocalizedString("This will confirm your identity", comment: "")
        textB.textColor =  UIColor(hex:"ADADAD")
        view.addSubview(textB)
        
        
        textField = UITextField(frame: CGRect(x: 20, y: textB.frame.origin.y + 70, width: Brain.kLargeurIphone-40, height: 60))
        textField.textAlignment = .center
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        textField.tintColor = Brain.kColorMain
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.sizeToFit()
        view.addSubview(textField)

        
        textField.sizeToFit()
        textField.frame.size.width = textField.frame.size.width + 40
        textField.frame.origin.x = (Brain.kLargeurIphone - textField.frame.size.width ) / 2

        
        
        nextButton = UIButton(frame: CGRect(x:20, y: originYBottomButtonCTA(), width:Brain.kLargeurIphone-40, height: 60))
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
        
        openCountries = UIButton(frame: CGRect(x: textField.frame.origin.x - 20, y: textField.frame.origin.y - 8, width: 40, height: 40))
        openCountries.setBackgroundImage(UIImage(named: "openPhoneCountry"), for: .normal)
        openCountries.addTarget(self, action: #selector(openPhone(_:)), for: .touchUpInside)
        openCountries.frame.origin.x =  textField.frame.origin.x - 35
        view.addSubview(openCountries)

        
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        let countryCode = carrier?.isoCountryCode
        let countries = Countries()
        for country:Country in countries.countries {
            
            if country.countryCode == (countryCode?.uppercased() ?? "FR"){
                
                selectedCountry(country: country)
            }
        }
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black

        navigationController?.setNavigationBarHidden(true, animated: animated)

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        textField.becomeFirstResponder()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        
        
        textField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        
        
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
  
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController:parent)
        if parent == nil {
            SignupProcess.shared().phone = nil
            
            if PFUser.current() != nil && self.navigationController!.viewControllers.count == 3{
                
                PFUser.logOut()
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if nextButton.frame.origin.y == originYBottomButtonCTA(){
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
    
    @objc func openPhone(_ sender: UIButton){
        
        
//        self.navigationController?.popViewController(animated: false)
        
        let countryList = CountryList()
        countryList.delegate = self
        let nav = UINavigationController(rootViewController: countryList)
        self.present(nav, animated: true) {
            
            
        }
        
    }
   
    
    @objc func touchNext(_ sender: UIButton){
        

        nextButton.loadingIndicatorWhite(true)
        self.backButtonNav.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        
        let code = String(Utils.randomNumber(inRange: 1000...9999))
        print("code : \(code)")
       
        
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//
//
//
//            self.nextButton.loadingIndicator(false)
//            self.backButtonNav.isHidden = false
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//
//            let verificationPhone = SignupPhone2ViewController(code: code, phone: self.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
//            self.pushViewController(verificationPhone, animated: true)
//
//        })
//
        
        var phone = self.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
        
            let phoneNumberKit = PhoneNumberKit()
            let phoneNumber =  try phoneNumberKit.parse(self.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            phone = phoneNumberKit.format(phoneNumber, toType: .e164) // +61236618300
            
       }
       catch {
       }



        PFCloud.callFunction(inBackground: "checkPhoneNumber",
                             withParameters:["phoneNumber":phone]) { (object:Any?, error:Error?) in


                                print("rrr phone \(error)")
                                
                                
                                if  error != nil && 1 == 2  {

                                    self.nextButton.loadingIndicator(false)
                                    self.backButtonNav.isHidden = false
                                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

                                    let alert = UIAlertController(title: NSLocalizedString("Phone number already used", comment: ""), message: "Sorry, this phone number is already registered", preferredStyle: UIAlertControllerStyle.alert)
                                    if let popoverController = alert.popoverPresentationController {
                                        popoverController.sourceView = self.view
                                        popoverController.permittedArrowDirections = []
                                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                                    }

                                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)


                                }else{


                                    var name = ""

                                    if PFUser.current() != nil {

                                        name = PFUser.current()!.object(forKey: Brain.kUserFirstName)! as! String

                                    }else{

                                        if SignupProcess.shared().firstname != nil {

                                            name = SignupProcess.shared().firstname!
                                        }
                                    }

                                    PFCloud.callFunction(inBackground: "sendSMSVerificationNumber",
                                                         withParameters:["code":code,
                                                                         "to":self.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                                                         "firstName":name]) { (object:Any?, error:Error?) in

                                                            self.nextButton.loadingIndicator(false)
                                                            self.backButtonNav.isHidden = false
                                                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true


                                                            if  error != nil {

                                                                print("err \(error)")


                                                            }else{

                                                                print("code \(code)")
                                                                let verificationPhone = SignupPhone2ViewController(code: code, phone: self.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                                                                self.pushViewController(verificationPhone, animated: true)


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
        
        textField.sizeToFit()
        textField.frame.size.width = textField.frame.size.width + 20
        textField.frame.origin.x = (Brain.kLargeurIphone - textField.frame.size.width ) / 2
        openCountries.frame.origin.x =  textField.frame.origin.x - 20
        
        if (textField.text!.count > prefixe.count && validePhone == true) {
            
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        }else{
            
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    func selectedCountry(country: Country) {
        
        currentCountry = country
        prefixe = "+"+currentCountry.phoneExtension
        textField.text = prefixe
        
//        rightButton.title = String(currentCountry.name!.prefix(12))
        
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
    
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        

        if (range.location <= prefixe.count - 1) {
            return false
        }
        
        return true
    }
    
}
