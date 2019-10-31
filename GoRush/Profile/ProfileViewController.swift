//
//  ProfileViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-10-13.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse


class ProfilViewController: ParentLoadingViewController {
    
    
    var titleViewController = NSLocalizedString("Profil", comment:"")
    
    var settingsButton : UIButton!
    var customTitle : UILabel!
    
 
    
    
    
    var lightMode = false
    
    deinit {
        
        print("dealloc Service")
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if lightMode == false {
            
            return .default
            
        }else{
            
            return .lightContent
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = titleViewController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        
        
        if isIphoneXFamily(){
            
            customTitle = UILabel(frame: CGRect(x: 15, y: yTop() + 15, width: Brain.kL - 30, height: 50))
            
        }else{
            
            customTitle = UILabel(frame: CGRect(x: 15, y: yTop() + 25, width: Brain.kL - 30, height: 50))
            
        }
        customTitle.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        customTitle.text = titleViewController
        customTitle.textColor = UIColor(hex: "4D4D4D")
        view.addSubview(customTitle)
        
        
        settingsButton = UIButton(frame: CGRect(x: Brain.kL - 65, y: customTitle.y() + 3, width: 50, height: 44))
        settingsButton.setImage(UIImage(named: "settingsButton"), for: .normal)
        settingsButton.addTarget(self, action: #selector(touchSettings), for: .touchUpInside)
        view.addSubview(settingsButton)
        
        
        
    }
    
   
    
    @objc func touchSettings(_ sender: UIButton){
        
        let settings = SettingsViewController()
        settings.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settings, animated: true)
        
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        
    
        
        
        
        
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    

    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
