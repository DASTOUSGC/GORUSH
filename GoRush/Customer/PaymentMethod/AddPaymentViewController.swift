//
//  AddPaymentViewController.swift
//  Tabby
//
//  Created by Julien on 24/07/2018.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//


import Foundation

import UIKit
import Parse
import Stripe
import Intercom



class AddPaymentViewController: ParentLoadingViewController , STPPaymentCardTextFieldDelegate{
    
    
    
    /// Parameters
    let titleViewController = NSLocalizedString("Add payment method", comment:"")
    
    
    var leftButton:UIButton!
    var rightButton:UIButton!
    var leftButtonImageName = ""
    var rightButtonImageName = ""
    
    var frontCard : UIImage!
    var backCard : UIImage!
    
    var card : UIImageView!

    var textField : STPPaymentCardTextField!
    var saveButton : UIButton!
    var stripeLabel : UILabel!

    
    override var prefersStatusBarHidden: Bool {
           return false
       }
       
       override var preferredStatusBarStyle: UIStatusBarStyle {
           
           return .lightContent
       }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = titleViewController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        
        
        ///Navbar
        
        if leftButtonImageName.count > 0 {
            
            leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            leftButton.setBackgroundImage(UIImage(named: leftButtonImageName), for:.normal)
            leftButton.addTarget(self, action: #selector(touchLeftButton(_:)), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        }
        
        if rightButtonImageName.count > 0 {
            
            rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            rightButton.setBackgroundImage(UIImage(named: rightButtonImageName), for:.normal)
            rightButton.addTarget(self, action: #selector(touchRightButton(_:)), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
            
        }
        
        
        
        let lock = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        lock.image = UIImage(named: "lockStripe")?.withRenderingMode(.alwaysTemplate)
        lock.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: lock)

        
        self.frontCard = UIImage(named: "bbCardFront")?.withRenderingMode(.alwaysTemplate)
        self.backCard = UIImage(named: "bbCardBack")?.withRenderingMode(.alwaysTemplate)
        
        self.card = UIImageView(image: self.frontCard)
        self.card.contentMode = .center
        self.card.frame = CGRect(x: 0, y: 10, width: Brain.kLargeurIphone, height: self.card.frame.size.height + 80);
        self.card.tintColor = Brain.kColorMain
        self.view.addSubview(self.card)
        
        
        
        self.textField = STPPaymentCardTextField(frame: CGRect(x:20, y: self.card.frame.origin.y + self.card.frame.size.height , width:  Brain.kLargeurIphone - 40, height: 60))
        self.textField.delegate = self
        self.textField.cursorColor = Brain.kColorMain
        self.textField.layer.cornerRadius = 30
        self.textField.textColor = .black
//        self.textField.backgroundColor = UIColor(hex: "333333")
        self.textField.textErrorColor = UIColor.red
        self.textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.textField.keyboardAppearance = .light
        self.view.addSubview(self.textField)
        
        
        self.saveButton = UIButton(frame: CGRect(x:20, y: self.textField.yBottom() + 10, width: Brain.kLargeurIphone - 40 , height: 60))
        self.saveButton.layer.cornerRadius = 30
        self.saveButton.setTitle(NSLocalizedString("Save Card", comment: ""), for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.saveButton.alpha = 1
        self.saveButton.applyGradient()
        self.saveButton.clipsToBounds = true
        self.saveButton.isEnabled = false
        self.saveButton.addTarget(self, action: #selector(saveButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(self.saveButton)
        
        
        let attrs1 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor: Brain.kColorMain]
        let attrs2 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor:Brain.kColorMain]

        let text1 = NSAttributedString(string:NSLocalizedString("Powered by ", comment: ""), attributes: attrs1)
        let text2 = NSAttributedString(string: NSLocalizedString("Stripe", comment: ""), attributes: attrs2)

        let stringL = NSMutableAttributedString()
        stringL.append(text1)
        stringL.append(text2)
        
        self.stripeLabel = UILabel(frame: CGRect(x: 0, y: self.saveButton.yBottom() + 15, width: Brain.kLargeurIphone, height: 30))
        self.stripeLabel.textAlignment = .center
        self.stripeLabel.attributedText = stringL
        self.view.addSubview(self.stripeLabel)
        

      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barStyle = .black

        
          self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.layoutIfNeeded()
          
        Intercom.logEvent(withName: "customer_openAddPaymentView")


    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        super.viewWillDisappear(animated)
        self.textField.resignFirstResponder()
        navigationController?.setNavigationBarHidden(false, animated: animated)


    }
    
  
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    @objc func saveButtonAction(_ sender: UIButton){
        
//        self.textField.resignFirstResponder()
        self.saveButton.isEnabled = false
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.addLoadingView()
        self.saveButton.loadingIndicatorWhite(true)
        
        let cardParams = STPCardParams()
        cardParams.number = self.textField.cardNumber
        cardParams.expMonth = self.textField.expirationMonth
        cardParams.expYear = self.textField.expirationYear
        cardParams.cvc = self.textField.cvc
        
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            
            if error != nil {
                
                self.saveButton.loadingIndicator(false)
                self.saveButton.isEnabled = true

                self.textField.becomeFirstResponder()
                self.showAlertError()
                
                
            }else{
                
                print("Token \(token)")
                
                        if PFUser.current()?.object(forKey: Brain.kUserStripeCustomer) != nil {
                            
                            let stripeCustomer =  PFUser.current()?.object(forKey: Brain.kUserStripeCustomer) as! PFObject
                            
                            stripeCustomer.fetchInBackground { (stripeFetched, error) in
                                
                                
                                let customerStripeId = stripeFetched?.object(forKey: Brain.kStripeCustomerIdStripe) as! String
                                
                                
                                PFCloud.callFunction(inBackground: "AddNewPaymentMethodCustomerAccount", withParameters: ["customerStripeId":customerStripeId,"token":token!.tokenId], block: { (object, error) in
                                    
                                    if error != nil {
                                    
                                        print("error \(String(describing: error))")
//                                        appDelegate.removeLoadingView()
                                        self.saveButton.loadingIndicator(false)
                                        self.saveButton.isEnabled = true

                                        self.showAlertError()

                                    }else{
                                      
                                        
                                        Intercom.logEvent(withName: "customer_AddPaymentMethod")


                                        StripeCustomer.shared().refreshStripeAccount(completion: { (user) in
                                            
                                            self.saveButton.loadingIndicator(false)
                                            self.saveButton.isEnabled = true

                                            self.navigationController?.popViewController(animated: true)
                                        })
                                        
                                      
//                                        appDelegate.removeLoadingView()

                                    
                                    }
                                    
                                    
                                  
                                    
                                    
                                })
                                
                                
                                
                                


                            }
                        }
                
            }
            
        }
        
        
    }
    @objc func touchLeftButton(_ sender: UIButton){
        
        
    }
    
    @objc func touchRightButton(_ sender: UIButton){
        
        
    }
    
    
    func showAlertError(){
        
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Sorry, an error occurred ", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
       
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.saveButton.isEnabled = true

    }
    
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        
        UIView.transition(with: self.card, duration: 0.25, options: UIView.AnimationOptions.transitionFlipFromRight, animations: {
            
            self.card.image = self.backCard
            
        }, completion: nil)
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        
        UIView.transition(with: self.card, duration: 0.25, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
            
            self.card.image = self.frontCard
            
        }, completion: nil)
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        
        self.saveButton.isEnabled = textField.isValid
        if self.saveButton.isEnabled {
            
            self.saveButton.alpha = 1.0

            
        }else{
            
            self.saveButton.alpha = 1.0

        }
        
    }
    
    
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}
