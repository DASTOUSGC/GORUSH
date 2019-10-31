//
//  SelectTypeViewController
//  GoRush
//
//  Created by Julien Levallois on 19-09-08.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import Parse


class SelectTypeViewController.sw: ParentLoadingViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    var types = [PFObject]()
    var titleViewController = NSLocalizedString("Select Your Service", comment:"")

    
    var collectionView : UICollectionView!
    
    var backButtonNav : UIButton!

    
    
    deinit {
        
        print("dealloc Service")
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        self.title = self.titleViewController
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .done, target: self, action: #selector(touchBack(_:)))

        
        
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize(width: ( Brain.kLargeurIphone - 45 ) / 2, height: ( Brain.kLargeurIphone - 45 ) / 2)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0 , width: Brain.kLargeurIphone , height: self.view.h() ) , collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(20, 0, 150, 0)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        //        collectionView.backgroundColor = .yellow
        //        collectionView.isScrollEnabled = false
        collectionView.register(typeCollectionViewCell.self, forCellWithReuseIdentifier: "Types")
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
        
       
        
    }
    
    
   
    @objc func touchBack(_ sender: UIButton){
        
        
        self.dismiss(animated: true) {
        
            
        }
        
    }
    
    
    override func appbecomeActive() {
        
        print("become active App")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barStyle = .black

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        
        
        self.getMytypes()
        self.collectionView.reloadData()
       
        
    }
    
    
    
    func getMytypes() {
        
//        let querytypes = PFQuery(className: Brain.kProfilClassName)
//        querytypes.whereKey(Brain.kProfilUser, equalTo: PFUser.current()!)
//        querytypes.includeKey(Brain.kProfilRecettes)
//        querytypes.order(byAscending: "createdAt")
//        querytypes.limit = 1000
//        querytypes.cachePolicy = .cacheThenNetwork
//        querytypes.findObjectsInBackground { (typesFetched, error) in
//
//            if error == nil {
//
//                self.types = typesFetched!
//
//            }else {
//
//                self.types = [PFObject]()
//
//            }
//
//            self.collectionView.reloadData()
//
//        }
        
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
    
    
    func pushViewController(_ viewcontroller:UIViewController, animated:Bool){
        
        navigationController?.pushViewController(viewcontroller, animated: animated)
        
    }
    
    
    ////COLLECTIONVIEW
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        
        return CGSize(width: ( Brain.kLargeurIphone - 45 ) / 2, height: ( Brain.kLargeurIphone - 45 ) / 2)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Types", for: indexPath as IndexPath) as! typeCollectionViewCell
        
        
        cell.cover.isHidden = true
        cell.filter.isHidden = true
        cell.editProfil.isHidden = true
        cell.name.isHidden = true
        cell.subName.isHidden = true
        cell.addProfil.isHidden = true
        
        
        if indexPath.row < self.types.count {
            
          
            
        }
        
        return cell
        
    }
    
    
 
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if indexPath.row < self.types.count {
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
