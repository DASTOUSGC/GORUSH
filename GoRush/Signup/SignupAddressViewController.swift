//
//  SignupAddressViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2020-02-07.
//  Copyright © 2020 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import Intercom


class SignupAddressViewController: UIViewController , UIGestureRecognizerDelegate, UITextFieldDelegate, DateTextFieldDelegate{
    
    
    
    var textA: UILabel!
    var textB: UILabel!
    
    var textFieldAddress: UITextField!
    var textFieldCity: UITextField!
    var textFieldPostalCode: UITextField!
    var textFieldBirthdate: DateTextField!

    
    var backButtonNav:UIButton!
    var nextButton:UIButton!
  
    
    var fromCustomerMode = false

  
    convenience init(fromCustomerMode:Bool)
    {
        
        self.init()
     
        self.fromCustomerMode = fromCustomerMode
                
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .white

            
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        
        self.backButtonNav = UIButton(frame:CGRect(x:10,y:  yTop() + 35,width:40,height:40))
        self.backButtonNav.setBackgroundImage(UIImage.init(named:"backButtonWithoutNav"), for: UIControl.State.normal)
        self.backButtonNav.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButtonNav)
        
        
        textA = UILabel(frame: CGRect(x: 0, y:  yTop() + 80, width: Brain.kLargeurIphone, height: 30))
        textA.textAlignment = .center
        textA.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        textA.text = NSLocalizedString("Some more information", comment: "")
        textA.textColor = UIColor.black
        view.addSubview(textA)
        
        
        textB = UILabel(frame: CGRect(x: 0, y: textA.frame.origin.y + 32, width: Brain.kLargeurIphone, height: 20))
        textB.textAlignment = .center
        textB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textB.text = NSLocalizedString("In order to become a GoRush worker", comment: "")
        textB.textColor = UIColor(hex:"ADADAD")
        view.addSubview(textB)
        
        
        
                  
        textFieldBirthdate = DateTextField(frame: CGRect(x: 20, y: textB.yBottom() + 30, width: Brain.kLargeurIphone-40, height: 60))
        textFieldBirthdate.dateFormat = .dayMonthYear
        textFieldBirthdate.separator = "/"
        textFieldBirthdate.textAlignment = .center
        textFieldBirthdate.layer.cornerRadius = 30
        textFieldBirthdate.tag = 100
        textFieldBirthdate.textColor = UIColor.black
        textFieldBirthdate.backgroundColor = UIColor(hex: "FCFCFC")
        textFieldBirthdate.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textFieldBirthdate.customDelegate = self
        textFieldBirthdate.tintColor = Brain.kColorMain
        textFieldBirthdate.placeholder = NSLocalizedString("Birth date", comment: "")
        textFieldBirthdate.placeholderColor(color: UIColor(hex: "ADADAD"))
        view.addSubview(textFieldBirthdate)
                
        
        textFieldAddress = UITextField(frame: CGRect(x: 20, y: textFieldBirthdate.yBottom() + 10, width: Brain.kLargeurIphone - 40, height: 60))
        textFieldAddress.textAlignment = .center
        textFieldAddress.layer.cornerRadius = 30
        textFieldAddress.backgroundColor = UIColor(hex: "FCFCFC")
        textFieldAddress.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textFieldAddress.delegate = self
        textFieldAddress.tintColor = Brain.kColorMain
        textFieldAddress.textColor = .black
        textFieldAddress.tag = 101
        textFieldAddress.returnKeyType = .next
        textFieldAddress.placeholder = NSLocalizedString("Address", comment: "")
        textFieldAddress.placeholderColor(color: UIColor(hex: "ADADAD"))
        textFieldAddress.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textFieldAddress)
        
        textFieldCity = UITextField(frame: CGRect(x: 20, y: textFieldAddress.yBottom() + 10, width: (Brain.kLargeurIphone-40)/2 - 5 + 30, height: 60))
        textFieldCity.textAlignment = .center
        textFieldCity.layer.cornerRadius = 30
        textFieldCity.textColor = UIColor.black
        textFieldCity.backgroundColor = UIColor(hex: "FCFCFC")
        textFieldCity.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textFieldCity.delegate = self
        textFieldCity.tag = 102
        textFieldCity.returnKeyType = .next
        textFieldCity.tintColor = Brain.kColorMain
        textFieldCity.placeholder = NSLocalizedString("City", comment: "")
        textFieldCity.placeholderColor(color: UIColor(hex: "ADADAD"))
        textFieldCity.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textFieldCity)
        
        
        textFieldPostalCode = UITextField(frame: CGRect(x: Brain.kLargeurIphone/2 + 35, y: textFieldAddress.yBottom() + 10, width: (Brain.kLargeurIphone-40)/2 - 35, height: 60))
        textFieldPostalCode.textAlignment = .center
        textFieldPostalCode.layer.cornerRadius = 30
        textFieldPostalCode.textColor = UIColor.black
        textFieldPostalCode.backgroundColor = UIColor(hex: "FCFCFC")
        textFieldPostalCode.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textFieldPostalCode.delegate = self
        textFieldPostalCode.tag = 103
        textFieldPostalCode.returnKeyType = .next
        textFieldPostalCode.tintColor = Brain.kColorMain
        textFieldPostalCode.placeholder = NSLocalizedString("Postal code", comment: "")
        textFieldPostalCode.placeholderColor(color: UIColor(hex: "ADADAD"))
        textFieldPostalCode.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textFieldPostalCode)
        
      
        nextButton = UIButton(frame: CGRect(x:20, y: textFieldPostalCode.yBottom() + 10 , width:Brain.kLargeurIphone-40, height: 60))
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
        textFieldBirthdate.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        textFieldCity.resignFirstResponder()
        textFieldPostalCode.resignFirstResponder()
        textFieldAddress.resignFirstResponder()
        textFieldBirthdate.resignFirstResponder()
        
        
    }
    
   
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @objc func touchNext(_ sender: UIButton){
        
        
      
        next()
        
    }
    
    
    func next(){

        
        Intercom.logEvent(withName: "worker_createWorkerMode")

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

      
        if self.textFieldBirthdate.text!.count < 10 {
                
                return
            }
            
            let day =  Int(self.textFieldBirthdate.text!.substring(with: 0..<2))!
            let month =  Int(self.textFieldBirthdate.text!.substring(with: 3..<5))!
            let year =  Int(self.textFieldBirthdate.text!.substring(with: 6..<10))!

            self.nextButton.loadingIndicatorWhite(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {

                let url = URL(string: "https://api.ipify.org")

                var ip = "0.0.0.0"
                
                do {
                 if let url = url {
                     let ipAddress = try String(contentsOf: url)
                     print("My public IP address is: " + ipAddress)
                    ip = ipAddress
                 }
                } catch let error {
                 print(error)
                }
                
                PFCloud.callFunction(inBackground: "CreateStripeBusinessAccount", withParameters: [
                    "email":PFUser.current()?.object(forKey: Brain.kUserEmail) as! String,
                    "firstname":PFUser.current()?.object(forKey: Brain.kUserFirstName) as! String,
                    "lastname":PFUser.current()?.object(forKey: Brain.kUserLastName) as! String,
                    "address":self.textFieldAddress.text!,
                    "city":self.textFieldCity.text!,
                    "postalcode":self.textFieldPostalCode.text!,
                    "ip": ip,
                    "dayBirth":day,
                    "monthBirth":month,
                    "yearBirth":year,

                ]) { (business, error) in
                   
                   if (business != nil) {
                    
                            
                    Intercom.logEvent(withName: "worker_createWorkerModeSuccess")

                          
                            let stripeWorker =  PFUser.current()?.object(forKey: Brain.kUserStripeCustomer) as! PFObject
                            stripeWorker.fetchInBackground { (stripeWorker, error) in
                                
                                
                                stripeWorker?.setObject((business! as! [String:Any])["id"] as! String, forKey: Brain.kStripeWorkerIdStripe)
                                stripeWorker?.saveInBackground()
                                
                                
                                
                                PFUser.current()?.setObject(PFConfig.current().object(forKey: Brain.kConfigExploreDistance) as! Int, forKey: Brain.kUserExploreDistance)
                                PFUser.current()?.setObject(PFConfig.current().object(forKey: Brain.kConfigSimultaneousJobs) as! Int, forKey: Brain.kUserSimultaneousJobs)
                                PFUser.current()?.setObject("ios", forKey: Brain.kUserPlatform)
                                PFUser.current()?.setObject("worker", forKey: Brain.kUserType)
                                PFUser.current()?.saveInBackground()
                                

                                appDelegate.tabBarController?.updateMode()
                                appDelegate.tabBarController?.selectedIndex = 0
                                
                                

                                
                                PFCloud.callFunction(inBackground: "AddFirstSkillsToBusiness", withParameters: [
                                                                          
                                    "userId":PFUser.current()!.objectId!

                                ]) { (user, error) in
                                                                   
                                    PFUser.current()?.fetchInBackground(block: { (done, error) in
                                        
                                        
                                           if self.fromCustomerMode == true {

                                           
                                               self.navigationController?.popViewController(animated: true)
                                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Change `2.0` to the desired number of seconds.
                                               // Code you want to be delayed
                                                
                                                   appDelegate.removeLoadingView()
                                                
                                               }
                                               
                                           }else{
                                               
                                               let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                               appDelegate.loginDone()

                                           }
            
                                    })
                                }
                                
                                
                               
                                
                            }
                            
                       
                        
                        
                   }else if error != nil{
                    
                    Intercom.logEvent(withName: "worker_createWorkerModeError", metaData: ["error":error!.localizedDescription])

                        self.nextButton.loadingIndicatorWhite(false)
                        print("error 233 \(String(describing: error))")
                    
                   }else{
                    
                    self.nextButton.loadingIndicatorWhite(false)

                    }

                }


            })
                
    }
    
    
    
    @objc func dateDidChange(dateTextField: DateTextField){
        
        updateTextfield()

    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        

        
        updateTextfield()
    }
    
    func updateTextfield(){
        
        
        if (self.textFieldBirthdate.text!.isEmpty || self.textFieldAddress.text!.isEmpty || self.textFieldPostalCode.text!.isEmpty || self.textFieldCity.text!.isEmpty || self.textFieldBirthdate.text!.count < 10 || validZipCode(postalCode: self.textFieldPostalCode.text!.uppercased()) == false) {

            nextButton.isEnabled = false
            nextButton.alpha = 0.5

        }else{

            nextButton.isEnabled = true
            nextButton.alpha = 1.0

        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
           
    
    
    
    func validZipCode(postalCode:String)->Bool{
          let postalcodeRegex = "[ABCEGHJKLMNPRSTVXY][0-9][ABCEGHJKLMNPRSTVWXYZ] ?[0-9][ABCEGHJKLMNPRSTVWXYZ][0-9]"
          let pinPredicate = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
          let bool = pinPredicate.evaluate(with: postalCode) as Bool
          return bool
      }
      
    
}


extension String {
   
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
       
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
       
        return String(self[startIndex..<endIndex])
    }
}
