//
//  WhereViewController.swift
//  GoRush
//
//  Created by Julien Levallois on 2019-10-28.
//  Copyright © 2019 Julien Levallois. All rights reserved.
//

import Foundation

import UIKit
import Mapbox
import Parse
import MapboxGeocoder

class WhereViewController: UIViewController, MGLMapViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    let titleViewController = NSLocalizedString("Where", comment:"")
    
    var objects: NSMutableArray = NSMutableArray()
    
    var map:MGLMapView!
    var currentLocationButton : UIButton!
    
    
    ///Search
    var searchBackground : UIView!
    var searchIcon : UIImageView!
    var searchTextField : UITextField!
    var resetSearch : UIButton!
    
    
    ////Tableview
    var searchResults: NSMutableArray = NSMutableArray()
    var tableView: UITableView!
    var headerTableView: UIView!
    var footerTableView: UIView!
    
    var tableviewIdentifier = "MyCell"
    var tableViewHeightCell:CGFloat = 55
    var geocoder : Geocoder!
    
    var request : PFObject!
    var nextButton : UIButton!
    
    var currentAnnotation : MGLPointAnnotation!
    
    
    
    convenience init( request : PFObject)
    {
        
        self.init()
        
        self.request = request
        
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
        
        
        geocoder = Geocoder(accessToken: "pk.eyJ1IjoibGV2YWxsb2lzanVsaWVuIiwiYSI6ImNqbGZrcDdzOTB4dDgzcW1jbHRicDU2dDkifQ.a271cvQEqswRJTB8APIWyg")
        
      
        
        
        var url = URL(string: "mapbox://styles/levalloisjulien/cjlcx1jkk64bl2sn14hn73sed")
        
        if (PFConfig.current().object(forKey: Brain.kConfigMapboxUrl) != nil) {
            
            url = URL(string: PFConfig.current().object(forKey: Brain.kConfigMapboxUrl)! as! String)
        }
        
        map = MGLMapView(frame:CGRect(x:0,y:0,width:Brain.kLargeurIphone,height:Brain.kHauteurIphone), styleURL: url)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.compassView.isHidden = true
        map.showsUserLocation = false
        map.isRotateEnabled = false
        map.isPitchEnabled = false
        map.delegate = self
        map.logoView.alpha = 0
        map.attributionButton.alpha = 0
        map.tintColor = Brain.kColorMain
        view.addSubview(map)
        
        //
        //        if (PFConfig.current().object(forKey: Brain.kConfigDefaultCityLatitude) != nil) {
        //
        //
        //            self.map.setCenter(CLLocationCoordinate2DMake(PFConfig.current().object(forKey: Brain.kConfigDefaultCityLatitude)! as! CLLocationDegrees, PFConfig.current().object(forKey: Brain.kConfigDefaultCityLongitude)! as! CLLocationDegrees), zoomLevel: 12, animated: false)
        //
        //        }
        //
        
        
        
        
        self.currentAnnotation = MGLPointAnnotation()
        currentAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.7326808, longitude: -73.9843407)
        // Add marker `hello` to the map.
        map.addAnnotation(currentAnnotation)
        
        
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
            
            if geopoint != nil && error == nil {
                
                self.map.setCenter(CLLocationCoordinate2DMake(geopoint!.latitude, geopoint!.longitude), zoomLevel: 11, animated: false)
                self.currentAnnotation.coordinate = CLLocationCoordinate2D(latitude: geopoint!.latitude, longitude: geopoint!.longitude)

            }
        }
        
        
        //        if Device.IS_IPHONE_X {
        //
        //            self.closeEvent = UIButton(frame:CGRect(x: Brain.kLargeurIphone-15-40, y: 25+15, width: 40, height: 40))
        //
        //        }else{
        //
        //            self.closeEvent = UIButton(frame:CGRect(x: Brain.kLargeurIphone-15-40, y: 25, width: 40, height: 40))
        //
        //        }
        //        self.closeEvent.setBackgroundImage(UIImage(named:"btnCloseEvent"), for: .normal)
        //        self.closeEvent.addTarget(self, action: #selector(closeMap(_:)), for: .touchUpInside)
        //        self.view.addSubview(self.closeEvent)
        
        
        
        
        currentLocationButton = UIButton(frame: CGRect(x: Brain.kLargeurIphone-64, y: Brain.kHauteurIphone - 90, width: 49, height: 49))
        currentLocationButton.setBackgroundImage(UIImage(named: "currentLocationButton"), for: .normal)
        self.view.addSubview(currentLocationButton)
        self.currentLocationButton.addTarget(self, action: #selector(tapCurrentLocation(_:)), for: .touchUpInside)
        
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: self.view.frame.size.height))
        tableView.register(addressTableViewCell.self, forCellReuseIdentifier: tableviewIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(hex:"FAFAFA")
        tableView.isHidden = true
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .interactive
        view.addSubview(tableView)
        
        
        updateTableViewHeader()
        
        
        
        
        
        searchBackground = UIView(frame: CGRect(x: 20, y: 25, width: Brain.kLargeurIphone-40, height: 44))
        searchBackground.layer.cornerRadius = 22
        searchBackground.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        searchBackground.layer.applySketchShadow(color: .black, alpha: 0.1, x: 1, y: 2, blur: 8, spread: 0)
        view.addSubview(searchBackground)
        
        searchIcon = UIImageView(frame: CGRect(x: 15, y: 14, width: 15, height: 16))
        searchIcon.image = UIImage(named:"searchIcon")
        searchBackground.addSubview(searchIcon)
        
        resetSearch = UIButton(frame: CGRect(x: searchBackground.frame.size.width - 35, y: 4.5, width: 35, height: 35))
        resetSearch.setBackgroundImage(UIImage(named: "resetSearch"), for: .normal)
        resetSearch.addTarget(self, action:#selector(resetSearchAction(_:)), for:.touchUpInside)
        resetSearch.isHidden = true
        searchBackground.addSubview(resetSearch)
        
        
        searchTextField = UITextField(frame: CGRect(x: 40, y: 0, width: searchBackground.frame.size.width - 15 - 40 - 35, height: 44))
        searchTextField.tintColor = Brain.kColorMain
        searchTextField.placeholder = NSLocalizedString("Select your address...", comment: "")
        searchTextField.returnKeyType = .done
        searchTextField.delegate = self
        searchTextField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        searchTextField.textColor = UIColor(hex:"B5ABAB")
        searchTextField.addTarget(self, action: #selector(searchChanged(_:)), for: .editingChanged)
        searchBackground.addSubview(searchTextField)
        
        if isIphoneXFamily() {
            
            nextButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: Brain.kHauteurIphone - 90 - 85, width:335, height: 60))

            
        }else{
            
            nextButton = UIButton(frame: CGRect(x:(Brain.kLargeurIphone-335)/2, y: Brain.kHauteurIphone - 55 - 85, width:335, height: 60))

        }
        nextButton.layer.cornerRadius = 30;
        nextButton.backgroundColor = Brain.kColorMain
        nextButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(touchNext(_:)), for: .touchUpInside)
        nextButton.applyGradient()
        view.addSubview(nextButton)
        
        if self.searchTextField.text!.count > 0 {
            
            self.nextButton.isHidden = false
            
            
        }else{
            
            self.nextButton.isHidden = true
            self.currentAnnotation.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

        }
        
        
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
            
           
            if geopoint != nil && error == nil {
                
                let options = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: geopoint!.latitude, longitude: geopoint!.longitude))
                // Or perhaps: ReverseGeocodeOptions(location: locationManager.location)
                
                _ = self.geocoder.geocode(options) { (placemarks, attribution, error) in
                    guard let placemark = placemarks?.first else {
                        return
                    }
                
                    print("fff \(placemark)")
                    
                    
                    self.searchTextField.text = String(format: "%@", placemark)
                    
                    self.searchResults = NSMutableArray(array: placemarks!)

                    self.tableView.reloadData()
                    
                    self.resetSearch.isHidden = false

                    
                    if self.searchTextField.text!.count > 0 {
                        
                        self.nextButton.isHidden = false
                        
                        
                    }else{
                        
                        self.nextButton.isHidden = true
                        self.currentAnnotation.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

                    }
                    
                    
                }
                
            }
        }
        
        
       
        
        
        
    }
    
  
    @objc func touchNext(_ sender: UIButton){
        
        
        self.request.setObject(self.searchTextField.text!, forKey: Brain.krequestAddress)
        
        let takeVideo = CameraViewController(request:request)
        
        self.navigationController?.pushViewController(takeVideo, animated: true)

       

        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    
    
    
    @objc func tapCurrentLocation(_ sender: UIButton){
        
        self.searchTextField.text = ""
        self.searchResults = NSMutableArray()
        self.tableView.reloadData()
        self.resetSearch.isHidden = true
        
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
            
            if geopoint != nil && error == nil {
                
                self.map.setCenter(CLLocationCoordinate2DMake(geopoint!.latitude, geopoint!.longitude), zoomLevel: 11, animated: true)
                self.currentAnnotation.coordinate = CLLocationCoordinate2D(latitude: geopoint!.latitude, longitude: geopoint!.longitude)

            }
        }
        
    }
    
    
    
    @objc func closeMap(_ sender: UIButton){
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    ////Textfield
    @objc func searchChanged(_ textField: UITextField) {
        
        if searchTextField.text!.count > 0 {
            
            resetSearch.isHidden = false
            
        }else{
            
            resetSearch.isHidden = true
        }
        self.callGeocode()
     
        if self.searchTextField.text!.count > 0 && self.tableView.isHidden == true{
            
            self.nextButton.isHidden = false
            
            
        }else{
            
            self.nextButton.isHidden = true
            self.currentAnnotation.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

        }

        
    }
    
    
    @objc func resetSearchAction(_ sender: UIButton){
        
        self.searchTextField.text = ""
        resetSearch.isHidden = true
        
        if self.searchTextField.text!.count > 0 {
            
            self.nextButton.isHidden = false
            
        }else{
            
            self.nextButton.isHidden = true
            self.currentAnnotation.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            
        }
        
        self.searchResults = NSMutableArray()
        self.tableView.reloadData()
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.showTableView(show: true)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.showTableView(show: false)
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        self.showTableView(show: false)
        
        
        
        
        return true
    }
    
    
    
    /// TableView
    
    func showTableView(show:Bool){
        
        if show == true {
            
            self.tableView.alpha = 0
            self.tableView.isHidden = false
            self.nextButton.isHidden = true

            UIView.animate(withDuration: 0.4) {
                
                self.tableView.alpha = 1
            }
            
        }else{
            
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.tableView.alpha = 0
                
            }) { (_) in
                
                self.tableView.isHidden = true
                
                if self.searchTextField.text!.count > 0 {
                   
                    self.nextButton.isHidden = false

                    
                }else{
                    
                    self.nextButton.isHidden = true

                }

            }
        }
        
    }
    func updateTableViewHeader() {
        
        headerTableView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: 85))
        headerTableView.backgroundColor = UIColor(hex:"FAFAFA")
        tableView.tableHeaderView = headerTableView
        
        
        footerTableView = UIView(frame: CGRect(x: 0, y: 0, width: Brain.kLargeurIphone, height: 350 ))
        footerTableView.backgroundColor = UIColor(hex:"FAFAFA")
        tableView.tableFooterView = footerTableView
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableviewIdentifier, for: indexPath as IndexPath) as! addressTableViewCell
        
        
        cell.placemark = self.searchResults.object(at: indexPath.row) as? GeocodedPlacemark
        
        cell.address.text = cell.placemark.qualifiedName!
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.selectAdressAtIndex(row: indexPath.row)
        
    }
    
    func selectAdressAtIndex(row:Int){
        
        let placemark = self.searchResults.object(at: row) as! GeocodedPlacemark
        self.searchTextField.text = placemark.qualifiedName!
        self.showTableView(show: false)
        self.searchTextField.resignFirstResponder()
        
        if placemark.location != nil {
            
            self.map.setCenter(placemark.location!.coordinate, zoomLevel: 11, animated: true)
            self.currentAnnotation.coordinate = CLLocationCoordinate2D(latitude: placemark.location!.coordinate.latitude, longitude: placemark.location!.coordinate.longitude)

        }
        
        
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {


        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "pin")
        
        if annotationImage == nil {
            var image = UIImage(named: "pinLocation")!
            
          
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pin")
        }
        
        return annotationImage
        
        
    }

        
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableViewHeightCell
    }
    
    func callGeocode(){
        
        if self.searchTextField.text?.count == 0 {
            
            
            self.searchResults = NSMutableArray()
            self.tableView.reloadData()
            return
            
        }
        
        
        let options = ForwardGeocodeOptions(query: searchTextField.text!)
        
        // To refine the search, you can set various properties on the options object.
        options.allowedISOCountryCodes = ["CA","ES"]
        options.maximumResultCount = 20
        
        if PFUser.current()?.object(forKey: Brain.kUserLocation) != nil {
            
            options.focalLocation = CLLocation(latitude: (PFUser.current()!.object(forKey: Brain.kUserLocation) as! PFGeoPoint).latitude, longitude: (PFUser.current()!.object(forKey: Brain.kUserLocation) as! PFGeoPoint).longitude)
            
        }
        options.allowedScopes = [.address]
        
        
        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            
            
            
            self.searchResults = NSMutableArray(array: placemarks!)
            
            self.tableView.reloadData()
            
            
            
        }
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}



