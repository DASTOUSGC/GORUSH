//
//  PointsViewController.swift
//  Salud
//
//  Created by Julien Levallois on 19-07-10.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse





class PointsViewController: ParentLoadingViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    let titleViewController = NSLocalizedString("0 points", comment:"")
    
    var challenges = [PFObject]()
    var gifts = [PFObject]()
    
    var backgroundSlider : UIView!
    var slider : UIView!
    var challengesButton : UIButton!
    var giftsButton : UIButton!
    var codeButton : UIButton!
    var codeView : UIView!
    
    var addCodeButton : UIButton!
    var labelCode : UILabel!
    var textField : UITextField!


    var mainScroll : UIScrollView!
    
    var tableheaderView : UIView!
    var tablefooterView : UIView!
    var tableheaderViewGifts : UIView!
    var tablefooterViewGifts : UIView!
    
    
    var tableViewChallenge : UITableView!
    var tableViewGifts : UITableView!
    var tableviewIdentifierchallenges = "Challenges"
    var tableviewIdentifiergifts = "Gifts"

    var showStatusBar = true
    
    var labelInfoChallenge : UILabel!
    var labelInfoGift : UILabel!

    
    var showKey = true
    
    override var prefersStatusBarHidden: Bool {
        
        if showStatusBar == true {
            
            return false
            
        } else {
            
            return true
            
        }
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Brain.kColorCustomGray
        title = titleViewController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        
        
        mainScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: Brain.kL, height: self.view.h()))
        mainScroll.contentSize = CGSize(width: Brain.kL * 3, height: Brain.kH)
        mainScroll.isPagingEnabled = true
        mainScroll.delegate = self
//        mainScroll.isScrollEnabled = false
        view.addSubview(mainScroll)
        
        
        self.tableheaderView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kL, height: 21.5))
        self.tablefooterView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kL, height: 250))
        
        self.tableheaderViewGifts = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kL, height: 21.5))
        self.tablefooterViewGifts = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kL, height: 250))
        
        
        if isIphoneXFamily() {
            
            tableViewChallenge = UITableView(frame: CGRect(x: 0, y: yTop() - 1.5, width: Brain.kL, height: self.view.h()))

            
        }else{
            
            tableViewChallenge = UITableView(frame: CGRect(x: 0, y: yTop() + 28, width: Brain.kL, height: self.view.h()))

        }
        
        tableViewChallenge.register(challengeTableViewCell.self, forCellReuseIdentifier: tableviewIdentifierchallenges)
        tableViewChallenge.dataSource = self
        tableViewChallenge.separatorStyle = .none
        tableViewChallenge.delegate = self
        tableViewChallenge.contentInsetAdjustmentBehavior = .never
        tableViewChallenge.backgroundColor = .clear
        tableViewChallenge.showsVerticalScrollIndicator = false
        tableViewChallenge.tableHeaderView = self.tableheaderView
        tableViewChallenge.tableFooterView = self.tablefooterView
        mainScroll.addSubview(tableViewChallenge)
        
        
        
        if isIphoneXFamily() {
            
            tableViewGifts = UITableView(frame: CGRect(x: 2 * Brain.kL, y: yTop() - 1.5, width: Brain.kL, height: self.view.h()))

            
        }else{
            
            tableViewGifts = UITableView(frame: CGRect(x: 2 * Brain.kL, y: yTop() + 28, width: Brain.kL, height: self.view.h()))

        }
        
        tableViewGifts.register(giftTableViewCell.self, forCellReuseIdentifier: tableviewIdentifiergifts)
        tableViewGifts.dataSource = self
        tableViewGifts.separatorStyle = .none
        tableViewGifts.delegate = self
        tableViewGifts.contentInsetAdjustmentBehavior = .never
        tableViewGifts.backgroundColor = .clear
        tableViewGifts.showsVerticalScrollIndicator = false
        tableViewGifts.tableHeaderView = self.tableheaderViewGifts
        tableViewGifts.tableFooterView = self.tablefooterViewGifts
        mainScroll.addSubview(tableViewGifts)
        
        
        
        codeView = UIView(frame: CGRect(x: Brain.kLargeurIphone, y: 0, width: Brain.kLargeurIphone, height: self.view.h()))
        mainScroll.addSubview(codeView)
        
        if isIphoneXFamily(){
            
            addCodeButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: codeView.h() - 238, width:335, height: 60))
            
        }else{
            
            addCodeButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: codeView.h() - 223, width:335, height: 60))
            
        }
        addCodeButton.layer.cornerRadius = 30;
        addCodeButton.backgroundColor = Brain.kColorMain
        addCodeButton.setTitle(NSLocalizedString("Add Promo Code", comment: ""), for: .normal)
        addCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        addCodeButton.setTitleColor(UIColor.white, for: .normal)
        addCodeButton.setTitleColor(UIColor.gray, for: .highlighted)
        addCodeButton.addTarget(self, action: #selector(addPromoCode(_:)), for: .touchUpInside)
        addCodeButton.alpha = 1
        addCodeButton.applyGradient()
        codeView.addSubview(addCodeButton)
        
        
        
        if isIphoneXFamily(){

            labelCode = UILabel(frame: CGRect(x: 0, y: 150, width: Brain.kL, height: 50))

        }else{
            
            labelCode = UILabel(frame: CGRect(x: 0, y: 90, width: Brain.kL, height: 50))

        }
        labelCode.textAlignment = .center
        labelCode.numberOfLines = 2
        labelCode.text = NSLocalizedString("Add Promo Code\nTo Win Points", comment: "")
        labelCode.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        labelCode.textColor = UIColor.white.withAlphaComponent(0.4)
        codeView.addSubview(labelCode)

        textField = UITextField(frame: CGRect(x: Brain.kL + (Brain.kLargeurIphone-335)/2, y: labelCode.yBottom(), width: 335, height: 60))
        textField.textAlignment = .center
        textField.textColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        textField.delegate = self
        textField.tintColor = Brain.kColorMain
        textField.keyboardType = .default
        textField.returnKeyType = .done
//        textField.autocapitalizationType = .allCharacters
        textField.keyboardAppearance = .dark
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        mainScroll.addSubview(textField)
        
        
        backgroundSlider = UIView(frame: CGRect(x: 15, y: 5, width: Brain.kL - 30, height: 37))
        backgroundSlider.layer.cornerRadius = 37 / 2
        backgroundSlider.backgroundColor = UIColor(hex: "2A2A2A")
        mainScroll.addSubview(backgroundSlider)
        
        slider = UIView(frame: CGRect(x: 0, y: 0, width: backgroundSlider.w()/3, height: backgroundSlider.h()))
        slider.applyGradient()
        slider.layer.cornerRadius = backgroundSlider.h() / 2
        slider.layer.applySketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        backgroundSlider.addSubview(slider)
        
//        mainScroll.setContentOffset(CGPoint(x: Brain.kL, y: 0), animated: false)
        
        
        
        challengesButton = UIButton(frame: CGRect(x: 0, y: 0, width: backgroundSlider.w()/3, height: backgroundSlider.h()))
        challengesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        challengesButton.setTitleColor(.white, for: .normal)
        challengesButton.setTitle(NSLocalizedString("Challenges", comment: ""), for: .normal)
        challengesButton.addTarget(self, action: #selector(touchChallenges(_:)), for: .touchUpInside)
        backgroundSlider.addSubview(challengesButton)
        
        codeButton = UIButton(frame: CGRect(x: backgroundSlider.w()/3, y: 0, width: backgroundSlider.w()/3, height: backgroundSlider.h()))
        codeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        codeButton.setTitleColor(.white, for: .normal)
        codeButton.setTitle(NSLocalizedString("Code", comment: ""), for: .normal)
        codeButton.addTarget(self, action: #selector(touchPromoCode(_:)), for: .touchUpInside)
        backgroundSlider.addSubview(codeButton)
        
        giftsButton = UIButton(frame: CGRect(x: 2 * backgroundSlider.w()/3, y: 0, width: backgroundSlider.w()/3, height: backgroundSlider.h()))
        giftsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        giftsButton.setTitleColor(.white, for: .normal)
        giftsButton.setTitle(NSLocalizedString("Gifts", comment: ""), for: .normal)
        giftsButton.addTarget(self, action: #selector(touchGifts(_:)), for: .touchUpInside)
        backgroundSlider.addSubview(giftsButton)
        
        
        
     
        labelInfoChallenge = UILabel(frame: CGRect(x: 30, y: 20, width: Brain.kLargeurIphone - 60, height: 100))
        labelInfoChallenge.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelInfoChallenge.textColor = .white
        labelInfoChallenge.isHidden = true
        labelInfoChallenge.textAlignment = .center
        labelInfoChallenge.numberOfLines = 0
        tableheaderView.addSubview(labelInfoChallenge)

        
        labelInfoGift = UILabel(frame: CGRect(x: 30, y: 20, width: Brain.kLargeurIphone - 60, height: 100))
        labelInfoGift.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelInfoGift.textColor = .white
        labelInfoGift.isHidden = true
        labelInfoGift.textAlignment = .center
        labelInfoGift.numberOfLines = 0
        tableheaderViewGifts.addSubview(labelInfoGift)


        
        
    }
    
  
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        
    }
    
    
    
    
    func getChallenges(){
        
    
        
        let query = PFQuery(className: Brain.kChallengeClassName)
        query.order(byAscending: Brain.kChallengeOrder)
        query.whereKey(Brain.kChallengeAvailable, equalTo: true)
        query.limit = 1000
        query.cachePolicy = .cacheThenNetwork
        
        query.findObjectsInBackground { (challengesFetched, error) in
            
            
            
            if challengesFetched != nil {
                
                self.challenges = challengesFetched!
                
                for challenge in self.challenges {
                    
                    
                    if challenge.object(forKey: Brain.kChallengeIcon) != nil {

                        let iconChallenge = challenge.object(forKey: Brain.kChallengeIcon) as! PFFile
                        iconChallenge.getDataInBackground()

                    }
                
                }
                
            }else{
                
                self.challenges = [PFObject]()
                
            }
            
           
            
            self.tableViewChallenge.reloadData()
            
        }
        
    }
    
    func getGifts(){
        
        
        let query = PFQuery(className: Brain.kGiftClassName)
        query.order(byAscending: Brain.kGiftOrder)
        query.includeKey(Brain.kGiftClub)
        query.includeKey(Brain.kGiftClubs)
        query.whereKey(Brain.kGiftAvailable, equalTo: true)
        query.limit = 1000
        query.cachePolicy = .cacheThenNetwork
        query.findObjectsInBackground { (giftsFetched, error) in
            
            
            if giftsFetched != nil {
                
                
                self.gifts = [PFObject]()
                
                for gift in giftsFetched! {
                    
                    
                    var userUsed = 0
                    
                    if PFUser.current()?.object(forKey: Brain.kUserGift) != nil {
                        
                        let giftsUsed = PFUser.current()?.object(forKey: Brain.kUserGift)  as! [String]
                        
                        for giftUsed in giftsUsed {
                            
                            if gift.objectId! == giftUsed {
                                
                                userUsed = userUsed + 1
                            }
                            
                        }
                    }
                    
                    
                    if gift.object(forKey: Brain.kGiftLimitByUser) != nil {
                        
                        let remaining = (gift.object(forKey: Brain.kGiftLimitByUser) as! Int) - userUsed
                        
                        if remaining > 0 {
                            
                           
                            self.gifts.append(gift)

                        }
                   
                    }else{
                        
                        
                        self.gifts.append(gift)
                        
                    }
                    
                    
                    
                    
                    if gift.object(forKey: Brain.kGiftPhoto) != nil {
                        
                        let file = gift.object(forKey: Brain.kGiftPhoto) as! PFFile
                        file.getDataInBackground()
                    }
                    
                    if gift.object(forKey: Brain.kGiftVideo) != nil {
                        
                        let file = gift.object(forKey: Brain.kGiftVideo) as! PFFile
                        file.getDataInBackground()
                    }
                }
                
            }else{
                
                
                self.gifts = [PFObject]()
                
            }
          
            
            
            self.tableViewGifts.reloadData()
            
            
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.mainScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        return true
    }
    
    
    @objc func addPromoCode (_ sender : UIButton){
        
     
        self.addCodeButton.loadingIndicator(true)
        self.addCodeButton.isEnabled = false
        
        let queryCode = PFQuery(className: Brain.kPromoCodeClassName)
        queryCode.whereKey(Brain.kPromoCodeAvailable, equalTo: true)
        queryCode.whereKeyExists(Brain.kPromoCodePoint)
        queryCode.whereKey(Brain.kPromoCodeCode, equalTo: self.textField.text!)
        queryCode.getFirstObjectInBackground { (codeObject, error) in
            
            self.addCodeButton.loadingIndicator(false)
            self.addCodeButton.isEnabled = true

            
            if error == nil {
                
                if codeObject != nil {
                    
                    if PFUser.current()?.object(forKey: Brain.kUserPromoCode) != nil {
                        
                        
                        let codesAlreadyUsed = PFUser.current()?.object(forKey: Brain.kUserPromoCode) as! [String]
                        
                        var nb = 0
                        for code in codesAlreadyUsed {
                            
                            if code == codeObject?.objectId! {
                                
                                nb = nb + 1
                            }
                            
                        }
                        
                        print("nb \(nb)")
                        print("limit \(codeObject?.object(forKey: Brain.kPromoCodeLimitByUser) as! Int)")

                        
                        if nb >= codeObject?.object(forKey: Brain.kPromoCodeLimitByUser) as! Int {
                         
                            
                            self.showPopupCodeAlreadyUsed()

                            
                        }else{
                            
                            self.wonPromoCode(promoCode: codeObject!)

                        }
                        
                        
                    }else{
                        
                        
                       self.wonPromoCode(promoCode: codeObject!)
                        
                    }
                    
                }else{
                    
                    self.showPopupErrorCode()

                }
            }else{
                
                self.showPopupErrorCode()
                
            }
        }
        
    }
    
    func wonPromoCode(promoCode:PFObject){
        
        
        self.textField.text = ""
        
        let points = promoCode.object(forKey: Brain.kPromoCodePoint) as! Int
        
        var totalPoints = 0
        
        if PFUser.current()?.object(forKey: Brain.kUserPoint) != nil {
            
            totalPoints = totalPoints + (PFUser.current()?.object(forKey: Brain.kUserPoint) as! Int)
        }
        
        totalPoints = totalPoints + points
        
        
        if PFUser.current()?.object(forKey: Brain.kUserPoint) != nil {
            
            self.incrementLabel(from: PFUser.current()?.object(forKey: Brain.kUserPoint)  as! Int, to: totalPoints)

        }else{
            self.incrementLabel(from: 0, to: totalPoints)

            
        }
        
        
        
        
        PFUser.current()?.setObject(totalPoints, forKey: Brain.kUserPoint)

        self.tableViewGifts.reloadData()
        
        
        title = String(format: "%d points", PFUser.current()?.object(forKey: Brain.kUserPoint) as! Int)
        self.tabBarItem.title = nil


        if PFUser.current()?.object(forKey: Brain.kUserPromoCode) != nil {

            var codes = PFUser.current()?.object(forKey: Brain.kUserPromoCode) as! [String]
            codes.append(promoCode.objectId!)
            
            PFUser.current()?.setObject(codes, forKey: Brain.kUserPromoCode)
            PFUser.current()?.saveInBackground()

            
            
        }else{
            
            var codes = [String]()
            codes.append(promoCode.objectId!)
            
            PFUser.current()?.setObject(codes, forKey: Brain.kUserPromoCode)
            PFUser.current()?.saveInBackground()
            
        }
        
    }
    
    

    func generateHapticFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
    
    
    func incrementLabel(from : Int, to: Int) {
        let duration: Double = 2.0 //seconds
        DispatchQueue.global().async {
            
            
            print("c \(from)")
            print("e \(to)")
            for i in from..<(to+1) {
            
                let sleepTime = UInt32(duration/Double(to-from) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.title = String(format: "%d points", i)
                    self.tabBarItem.title = "";

                    self.tabBarItem.title = nil

                    if i % 10 == 0 {
                        
                        self.generateHapticFeedback()

                    }

                }
                
            }
        }
    }
    
    func decrementLabel(from : Int, to: Int) {
      
        let duration: Double = 2.0 //seconds
        DispatchQueue.global().async {
            
         
            print("from \(from)")
            print("to \(to)")
            for i in (to..<(from+1)).reversed() {
                
                let sleepTime = UInt32(duration/Double(from-to) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.title = String(format: "%d points", i)
                    self.tabBarItem.title = "";
                    
                    self.tabBarItem.title = nil
                    
                    if i % 10 == 0 {
                        
                        self.generateHapticFeedback()
                        
                    }
                    
                }
                
            }
        }
    }

    
    
    func showPopupErrorCode(){
       
        
        let alert = UIAlertController(title: NSLocalizedString("Invalid Promo Code", comment: ""), message: NSLocalizedString("Sorry, your promo code is invalid", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = []
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showPopupCodeAlreadyUsed(){
        
        
        let alert = UIAlertController(title: NSLocalizedString("Promo code already used", comment: ""), message: NSLocalizedString("Sorry, you have already used promo code", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = []
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    @objc func touchChallenges (_ sender : UIButton){
        
        
        

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            //            self.slider.frame.origin.x = 0
            self.mainScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
            
        }) { (done) in
          
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                self.textField.resignFirstResponder()
                
            }
        }
        
    }
    
    @objc func touchPromoCode (_ sender : UIButton){
        

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            //            self.slider.frame.origin.x = 0
            self.mainScroll.setContentOffset(CGPoint(x: Brain.kL, y: 0), animated: true)
            
            
        }) { (done) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                
                if self.showKey == true {
                    
                    self.textField.becomeFirstResponder()

                }

            }

        }
        

    }
    
    @objc func touchGifts (_ sender : UIButton){
        
        
//        self.textField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            //            self.slider.frame.origin.x = self.backgroundSlider.w()/2
            self.mainScroll.setContentOffset(CGPoint(x: 2 * Brain.kL, y: 0), animated: true)
            
            
        }) { (done) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                self.textField.resignFirstResponder()
                
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if scrollView == mainScroll {
            
            self.backgroundSlider.frame.origin.x = 15 + scrollView.contentOffset.x
            
            
            var originX = mainScroll.contentOffset.x
            
            if originX < 0 {
                
                originX = 0
            }
            
            if originX > 2 * Brain.kLargeurIphone{
                
                originX =  2 * Brain.kLargeurIphone
            }
            
            
            if originX == 0 {
                
                self.textField.resignFirstResponder()
                
            }
            
            if originX == 2 * Brain.kLargeurIphone {
                
                self.textField.resignFirstResponder()
                
            }
            
            if originX ==  Brain.kLargeurIphone {
                
                
                if self.showKey == true {
                    
                    self.textField.becomeFirstResponder()

                }
                
            }
            self.slider.frame.origin.x = (originX / ( Brain.kLargeurIphone)) * self.slider.w()
            
//            if scrollView.contentOffset.x == 0 {
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
//                    // Code you want to be delayed
//                    self.textField.resignFirstResponder()
//                    
//                }
//            }else if scrollView.contentOffset.x == Brain.kLargeurIphone {
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
//                    // Code you want to be delayed
//                    self.textField.becomeFirstResponder()
//                    
//                }
//                
//            }else if scrollView.contentOffset.x == 2 * Brain.kLargeurIphone {
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
//                    // Code you want to be delayed
//                    self.textField.resignFirstResponder()
//                    
//                }
//            }
        }
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableViewChallenge {
            
            return 58
            
        }else{
            
            
            return 196
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView == self.tableViewChallenge {
            
            return challenges.count
            
        }else{
            
            
            return gifts.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
    
        
        
        if tableView == self.tableViewChallenge {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: tableviewIdentifierchallenges, for: indexPath as IndexPath) as! challengeTableViewCell

            cell.challenge = self.challenges[indexPath.row]
            
            cell.name.text = cell.challenge.object(forKey: Brain.kChallengeName) as? String
            
            if cell.challenge.object(forKey: Brain.kChallengeIcon) != nil {
                
                let file = cell.challenge.object(forKey: Brain.kChallengeIcon) as! PFFile
                file.getDataInBackground { (data, error) in
                    
                    if data != nil {
                        
                        cell.icon.image = UIImage(data: data!)?.withRenderingMode(.alwaysTemplate)

                    }
                }
            }
            
            if PFUser.current()?.object(forKey: Brain.kUserChallenge) != nil {
                
                if (PFUser.current()?.object(forKey: Brain.kUserChallenge) as! [String]).contains(cell.challenge.objectId!){
                    
                    cell.icon.tintColor = Brain.kColorMain
                    cell.name.alpha = 1
                    cell.icon.alpha = 1

                }else{
                  
                    cell.icon.tintColor = .white
                    cell.name.alpha = 0.27
                    cell.icon.alpha = 0.27

                }

                
            }else{
                
                cell.icon.tintColor = .white
                cell.name.alpha = 0.27
                cell.icon.alpha = 0.27

            }
            
            
            return cell

            
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: tableviewIdentifiergifts, for: indexPath as IndexPath) as! giftTableViewCell

            cell.gift = gifts[indexPath.row]
            
            
            cell.name.text = cell.gift.object(forKey: Brain.kGiftName) as? String
            cell.descriptionGift.text = cell.gift.object(forKey: Brain.kGiftDescription) as? String

            cell.points.text = String(format: "%d points", cell.gift.object(forKey: Brain.kGiftPoint) as! Int)

            cell.cta.isHidden = true
            cell.cta.alpha = 1
            
            
           
          
            if cell.gift.object(forKey: Brain.kGiftHidePoints) != nil {
                
                if cell.gift.object(forKey: Brain.kGiftHidePoints) as! Bool == true {
                    
                    cell.points.isHidden = true

                }
                
            }
            
            cell.fakeCta.setTitle(NSLocalizedString("Redeem", comment: ""), for: .normal)

            
            if cell.gift.object(forKey: Brain.kGiftPoint) != nil  &&  PFUser.current()?.object(forKey: Brain.kUserPoint) != nil {
                

                if (PFUser.current()?.object(forKey: Brain.kUserPoint) as! Int) >= (cell.gift.object(forKey: Brain.kGiftPoint) as! Int) {
                    
                    
                    cell.cta.isHidden = false
                }
                
            }
            
            var userUsed = 0
            
            if PFUser.current()?.object(forKey: Brain.kUserGift) != nil {
                
                let giftsUsed = PFUser.current()?.object(forKey: Brain.kUserGift)  as! [String]
                
                for giftUsed in giftsUsed {
                    
                    if cell.gift.objectId! == giftUsed {
                        
                        userUsed = userUsed + 1
                    }
                    
                }
            }
            
            if cell.gift.object(forKey: Brain.kGiftLimitByUser) != nil {
                
                
                
                if cell.gift.object(forKey: Brain.kGiftLimitByUser) as! Int == 10000 {
                    
                    cell.points.text = String(format: "%@ · ∞", cell.points.text!)

                }else{
                    
                    let remaining = (cell.gift.object(forKey: Brain.kGiftLimitByUser) as! Int) - userUsed
                    cell.points.text = String(format: "%@ · %d remaining", cell.points.text!,remaining)
                    
                    if remaining == 0 {
                        
                        cell.cta.isHidden = true
                        cell.fakeCta.setTitle(NSLocalizedString("0 Remaining", comment: ""), for: .normal)
                        
                    }
               
                }
                
              
            }
          
            
            cell.cta.tag = indexPath.row
            cell.cta.addTarget(self, action: #selector(touchCta(_:)), for: .touchUpInside)

            
            
           
            
            
            return cell

            
        }
        
        
        
    }
    
    
    @objc func touchCta(_ sender: UIButton){
        
        self.redeemGift(sender: sender)

        
        
    }
    
    
    func redeemGift(sender : UIButton){
        
        let cell = tableViewGifts.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! giftTableViewCell

        
        if cell.gift.object(forKey: Brain.kGiftClubs) != nil {
            
            let clubs = cell.gift.object(forKey: Brain.kGiftClubs) as! [PFObject]
            
            if clubs.count == 1 {
                
                let alert = UIAlertController(title: NSLocalizedString("Be Careful", comment: ""), message: NSLocalizedString("You will have 2 minutes to show your gift to the bartender, after it will disappear forever.\n\nIt will not be valid if you take a screeenshot.\n\nHand over the Phone to the bartender so that he/she can confirm the order", comment: ""), preferredStyle: .alert)

                
                alert.addColorInTitleAndMessage(color: UIColor.black)
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.permittedArrowDirections = []
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                }
                
                
                let yesAction = UIAlertAction(title: NSLocalizedString("Continue", comment: ""), style: .default, handler: { action in
                    
                    
                    self.endRedeem(gift : cell.gift, club: clubs[0], sender : sender)

                })
                yesAction.setValue(UIColor.black, forKey: "titleTextColor")
                alert.addAction(yesAction)
                
                
                
                let noAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                alert.addAction(noAction)
                
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                    
                }
                
                
                
                
            }else{
                
                
                let select = SelectClubViewController(pointsVC: self, gift: cell.gift, initClubs: clubs, sender: sender)
                select.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(select, animated: true)

            }
            
            
        }else{

            let select = SelectClubViewController(pointsVC: self, gift: cell.gift, initClubs: nil, sender: sender)
            select.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(select, animated: true)

        }
        
    

        
    }
    
    func redeemSelectedClub(gift : PFObject, club : PFObject, sender: UIButton){
        
        
        let alert = UIAlertController(title: NSLocalizedString("Be Careful", comment: ""), message: NSLocalizedString("You will have 2 minutes to show your gift to the bartender, after it will disappear forever.\n\nIt will not be valid if you take a screeenshot.\n\nHand over the Phone to the bartender so that he/she can confirm the order", comment: ""), preferredStyle: .alert)

        
        
        alert.addColorInTitleAndMessage(color: UIColor.black)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = []
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        
        let yesAction = UIAlertAction(title: NSLocalizedString("Continue", comment: ""), style: .default, handler: { action in
            
            
            self.endRedeem(gift : gift, club: club, sender : sender)
            
        })
        yesAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(yesAction)
        
        
        
        let noAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(noAction)
        
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
            
        }
        
    }
    
    func endRedeem(gift : PFObject, club : PFObject, sender: UIButton){
    
    
            let points = gift.object(forKey: Brain.kGiftPoint) as! Int
        
            var currentPoints = 0
            var totalPoints = 0
        
            if PFUser.current()?.object(forKey: Brain.kUserPoint) != nil {
            
                currentPoints = currentPoints + (PFUser.current()?.object(forKey: Brain.kUserPoint) as! Int)
           
            }
        
        
            totalPoints = currentPoints - points
        
        
            if PFUser.current()?.object(forKey: Brain.kUserPoint) != nil {
            
                self.decrementLabel(from: currentPoints, to: totalPoints)
            
                UIView.animate(withDuration: 2.0, animations: {
                
                    sender.alpha = 0
                  
                
                
                }) { (done) in
                
                   
                    let giftVC = GiftViewController(gifts: [gift], club : club)
                    self.present(giftVC, animated: true, completion: {
                        
                    })
                    
                    
                    sender.isHidden = true
                    self.tableViewGifts.reloadData()
                    
                    
                    
                }
    
        
            }
    
        
            PFUser.current()?.setObject(totalPoints, forKey: Brain.kUserPoint)
    
    
            title = String(format: "%d points", PFUser.current()?.object(forKey: Brain.kUserPoint) as! Int)
            self.tabBarItem.title = nil
        
        
            if PFUser.current()?.object(forKey: Brain.kUserGift) != nil {
                
                var gifts = PFUser.current()?.object(forKey: Brain.kUserGift) as! [String]
                gifts.append(gift.objectId!)
                
                PFUser.current()?.setObject(gifts, forKey: Brain.kUserGift)
                PFUser.current()?.saveInBackground()
                
            
            
            }else{
            
                var gifts = [String]()
                gifts.append(gift.objectId!)
                
                PFUser.current()?.setObject(gifts, forKey: Brain.kUserGift)
                PFUser.current()?.saveInBackground()
            
            }
        
        
            let giftRedeem = PFObject(className: Brain.kGiftRedeemClassName)
            giftRedeem.setObject(PFUser.current()!, forKey: Brain.kGiftRedeemUser)
            giftRedeem.setObject(gift, forKey: Brain.kGiftRedeemGift)
            giftRedeem.setObject(club, forKey: Brain.kGiftRedeemClub)
            giftRedeem.saveInBackground()
   
    
    
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
//
//        return false
//    }
    
    
    override func appbecomeActive() {
        
        
        self.getChallenges()
        self.getGifts()
        
    }
    
    override func appResignActive() {
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        
        PFUser.current()?.fetchInBackground(block: { (user, error) in
            
            self.tableViewChallenge.reloadData()
            self.tableViewGifts.reloadData()
            
            
            if PFUser.current()?.object(forKey: Brain.kUserPoint) != nil {
                
                self.title = String(format: "%d points", PFUser.current()?.object(forKey: Brain.kUserPoint) as! Int)
                
            }else{
                
                self.title = String(format: "%d points", 0)
                
            }
            
            self.tabBarItem.title = "";

            self.getChallenges()
            self.getGifts()
                        
            
            
        })
        
        if PFUser.current()?.object(forKey: Brain.kUserPoint) != nil {
            
            title = String(format: "%d points", PFUser.current()?.object(forKey: Brain.kUserPoint) as! Int)
            
        }else{
            
            title = String(format: "%d points", 0)
            
        }
        self.tabBarItem.title = nil

        
        
        self.getChallenges()
        self.getGifts()
        
      
        
        if PFConfig.current().object(forKey: Brain.kconfigDisabledRewards) != nil {
            
            self.tableheaderView.frame = CGRect(x: 0, y: 0, width: Brain.kL, height: 101.5)
            self.tableheaderViewGifts.frame = CGRect(x: 0, y: 0, width: Brain.kL, height: 101.5)
            
            labelInfoChallenge.isHidden = false
            labelInfoGift.isHidden = false
            
            labelInfoChallenge.text = PFConfig.current().object(forKey: Brain.kconfigDisabledRewards)  as? String
            labelInfoGift.text = PFConfig.current().object(forKey: Brain.kconfigDisabledRewards)  as? String

        }else{
            
            self.tableheaderView.frame = CGRect(x: 0, y: 0, width: Brain.kL, height: 21.5)
            self.tableheaderViewGifts.frame = CGRect(x: 0, y: 0, width: Brain.kL, height: 21.5)
            
            labelInfoChallenge.isHidden = true
            labelInfoGift.isHidden = true

            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)

        self.textField.resignFirstResponder()
        
        
        super.viewWillDisappear(animated)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                addCodeButton.frame = CGRect(x:(Brain.kLargeurIphone-335)/2, y: Brain.kHauteurIphone-60-105 - keyboardSize.height, width:335, height: 60)
        }
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        
    }
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
