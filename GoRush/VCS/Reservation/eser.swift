//
//  ReservationViewController.swift
//  Salud
//
//  Created by Julien Levallois on 19-07-21.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import Parse

class ReservationViewController: ParentLoadingViewController,  UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TimeViewDelegate {
   
    
    
    /// Parameters
    let titleViewController = NSLocalizedString("Your Table", comment:"")
    
    var selectedFriends = [PFUser]()

    
    var tableView: UITableView!
    var headerTableView: UIView!
    var footerTableView: UIView!
    
    var tableviewIdentifier = "MyCell"
    var tableViewHeightCell:CGFloat = 40
    
    
    
    var nextButton:UIButton!
    
    var bottomFilter : UIImageView!
    
    
    var guest = 0
    
    var reservation : PFObject!
    var club : PFObject!
    
    var clubView : ClubView!
    
    var timeLabel : UILabel!
    var timeValue : UILabel!

    var serviceLabel : UILabel!
    var serviceValue : UILabel!
    
    
    var friendsLabel : UILabel!
    var friendsValue : UILabel!

    var timeView : TimeView!

    convenience init(reservation:PFObject)
    {

        self.init()
        self.reservation = reservation
        self.selectedFriends = self.reservation.object(forKey: Brain.kReservationPeople) as! [PFUser]
        self.club = self.reservation.object(forKey: Brain.kReservationClub) as? PFObject
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleViewController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        
        self.loading.stopAnimating()
        
        
        //TableView
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
        tableView.register(minUserTableViewCell.self, forCellReuseIdentifier: tableviewIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.allowsMultipleSelection = true
        view.addSubview(tableView)
        
        
        
        updateTableViewHeader()
        
        
        clubView = ClubView(frame: CGRect(x: 0, y: 10, width: Brain.kLargeurIphone, height: 265))
        headerTableView.addSubview(clubView)
        
        timeLabel = UILabel(frame: CGRect(x: 17, y: 284, width: Brain.kLargeurIphone - 34, height: 21))
        timeLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        timeLabel.textColor = .white
        timeLabel.text = NSLocalizedString("Time", comment: "")
        headerTableView.addSubview(timeLabel)
        
        
        timeView = TimeView(frame: CGRect(x: 0, y: timeLabel.y() + 25, width: Brain.kL, height: 38))
        timeView.delegate = self
        timeView.collectionView.selectItem(at: IndexPath(item: 2, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
        headerTableView.addSubview(timeView)
        
        
        
        timeValue = UILabel(frame: CGRect(x: 17, y: 352, width: Brain.kLargeurIphone - 34, height: 15))
        timeValue.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        timeValue.textColor = .white
        timeValue.text = NSLocalizedString("Friday 10 July to 11 July", comment: "")
        headerTableView.addSubview(timeValue)
        
        
        serviceLabel = UILabel(frame: CGRect(x: 17, y: 389, width: Brain.kLargeurIphone - 34, height: 21))
        serviceLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        serviceLabel.textColor = .white
        serviceLabel.text = (self.reservation.object(forKey: Brain.kReservationService) as! PFObject).object(forKey: Brain.kServiceName) as? String
        headerTableView.addSubview(serviceLabel)
        
        serviceValue = UILabel(frame: CGRect(x: 17, y: 389 + 26, width: Brain.kLargeurIphone - 34, height: 15))
        serviceValue.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        serviceValue.textColor = .white
        serviceValue.text = String(format: "Minimum %d$", (self.reservation.object(forKey: Brain.kReservationService) as! PFObject).object(forKey: Brain.kServiceMinimum) as! Int)
        headerTableView.addSubview(serviceValue)
        
        friendsLabel = UILabel(frame: CGRect(x: 17, y: 452, width: Brain.kLargeurIphone - 34, height: 21))
        friendsLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        friendsLabel.textColor = .white
        friendsLabel.text = NSLocalizedString("Friends", comment: "")
        headerTableView.addSubview(friendsLabel)
        
        
        friendsValue = UILabel(frame: CGRect(x: 17, y: 452, width: Brain.kLargeurIphone - 34, height: 21))
        friendsValue.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        friendsValue.textColor = .white
        friendsValue.textAlignment = .right
        
        if (self.selectedFriends.count - 1 + (self.reservation.object(forKey: Brain.kReservationGuestNumber) as! Int)) > 0  {
            
            friendsValue.text = String(format:  NSLocalizedString("Me + %d", comment: ""), (self.selectedFriends.count - 1 + (self.reservation.object(forKey: Brain.kReservationGuestNumber) as! Int)))

        }else{
            
            friendsValue.text =  NSLocalizedString("", comment: "")

        }
        
        headerTableView.addSubview(friendsValue)
        
        
        
        if self.club.object(forKey: Brain.kClubProfile)  != nil {
            
            self.clubView.profile.file = self.club.object(forKey: Brain.kClubProfile) as? PFFile
            self.clubView.profile.loadInBackground()
            
        }
        
        if self.club.object(forKey: Brain.kClubCover)  != nil {
            
            self.clubView.cover.file = self.club.object(forKey: Brain.kClubCover) as? PFFile
            self.clubView.cover.loadInBackground()
            
        }
        
        self.clubView.name.text = self.club.object(forKey: Brain.kClubName) as? String
        
        if self.club.object(forKey: Brain.kClubStyle) != nil {
            
            
            let styles = self.club.object(forKey: Brain.kClubStyle) as! [PFObject]
            
            if styles.count > 0 {
                
                let style = styles[0]
                self.clubView.styleClub.isHidden = false
                self.clubView.styleClub.text = style.object(forKey: Brain.kStyleName) as? String
                
                
            }else{
                
                self.clubView.styleClub.isHidden = true
                
            }
            
        }else{
            
            self.clubView.styleClub.isHidden = true
        }
        
        
        
        
        
        
        bottomFilter = UIImageView(frame: CGRect(x: 0, y:  Brain.kH - 200, width: Brain.kL, height: 200))
        bottomFilter.image = UIImage(named: "bottomFilter")
        self.view.addSubview(bottomFilter)
        
        
        
        
        
        
        if isIphoneXFamily(){
            
            nextButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: view.h() - 185, width:335, height: 60))
            
        }else{
            
            nextButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: view.h() - 170, width:335, height: 60))
            
        }
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Book Table", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.alpha = 1
        nextButton.applyGradient()
        view.addSubview(nextButton)
        
    }
    
    
    func updateSelectedDate(time: String) {
        
    }
    
    
    
    
    @objc func touchNext(_ sender: UIButton){
        
        self.nextButton.loadingIndicator(true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        self.reservation.saveInBackground { (done, error) in
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // do stuff 42 seconds later
                appDelegate.tabBarController?.orderViewController?.getOrders()
                
                appDelegate.tabBarController?.selectedIndex = 2

                self.navigationController?.popToRootViewController(animated: false)

                
                
            }
            
            
        }

        
        
    }
    
    
   
    
    @objc func touchLeftButton(_ sender: UIButton){
        
        
    }
    
    @objc func touchRightButton(_ sender: UIButton){
        
        
    }
    
    @objc func inviteFriendsAction(_ sender: UIButton){
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    @objc func dismiss(_ sender: Any){
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func updateTableViewHeader() {
        
        headerTableView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: 475))
        headerTableView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = headerTableView
        
        footerTableView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: 260))
        footerTableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footerTableView
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
        if self.isMovingFromParentViewController
        {
            print("pop")
            
        }
        else
        {
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        
    }
    
    
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        if self.reservation.object(forKey: Brain.kReservationGuestNumber) as! Int > 0 {
            
            return (self.reservation.object(forKey: Brain.kReservationPeople) as! [PFUser]).count + 1

            
        }else{
            
            return (self.reservation.object(forKey: Brain.kReservationPeople) as! [PFUser]).count

            
        }
        
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableviewIdentifier, for: indexPath as IndexPath) as! minUserTableViewCell
        
        if indexPath.row == 0 && self.reservation.object(forKey: Brain.kReservationGuestNumber) as! Int > 0 {
            
            
            if self.reservation.object(forKey: Brain.kReservationGuestNumber) as! Int == 1 {
                
                cell.name.text  = String(format: NSLocalizedString("%d Guest without Salud", comment: ""), self.reservation.object(forKey: Brain.kReservationGuestNumber) as! Int)

            }else{
                
                cell.name.text  = String(format: NSLocalizedString("%d Guests without Salud", comment: ""), self.reservation.object(forKey: Brain.kReservationGuestNumber) as! Int)

            }
            cell.profilePicture.image = UIImage(named: "guestIcon")

            
            
        }else{
            
            
            if self.reservation.object(forKey: Brain.kReservationGuestNumber) as! Int > 0 {
                
                cell.user = (self.reservation.object(forKey: Brain.kReservationPeople) as! [PFUser])[indexPath.row-1]

            }else{
                
                cell.user = (self.reservation.object(forKey: Brain.kReservationPeople) as! [PFUser])[indexPath.row]

            }
            
            
            cell.name.text  = cell.user.object(forKey: Brain.kUserFirstName) as? String
            
            
            
            if cell.user != nil {
                
                if let images = cell.user?.object(forKey: Brain.kUserImages) as? [PFFile] {
                    
                    cell.profilePicture.file = images[0]
                    cell.profilePicture.loadInBackground()
                    
                }else{
                    
                    cell.profilePicture.image = UIImage(named: "emptyProfile")
                }
                
            }else{
                
                cell.profilePicture.image = UIImage(named: "emptyProfile")
                
            }
            
        }
        
        
        
        
        
        return cell
    }
    
    


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
            tableView.deselectRow(at: indexPath, animated: false)
            
        
        
        
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableViewHeightCell
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
}
