//
//  EditProfileViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-12-10.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse
import UIKit
//import ParseLiveQuery
import UserNotifications
//import YPImagePicker
import PhoneNumberKit
import Intercom


class EditProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
   
    
    
    
    /// Parameters
    let titleViewController = NSLocalizedString("Edit Profile", comment:"")
    
 
    var leftButton:UIButton!
    var rightButton:UIButton!
    var leftButtonImageName = ""
    var rightButtonImageName = ""
    
    var tableView: UITableView!
    
    
    var tableviewIdentifier = "MyCell"
 
    
    var objects: NSMutableArray = NSMutableArray(array: [])

    
    var initValueFirst : String!
    var initValueLast : String!
    var initValueEmail : String!
    var initValuePhone : String!
    var initValueNewPassword  = ""
    var initValueConfirmPassword  = ""

    var pushToEditPhone = false
    
    var activityIndicator : UIActivityIndicatorView!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        print("GOOO")
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        title = titleViewController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        
        
        activityIndicator = UIActivityIndicatorView.init(style: .white)
        let refreshBarButton: UIBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.leftBarButtonItem = refreshBarButton

        
        
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
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismiss(_:)))

        
        //TableView
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
        tableView.register(editProfileTableViewCell.self, forCellReuseIdentifier: tableviewIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .interactive
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: 20))
        view.addSubview(tableView)
        
        
        
        objects = [
            NSLocalizedString("First name", comment:""),
            NSLocalizedString("Last name", comment:""),
            NSLocalizedString("Email", comment:""),
            NSLocalizedString("Phone number", comment:""),
            NSLocalizedString("", comment:""),
            NSLocalizedString("New password", comment:""),
            NSLocalizedString("Confirm new password", comment:""),
        ]
        
        if PFUser.current()?.object(forKey: Brain.kUserFacebookId) != nil {

            objects = [
                NSLocalizedString("First name", comment:""),
                NSLocalizedString("Last name", comment:""),

                NSLocalizedString("Email", comment:""),
                NSLocalizedString("Phone number", comment:""),

            ]
        }
        
        tableView.reloadData()
        
        
    }
    
    

  
    
    @objc func dismiss(_ sender: Any){
        
        if self.initValueNewPassword.count > 0 {
            
            if self.initValueNewPassword != self.initValueConfirmPassword {
                
             
                let alert = UIAlertController(title: NSLocalizedString("Password error", comment: ""), message: "Sorry, your password confirmation is different from your new password", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                return
            }
            
        }
        
        
        if self.initValueFirst.count > 0 && self.initValueEmail.count > 0 && self.initValueLast.count > 0{



            for cell in tableView.visibleCells {

                (cell as! editProfileTableViewCell).value.resignFirstResponder()
            }


            activityIndicator.startAnimating()

            // On teste si le nouveau username est dispo
            if self.initValueEmail != PFUser.current()!.object(forKey: Brain.kUserEmail) as? String {

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.addLoadingView()

                
                PFCloud.callFunction(inBackground: "checkEmail",
                                     withParameters:["email":self.initValueEmail!.lowercased()]) { (response:Any?, error:Error?) in


                                        if  error != nil  {

                                            appDelegate.removeLoadingView()

                                            self.activityIndicator.stopAnimating()

                                            let alert = UIAlertController(title: NSLocalizedString("Email already used", comment: ""), message: "Sorry, this email is already registered", preferredStyle: UIAlertController.Style.alert)
                                            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)

                                            if PFUser.current()?.object(forKey: Brain.kUserEmail) != nil {

                                                self.initValueEmail = PFUser.current()?.object(forKey: Brain.kUserEmail) as? String
                                            }else{

                                                self.initValueEmail = ""

                                            }

                                            self.tableView.reloadData()

                                        }else{
                                            
                                            
                                            if self.initValueNewPassword.count > 0 {

                                                PFUser.current()?.setObject(self.initValueNewPassword, forKey: "password")
                                                
                                            }
                                            if self.initValueFirst != PFUser.current()!.object(forKey: Brain.kUserFirstName) as? String {
                                                
                                                PFUser.current()?.setObject(self.initValueFirst!, forKey: Brain.kUserFirstName)
                                                
                                            }
                                            
                                            
                                            if self.initValueLast != PFUser.current()!.object(forKey: Brain.kUserLastName) as? String {

                                                PFUser.current()?.setObject(self.initValueLast!, forKey: Brain.kUserLastName)

                                            }


                                            PFUser.current()?.setObject(self.initValueEmail!, forKey: Brain.kUserEmail)
                                            
                                            if PFUser.current()?.object(forKey: Brain.kUserFacebookId) == nil {
                                                
                                                PFUser.current()?.username = self.initValueEmail.lowercased()

                                            }
                                            PFUser.current()?.saveInBackground(block: { (done, error) in

                                                if self.initValuePhone != PFUser.current()!.object(forKey: Brain.kUserPhone) as? String {
                                                    
                                                    
                                                    self.editPhone()


                                                    
                                                }else{
                                                    
                                                    self.activityIndicator.stopAnimating()

                                                    
                                                    self.dismiss(animated: true, completion: nil)
                                                    
                                                }
                                                

                                                
                                                

                                            })

                                        }

                }


            }else{

                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.addLoadingView()

                
                if self.initValueFirst != PFUser.current()!.object(forKey: Brain.kUserFirstName) as? String {

                    PFUser.current()?.setObject(self.initValueFirst!, forKey: Brain.kUserFirstName)

                }

                
                if self.initValueLast != PFUser.current()!.object(forKey: Brain.kUserLastName) as? String {

                    PFUser.current()?.setObject(self.initValueLast!, forKey: Brain.kUserLastName)

                }

                PFUser.current()?.saveInBackground(block: { (done, error) in

                    
                    appDelegate.removeLoadingView()
                    
                
                    if self.initValuePhone != PFUser.current()!.object(forKey: Brain.kUserPhone) as? String {
                        
                        
                        self.editPhone()

                        

                    }else{
                        
                        self.activityIndicator.stopAnimating()

                        self.dismiss(animated: true, completion: nil)

                    }



                })
                

                
            

            }





        }


       
        
        
        
    }
    
    
    
    func editPhone(){
        
        
        let code = String(Utils.randomNumber(inRange: 1000...9999))

        print("GOO PH")
        
        var phone = self.initValuePhone.trimmingCharacters(in: .whitespacesAndNewlines)
                    do {

           let phoneNumberKit = PhoneNumberKit()
           let phoneNumber =  try phoneNumberKit.parse(self.initValuePhone.trimmingCharacters(in: .whitespacesAndNewlines))
           phone = phoneNumberKit.format(phoneNumber, toType: .e164) // +61236618300
           
        }
        catch {
        }

        
        
        PFCloud.callFunction(inBackground: "checkPhoneNumber",
                                   withParameters:["phoneNumber":phone]) { (object:Any?, error:Error?) in


                  if  error != nil {

                    self.activityIndicator.stopAnimating()


                      let alert = UIAlertController(title: NSLocalizedString("Phone number already used", comment: ""), message: NSLocalizedString("Sorry, this phone number is already registered", comment: ""), preferredStyle: UIAlertController.Style.alert)
                     
                      alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                      self.present(alert, animated: true, completion: nil)


                  }else{

                      PFCloud.callFunction(inBackground: "sendSMSVerificationNumber",
                                           withParameters:["code":code,
                                                           "to":self.initValuePhone.trimmingCharacters(in: .whitespacesAndNewlines),
                                                           "firstName":PFUser.current()!.object(forKey: Brain.kUserFirstName)! as! String]) { (object:Any?, error:Error?) in

                              self.activityIndicator.stopAnimating()

                              if  error != nil {

                                print("err \(error!)")
                              }else{

                                  print("code \(code)")
                               
                                 let editPhone = SignupPhone2ViewController(code: code, phone: self.initValuePhone, updatePhone: true, editProfileVC: self)
                                self.navigationController?.pushViewController(editPhone, animated: true)
        

                              }

                      }
                  }

        
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        

        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barStyle = .black

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()

        
        if PFUser.current()?.object(forKey: Brain.kUserFirstName) != nil {
            
            initValueFirst = PFUser.current()?.object(forKey: Brain.kUserFirstName) as? String
        }else{
            
            initValueFirst = ""
            
        }
        
        
        if PFUser.current()?.object(forKey: Brain.kUserLastName) != nil {

            initValueLast = PFUser.current()?.object(forKey: Brain.kUserLastName) as? String
        }else{

            initValueLast = ""

        }
        
        
        
        if PFUser.current()?.object(forKey: Brain.kUserEmail) != nil {
            
            initValueEmail = PFUser.current()?.object(forKey: Brain.kUserEmail) as? String
        }else{
            
            initValueEmail = ""
            
        }
        
        
        if self.pushToEditPhone == false {
            
            if PFUser.current()?.object(forKey: Brain.kUserPhone) != nil {
                
                initValuePhone = PFUser.current()?.object(forKey: Brain.kUserPhone) as? String
            }else{
                
                initValuePhone = ""
                
            }
        }
        
      
        Intercom.logEvent(withName: "customer_openEditProfileView")

        
        tableView.reloadData()
        
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)

    }
    
  
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
  
    @objc func touchLeftButton(_ sender: UIButton){
        
        
    }
    
    @objc func touchRightButton(_ sender: UIButton){
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (objects.object(at: indexPath.row) as! String).count == 0 {
            
            return 30

        }else{
            
            return 60

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: tableviewIdentifier, for: indexPath as IndexPath) as!editProfileTableViewCell
        
        
        cell.value.keyboardType = .default

        if (objects.object(at: indexPath.row) as! String).count == 0 {
            
            cell.value.isEnabled = true
            cell.value.isHidden = true
            cell.name.isHidden = true
            

        }else{
            
            cell.value.isSecureTextEntry = false
            cell.name.text = objects.object(at: indexPath.row) as? String
            cell.value.placeholder = objects.object(at: indexPath.row) as? String
//            cell.value.placeholderColor(color: UIColor.black)
            cell.value.delegate = self
            cell.value.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            cell.value.isEnabled = true
            
            cell.value.isHidden = false
            cell.name.isHidden = false

            cell.value.tag = indexPath.row
            
        }
        


        
        if objects.object(at: indexPath.row) as! String == NSLocalizedString("First name", comment: ""){
            
            cell.value.isEnabled = true
            
            
            cell.value.text = initValueFirst
            
            
            cell.value.addTarget(self, action: #selector(firstDidChange(textField:)), for: .editingChanged)


        }else if objects.object(at: indexPath.row) as! String == NSLocalizedString("Last name", comment: "") {


            cell.value.isEnabled = true


            cell.value.text = initValueLast
           cell.value.delegate = self

            cell.value.addTarget(self, action: #selector(lastDidChange(textField:)), for: .editingChanged)


//        }
//
        }else if objects.object(at: indexPath.row) as! String == NSLocalizedString("Email", comment: "") {
            
            
            cell.value.isEnabled = true
            cell.value.keyboardType = .emailAddress

            
            cell.value.text = initValueEmail
            cell.value.delegate = self
            
            cell.value.addTarget(self, action: #selector(emailDidChange(textField:)), for: .editingChanged)
            
            
        }else if objects.object(at: indexPath.row) as! String == NSLocalizedString("Phone number", comment: "") {
            
            
            cell.value.isEnabled = true
            
            
            cell.value.text = initValuePhone
            cell.value.delegate = self
            
            cell.value.addTarget(self, action: #selector(phoneDidChange(textField:)), for: .editingChanged)
            
            
        }else if objects.object(at: indexPath.row) as! String == NSLocalizedString("New password", comment: "") {
            
            
            cell.value.isEnabled = true
            cell.value.isSecureTextEntry = true

            cell.value.text = initValueNewPassword

            cell.value.delegate = self
            
            cell.value.addTarget(self, action: #selector(passwordDidChange(textField:)), for: .editingChanged)
            
            
        }else if objects.object(at: indexPath.row) as! String == NSLocalizedString("Confirm new password", comment: "") {
            
            
            cell.value.isEnabled = true
            cell.value.isSecureTextEntry = true
            
            cell.value.text = initValueConfirmPassword

            cell.value.delegate = self
            
            cell.value.addTarget(self, action: #selector(confirmPasswordDidChange(textField:)), for: .editingChanged)
            
            
        }else{
            

            
        }
        
        return cell
    }
    
    
    @objc func passwordDidChange(textField: UITextField){
        
        
        self.initValueNewPassword = textField.text!
    }
    
    @objc func confirmPasswordDidChange(textField: UITextField){
        
        
        self.initValueConfirmPassword = textField.text!
    }
   
    @objc func firstDidChange(textField: UITextField){
        
        print("First changed")
        
        self.initValueFirst = textField.text
    }
    
    @objc func phoneDidChange(textField: UITextField){
        
        print("First changed")
        
        self.initValuePhone = textField.text
    }
    
    @objc func lastDidChange(textField: UITextField){
        
        print("Last changed")
        self.initValueLast = textField.text

    }
    
    @objc func emailDidChange(textField: UITextField){
        
        print("Email changed")
        self.initValueEmail = textField.text
        
    }
    
    
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " " ) {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

