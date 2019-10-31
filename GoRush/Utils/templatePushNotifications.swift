//
//  templatePushNotifications.swift
//  templateProject
//
//  Created by Julien Levallois on 18-02-04.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//

import UIKit

class templatePushNotifications: UIViewController {
    
    
    
    /// Parameters
    
    var displayWidth: CGFloat!
    var displayHeight: CGFloat!
    
    var info: UILabel!
    var subInfo: UILabel!
    var logo: UIImageView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        tabBarItem.title = "";
        
        displayWidth = view.frame.width
        displayHeight = heightView(heightView:view)

        logo = UIImageView(frame: CGRect(x: displayWidth/2 - 75, y: displayHeight/2 - 200, width: 150, height: 150))
        logo.backgroundColor = UIColor.gray
        logo.image = UIImage(named: "")
        view.addSubview(logo)
        
        info = UILabel(frame:CGRect(x: 0, y: displayHeight/2-20, width: displayWidth, height: 40))
        info.textAlignment = .center
        info.textColor = UIColor(hex:"000")
        info.text = NSLocalizedString("Keep me posted", comment: "")
        info.font = UIFont(name: "customFont", size: 30) ?? UIFont.systemFont(ofSize:30)
        view.addSubview(info)
        
        subInfo = UILabel(frame:CGRect(x: 0, y: info.frame.origin.y + info.frame.size.height + 20, width: displayWidth, height: 40))
        subInfo.textAlignment = .center
        subInfo.textColor = UIColor(hex:"000")
        subInfo.numberOfLines = 2
        subInfo.lineBreakMode = .byWordWrapping
        subInfo.text = NSLocalizedString("Find out when you get\na match or message", comment: "")
        subInfo.font = UIFont(name: "customFont", size: 16) ?? UIFont.systemFont(ofSize:16)
        view.addSubview(subInfo)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
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
    
    
    
    
    
}
