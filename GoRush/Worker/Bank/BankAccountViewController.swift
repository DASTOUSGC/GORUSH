//
//  BankAccountViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2020-01-18.
//  Copyright © 2020 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Stripe
import Intercom




class BankAccountViewController: UIViewController , STPPaymentCardTextFieldDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate{
    
    
    
    /// Parameters
    let titleViewController = NSLocalizedString("Bank account", comment:"")
    let stringAccount = NSLocalizedString("This bank account will allow you to receive your weekly transfers from GoRush. 4 working days delay. The bank account must be a Canadian account. GoRush uses Stripe to secure bank payments. Powered by Stripe.com", comment: "")
    
    var textField: UITextField!
    var textField2: UITextField!
    var textField3: UITextField!

    var nextButton:UIButton!
    
    var descriptionAccount : UILabel!
    
    var oldBankAccountStripeId : String!

  
    
    override var prefersStatusBarHidden: Bool {
         return false
     }
     
     override var preferredStatusBarStyle: UIStatusBarStyle {
         
         return .lightContent
     }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        
        title = titleViewController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
    

        textField = UITextField(frame: CGRect(x: 20, y: 20, width: Brain.kLargeurIphone-40, height: 60))
        textField.textAlignment = .center
        textField.layer.cornerRadius = 30
        textField.backgroundColor = UIColor(hex: "FCFCFC")
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.tintColor = Brain.kColorMain
        textField.placeholder = NSLocalizedString("Account number", comment: "")
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
        textField2.placeholder = NSLocalizedString("Transit number", comment: "")
        textField2.autocapitalizationType = .none
        textField2.keyboardType = .numberPad
        textField2.placeholderColor(color: UIColor(hex: "ADADAD"))
        textField2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textField2)

    
        textField3 = UITextField(frame: CGRect(x: 20, y: textField2.yBottom() + 10, width: Brain.kLargeurIphone-40, height: 60))
        textField3.textAlignment = .center
        textField3.layer.cornerRadius = 30
        textField3.textColor = UIColor.black
        textField3.backgroundColor = UIColor(hex: "FCFCFC")
        textField3.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField3.delegate = self
        textField3.keyboardType = .numberPad

        textField3.tintColor = Brain.kColorMain
        textField3.placeholder = NSLocalizedString("Institution number", comment: "")
        textField3.autocapitalizationType = .none
        textField3.placeholderColor(color: UIColor(hex: "ADADAD"))
        textField3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textField3)

        nextButton = UIButton(frame: CGRect(x:20, y: textField3.yBottom() + 10, width:Brain.kLargeurIphone-40, height: 60))
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Add bank account", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.applyGradient()
        view.addSubview(nextButton)
        
        descriptionAccount = UILabel(frame: CGRect(x: 20, y: nextButton.yBottom() + 5, width: Brain.kLargeurIphone - 40, height: 70))
        descriptionAccount.numberOfLines = 0
        descriptionAccount.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        descriptionAccount.textColor = UIColor.black.withAlphaComponent(0.4)
        descriptionAccount.text = self.stringAccount
        view.addSubview(descriptionAccount)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barStyle = .black


        self.nextButton.loadingIndicatorWhite(true)
        self.textField.becomeFirstResponder()
        self.refreshAccount()
        
        Intercom.logEvent(withName: "worker_openBankAccount")


    }
    
   
    func refreshAccount(){
        
        
        PFCloud.callFunction(inBackground: "RetreiveAccountBusinessAccount", withParameters: ["userId":PFUser.current()!.objectId!], block: { (object, error) in
            
            self.nextButton.loadingIndicatorWhite(false)

            if error != nil {
                
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                
                    
                    let okAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
                self.descriptionAccount.text = self.stringAccount

                
            }
            
            if object != nil{
                
                let externalAccounts = (object! as! [String:Any])["external_accounts"] as! [String:Any]
                
                if (externalAccounts["total_count"] as! Int) > 0 {
                    
                    let accounts = externalAccounts["data"] as! Array<Any>
                    let firstAccount = accounts[0] as! [String:Any]
                    
                    print("first account ::  \(firstAccount)")
                    
                    self.oldBankAccountStripeId = firstAccount["id"] as? String
                    
                    self.nextButton.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)

                    self.descriptionAccount.text = String(format: NSLocalizedString("Current bank account %@\n**** %@ | %@ \nThis bank account will allow you to receive your weekly transfers from GoRush. 4 working days delay.", comment: ""), firstAccount["bank_name"] as! String, firstAccount["last4"] as! String , firstAccount["routing_number"] as! String )

                    
                }else{
                    
                    self.nextButton.setTitle(NSLocalizedString("Add bank account", comment: ""), for: .normal)
                    
                    
                    self.descriptionAccount.text = self.stringAccount

                    
                }
                
            }else{
                
                
                self.descriptionAccount.text = self.stringAccount

            }
            
        })
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
           
           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
            if isIphoneXFamily(){
                
                nextButton.frame.origin.y =  Brain.kHauteurIphone - keyboardSize.height - 70 - 90

            }else{
                
                nextButton.frame.origin.y =  Brain.kHauteurIphone - keyboardSize.height - 70 - 75

            }

           }
       }
       
    
       
   @objc func touchNext(_ sender: UIButton){
       
        
        sender.loadingIndicatorWhite(true)
        
        if self.textField.text!.count == 0 ||   self.textField2.text!.count == 0 ||  self.textField3.text!.count == 0 {
            
           sender.loadingIndicatorWhite(false)

            return
        }
    
    
        let account = STPBankAccountParams()
        account.country = Brain.kCountry
        account.currency = Brain.kDevise
        account.routingNumber = self.textField2.text!+self.textField3.text!
        account.accountNumber = self.textField.text!

        STPAPIClient.shared().createToken(withBankAccount: account) { (token, error) in
           
           if error != nil {
               
               DispatchQueue.main.async {

               let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                  
                  
                   
                   let okAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                   alert.addAction(okAction)
                   self.present(alert, animated: true, completion: nil)
                   
               }
               
           }else{
               
            
            Intercom.logEvent(withName: "worker_addBankAccount")

               
            PFCloud.callFunction(inBackground: "AddBankAccountBusinessAccount", withParameters: ["userId":PFUser.current()!.objectId!,"tokenCard":token!.tokenId], block: { (newAccount, error) in
                   
                                  
                   if error != nil {
                       
                    Intercom.logEvent(withName: "worker_addBankAccountError")


                       DispatchQueue.main.async {
                           
                           let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                           
                         
                           let okAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                           alert.addAction(okAction)
                           self.present(alert, animated: true, completion: nil)
                           
                       }
                       
                       
                       
                   }else{
                       
                    
                    Intercom.logEvent(withName: "worker_addBankAccountSuccess")

                       if self.oldBankAccountStripeId.count > 0 {
                           
                        PFCloud.callFunction(inBackground: "DeleteBankAccountBusinessAccount", withParameters: ["userId":PFUser.current()!.objectId!,"bankAccountStripeId":self.oldBankAccountStripeId!], block: { (old, error) in
                               
                              self.popupBankAccountUpdated()

                            self.refreshAccount()

                            
                               
                           })
                           
                           
                           
                       }else{
                           
                            self.popupBankAccountUpdated()

                         
                           self.refreshAccount()
                      
                    
                    }
                       
                      
                   }
                   
               })
               
               
           }
        }

    
    
    

   }
    
    func popupBankAccountUpdated(){
        
        
        self.textField.text = ""
        self.textField2.text = ""
        self.textField3.text = ""

        self.nextButton.loadingIndicatorWhite(false)


        
        let alert = UIAlertController(title: NSLocalizedString("Congratulations", comment: ""), message: NSLocalizedString("Your bank account has been updated. You will now receive all your paid jobs on this one", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                 
        
         let okAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil)
         alert.addAction(okAction)
         self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        super.viewWillDisappear(animated)

        textField.resignFirstResponder()
        textField2.resignFirstResponder()

        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
  
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
      
    }
    
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}
