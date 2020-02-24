//
//  PaymentsViewController.swift
//  Tabby
//
//  Created by Julien Levallois on 18-07-01.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//

import Foundation

import UIKit
import Parse

class PaymentsViewController: ParentLoadingViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    /// Parameters
    let titleViewController = NSLocalizedString("Payment", comment:"")
    
    
    var objects: NSMutableArray = NSMutableArray()
    var tableView: UITableView!
    var headerTableView: UIView!
    
    var tableviewIdentifier = "MyCell"
    var tableViewHeightCell:CGFloat = 65
    
    var leftButton:UIButton!
    var rightButton:UIButton!
    var leftButtonImageName = ""
    var rightButtonImageName = ""
    var nextButton:UIButton!
    var emptyCards : UIImageView!

    var refreshControl: UIRefreshControl!
//    var activityIndicatorView: UIActivityIndicatorView!
    
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
        
        
        
        //TableView
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
        tableView.register(cardTableViewCell.self, forCellReuseIdentifier: tableviewIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
//        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        activityIndicatorView.center = self.view.center
//        activityIndicatorView.hidesWhenStopped = true
//        self.view.addSubview(activityIndicatorView)
        
        emptyCards = UIImageView(frame: CGRect(x: 20, y: 13, width: 296, height: 198))
        emptyCards.image = UIImage(named: "emptyOrders")
        emptyCards.isHidden = true
        tableView.addSubview(emptyCards)
        
        
        updateTableViewHeader()
        
       
        
        if isIphoneXFamily() {
           
           nextButton = UIButton(frame: CGRect(x:20, y: Brain.kHauteurIphone - 90 - 85, width:Brain.kLargeurIphone-40, height: 60))

           
        }else{
           
           nextButton = UIButton(frame: CGRect(x:20, y: Brain.kHauteurIphone - 55 - 85, width:Brain.kLargeurIphone-40, height: 60))

        }
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Add New Card", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchAddPayment(_:)), for: .touchUpInside)
        nextButton.applyGradient()
        view.addSubview(nextButton)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black

        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        

        
        
        self.checkPaymentsMethod(forceRefresh: false)

        navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
          
          super.viewWillDisappear(animated)
          
          navigationController?.setNavigationBarHidden(false, animated: animated)
          
      }
    
    func checkPaymentsMethod(forceRefresh:Bool){
        
        
        
        tableView.isHidden = true
        self.nextButton.loadingIndicatorWhite(true)
        
        if StripeCustomer.shared().stripeAccount != nil && forceRefresh == false {
            
            self.tableView.isHidden = false
            self.nextButton.loadingIndicatorWhite(false)

            if StripeCustomer.shared().stripeAccount!["sources"] != nil {
                
                
                let sources = StripeCustomer.shared().stripeAccount!["sources"] as? Dictionary<String, Any>

                if sources!["data"] != nil {
                    
                    self.objects = NSMutableArray(array: sources!["data"] as! Array)

                }else{
                 
                    self.objects = NSMutableArray()

                    
                }
                
                if self.objects.count > 0 {
                    
                    self.emptyCards.isHidden = true
                    
                }else{
                    
                    self.emptyCards.isHidden = false
                    
                }
                
                self.tableView.reloadData()
                
            
            }else{
                
                self.objects = NSMutableArray()

            }
            
            if self.objects.count > 0 {
                
                self.emptyCards.isHidden = true
                
            }else{
                
                self.emptyCards.isHidden = false
                
            }
            
            
            
            self.tableView.reloadData()
            
        }else{
            
          
            StripeCustomer.shared().refreshStripeAccount { (stripeAccount) in
                
                self.tableView.isHidden = false
                self.nextButton.loadingIndicatorWhite(false)

                
                if stripeAccount != nil {
                    
                    
                    if StripeCustomer.shared().stripeAccount!["sources"] != nil {
                        
                        
                        let sources = StripeCustomer.shared().stripeAccount!["sources"] as? Dictionary<String, Any>
                        
                        if sources!["data"] != nil {
                            
                            self.objects = NSMutableArray(array: sources!["data"] as! Array)
                            
                        }else{
                            
                            self.objects = NSMutableArray()
                            
                            
                        }
                    }else{
                        
                        self.objects = NSMutableArray()
                        
                    }
                    
                    
                    if self.objects.count > 0 {
                        
                        self.emptyCards.isHidden = true
                        
                    }else{
                        
                        self.emptyCards.isHidden = false
                        
                    }
                    self.tableView.reloadData()
                    
                    
                }else{
                    
                    
                    self.objects.removeAllObjects()


                    if self.objects.count > 0 {
                        
                        self.emptyCards.isHidden = true
                        
                    }else{
                        
                        self.emptyCards.isHidden = false
                        
                    }
                    self.tableView.reloadData()
                
                
                }
                
            }
            
            
        }
        

    }
    
  
    
    func updateTableViewHeader() {
        
        headerTableView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: 20))
        headerTableView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = headerTableView
        
    }
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    
    @objc func touchAddPayment(_ sender: UIButton){
        
        let addCard = AddPaymentViewController()
        self.navigationController?.pushViewController(addCard, animated: true)

    }
    
    
    @objc func touchLeftButton(_ sender: UIButton){
        
        
    }
    
    @objc func touchRightButton(_ sender: UIButton){
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
            let cell = tableView.dequeueReusableCell(withIdentifier: tableviewIdentifier, for: indexPath as IndexPath) as! cardTableViewCell
            
            
            cell.card = self.objects.object(at: indexPath.row) as? Dictionary <String, Any>
           
            if cell.card["brand"] as! String  == "Visa" {
                
                cell.imageCard.image = UIImage(named: "cardVisa")

            }else if cell.card["brand"] as! String == "MasterCard" {
                
                cell.imageCard.image = UIImage(named: "cardMasterCard")

                
            }else{
                
                cell.imageCard.image = UIImage(named: "cardOther")

                
            }
            
            if indexPath.row == 0 {
                
                cell.check.isHidden = false

            }else {
                
                cell.check.isHidden = true
            }
            
            
            cell.number.text = cell.card["last4"] as? String
           
            cell.expiration.text = String(format:"EXP %.2d/%d", cell.card["exp_month"] as! Int, cell.card["exp_year"] as! Int )

            return cell

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

            
            
            let card = self.objects.object(at: indexPath.row) as! Dictionary <String, Any>

            let title = "\(card["brand"] as! String) \(card["last4"] as! String)"
            
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.permittedArrowDirections = []
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }
            
            
            let defaultA = UIAlertAction(title: NSLocalizedString("Set default card", comment: ""), style: .default, handler: { action in
                
                
                
//                self.activityIndicatorView.startAnimating()
                self.nextButton.loadingIndicatorWhite(true)

                self.tableView.isHidden = true
                
                if StripeCustomer.shared().stripeId == nil {
                    
                    return
                }
                
                PFCloud.callFunction(inBackground: "SetDefaultPaymentMethodCustomerAccount", withParameters: ["customerId":StripeCustomer.shared().stripeId!, "cardId": card["id"]!], block: { (object, error) in
                    
                    
                    
                    if object != nil {
                        
                        StripeCustomer.shared().stripeAccount = object! as? [String:Any]
                        self.checkPaymentsMethod(forceRefresh: true)

                    }
                    
                })
                
                
                
            })
            defaultA.setValue(UIColor.black, forKey: "titleTextColor")
            alert.addAction(defaultA)
            
            
          
            
            let delete = UIAlertAction(title: NSLocalizedString("Delete card", comment: ""), style: .default, handler: { action in
                
                
                
                let alert = UIAlertController(title: NSLocalizedString("Delete card", comment: ""), message: NSLocalizedString("Are you sure you want to delete this card?", comment: ""), preferredStyle: .alert)
                
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.permittedArrowDirections = []
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                }
                
                
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.permittedArrowDirections = []
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                }
                
                
                let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler:  { action in
                    
//                    self.activityIndicatorView.startAnimating()
                    self.nextButton.loadingIndicatorWhite(true)

                    self.tableView.isHidden = true
                    
                    
                    if StripeCustomer.shared().stripeId == nil {
                        
                        return
                    }
                    
                    PFCloud.callFunction(inBackground: "DeletePaymentMethodCustomerAccount", withParameters: ["customerId":StripeCustomer.shared().stripeId!, "cardId": card["id"]!], block: { (object, error) in
                        
                    
                        
                        if object != nil {
                            
                            StripeCustomer.shared().stripeAccount = object! as? [String:Any]
                            self.checkPaymentsMethod(forceRefresh: true)

                        }else{
                            
                            
                        }
                        
                        
                    })
                    
                    
                })
                yesAction.setValue(UIColor.red, forKey: "titleTextColor")

                alert.addAction(yesAction)
                
                
                let noAction = UIAlertAction(title: "No", style: .cancel, handler:  { action in
                    
                })
                noAction.setValue(UIColor.black, forKey: "titleTextColor")
                alert.addAction(noAction)
                
                self.present(alert, animated: true)
                
                
            })
            
            
            delete.setValue(UIColor.black, forKey: "titleTextColor")
            alert.addAction(delete)
            
            
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            cancel.setValue(UIColor.black, forKey: "titleTextColor")
            alert.addAction(cancel)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
                
            }
            
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       
            return tableViewHeightCell

        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}

