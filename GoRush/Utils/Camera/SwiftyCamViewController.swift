/*Copyright (c) 2016, Andrew Walz.

Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit
import AVFoundation
import CallKit

// MARK: View Controller Declaration

/// A UIViewController Camera View Subclass

open class SwiftyCamViewController: UIViewController, UIGestureRecognizerDelegate, CXCallObserverDelegate {

	// MARK: Enumeration Declaration

	/// Enumeration for Camera Selection

    public enum CameraSelection: String {

		/// Camera on the back of the device
		case rear = "rear"

		/// Camera on the front of the device
		case front = "front"
	}

	/// Enumeration for video quality of the capture session. Corresponds to a AVCaptureSessionPreset


	public enum VideoQuality {

		/// AVCaptureSessionPresetHigh
		case high

		/// AVCaptureSessionPresetMedium
		case medium

		/// AVCaptureSessionPresetLow
		case low

		/// AVCaptureSessionPreset352x288
		case resolution352x288

		/// AVCaptureSessionPreset640x480
		case resolution640x480

		/// AVCaptureSessionPreset1280x720
		case resolution1280x720

		/// AVCaptureSessionPreset1920x1080
		case resolution1920x1080

		/// AVCaptureSessionPreset3840x2160
		case resolution3840x2160

		/// AVCaptureSessionPresetiFrame960x540
		case iframe960x540

		/// AVCaptureSessionPresetiFrame1280x720
		case iframe1280x720
	}

	/**

	Result from the AVCaptureSession Setup

	- success: success
	- notAuthorized: User denied access to Camera of Microphone
	- configurationFailed: Unknown error
	*/

	fileprivate enum SessionSetupResult {
		case success
		case notAuthorized
		case configurationFailed
	}

    
   
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)

    
	// MARK: Public Variable Declarations

	/// Public Camera Delegate for the Custom View Controller Subclass

	public weak var cameraDelegate: SwiftyCamViewControllerDelegate?

	/// Maxiumum video duration if SwiftyCamButton is used

	public var maximumVideoDuration : Double     = 0.0

	/// Video capture quality

	public var videoQuality : VideoQuality       = .high

	/// Sets whether flash is enabled for photo and video capture

	public var flashEnabled                      = false

	/// Sets whether Pinch to Zoom is enabled for the capture session

	public var pinchToZoom                       = true

	/// Sets the maximum zoom scale allowed during gestures gesture

	public var maxZoomScale				         = CGFloat.greatestFiniteMagnitude

	/// Sets whether Tap to Focus and Tap to Adjust Exposure is enabled for the capture session

	public var tapToFocus                        = true

	/// Sets whether the capture session should adjust to low light conditions automatically
	///
	/// Only supported on iPhone 5 and 5C

	public var lowLightBoost                     = true

	/// Set whether SwiftyCam should allow background audio from other applications

	public var allowBackgroundAudio              = true

	/// Sets whether a double tap to switch cameras is supported

	public var doubleTapCameraSwitch            = true

    /// Sets whether swipe vertically to zoom is supported

    public var swipeToZoom                     = false

    /// Sets whether swipe vertically gestures should be inverted

    public var swipeToZoomInverted             = false

	/// Set default launch camera

	public var defaultCamera                   = CameraSelection.rear

	/// Sets wether the taken photo or video should be oriented according to the device orientation

    public var shouldUseDeviceOrientation      = false {
        didSet {
            orientation.shouldUseDeviceOrientation = shouldUseDeviceOrientation
        }
    }

    /// Sets whether or not View Controller supports auto rotation

    public var allowAutoRotate                = false

    /// Specifies the [videoGravity](https://developer.apple.com/reference/avfoundation/avcapturevideopreviewlayer/1386708-videogravity) for the preview layer.
    public var videoGravity                   : SwiftyCamVideoGravity = .resizeAspect

    /// Sets whether or not video recordings will record audio
    /// Setting to true will prompt user for access to microphone on View Controller launch.
    public var audioEnabled                   = true

    /// Sets whether or not app should display prompt to app settings if audio/video permission is denied
    /// If set to false, delegate function will be called to handle exception
    public var shouldPrompToAppSettings       = true

    /// Public access to Pinch Gesture
    fileprivate(set) public var pinchGesture  : UIPinchGestureRecognizer!



	// MARK: Public Get-only Variable Declarations

	/// Returns true if video is currently being recorded

	private(set) public var isVideoRecording      = false

	/// Returns true if the capture session is currently running

	private(set) public var isSessionRunning     = false

	/// Returns the CameraSelection corresponding to the currently utilized camera

	private(set) public var currentCamera        = CameraSelection.rear

	// MARK: Private Constant Declarations

	/// Current Capture Session

	public let session                           = AVCaptureSession()

	/// Serial queue used for setting up session

	fileprivate let sessionQueue                 = DispatchQueue(label: "session queue", attributes: [])

	// MARK: Private Variable Declarations

	/// Variable for storing current zoom scale

	fileprivate var zoomScale                    = CGFloat(1.0)

	/// Variable for storing initial zoom scale before Pinch to Zoom begins

	fileprivate var beginZoomScale               = CGFloat(1.0)

	/// Returns true if the torch (flash) is currently enabled

	fileprivate var isCameraTorchOn              = false

	/// Variable to store result of capture session setup

	fileprivate var setupResult                  = SessionSetupResult.success

	/// BackgroundID variable for video recording

	fileprivate var backgroundRecordingID        : UIBackgroundTaskIdentifier? = nil

	/// Video Input variable

	fileprivate var videoDeviceInput             : AVCaptureDeviceInput!

	/// Movie File Output variable

	fileprivate var movieFileOutput              : AVCaptureMovieFileOutput?

	/// Photo File Output variable

	fileprivate var photoFileOutput              : AVCaptureStillImageOutput?

	/// Video Device variable

	fileprivate var videoDevice                  : AVCaptureDevice?

	/// PreviewView for the capture session

	fileprivate var previewLayer                 : PreviewView!

    var frontLayer : UIView!
	/// UIView for front facing flash

	fileprivate var flashView                    : UIView?

    /// Pan Translation

    fileprivate var previousPanTranslation       : CGFloat = 0.0

	/// Last changed orientation

    fileprivate var orientation                  : Orientation = Orientation()

    /// Boolean to store when View Controller is notified session is running

    fileprivate var sessionRunning               = false

	/// Disable view autorotation for forced portrait recorindg

    var audioDeviceInput : AVCaptureDeviceInput?
    
	override open var shouldAutorotate: Bool {
		return allowAutoRotate
	}

    var toCloseCamera = false

    
    var bottomCache : UIView?
    var topCache : UIView!
    var callObserver: CXCallObserver! // add property
    var audioSessionDone = false

	// MARK: ViewDidLoad

	/// ViewDidLoad Implementation

	override open func viewDidLoad() {
		super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)

        callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil) //
        
        
        topCache = UIView(frame: CGRect(x: 0, y: -Brain.kHauteurIphone, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone + 50))
        topCache?.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.view.addSubview(topCache!)
        
        
        if isIphoneXFamily() {
            
      
            
            bottomCache = UIView(frame: CGRect(x: 0, y: Brain.kHauteurIphone - ( Brain.kHauteurIphone - Utils.getHeightOfStory() + 44 ) , width: Brain.kLargeurIphone, height: ( Brain.kHauteurIphone - Utils.getHeightOfStory() + 44 )))
            bottomCache?.backgroundColor = .black
            self.view.addSubview(bottomCache!)

            previewLayer = PreviewView(frame: CGRect(x: 0, y: 44, width: Brain.kLargeurIphone, height:  Utils.getHeightOfStory()), videoGravity: videoGravity)
            previewLayer.layer.cornerRadius = 8
            self.frontLayer = UIView(frame: CGRect(x: 0, y: 44, width: Brain.kLargeurIphone, height:  Utils.getHeightOfStory()))
            frontLayer.backgroundColor = .clear
            view.addSubview(self.frontLayer)
            view.sendSubview(toBack: frontLayer)
            
            
            view.addSubview(previewLayer)
            view.sendSubview(toBack: previewLayer)
            view.sendSubview(toBack: bottomCache!)
            view.sendSubview(toBack: topCache!)

        }else{
            
            previewLayer = PreviewView(frame: view.frame, videoGravity: videoGravity)
            previewLayer.layer.cornerRadius = 0
            self.frontLayer = UIView(frame: view.frame)

            frontLayer.backgroundColor = .clear
            view.addSubview(self.frontLayer)
            view.sendSubview(toBack: frontLayer)
            
            
            view.addSubview(previewLayer)
            view.sendSubview(toBack: previewLayer)
            view.sendSubview(toBack: topCache!)

        }
        
       

        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomGesture(pinch:)))
        pinchGesture.delegate = self
        frontLayer.addGestureRecognizer(pinchGesture)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapGesture(tap:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.delegate = self
        frontLayer.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture(tap:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        frontLayer.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panBackgroundView(sender:)))
        self.frontLayer.addGestureRecognizer(pan)
        pan.delegate = self

        
        
        
		previewLayer.session = session

		// Test authorization status for Camera and Micophone

		switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
		case .authorized:

			// already authorized
			break
		case .notDetermined:

			// not yet determined
			sessionQueue.suspend()
			AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [unowned self] granted in
				if !granted {
					self.setupResult = .notAuthorized
				}
				self.sessionQueue.resume()
			})
		default:

			// already been asked. Denied access
			setupResult = .notAuthorized
		}
		sessionQueue.async { [unowned self] in
			self.configureSession()
		}
	}

    
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPinchGestureRecognizer.self) {
            beginZoomScale = zoomScale;
        }
        return true
    }
    
    @objc func panBackgroundView(sender:UIPanGestureRecognizer) {
        
        if self.frontLayer == nil {
            
            
            return
            
        }

        let touchPoint = sender.location(in: self.frontLayer!.window)
        

        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {

            if touchPoint.y - initialTouchPoint.y > 0 {

                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                let distance = touchPoint.y - initialTouchPoint.y
                let alpha = 1 -   (distance / Brain.kHauteurIphone)
               
                self.topCache.backgroundColor = UIColor.black.withAlphaComponent(alpha)
                
                if !isIphoneXFamily() {
                    
                    let cornerRadius =  10 * (distance / 100)
                    
                    self.previewLayer.layer.cornerRadius = min(cornerRadius, 10)

                }

            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.topCache.backgroundColor = UIColor.black.withAlphaComponent(0)

                })

                toCloseCamera = true
                self.dismiss(animated: true, completion: nil)

            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    
                    self.topCache.backgroundColor = UIColor.black.withAlphaComponent(1)

                    if !isIphoneXFamily() {
                        
                        
                        self.previewLayer.layer.cornerRadius = 0
                        
                    }
                    
                })
            }
        }
        
    }
    
    
    
    // MARK: ViewDidLayoutSubviews

    /// ViewDidLayoutSubviews() Implementation
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {

        layer.videoOrientation = orientation


        if isIphoneXFamily() {
            
            previewLayer.frame = CGRect(x: 0, y: 44, width: Brain.kLargeurIphone, height:  Utils.getHeightOfStory())
            previewLayer.layer.cornerRadius = 8

        }else{
            
            previewLayer.frame = self.view.bounds
            previewLayer.layer.cornerRadius = 0

        }
        
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let connection =  self.previewLayer?.videoPreviewLayer.connection  {

            let currentDevice: UIDevice = UIDevice.current

            let orientation: UIDeviceOrientation = currentDevice.orientation

            let previewLayerConnection : AVCaptureConnection = connection

            if previewLayerConnection.isVideoOrientationSupported {

                switch (orientation) {
                case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)

                    break

                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)

                    break

                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)

                    break

                case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)

                    break

                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)

                    break
                }
            }
        }
    }

    // MARK: ViewWillAppear

    /// ViewWillAppear(_ animated:) Implementation

    open override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.topCache.backgroundColor == UIColor.black.withAlphaComponent(0) {
            
            UIView.animate(withDuration: 0.4) {
                
                self.topCache.backgroundColor = UIColor.black.withAlphaComponent(1)

            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(captureSessionDidStartRunning), name: .AVCaptureSessionDidStartRunning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(captureSessionDidStopRunning),  name: .AVCaptureSessionDidStopRunning,  object: nil)
        
        // Subscribe to device rotation notifications
        
        if shouldUseDeviceOrientation {
            orientation.start()
        }
        
        // Set background audio preference
        
        setBackgroundAudioPreference()
        
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                // Begin Session
                self.session.startRunning()
                self.isSessionRunning = self.session.isRunning
                
                // Preview layer video orientation can be set only after the connection is created
                DispatchQueue.main.async {
                    self.previewLayer.videoPreviewLayer.connection?.videoOrientation = self.orientation.getPreviewLayerOrientation()
                }
                
            case .notAuthorized:
                if self.shouldPrompToAppSettings == true {
                    self.promptToAppSettings()
                } else {
                    self.cameraDelegate?.swiftyCamNotAuthorized(self)
                }
            case .configurationFailed:
                // Unknown Error
                DispatchQueue.main.async {
                    self.cameraDelegate?.swiftyCamDidFailToConfigure(self)
                }
            }
        }
    }

	// MARK: ViewDidAppear

	/// ViewDidAppear(_ animated:) Implementation
	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		
	}

	// MARK: ViewDidDisappear

	/// ViewDidDisappear(_ animated:) Implementation


    override open func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)

        
        NotificationCenter.default.removeObserver(self)

        self.callObserver.setDelegate(nil, queue: nil)
        self.callObserver = nil
        
        
        //Disble flash if it is currently enabled
        disableFlash()
        
        sessionRunning = false
        
        
        DispatchQueue.global(qos: .background).async {
           
            print("Ca va etre call?")
            // If session is running, stop the session
            if self.isSessionRunning == true {
                self.session.stopRunning()
                self.isSessionRunning = false
            }
            
            
        }
        
       
        


    }
	override open func viewDidDisappear(_ animated: Bool) {
		
        
        
        super.viewDidDisappear(animated)


	}

	// MARK: Public Functions

	/**

	Capture photo from current session

	UIImage will be returned with the SwiftyCamViewControllerDelegate function SwiftyCamDidTakePhoto(photo:)

	*/

	public func takePhoto() {

		guard let device = videoDevice else {
			return
		}


		if device.hasFlash == true && flashEnabled == true /* TODO: Add Support for Retina Flash and add front flash */ {
			changeFlashSettings(device: device, mode: .on)
			capturePhotoAsyncronously(completionHandler: { (_) in })

		} else if device.hasFlash == false && flashEnabled == true && currentCamera == .front {
			flashView = UIView(frame: view.frame)
			flashView?.alpha = 0.0
			flashView?.backgroundColor = UIColor.white
			previewLayer.addSubview(flashView!)

			UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
				self.flashView?.alpha = 1.0

			}, completion: { (_) in
				self.capturePhotoAsyncronously(completionHandler: { (success) in
					UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
						self.flashView?.alpha = 0.0
					}, completion: { (_) in
						self.flashView?.removeFromSuperview()
					})
				})
			})
		} else {
			if device.isFlashActive == true {
				changeFlashSettings(device: device, mode: .off)
			}
			capturePhotoAsyncronously(completionHandler: { (_) in })
		}
	}

	/**

	Begin recording video of current session

	SwiftyCamViewControllerDelegate function SwiftyCamDidBeginRecordingVideo() will be called

	*/

	public func startVideoRecording() {

        guard sessionRunning == true else {
            print("[SwiftyCam]: Cannot start video recoding. Capture session is not running")
            return
        }
		guard let movieFileOutput = self.movieFileOutput else {
			return
		}

		if currentCamera == .rear && flashEnabled == true {
			enableFlash()
		}

		if currentCamera == .front && flashEnabled == true {
			flashView = UIView(frame: view.frame)
			flashView?.backgroundColor = UIColor.white
			flashView?.alpha = 0.85
			previewLayer.addSubview(flashView!)
		}

        //Must be fetched before on main thread
        let previewOrientation = previewLayer.videoPreviewLayer.connection!.videoOrientation

		sessionQueue.async { [unowned self] in
			if !movieFileOutput.isRecording {
				if UIDevice.current.isMultitaskingSupported {
					self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
				}

				// Update the orientation on the movie file output video connection before starting recording.
				let movieFileOutputConnection = self.movieFileOutput?.connection(with: AVMediaType.video)


				//flip video output if front facing camera is selected
				if self.currentCamera == .front {
					movieFileOutputConnection?.isVideoMirrored = true
				}

				movieFileOutputConnection?.videoOrientation = self.orientation.getVideoOrientation() ?? previewOrientation

				// Start recording to a temporary file.
				let outputFileName = UUID().uuidString
				let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
				movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
				self.isVideoRecording = true
				DispatchQueue.main.async {
					self.cameraDelegate?.swiftyCam(self, didBeginRecordingVideo: self.currentCamera)
				}
			}
			else {
				movieFileOutput.stopRecording()
			}
		}
	}

	/**

	Stop video recording video of current session

	SwiftyCamViewControllerDelegate function SwiftyCamDidFinishRecordingVideo() will be called

	When video has finished processing, the URL to the video location will be returned by SwiftyCamDidFinishProcessingVideoAt(url:)

	*/

	public func stopVideoRecording() {
		if self.movieFileOutput?.isRecording == true {
			self.isVideoRecording = false
			movieFileOutput!.stopRecording()
			disableFlash()

			if currentCamera == .front && flashEnabled == true && flashView != nil {
				UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
					self.flashView?.alpha = 0.0
				}, completion: { (_) in
					self.flashView?.removeFromSuperview()
				})
			}
			DispatchQueue.main.async {
				self.cameraDelegate?.swiftyCam(self, didFinishRecordingVideo: self.currentCamera)
			}
		}
	}

	/**

	Switch between front and rear camera

	SwiftyCamViewControllerDelegate function SwiftyCamDidSwitchCameras(camera:  will be return the current camera selection

	*/


	public func switchCamera() {
		guard isVideoRecording != true else {
			//TODO: Look into switching camera during video recording
			print("[SwiftyCam]: Switching between cameras while recording video is not supported")
			return
		}

        guard session.isRunning == true else {
            return
        }

		switch currentCamera {
		case .front:
			currentCamera = .rear
		case .rear:
			currentCamera = .front
		}

		session.stopRunning()

		sessionQueue.async { [unowned self] in

			// remove and re-add inputs and outputs

			for input in self.session.inputs {
				self.session.removeInput(input )
			}

			self.addInputs()
			DispatchQueue.main.async {
				self.cameraDelegate?.swiftyCam(self, didSwitchCameras: self.currentCamera)
			}

			self.session.startRunning()
		}

		// If flash is enabled, disable it as the torch is needed for front facing camera
		disableFlash()
	}

	// MARK: Private Functions

	/// Configure session, add inputs and outputs

	fileprivate func configureSession() {
		guard setupResult == .success else {
			return
		}

		// Set default camera

		currentCamera = defaultCamera

		// begin configuring session

		session.beginConfiguration()
		configureVideoPreset()
		addVideoInput()
		addAudioInput()
		configureVideoOutput()
		configurePhotoOutput()

		session.commitConfiguration()
	}

	/// Add inputs after changing camera()

	fileprivate func addInputs() {
		session.beginConfiguration()
		configureVideoPreset()
		addVideoInput()
		addAudioInput()
		session.commitConfiguration()
	}


	// Front facing camera will always be set to VideoQuality.high
	// If set video quality is not supported, videoQuality variable will be set to VideoQuality.high
	/// Configure image quality preset

	fileprivate func configureVideoPreset() {
		if currentCamera == .front {
            if session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))) {
                session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))
            } else {
                session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: .high))
            }
		} else {
			if session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))) {
				session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))
			} else {
				session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: .high))
			}
		}
	}

	/// Add Video Inputs

	fileprivate func addVideoInput() {
		switch currentCamera {
		case .front:
			videoDevice = SwiftyCamViewController.deviceWithMediaType(AVMediaType.video.rawValue, preferringPosition: .front)
		case .rear:
			videoDevice = SwiftyCamViewController.deviceWithMediaType(AVMediaType.video.rawValue, preferringPosition: .back)
		}

		if let device = videoDevice {
			do {
				try device.lockForConfiguration()
				if device.isFocusModeSupported(.continuousAutoFocus) {
					device.focusMode = .continuousAutoFocus
					if device.isSmoothAutoFocusSupported {
						device.isSmoothAutoFocusEnabled = true
					}
				}

				if device.isExposureModeSupported(.continuousAutoExposure) {
					device.exposureMode = .continuousAutoExposure
				}

				if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
					device.whiteBalanceMode = .continuousAutoWhiteBalance
				}

				if device.isLowLightBoostSupported && lowLightBoost == true {
					device.automaticallyEnablesLowLightBoostWhenAvailable = true
				}

				device.unlockForConfiguration()
			} catch {
				print("[SwiftyCam]: Error locking configuration")
			}
		}

		do {
            if let videoDevice = videoDevice {
                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                if session.canAddInput(videoDeviceInput) {
                    session.addInput(videoDeviceInput)
                    self.videoDeviceInput = videoDeviceInput
                } else {
                    print("[SwiftyCam]: Could not add video device input to the session")
                    print(session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))))
                    setupResult = .configurationFailed
                    session.commitConfiguration()
                    return
                }
            }
			
		} catch {
			print("[SwiftyCam]: Could not create video device input: \(error)")
			setupResult = .configurationFailed
			return
		}
	}

	/// Add Audio Inputs

    func addAudioInput() {
        guard audioEnabled == true else {
            return
        }
        
        
        if isOnPhoneCall() {
            
            return
        }
        
        
		do {
            if let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio){
                
                if audioDeviceInput != nil {
                    if session.canAddInput(audioDeviceInput!) {
                        session.addInput(audioDeviceInput!)
                    }
                    return;
                }
                
                audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                if session.canAddInput(audioDeviceInput!) {
                    session.addInput(audioDeviceInput!)
                } else {
                    print("[SwiftyCam]: Could not add audio device input to the session")
                }
                
            } else {
                print("[SwiftyCam]: Could not find an audio device")
            }
            
		} catch {
			print("[SwiftyCam]: Could not create audio device input: \(error)")
		}
	}
    
    func removeAudioInput(){
        
        
            if let audioInput = audioDeviceInput{
                
                self.session.removeInput(audioInput)
                
            }
    }

	/// Configure Movie Output

	fileprivate func configureVideoOutput() {
		let movieFileOutput = AVCaptureMovieFileOutput()

		if self.session.canAddOutput(movieFileOutput) {
			self.session.addOutput(movieFileOutput)
			if let connection = movieFileOutput.connection(with: AVMediaType.video) {
				if connection.isVideoStabilizationSupported {
					connection.preferredVideoStabilizationMode = .auto
				}
                
                
                if movieFileOutput.availableVideoCodecTypes.contains(.hevc){
                    
                    movieFileOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: connection)
                }else{
                    
                    movieFileOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.h264], for: connection)

                }
                
			}
            
           
			self.movieFileOutput = movieFileOutput
		}
	}

	/// Configure Photo Output

	fileprivate func configurePhotoOutput() {
		let photoFileOutput = AVCaptureStillImageOutput()

		if self.session.canAddOutput(photoFileOutput) {
            photoFileOutput.outputSettings  = [AVVideoCodecKey: AVVideoCodecType.jpeg]
			self.session.addOutput(photoFileOutput)
			self.photoFileOutput = photoFileOutput
		}
	}


	/**
	Returns a UIImage from Image Data.

	- Parameter imageData: Image Data returned from capturing photo from the capture session.

	- Returns: UIImage from the image data, adjusted for proper orientation.
	*/

	fileprivate func processPhoto(_ imageData: Data) -> UIImage {
		let dataProvider = CGDataProvider(data: imageData as CFData)
		let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)

		// Set proper orientation for photo
		// If camera is currently set to front camera, flip image

		let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: self.orientation.getImageOrientation(forCamera: self.currentCamera))

		return image
	}

	fileprivate func capturePhotoAsyncronously(completionHandler: @escaping(Bool) -> ()) {

        guard sessionRunning == true else {
            print("[SwiftyCam]: Cannot take photo. Capture session is not running")
            return
        }

		if let videoConnection = photoFileOutput?.connection(with: AVMediaType.video) {

			photoFileOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
				if (sampleBuffer != nil) {
					let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
					let image = self.processPhoto(imageData!)

					// Call delegate and return new image
					DispatchQueue.main.async {
						self.cameraDelegate?.swiftyCam(self, didTake: image)
					}
					completionHandler(true)
				} else {
					completionHandler(false)
				}
			})
		} else {
			completionHandler(false)
		}
	}

	/// Handle Denied App Privacy Settings

	fileprivate func promptToAppSettings() {
		// prompt User with UIAlertView

		DispatchQueue.main.async(execute: { [unowned self] in
			let message = NSLocalizedString("Buzzy doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the camera")
			let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Alert OK button"), style: .cancel, handler: nil))
			alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .default, handler: { action in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    
                } else {
                    if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(appSettings)
                    }
                }
			}))
			self.present(alertController, animated: true, completion: nil)
		})
	}

	/**
	Returns an AVCapturePreset from VideoQuality Enumeration

	- Parameter quality: ViewQuality enum

	- Returns: String representing a AVCapturePreset
	*/

	fileprivate func videoInputPresetFromVideoQuality(quality: VideoQuality) -> String {
		switch quality {
		case .high: return AVCaptureSession.Preset.high.rawValue
		case .medium: return AVCaptureSession.Preset.medium.rawValue
		case .low: return AVCaptureSession.Preset.low.rawValue
		case .resolution352x288: return AVCaptureSession.Preset.cif352x288.rawValue
		case .resolution640x480: return AVCaptureSession.Preset.vga640x480.rawValue
		case .resolution1280x720: return AVCaptureSession.Preset.hd1280x720.rawValue
		case .resolution1920x1080: return AVCaptureSession.Preset.hd1920x1080.rawValue
		case .iframe960x540: return AVCaptureSession.Preset.iFrame960x540.rawValue
		case .iframe1280x720: return AVCaptureSession.Preset.iFrame1280x720.rawValue
		case .resolution3840x2160:
			if #available(iOS 9.0, *) {
				return AVCaptureSession.Preset.hd4K3840x2160.rawValue
			}
			else {
				print("[SwiftyCam]: Resolution 3840x2160 not supported")
				return AVCaptureSession.Preset.high.rawValue
			}
		}
	}

	/// Get Devices

	fileprivate class func deviceWithMediaType(_ mediaType: String, preferringPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
		if #available(iOS 10.0, *) {
				let avDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType(rawValue: mediaType), position: position)
				return avDevice
		} else {
				// Fallback on earlier versions
				let avDevice = AVCaptureDevice.devices(for: AVMediaType(rawValue: mediaType))
				var avDeviceNum = 0
				for device in avDevice {
						print("deviceWithMediaType Position: \(device.position.rawValue)")
						if device.position == position {
								break
						} else {
								avDeviceNum += 1
						}
				}

				return avDevice[avDeviceNum]
		}

		//return AVCaptureDevice.devices(for: AVMediaType(rawValue: mediaType), position: position).first
	}

	/// Enable or disable flash for photo

	fileprivate func changeFlashSettings(device: AVCaptureDevice, mode: AVCaptureDevice.FlashMode) {
		do {
			try device.lockForConfiguration()
			device.flashMode = mode
			device.unlockForConfiguration()
		} catch {
			print("[SwiftyCam]: \(error)")
		}
	}

	/// Enable flash

	fileprivate func enableFlash() {
		if self.isCameraTorchOn == false {
			toggleFlash()
		}
	}

	/// Disable flash

	fileprivate func disableFlash() {
		if self.isCameraTorchOn == true {
			toggleFlash()
		}
	}

	/// Toggles between enabling and disabling flash

	fileprivate func toggleFlash() {
		guard self.currentCamera == .rear else {
			// Flash is not supported for front facing camera
			return
		}

		let device = AVCaptureDevice.default(for: AVMediaType.video)
		// Check if device has a flash
		if (device?.hasTorch)! {
			do {
				try device?.lockForConfiguration()
				if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
					device?.torchMode = AVCaptureDevice.TorchMode.off
					self.isCameraTorchOn = false
				} else {
					do {
						try device?.setTorchModeOn(level: 1.0)
						self.isCameraTorchOn = true
					} catch {
						print("[SwiftyCam]: \(error)")
					}
				}
				device?.unlockForConfiguration()
			} catch {
				print("[SwiftyCam]: \(error)")
			}
		}
	}

	/// Sets whether SwiftyCam should enable background audio from other applications or sources

	fileprivate func setBackgroundAudioPreference() {
		guard allowBackgroundAudio == true else {
			return
		}
        
        guard audioEnabled == true else {
            return
        }

        
        print("is call ? \(isOnPhoneCall())")

        
        if isOnPhoneCall() {
            
            return
        }
        

        audioSessionDone = true
		do{
            print("gooo audio..")
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord,
                                                                with: [.mixWithOthers, .allowBluetooth, .allowAirPlay, .allowBluetoothA2DP])
            } else {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord,
                                                                with: [.mixWithOthers, .allowBluetooth])
            }
			session.automaticallyConfiguresApplicationAudioSession = false
		}
		catch {
			print("[SwiftyCam]: Failed to set background audio preference")

		}
	}

    /// Called when Notification Center registers session starts running

    @objc private func captureSessionDidStartRunning() {
        sessionRunning = true
        DispatchQueue.main.async {
            self.cameraDelegate?.swiftyCamSessionDidStartRunning(self)
        }
    }

    /// Called when Notification Center registers session stops running

    @objc private func captureSessionDidStopRunning() {
        sessionRunning = false
        DispatchQueue.main.async {
            self.cameraDelegate?.swiftyCamSessionDidStopRunning(self)
        }
    }
}

extension SwiftyCamViewController : SwiftyCamButtonDelegate {

	/// Sets the maximum duration of the SwiftyCamButton

	public func setMaxiumVideoDuration() -> Double {
		return maximumVideoDuration
	}

	/// Set UITapGesture to take photo

	public func buttonWasTapped() {
		takePhoto()
	}

	/// Set UILongPressGesture start to begin video

	public func buttonDidBeginLongPress() {
		startVideoRecording()
	}

	/// Set UILongPressGesture begin to begin end video


	public func buttonDidEndLongPress() {
		stopVideoRecording()
	}

	/// Called if maximum duration is reached

	public func longPressDidReachMaximumDuration() {
		stopVideoRecording()
	}
}

// MARK: AVCaptureFileOutputRecordingDelegate

extension SwiftyCamViewController : AVCaptureFileOutputRecordingDelegate {

	/// Process newly captured video and write it to temporary directory

    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let currentBackgroundRecordingID = backgroundRecordingID {
            backgroundRecordingID = UIBackgroundTaskInvalid

            if currentBackgroundRecordingID != UIBackgroundTaskInvalid {
                UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
            }
        }

        if let currentError = error {
            print("[SwiftyCam]: Movie file finishing error: \(currentError)")
            DispatchQueue.main.async {
                self.cameraDelegate?.swiftyCam(self, didFailToRecordVideo: currentError)
            }
        } else {
            //Call delegate function with the URL of the outputfile
            DispatchQueue.main.async {
                self.cameraDelegate?.swiftyCam(self, didFinishProcessVideoAt: outputFileURL)
            }
        }
    }
}

// Mark: UIGestureRecognizer Declarations

extension SwiftyCamViewController {

	/// Handle pinch gesture

	@objc fileprivate func zoomGesture(pinch: UIPinchGestureRecognizer) {

        
		do {
            
            var captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)


            if currentCamera == .front {
                
                captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)

            }
            
            
            try captureDevice!.lockForConfiguration()

            zoomScale = min(maxZoomScale, max(1.0, min(beginZoomScale * pinch.scale,  captureDevice!.activeFormat.videoMaxZoomFactor)))

            captureDevice!.videoZoomFactor = zoomScale

			// Call Delegate function with current zoom scale
			DispatchQueue.main.async {
				self.cameraDelegate?.swiftyCam(self, didChangeZoomLevel: self.zoomScale)
			}

            captureDevice!.unlockForConfiguration()

		} catch {
			print("[SwiftyCam]: Error locking configuration")
		}
        
//        guard let device = AVCaptureDevice.devices() captureDevice else { return }
//
//        func minMaxZoom(_ factor: CGFloat) -> CGFloat { return min(max(factor, 1.0), device.activeFormat.videoMaxZoomFactor) }
//
//        func update(scale factor: CGFloat) {
//            do {
//                try device.lockForConfiguration()
//                defer { device.unlockForConfiguration() }
//                device.videoZoomFactor = factor
//            } catch {
//                debugPrint(error)
//            }
//        }
//
//        let newScaleFactor = minMaxZoom(pinch.scale * zoomFactor)
//
//        switch sender.state {
//        case .began: fallthrough
//        case .changed: update(scale: newScaleFactor)
//        case .ended:
//            zoomFactor = minMaxZoom(newScaleFactor)
//            update(scale: zoomFactor)
//        default: break
//        }
	}

	/// Handle single tap gesture

   
    
	@objc fileprivate func singleTapGesture(tap: UITapGestureRecognizer) {
		guard tapToFocus == true else {
			// Ignore taps
			return
		}

		let screenSize = previewLayer!.bounds.size
		let tapPoint = tap.location(in: previewLayer!)
		let x = tapPoint.y / screenSize.height
		let y = 1.0 - tapPoint.x / screenSize.width
		let focusPoint = CGPoint(x: x, y: y)

		if let device = videoDevice {
			do {
				try device.lockForConfiguration()

				if device.isFocusPointOfInterestSupported == true {
					device.focusPointOfInterest = focusPoint
					device.focusMode = .autoFocus
				}
				device.exposurePointOfInterest = focusPoint
				device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
				device.unlockForConfiguration()
				//Call delegate function and pass in the location of the touch

				DispatchQueue.main.async {
					self.cameraDelegate?.swiftyCam(self, didFocusAtPoint: tapPoint)
				}
			}
			catch {
				// just ignore
			}
		}
	}

	/// Handle double tap gesture

	@objc fileprivate func doubleTapGesture(tap: UITapGestureRecognizer) {
		guard doubleTapCameraSwitch == true else {
			return
		}
		switchCamera()
	}

    
    public func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        
        print("BOum on recoit de la data..")
      
        if call.hasEnded == true {
            print("CXCallState: Disconnected")
        }
        
        if call.isOutgoing == true && call.hasConnected == false {
            print("CXCallState: Dialing")
            
        }
        
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("CXCallState: Incoming")
           return
        }
        
        if call.hasConnected == true && call.hasEnded == false{
            print("CXCallState: Connected")
            
            if self.audioSessionDone == true  {
                
                toCloseCamera = true
                self.dismiss(animated: true, completion: nil)

            }

        }
        
     
    }
    
    private func isOnPhoneCall() -> Bool {
        for call in CXCallObserver().calls {
            if call.hasEnded == false {
                return true
            }
        }
        return false
    }
   
	
}


