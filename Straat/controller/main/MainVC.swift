//
//  Main.swift
//  Straat
//
//  Created by Global Array on 01/02/2019.
//

import UIKit
import GoogleMaps

class MainVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    var fname : String = ""
    let marker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMenu()
        navColor()
        initMapView()
//        loadInfo()
    }
    
}



// for implementing functions
extension MainVC {
    
    // for revealing side bar menu
    func createMenu() {
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
    func navColor() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.title = "Straat.info"
    }
    
    
    // loading partial user information
    func loadInfo() {
        
        self.fname = UserDefaults.standard.object(forKey: "user_fname") as! String
        
        let alert = UIAlertController(title: "Welcome to Straat.info", message: "Welcome \(self.fname)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    
    func initMapView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 52.077646, longitude: 4.315667, zoom: 16.0)
        let mv = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.93), camera: camera)
        mv.delegate = self
        self.view.addSubview(mv)
        
        customMarker (mView : mv, marker: marker, address : "sample title", lat : 52.077646, long : 4.315667)
        
        //Creates a circle shape in the center of the map
        let circle = GMSCircle()
        circle.radius = 130 // Meters
        circle.fillColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 0.5)
        circle.position = CLLocationCoordinate2D(latitude: 52.077646, longitude: 4.315667) // Your CLLocationCoordinate2D  position
        circle.strokeWidth = 1;
        circle.strokeColor = UIColor.black
        circle.map = mv; // Add it to the map
        
        
        let sendReportButton = UIButton(frame:  CGRect.init(x: 20, y: self.view.frame.size.height * 0.90, width: self.view.bounds.width * 0.90, height: 35))
        sendReportButton.backgroundColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1)
        sendReportButton.setTitle("send report", for: .normal)
        sendReportButton.tintColor = UIColor.white
        sendReportButton.addTarget(self, action: #selector(self.clickedSendReport), for: .touchUpInside)

//        self.view.addSubview(sendReportButton)
        
        
    }
    
    
    func customMarker (mView : GMSMapView, marker : GMSMarker, address : String, lat : Double, long : Double)  {
        // Creates a marker in the center of the map.
        
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = address
        marker.snippet = address
        marker.isDraggable = true
        marker.map = mView
        
    }
    
    
    //for sending report
    @objc func clickedSendReport()  {
        print("send report clicked")
    }
    
    
}

// dedicated for google maps delegates
extension MainVC : GMSMapViewDelegate {
 
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        getAddressFromLatLon(pdblLatitude: marker.position.latitude, withLongitude: marker.position.longitude, completion: { hasAdd , response in
            print("has address: \(hasAdd)")
            print("response: \(response)")
            
            if  hasAdd {
                self.customMarker (mView : mapView, marker: marker, address : response, lat : marker.position.latitude , long : marker.position.longitude)
            }
            
        })
        
    }
    
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
    
}
