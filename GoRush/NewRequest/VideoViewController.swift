
import UIKit
import AVFoundation
import Parse
import Photos

class VideoViewController: UIViewController, UIGestureRecognizerDelegate {
   
    
    
    var overlayView : UIView!
    var frontCamera : Bool!

    var videoURL: URL!
    var player: AVPlayer?
    var avPlayerLayer: AVPlayerLayer!
    
    var viewToCapture : UIView!
    
    var nextButton : UIButton!
    var request : PFObject!

    var filter : UIImageView!

    var titleVC : UILabel!
    var backButton : UIButton!

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    deinit {
        // perform the deinitialization
        print("dealloc video view \(Date())")
        
    }
    
    convenience init( request : PFObject)
    {
        
        self.init()

        self.videoURL = URL(string: request.object(forKey: Brain.kRequestUrl) as! String)
        self.frontCamera = request.object(forKey: Brain.kRequestFront) as? Bool
        self.request = request
        
    }
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        player = AVPlayer(url: videoURL)
        
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        
        self.title = NSLocalizedString("New Request", comment: "")
        tabBarItem.title = "";
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        
        
        viewToCapture = UIView(frame: view.frame)
        viewToCapture.backgroundColor = .black
        view.addSubview(viewToCapture)

        
        avPlayerLayer = AVPlayerLayer(player: player)

        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        if isIphoneXFamily() {
           
            avPlayerLayer.frame = CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height:  Brain.kHauteurIphone)


        }else{
            
            avPlayerLayer.frame = view.layer.bounds

        }
        view.backgroundColor = .black
        viewToCapture.layer.insertSublayer(avPlayerLayer, at: 0)


        
        

        
        self.filter = UIImageView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone))
        self.filter.image = UIImage(named: "filterCamera")
        self.view.addSubview(filter)
        
        
        
        self.titleVC = UILabel(frame: CGRect(x: 0, y: yTop() + 26, width: Brain.kLargeurIphone, height: 20))
        self.titleVC.textAlignment = .center
        self.titleVC.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.titleVC.textColor = .white
        self.titleVC.text = NSLocalizedString("Your Request", comment: "")
        self.view.addSubview(titleVC)
        
        self.backButton = UIButton(frame: CGRect(x: 13, y: yTop() + 8, width: 44, height: 42))
        self.backButton.setBackgroundImage(UIImage(named: "backArrowWhite"), for: .normal)
        self.backButton.addTarget(self, action: #selector(touchBackNav(_:)), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        
        
        nextButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: Brain.kHauteurIphone-90, width:335, height: 60))
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.applyGradient()
        view.addSubview(nextButton)
      
        
    }
    
    
    @objc func touchBackNav(_ sender: UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func touchNext(_ sender: UIButton){
        
        
        let whereVC = WhereViewController(request: self.request)
        self.navigationController?.pushViewController(whereVC, animated: true)
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        
        navigationController?.setNavigationBarHidden(true, animated: animated)

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForegroundNotification),
                                               name: .UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive),
                                               name: NSNotification.Name.UIApplicationWillResignActive,
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForegroundNotification),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
        
        
        
    }
    
   
    
    @objc func applicationWillResignActive() {
       
        player?.pause()

    }
    @objc func appWillEnterForegroundNotification() {

        

        player?.play()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        
        // Allow background audio to continue to play
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch let error as NSError {
            print(error)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error)
        }
        
        player?.pause()
        player?.play()
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        super.viewDidDisappear(animated)
        

        
        
        player?.pause()
        NotificationCenter.default.removeObserver(self)
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
}

extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        
        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}

