//
//  LandViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2020-02-15.
//  Copyright © 2020 Julien Levallois. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import Parse
import GoogleMaps
import MapKit


class LandViewController: UIViewController, UIGestureRecognizerDelegate, GMSMapViewDelegate {
    
    
    let titleViewController = NSLocalizedString("Mowing area", comment:"")
    
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
    
  
    var currentEditZone = 0


   
    var resultPi2 = 0.0
    var totalPi2 = 0.0
    var homePi2 = 0.0
    
  

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
        
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        self.navigationController?.navigationBar.prefersLargeTitles = false

        
        
        let camera = GMSCameraPosition.camera(withLatitude: self.centerPosition.latitude, longitude: self.centerPosition.longitude, zoom: 19)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: Brain.kHauteurIphone), camera: camera)
        mapView.mapType = .hybrid
        mapView.setMinZoom(16, maxZoom: 32)
        mapView.isMyLocationEnabled = false
        mapView.delegate = self
        view.addSubview(mapView)
        
        

        
        
        if PFUser.current()?.object(forKey: Brain.kRequestMowing) != nil {
            
            let mowingAreas = PFUser.current()?.object(forKey: Brain.kRequestMowing) as! [[String:Any]]
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
                
                


            }
            
            
        }
        
        
//        self.enterEditMode(toZone:1)
        
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
            
         
    
       }


     
        
       
    }

    
     
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
               navigationController?.navigationBar.barStyle = .black

               
               self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
               self.navigationController?.navigationBar.shadowImage = UIImage()
               self.navigationController?.navigationBar.layoutIfNeeded()
               self.navigationController?.navigationBar.prefersLargeTitles = false
        

        
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

