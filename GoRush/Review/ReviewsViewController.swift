//
//  ReviewsViewController.swift
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


class ReviewsViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
            
    var user : PFUser!
    var fromWorker : Bool!
    
   
    var reviews = [PFObject]()
    var tableView : UITableView!
    
    var tableviewIdentifier = "MyCell"
    
    var closeIndicator : UIImageView!

    deinit {
        
        print("dealloc Service")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    

    convenience init(user: PFUser, fromWorker: Bool)
    {
       
       self.init()
      
        self.fromWorker = fromWorker
        self.user = user
       
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        self.navigationController?.navigationBar.prefersLargeTitles = false

        
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        
        self.title = String(format: NSLocalizedString("%@'s Reviews", comment: ""), self.user.object(forKey: Brain.kUserFirstName) as! String)
     
                
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
        tableView.register(reviewTableViewCell.self, forCellReuseIdentifier: tableviewIdentifier)
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 30
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: 40))
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: 200))
        view.addSubview(tableView)




        closeIndicator = UIImageView(frame: CGRect(x: ( Brain.kL - 60 ) / 2, y: 12, width: 60, height: 5))
        closeIndicator.layer.cornerRadius = 2.5
        closeIndicator.backgroundColor = UIColor(hex: "ECECEC")
        view.addSubview(closeIndicator)

        
    }
    
    

   
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barStyle = .black

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.navigationBar.prefersLargeTitles = false

        Intercom.logEvent(withName: "customer_openReviews")

        self.getReviews()
    }
    
    
    
    func getReviews(){
        
        
        let reviewsQuery = PFQuery(className: Brain.kReviewClassName)
        
        if self.fromWorker == true {
            reviewsQuery.whereKey(Brain.kReviewCustomerId, equalTo: self.user.objectId!)
            reviewsQuery.whereKey(Brain.kReviewFrom, equalTo: "worker")
        }else{
            reviewsQuery.whereKey(Brain.kReviewWorkerId, equalTo: self.user.objectId!)
            reviewsQuery.whereKey(Brain.kReviewFrom, equalTo: "customer")


        }
        reviewsQuery.includeKey(Brain.kReviewCustomer)
        reviewsQuery.includeKey(Brain.kReviewWorker)
        reviewsQuery.whereKey(Brain.kReviewAvailable, equalTo: true)
        reviewsQuery.limit = 1000
        reviewsQuery.cachePolicy = .cacheThenNetwork
        reviewsQuery.findObjectsInBackground { (reviewsO, error) in
            
            if reviewsO != nil {
                
                self.reviews = reviewsO!
                
            }else{
                
                self.reviews = [PFObject]()
                
            }
            
            self.tableView.reloadData()
            
        }
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
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


   
        return self.reviews.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: tableviewIdentifier, for: indexPath as IndexPath) as! reviewTableViewCell

        cell.review = self.reviews[indexPath.row]
        
        if self.fromWorker == true {
        
            cell.user = cell.review.object(forKey: Brain.kReviewWorker) as? PFUser
        
        }else{
         
            cell.user = cell.review.object(forKey: Brain.kReviewCustomer) as? PFUser

        }
        
        
        if cell.user.object(forKey: Brain.kUserProfilePicture) != nil {
            
            cell.profile.file = cell.user.object(forKey: Brain.kUserProfilePicture) as? PFFileObject
            cell.profile.loadInBackground()
            
        }else{
            
            cell.profile.image =  UIImage.init(named: "bigProfile")
        }
        
        cell.name.text = cell.user.object(forKey: Brain.kUserFirstName) as? String
        cell.name.sizeToFit()
        
        cell.stars.frame.origin.x = cell.name.x() + cell.name.w() + 10
        
        
        cell.comment.text = cell.review.object(forKey: Brain.kReviewReview) as? String
        cell.comment.frame.size.width = Brain.kLargeurIphone - cell.comment.x() - 20
        cell.comment.sizeToFit()
        cell.comment.frame.size.width = Brain.kLargeurIphone - cell.comment.x() - 20

        cell.date.frame.origin.y = cell.comment.yBottom()
        
       let dateFormatterPrint1 = DateFormatter()
       dateFormatterPrint1.dateFormat = "dd MMMM yyyy"
       cell.date.text =  dateFormatterPrint1.string(from: cell.review.createdAt!)

           
       


        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            tableView.deselectRow(at: indexPath, animated: false)


    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let review = self.reviews[indexPath.row]
        
        let comment = UILabel(frame: CGRect(x: 63, y: 20, width: Brain.kLargeurIphone - 63 - 20, height: 19))
        comment.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        comment.numberOfLines = 0
        
        comment.text = review.object(forKey: Brain.kReviewReview) as? String
        comment.frame.size.width = Brain.kLargeurIphone - comment.x() - 20
        comment.sizeToFit()
        comment.frame.size.width = Brain.kLargeurIphone - comment.x() - 20

        return comment.h() + 50
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
