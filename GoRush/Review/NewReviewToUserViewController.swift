//
//  NewRatingToUserViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2020-01-16.
//  Copyright © 2020 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Parse
import KMPlaceholderTextView
import Cosmos
import Intercom


class NewReviewToUserViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate {
            
  
    var request : PFObject!
    var user : PFUser!
    var fromWorker : Bool!
    
    
    var textView : KMPlaceholderTextView!
    var sendButton : UIButton!
    var review : CosmosView!

    
    deinit {
        
        print("dealloc Service")
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    

    convenience init(user: PFUser, request : PFObject, fromWorker: Bool)
    {
       
       self.init()
      
        self.fromWorker = fromWorker
        self.user = user
        self.request = request
       
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        self.navigationController?.navigationBar.prefersLargeTitles = false

        
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        
        self.title = String(format: NSLocalizedString("Review %@", comment: ""), self.user.object(forKey: Brain.kUserFirstName) as! String)
     
        
       

        
        textView = KMPlaceholderTextView(frame: CGRect(x: 20, y: 20, width: Brain.kLargeurIphone - 40, height: 400))
        textView.tintColor = Brain.kColorMain
        textView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textView.textColor = .black
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.placeholder = NSLocalizedString("New review...", comment: "")
      
        textView.showsVerticalScrollIndicator = false


        view.addSubview(textView)



        sendButton = UIButton(frame: CGRect(x:20, y: yTopBottomButtonCTA(), width:Brain.kLargeurIphone-40, height: 60))
        sendButton.layer.cornerRadius = 30;
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.setTitleColor(UIColor.gray, for: .highlighted)
        sendButton.applyGradient()
        sendButton.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
        sendButton.addTarget(self, action: #selector(touchRate(_:)), for: .touchUpInside)
        sendButton.isHidden = true

        view.addSubview(sendButton)
        
        self.review = CosmosView(frame: CGRect(x: 0, y: sendButton.y() - 100, width: Brain.kLargeurIphone, height: 90))
        self.review.settings.updateOnTouch = true
        self.review.settings.fillMode = .full
        self.review.settings.starSize = 30
           // Set the distance between review
        self.review.settings.starMargin = 5
           // Set the color of a filled star
        self.review.settings.filledColor = Brain.kColorMain
           // Set the border color of an empty star
        self.review.settings.emptyBorderColor = Brain.kColorMain
           // Set the border color of a filled star
        self.review.settings.filledBorderColor = Brain.kColorMain
           // Set image for the filled star
        self.review.settings.filledImage = UIImage(named: "starFull")?.withRenderingMode(.alwaysTemplate)
           // Set image for the empty star
        self.review.settings.emptyImage = UIImage(named: "starEmpty")?.withRenderingMode(.alwaysTemplate)
        self.review.settings.totalStars = 5
        self.review.rating = 5.0
        self.review.isHidden = true
        self.review.center.x = self.view.center.x
        self.view.addSubview(self.review)



    }
    
    
    
    @objc func touchRate(_ sender: UIButton){
                 

        self.sendButton.loadingIndicatorWhite(true)
        
        let review = PFObject(className: Brain.kReviewClassName)
        review.setObject(self.request!, forKey: Brain.kReviewRequest)
        review.setObject(self.request.objectId!, forKey: Brain.kReviewRequestId)
        review.setObject(true, forKey: Brain.kReviewAvailable)

   
        review.setObject(self.review.rating, forKey: Brain.kReviewRate)
        review.setObject(self.textView.text!, forKey: Brain.kReviewReview)

        if self.fromWorker == true {
            
            review.setObject("worker", forKey: Brain.kReviewFrom)
            review.setObject(self.user!, forKey: Brain.kReviewCustomer)
            review.setObject(self.user.objectId!, forKey: Brain.kReviewCustomerId)
            review.setObject(PFUser.current()!, forKey: Brain.kReviewWorker)
            review.setObject(PFUser.current()!.objectId!, forKey: Brain.kReviewWorkerId)


        }else{
            
            review.setObject("customer", forKey: Brain.kReviewFrom)
            review.setObject(self.user!, forKey: Brain.kReviewWorker)
            review.setObject(self.user.objectId!, forKey: Brain.kReviewWorkerId)
            review.setObject(PFUser.current()!, forKey: Brain.kReviewCustomer)
            review.setObject(PFUser.current()!.objectId!, forKey: Brain.kReviewCustomerId)
        
        
        }
        
        review.saveInBackground { (done, error) in
            
            if self.fromWorker == true {

                self.request.setObject(review, forKey: Brain.kRequestReviewFromWorker)

                
            }else{
                
                self.request.setObject(review, forKey: Brain.kRequestReviewFromCustomer)

            }
            
            self.request.saveInBackground { (done, error) in
                
                self.sendButton.loadingIndicatorWhite(false)
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }

                           
                
    }
    
    
    
    

       
    @objc func keyboardWillShow(notification: NSNotification) {

      if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {


       if isIphoneXFamily() {

           sendButton.frame.origin.y =  Brain.kHauteurIphone - keyboardSize.height - 70 - 90

       }else{


           sendButton.frame.origin.y =  Brain.kHauteurIphone - keyboardSize.height - 70 - 75


       }

        
        self.review.frame.origin.y = sendButton.y() - 50



    }


    }


    @objc func keyboardWillHide(notification: Notification)

    {

    if isIphoneXFamily() {

           sendButton.frame.origin.y =  Brain.kHauteurIphone  - 80

       }else{


           sendButton.frame.origin.y =  Brain.kHauteurIphone  - 70


       }

        self.review.frame.origin.y = sendButton.y() - 50

    }
       
   
   
   func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
     

       if textView.text.count > 0 {
           
           sendButton.isHidden = false
           review.isHidden = false

       }else{
           
           sendButton.isHidden = true
           review.isHidden = true

       }
   }
       
   
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)

        navigationController?.navigationBar.barStyle = .black

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false

         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name:UIResponder.keyboardWillHideNotification, object: nil)

        textView.becomeFirstResponder()
        
        Intercom.logEvent(withName: "customer_openNewReview")


    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
