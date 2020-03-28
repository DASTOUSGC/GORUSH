//
//  MowingAreaViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-12-03.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Parse
import GoogleMaps
import MapKit
import Intercom



class MowingAreaViewController: UIViewController, UIGestureRecognizerDelegate, GMSMapViewDelegate, GrassHeightDelegate {
    
    
    
    let titleViewController = NSLocalizedString("Select your mowing area", comment:"")
    
    let kEarthRadius = 6378137.0
    let kM2toPi2 = 10.76391041671

    var centerPosition : PFGeoPoint!
    var request : PFObject!
    var service : PFObject!
    
    
    var mapView : GMSMapView!
   
    
    var totalPolyline = GMSPolyline()
    var totalCoordinates = [CLLocationCoordinate2D]()
    var totalMarkers = [GMSMarker]()
    
    
    var homePolyline = GMSPolyline()
    var homeCoordinates = [CLLocationCoordinate2D]()
    var homeMarkers = [GMSMarker]()
    
    

    var nextButton : UIButton!
    var doneButton : UIButton!
    var undoButton : UIButton!

    var currentEditZone = 0

    var totalView : UIButton!
    
    var zone1View : UIButton!
    var titleZone1 : UILabel!
    var subtitleZone1 : UILabel!
    
    var zone2View : UIButton!
    var titleZone2 : UILabel!
    var subtitleZone2 : UILabel!
      
    
    var equalLabel : UILabel!
    var minusLabel : UILabel!
    
    var resultPi2 = 0.0
    var totalPi2 = 0.0
    var homePi2 = 0.0
    
    var grassHeightLabel : UILabel!
    var grassHeight : GrassHeight!
    var currentHeighGrass = 0

    var showInformations = false
    var showInformationsDrawing = false

    convenience init( request : PFObject)
    {
        
        self.init()
        
        self.request = request
        self.centerPosition = self.request.object(forKey: Brain.kRequestCenter) as? PFGeoPoint
        
        self.service = self.request.object(forKey: Brain.kRequestService) as? PFObject
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = titleViewController
        tabBarItem.title = "";
        
        
    
        
        self.view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabBarItem.title = "";
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: self.centerPosition.latitude, longitude: self.centerPosition.longitude, zoom: 19)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone), camera: camera)
        mapView.mapType = .hybrid
        mapView.setMinZoom(16, maxZoom: 32)
        mapView.isMyLocationEnabled = false
        mapView.delegate = self
        view.addSubview(mapView)
        
        

        if isIphoneXFamily() {
           
           nextButton = UIButton(frame: CGRect(x:20, y: Brain.kHauteurIphone - 90 - 85, width:Brain.kLargeurIphone-40, height: 60))

           
        }else{
           
           nextButton = UIButton(frame: CGRect(x:20, y: Brain.kHauteurIphone - 55 - 85, width:Brain.kLargeurIphone-40, height: 60))

        }
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.applyGradient()
        nextButton.alpha = 0
        view.addSubview(nextButton)




        undoButton = UIButton(frame: CGRect(x:7, y: 5, width:70, height: 60))
        undoButton.setTitle(NSLocalizedString("Undo", comment: ""), for: .normal)
        undoButton.layer.applySketchShadow()
        undoButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        undoButton.setTitleColor(UIColor.white, for: .normal)
        undoButton.setTitleColor(UIColor.gray, for: .highlighted)
        undoButton.addTarget(self, action: #selector(touchUndo(_:)), for: .touchUpInside)
        undoButton.alpha = 0
        view.addSubview(undoButton)


        doneButton = UIButton(frame: CGRect(x: Brain.kLargeurIphone - 77, y: 5, width:70, height: 60))
        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        doneButton.layer.applySketchShadow()
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.setTitleColor(UIColor.gray, for: .highlighted)
        doneButton.addTarget(self, action: #selector(touchDone(_:)), for: .touchUpInside)
        doneButton.alpha = 0
        view.addSubview(doneButton)

       
        let widthZone = (Brain.kLargeurIphone - 230) / 2
      
        //20+20+35+35
        //115
        totalView = UIButton(frame: CGRect(x: 20, y: 24, width: 120, height: 38))
        totalView.setTitle("≅0pi²", for: .normal)
        totalView.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        totalView.setTitleColor(.white, for: .normal)
        totalView.layer.cornerRadius = 19
        totalView.applyGradient()
        view.addSubview(totalView)
        
        zone1View = UIButton(frame: CGRect(x: totalView.w() + totalView.x() + 35, y: 24, width: widthZone, height: 38))
        zone1View.layer.cornerRadius = 19
        zone1View.applyGradient()
        zone1View.addTarget(self, action: #selector(enterZone1(_:)), for: .touchUpInside)
        view.addSubview(zone1View)
        
        titleZone1 = UILabel(frame: CGRect(x:0, y: 8, width: zone1View.w(), height: 14))
        titleZone1.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleZone1.textColor = .white
        titleZone1.textAlignment = .center
        titleZone1.text = NSLocalizedString("Total", comment: "")
        zone1View.addSubview(titleZone1)
        
        subtitleZone1 = UILabel(frame: CGRect(x:0, y: 23, width: zone1View.w(), height: 8))
        subtitleZone1.font = UIFont.systemFont(ofSize: 6, weight: .semibold)
        subtitleZone1.textColor = .white
        subtitleZone1.textAlignment = .center
        subtitleZone1.text = NSLocalizedString("0pi²", comment: "")
        zone1View.addSubview(subtitleZone1)
        
        
        zone2View = UIButton(frame: CGRect(x: zone1View.w() + zone1View.x() + 35, y: 24, width: widthZone, height: 38))
        zone2View.layer.cornerRadius = 19
        zone2View.backgroundColor =  UIColor.white.withAlphaComponent(1)
        zone2View.addTarget(self, action: #selector(enterZone2(_:)), for: .touchUpInside)

        view.addSubview(zone2View)
        
        titleZone2 = UILabel(frame: CGRect(x:0, y: 8, width: zone2View.w(), height: 14))
        titleZone2.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleZone2.textColor = .black
        titleZone2.textAlignment = .center
        titleZone2.text = NSLocalizedString("Home", comment: "")
        zone2View.addSubview(titleZone2)
        
        subtitleZone2 = UILabel(frame: CGRect(x:0, y: 23, width: zone2View.w(), height: 8))
        subtitleZone2.font = UIFont.systemFont(ofSize: 6, weight: .semibold)
        subtitleZone2.textColor = .black
        subtitleZone2.textAlignment = .center
        subtitleZone2.text = NSLocalizedString("0pi²", comment: "")
        zone2View.addSubview(subtitleZone2)

        equalLabel = UILabel(frame: CGRect(x: totalView.w() + totalView.x(), y: 24, width: 35, height: 38))
        equalLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        equalLabel.textColor = .white
        equalLabel.textAlignment = .center
        equalLabel.text = NSLocalizedString("=", comment: "")
        view.addSubview(equalLabel)
        
        minusLabel = UILabel(frame: CGRect(x: zone1View.w() + zone1View.x(), y: 24, width: 35, height: 38))
        minusLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        minusLabel.textColor = .white
        minusLabel.textAlignment = .center
        minusLabel.text = NSLocalizedString("-", comment: "")
        view.addSubview(minusLabel)
        
        
        grassHeightLabel = UILabel(frame: CGRect(x: 20, y: nextButton.y() - 90, width: Brain.kLargeurIphone - 40, height: 22))
        grassHeightLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        grassHeightLabel.textColor = .white
        grassHeightLabel.alpha = 0
        grassHeightLabel.layer.applySketchShadow()
        grassHeightLabel.text = NSLocalizedString("Current grass height of your area", comment: "")
        view.addSubview(grassHeightLabel)
        
        grassHeight = GrassHeight(frame: CGRect(x: 0, y: grassHeightLabel.yBottom() + 10, width: Brain.kL, height: 38))
        grassHeight.delegate = self
        grassHeight.alpha = 0
        view.addSubview(grassHeight)
        
        
        if PFUser.current()?.object(forKey: Brain.kUserMowing) != nil {
            
            let mowingAreas = PFUser.current()?.object(forKey: Brain.kUserMowing) as! [[String:Any]]
            var indexArea = -1
            
            for i in 0..<mowingAreas.count {
                
                let mowingArea = mowingAreas[i]
                let oldCenterArray = mowingArea[Brain.kUserMowingCenterPosition] as! [Double]
                let oldCenter = PFGeoPoint(latitude: oldCenterArray[0], longitude: oldCenterArray[1])
                if centerPosition.distanceInKilometers(to: oldCenter) < 0.1 {

                    indexArea = i
                }

            }
            
            if indexArea != -1 {
                
                
               

                
               
                let mowingArea = mowingAreas[indexArea]
                
                let oldCenterArray = mowingArea[Brain.kUserMowingCenterPosition] as! [Double]
                let camera = GMSCameraPosition.camera(withLatitude: oldCenterArray[0], longitude: oldCenterArray[1], zoom: 19)
                mapView?.camera = camera
                           
                  
                  let totalCoordinatesData = mowingArea[Brain.kUserMowingCoordinatesTotal] as! [[Double]]
                  
                  self.currentEditZone = 1
                  
                  for i in 0..<totalCoordinatesData.count {
                      
                      self.totalCoordinates.append(CLLocationCoordinate2D(latitude: totalCoordinatesData[i][0], longitude: totalCoordinatesData[i][1]))
                      self.totalMarkers.append(createMarker(point: self.totalCoordinates.last!))

                  }

                  drawPolyline()
                  
                  
                  if mowingArea[Brain.kUserMowingCoordinatesHome] != nil {
                  
                      let homeCoordinatesData = mowingArea[Brain.kUserMowingCoordinatesHome] as! [[Double]]
                      self.currentEditZone = 2
                      for i in 0..<homeCoordinatesData.count {
                          
                          self.homeCoordinates.append(CLLocationCoordinate2D(latitude: homeCoordinatesData[i][0], longitude: homeCoordinatesData[i][1]))
                          self.homeMarkers.append(createMarker(point: self.homeCoordinates.last!))

                      }

                      drawPolyline()

                  }
                
                
                let indexGrass = (mowingArea[Brain.kUserMowingHeightGrass] as! Int / 1 ) - 5
                self.grassHeight.collectionView.selectItem(at: IndexPath(item: indexGrass, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                self.currentHeighGrass = Int(self.grassHeight.heights[indexGrass].replacingOccurrences(of: "″", with: ""))!

                
                

                  self.exitEditMode()


            }else{
                
                self.initEmptyMode()

            }
            
            
        }else{
            
            self.initEmptyMode()
            
            
            self.showInformations = true
            self.showInformationsDrawing = true
            
            //Popup init tuto
            let alert = UIAlertController(title: NSLocalizedString("Information", comment: ""), message: NSLocalizedString("Click on the Total button to start drawing the total area of ​​your land to be mowed.\n\nYou can include the area of ​​your home if it's in the center of the land. Indeed you can remove the area of ​​your home after", comment: ""), preferredStyle: .alert)
                       
                       
                    
                       let yesAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: { action in
                           
                       })
                       alert.addAction(yesAction)
                     
                       
                       
                       DispatchQueue.main.async {
                           self.present(alert, animated: true)
                           
                       }

        }
        
        
//        self.enterEditMode(toZone:1)
        
    }
    
    
  func updateSelectedHeight(height: String) {
    
    Intercom.logEvent(withName: "customer_selectHeightGrass", metaData: ["height":height])

    self.currentHeighGrass = Int(height.replacingOccurrences(of: "″", with: ""))!
        
  }
    
    func homeButton(disabledMode:Bool){
            
        if disabledMode == true {
            
            zone2View.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            zone2View.isEnabled = false
            minusLabel.alpha = 0.4
            titleZone2.textColor = .white
            subtitleZone2.textColor = .white

            
        }else{
            
            zone2View.backgroundColor = UIColor.white.withAlphaComponent(1)
            zone2View.isEnabled = true
            minusLabel.alpha = 1.0
            titleZone2.textColor = .black
            subtitleZone2.textColor = .black

        }
    }
    
    func initEmptyMode(){
        
        self.zone1View.pulsate100()
        self.homeButton(disabledMode: true)
        self.updateZones()
        self.grassHeight.collectionView.selectItem(at: IndexPath(item: 2, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        self.currentHeighGrass = Int(self.grassHeight.heights[2].replacingOccurrences(of: "″", with: ""))!

        
    }
    
    @objc func enterZone1(_ sender: UIButton){

        sender.pulsate()
        self.title = NSLocalizedString("Draw your total area", comment: "")
        self.enterEditMode(toZone: 1)
        
        if self.showInformationsDrawing == true {
            
            self.showInformationsDrawing = false
         
            let alert = UIAlertController(title: NSLocalizedString("Information", comment: ""), message: NSLocalizedString("Now click on the screen to add points to draw your mowing area.\n\nYou can click on Undo to delete your last point and click on Done to place your last point", comment: ""), preferredStyle: .alert)
           
             let yesAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: { action in
                 
             })
             alert.addAction(yesAction)
           
             
             
             DispatchQueue.main.async {
                 self.present(alert, animated: true)
                 
             }
            
            
        }
        
        
    }
    
    
    @objc func enterZone2(_ sender: UIButton){

        sender.pulsate()
       self.title = NSLocalizedString("Remove your home area", comment: "")
       self.enterEditMode(toZone: 2)
    
    }
       
    
    func enterEditMode(toZone:Int){
           
           currentEditZone = toZone
          
           

          UIView.animate(withDuration: 0.3, animations: {
              
              self.undoButton.alpha = 1
              self.doneButton.alpha = 1
              
              self.totalView.alpha = 0
              self.zone1View.alpha = 0
              self.zone2View.alpha = 0
              self.minusLabel.alpha = 0
              self.equalLabel.alpha = 0

              self.nextButton.alpha = 0
            self.grassHeight.alpha = 0
            self.grassHeightLabel.alpha = 0

          }) { (done) in
              
              
          }

           
           if self.currentEditZone == 1 {
               
               if self.totalMarkers.count > 0 {
                          
                          
                  self.totalMarkers.removeLast()
                  self.totalCoordinates.removeLast()
                  self.drawPolyline()
                  
                  
                  for i in 0..<self.totalMarkers.count {
                                    
                             self.totalMarkers[i].map = self.mapView

                  }
                   
                   
               }
               
               if self.totalMarkers.count > 2 {
                   
                   self.doneButton.isHidden = false

               }else{
                   
                   self.doneButton.isHidden = true
               }
           
        
        
           }else if self.currentEditZone == 2{
            
            
                if self.homeMarkers.count > 0 {
                         
                         
                 self.homeMarkers.removeLast()
                 self.homeCoordinates.removeLast()
                 self.drawPolyline()
                 
                 
                 for i in 0..<self.homeMarkers.count {
                                   
                  self.homeMarkers[i].map = self.mapView

                 }
                  
                  
                }

                if self.homeMarkers.count > 2 {
                  
                  self.doneButton.isHidden = false

                }else{
                  
                  self.doneButton.isHidden = true
                }
            
            
            
           }
           
          

          
           
           
       }
    
    
    
    
    @objc func touchDone(_ sender: UIButton){

        

        if self.currentEditZone == 1 {
            
            Intercom.logEvent(withName: "customer_drawAreaTotal")

            
            if self.totalCoordinates.count > 0  && self.totalMarkers.count > 0 {

                   totalCoordinates.append(totalCoordinates[0])
                   totalMarkers.append(createMarker(point: totalMarkers[0].position))
                   drawPolyline()
                       
                       
                self.exitEditMode()
                
                if self.showInformations == true {
                    
                    self.showInformations = false
                 
                    let alert = UIAlertController(title: NSLocalizedString("Information", comment: ""), message: NSLocalizedString("Now click on the Home button if you ever want to delete the area of ​​your home in the middle of your land", comment: ""), preferredStyle: .alert)
                   
                     
                     let yesAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: { action in
                         
                     })
                     alert.addAction(yesAction)
                   
                     
                     
                     DispatchQueue.main.async {
                         self.present(alert, animated: true)
                         
                     }
                    
                    
                }
                           
            }
        
        }else if self.currentEditZone == 2 {
            
            Intercom.logEvent(withName: "customer_drawAreaHome")

            if self.homeCoordinates.count > 0  && self.homeMarkers.count > 0 {

                     homeCoordinates.append(homeCoordinates[0])
                     homeMarkers.append(createMarker(point: homeMarkers[0].position))
                     drawPolyline()
                         
                         
                  self.exitEditMode()
                             
            }
            
            
        }
       
        
        
        
    }
    @objc func touchUndo(_ sender: UIButton){

        
        if self.currentEditZone == 1 {

            if self.totalCoordinates.count > 0  && self.totalMarkers.count > 0 {
                              
                  /// Update marker
                  self.totalMarkers.last!.map = nil
                  self.totalMarkers.removeLast()
                
                  
                  /// Update Polyline
                  self.totalCoordinates.removeLast()
                  self.totalPolyline.map = nil
                  self.drawPolyline()
                  

           }else{
               
               self.exitEditMode()
           }
    
    
            
        }else if self.currentEditZone == 2 {
            
            
            if self.homeCoordinates.count > 0  && self.homeMarkers.count > 0 {
                                         
                 /// Update marker
                 self.homeMarkers.last!.map = nil
                 self.homeMarkers.removeLast()
               
                 
                 /// Update Polyline
                 self.homeCoordinates.removeLast()
                 self.homePolyline.map = nil
                 self.drawPolyline()
                 

          }else{
              
              self.exitEditMode()
          }
            
            
            
        }

       
    }
    
    
    func exitEditMode(){
        
        
        
        
        
        
        
        if self.totalCoordinates.count > 0 {
            
            self.homeButton(disabledMode: false)

        }else{
            
            self.initEmptyMode()
            
        }
        
        
        self.currentEditZone = 0
        self.title = NSLocalizedString("Select your mowing area", comment: "")

        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.undoButton.alpha = 0
            self.doneButton.alpha = 0
            
            self.totalView.alpha = 1
            self.zone1View.alpha = 1
            self.zone2View.alpha = 1
            self.minusLabel.alpha = 1
            self.equalLabel.alpha = 1

            
        }) { (done) in
            
            
        }
        ///
        for i in 0..<self.totalMarkers.count {
            
            self.totalMarkers[i].map = nil

        }
        
        for i in 0..<self.homeMarkers.count {
            
            self.homeMarkers[i].map = nil

        }
        
        
        updateZones()
    }
    
    
    func updateZones(){
        
        
        
        totalPi2 = 0.0
        homePi2 = 0.0
        resultPi2 = 0.0

        if self.totalCoordinates.count > 2 {
            
            totalPi2 = regionArea(locations: self.totalCoordinates)
        }
        
        if self.homeCoordinates.count > 2 {
                   
            homePi2 = regionArea(locations: self.homeCoordinates)

        
        }
        
        if resultPi2 > totalPi2 {
            
            resultPi2 = totalPi2
            
        }
        
        resultPi2 = totalPi2 - homePi2
        
        
        subtitleZone2.text = String(format: NSLocalizedString("%dpi²", comment: ""), Int(homePi2))
        subtitleZone1.text = String(format: NSLocalizedString("%dpi²", comment: ""), Int(totalPi2))
        totalView.setTitle(String(format: NSLocalizedString("≅%dpi²", comment: ""), Int(resultPi2)), for: .normal)
        
        
        if totalPi2 > 0 {
            
            self.nextButton.alpha = 1
            self.grassHeight.alpha = 1
            self.grassHeightLabel.alpha = 1

        }else{
            
            self.nextButton.alpha = 0
            self.grassHeight.alpha = 0
            self.grassHeightLabel.alpha = 0


        }

    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        
        if currentEditZone == 0 {
           
            return
        
        }else if currentEditZone == 1 {
            
            totalCoordinates.append(coordinate)
            totalMarkers.append(createMarker(point: coordinate))
            drawPolyline()
      
        }else if currentEditZone == 2 {
            
            homeCoordinates.append(coordinate)
            homeMarkers.append(createMarker(point: coordinate))
            drawPolyline()
        }
        
        
     
    }
  
    func createMarker(point: CLLocationCoordinate2D) -> GMSMarker{
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
       
        if currentEditZone == 1 {

            marker.icon =  UIImage(named: "pin")

            
        }else if currentEditZone == 2 {
            
            marker.icon =  UIImage(named: "pinWhite")

        }
        
        marker.map = mapView
        

        return marker
    }
    

    func drawPolyline(){
        
      
        
        if currentEditZone == 1 {

            let path = GMSMutablePath()
                  for i in 0..<self.totalCoordinates.count {

                      let coordinate = totalCoordinates[i]
                      path.add(coordinate)

                  }
                  
                 
            totalPolyline.map = nil
            totalPolyline = GMSPolyline(path: path)


            totalPolyline.strokeColor = Brain.kColorMain
            totalPolyline.strokeWidth = 6.0
            totalPolyline.map = mapView

            
            if self.totalMarkers.count > 2 {
                                 
                 self.doneButton.isHidden = false

             }else{
                 
                 self.doneButton.isHidden = true
             }
    
           
       }else if currentEditZone == 2 {
           
            
            let path = GMSMutablePath()
                  for i in 0..<self.homeCoordinates.count {

                      let coordinate = homeCoordinates[i]
                      path.add(coordinate)

                  }
                  
                 
            homePolyline.map = nil
            homePolyline = GMSPolyline(path: path)


            homePolyline.strokeColor = .white
            homePolyline.strokeWidth = 4.0
            homePolyline.map = mapView
            
            
            if self.homeMarkers.count > 2 {
                         
                 self.doneButton.isHidden = false

             }else{
                 
                 self.doneButton.isHidden = true
             }
    
       }


     
        
       
    }

    
     
    
    
    
    
    
    
    @objc func touchNext(_ sender: UIButton){
  
        
        
        var mowingData = [String:Any]()
         
         mowingData[Brain.kUserMowingCenterPosition] = [self.centerPosition.latitude,self.centerPosition.longitude]

         if self.totalCoordinates.count > 0 {

             
             var totalCoordinatesArray = [[Double]]()
             for i in 0..<self.totalCoordinates.count {
                 
                 totalCoordinatesArray.append([self.totalCoordinates[i].latitude,self.totalCoordinates[i].longitude])
             }
            mowingData[Brain.kUserMowingCoordinatesTotal] = totalCoordinatesArray
        }

        if self.homeCoordinates.count > 0 {

             var totalCoordinatesArray = [[Double]]()
             for i in 0..<self.homeCoordinates.count {
               
               totalCoordinatesArray.append([self.homeCoordinates[i].latitude,self.homeCoordinates[i].longitude])
             }
             mowingData[Brain.kUserMowingCoordinatesHome] = totalCoordinatesArray
        }
         
         
        
        if self.resultPi2 > 0 {
            
            mowingData[Brain.kUserMowingAreaResult] = Int(self.resultPi2)

        }
        
        if self.totalPi2 > 0 {

              mowingData[Brain.kUserMowingAreaTotal] = Int(self.totalPi2)

        }
        
        if self.homePi2 > 0 {

            mowingData[Brain.kUserMowingAreaHome] = Int(self.homePi2)

        }
        
        mowingData[Brain.kUserMowingHeightGrass] = self.currentHeighGrass
        
        
        // On save le terrain du user
        if PFUser.current()?.object(forKey: Brain.kUserMowing) != nil {
            
            
            var mowingAreas = PFUser.current()?.object(forKey: Brain.kUserMowing) as! [[String:Any]]
            var indexArea = -1
            
            for i in 0..<mowingAreas.count {
                
                let mowingArea = mowingAreas[i]
                let oldCenterArray = mowingArea[Brain.kUserMowingCenterPosition] as! [Double]
                let oldCenter = PFGeoPoint(latitude: oldCenterArray[0], longitude: oldCenterArray[1])
                if centerPosition.distanceInKilometers(to: oldCenter) < 0.1 {

                    indexArea = i
                }

            }
            
            if indexArea != -1 {
                
                mowingAreas.remove(at: indexArea)
            }
            
            mowingAreas.append(mowingData)
            PFUser.current()?.setObject(mowingAreas, forKey: Brain.kUserMowing)
            PFUser.current()?.saveInBackground()
                
        }else{
            
              PFUser.current()?.setObject([mowingData], forKey: Brain.kUserMowing)
              PFUser.current()?.saveInBackground()
               
        }
       
        
        //Area & grass height
        self.request.setObject(mowingData, forKey: Brain.kRequestMowing)
        self.request.setObject(self.currentHeighGrass, forKey: Brain.kRequestMowingHeightGrass)

        
        //Price calcul
        let surface = mowingData[Brain.kUserMowingAreaResult] as! Int
       
        var fixedPrice = Double(0)
        if self.service.object(forKey: Brain.kServiceFixedPrice) != nil {
            
            fixedPrice =  Double(self.service.object(forKey: Brain.kServiceFixedPrice) as! Int)
        }
        
        
        var variablePrice = Double(0)
        if self.service.object(forKey: Brain.kServiceVariablePrice) != nil {
            
            variablePrice = Double(surface) * Double(truncating: self.service.object(forKey: Brain.kServiceVariablePrice) as! NSNumber)
        }
        
        var price = fixedPrice + variablePrice
       
        //Grass height factor
        if self.service.object(forKey: Brain.kServicePercentFactor) != nil {
            
            let percentByGrassHeight = Double(truncating: self.service.object(forKey: Brain.kServicePercentFactor) as! NSNumber)
            let percent = Double(self.service.object(forKey: Brain.kServicePercentFactor) as! Int - 5) * percentByGrassHeight
            price = price + (price * percent/100)
        }
      

        //Worker price
        self.request.setObject(price.rounded(toPlaces: 2), forKey: Brain.kRequestPriceWorker)
        price = price + (price * Double(self.service.object(forKey: Brain.kServiceFee) as! Int) / 100)

        //Customer price
        self.request.setObject(price.rounded(toPlaces: 2), forKey: Brain.kRequestPriceCustomer)
        self.request.setObject(surface, forKey: Brain.kRequestSurface)

    
        let options = OptionsMowingViewController(request:self.request)
        self.navigationController?.pushViewController(options, animated: true)
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barStyle = .black

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.nextButton.loadingIndicator(false)

        Intercom.logEvent(withName: "customer_openMowingAreaView")

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
    
    
    
    @objc func closeMap(_ sender: UIButton){
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    // CLLocationCoordinate2D uses degrees but we need radians
    func radians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }

    func regionArea(locations: [CLLocationCoordinate2D]) -> Double {

        guard locations.count > 2 else { return 0 }
        var area = 0.0

        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]

            area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
        }

        area = -(area * kEarthRadius * kEarthRadius / 2)

        return max(area, -area) * kM2toPi2 // In order not to worry about is polygon clockwise or counterclockwise defined.
    }
    
    
}



extension UIButton {

    func pulsate() {

        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0

        layer.add(pulse, forKey: "pulse")
    }
    
    func pulsate100() {

        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.97
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1000
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0

        layer.add(pulse, forKey: "pulse")
    }
    
    func stopAnimations(){
        
        
        layer.removeAllAnimations()
        
    }

    func flash() {

        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3

        layer.add(flash, forKey: nil)
    }


    func shake() {

        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true

        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)

        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)

        shake.fromValue = fromValue
        shake.toValue = toValue

        layer.add(shake, forKey: "position")
    }
}
