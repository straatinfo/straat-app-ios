//
//  Main.swift
//  Straat
//
//  Created by Global Array on 01/02/2019.
//

import UIKit
import GoogleMaps
import CoreLocation

class MainVC: UIViewController {

    // constraint for make notif and select report type initialisation
    @IBOutlet weak var makeNotifConstraint: NSLayoutConstraint!
    @IBOutlet weak var selecReportTypeConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var sendReport: UIButton!

    
    // for make notification ui view initialisation
    @IBOutlet weak var location: UILabel!
    
    
    //location manager
    let locationManager = CLLocationManager()
    
    var fname : String = ""
    let marker = GMSMarker()
    let circle = GMSCircle()
    var mapCamera = GMSCameraPosition()
    
    //coordinates
    var userLat : Double!
    var userLong : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMenu()
        navColor()
        initMapView()
        //loadInfo()
    }
    
    @IBAction func showSendReport(_ sender: Any) {
        self.requestPermission { (hasGranted, result) in
            
            if hasGranted {
                
                self.makeNotifConstraint.constant = 0
                self.sendReport.isHidden = true
                animateLayout(view: self.view, timeInterval: 0.6)
                
            } else {
                
                defaultDialog(vc: self, title: "Permission", message: result)
                self.customMarker (mView : self.mapView, marker: self.marker, address : "initial address", lat : 52.077646 , long : 4.315667)
                
            }
            
        }
        
    }
    
    @IBAction func makeNotifDismiss(_ sender: Any) {
        self.makeNotifConstraint.constant = 400
        sendReport.isHidden = false
        
        animateLayout(view: self.view, timeInterval: 0.6)
    }
    
    @IBAction func makeNotif(_ sender: Any) {
        //saving location to local data
        let uds = UserDefaults.standard
        uds.set(location.text!, forKey: "user_loc_address")
        uds.set(userLat, forKey: "user_loc_lat")
        uds.set(userLong, forKey: "user_loc_long")

        self.makeNotifConstraint.constant = 400
        self.selecReportTypeConstraint.constant = 0
        
        animateLayout(view: self.view, timeInterval: 0.6)
    }
    
    @IBAction func selectReportTypeDismiss(_ sender: UIButton) {
        self.selecReportTypeConstraint.constant = 400
        sendReport.isHidden = false
        
        animateLayout(view: self.view, timeInterval: 0.6)
    }
}



// for implementing functions
extension MainVC  {
    
    // for revealing side bar menu
    func createMenu() -> Void {
        if revealViewController() != nil {
            
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = UIScreen.main.bounds.size.width - 100
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        } else {
            print("problem in SWRVC")
        }
    }
    
    // setting navigation bar colors
    func navColor() -> Void {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.title = "Straat.info"
    }
    
    
    // loading partial user information
    func loadInfo() -> Void {
        
        self.fname = UserDefaults.standard.object(forKey: "user_fname") as! String
        
        let alert = UIAlertController(title: "Welcome to Straat.info", message: "Welcome \(self.fname)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    
    func initMapView() -> Void {
        
        self.initMapCamera(lat: 52.077646, long: 4.315667)
        self.initMapRadius(lat: 52.077646, long: 4.315667)
        
    }
    
    //Creates a camera position that will focus on the indicated coordinate
    func initMapCamera(lat : Double, long : Double) -> Void {
        mapCamera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16.0)
        mapView.camera = mapCamera
        mapView.delegate = self
    }
    
    //Creates a circle shape in the center of the map
    func initMapRadius(lat : Double, long : Double) -> Void {
    
        circle.radius = 130 // Meters
        circle.fillColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 0.5)
        circle.position = CLLocationCoordinate2D(latitude: lat, longitude: long) // Your CLLocationCoordinate2D  position
        circle.strokeWidth = 1;
        circle.strokeColor = UIColor.black
        circle.map = mapView; // Add it to the map
    }
    
    
    func customMarker (mView : GMSMapView, marker : GMSMarker, address : String, lat : Double, long : Double) -> Void {
        // Creates a marker in the center of the map.        
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = address
        marker.snippet = address
        marker.isDraggable = true
        marker.map = mView
        
        location.text = address
        userLat = lat
        userLong = long
        
    }
    
}

// dedicated for google maps delegates
extension MainVC : GMSMapViewDelegate, CLLocationManagerDelegate {
 
    // getting coordinatas after end dragging the GMSMarker
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        getAddressFromLatLon(pdblLatitude: marker.position.latitude, withLongitude: marker.position.longitude, completion: { hasAdd , response in
            print("has address: \(hasAdd)")
            print("response: \(response)")
            
            if  hasAdd {
                self.customMarker (mView : mapView, marker: marker, address : response, lat : marker.position.latitude , long : marker.position.longitude)
            } else {
                defaultDialog(vc: self, title: "Unidentified Location", message: "This location is unindentified")
            }
            
        })
        
    }
    
    // creating custom marker
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width * 0.70, height: 100))
        
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 0, width: view.frame.size.width * 0.50
            , height: 70))
        lbl1.text = "Report Category"
        lbl1.lineBreakMode = .byWordWrapping
        lbl1.numberOfLines = 3
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width * 0.50, height: 20))
        
        lbl2.text = marker.snippet
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl2.lineBreakMode = .byWordWrapping
        lbl2.numberOfLines = 3
        view.addSubview(lbl2)
        
        let img = UIImageView(frame: CGRect.init(x: lbl1.frame.size.width + 20, y: 0, width: view.frame.size.width * 0.40, height: view.frame.height))
        
        img.image = UIImage(named: "AppIcon")
        img.contentMode = .scaleToFill
        img.layer.cornerRadius = 6
        img.layer.borderColor = UIColor.init(red: 200 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1).cgColor
        img.layer.borderWidth = 2
        view.addSubview(img)
        
        return view
    }
    
    // getting the address from coordinates
    func getAddressFromLatLon(pdblLatitude: Double , withLongitude pdblLongitude: Double, completion: @escaping ( Bool, String) -> Void ) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = pdblLatitude
        //21.228124
        let lon: Double = pdblLongitude
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var addressString : String = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                    completion(false , "reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    completion(true, addressString)
                    
                }
        })
        
    }
    
    //getting user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        getAddressFromLatLon(pdblLatitude: locValue.latitude, withLongitude: locValue.longitude, completion: { hasAdd , response in
            print("has address: \(hasAdd)")
            print("response: \(response)")
            
            if  hasAdd {
                self.initMapCamera(lat: locValue.latitude, long: locValue.longitude)
                self.customMarker (mView : self.mapView, marker: self.marker, address : response, lat : locValue.latitude , long : locValue.longitude)
                self.initMapRadius(lat: locValue.latitude, long: locValue.longitude)
            } else {
                defaultDialog(vc: self, title: "Unidentified Location", message: "Your location is unindentified")
            }
            
            self.locationManager.stopUpdatingLocation()
            
        })
    }
    
    // permission for getting user's location
    func requestPermission( completion : @escaping ( Bool, String? ) -> Void ) -> Void {
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()

                    completion(true, "granted")
                    print("granted")
                case .notDetermined:

                    self.locationManager.requestAlwaysAuthorization()
                    self.locationManager.requestWhenInUseAuthorization()
                    completion(false, "User not determined")
                    print("not determined")
                case .restricted:
                    completion(false, "Restricted")
                    print("restricted")
                case .denied:
                    completion(false, "Permission denied")
                    print("denied")
            }
         

        } else {
            completion(false, "Location not enabled")
            print("Location service not enabled")
        }
        
    }
    
    
    
}
