//
//  Main.swift
//  Straat
//
//  Created by Global Array on 01/02/2019.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Kingfisher
import Alamofire
import AlamofireImage

class MainVC: UIViewController {
    
    // constraint for make notif and select report type initialisation
    @IBOutlet weak var makeNotifConstraint: NSLayoutConstraint!
    @IBOutlet weak var selecReportTypeConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var sendReport: UIButton!
    @IBOutlet weak var reportTypeTextField: UITextField!
    @IBOutlet weak var chatBarButtonItem: UIBarButtonItem!
    
    // for make notification ui view initialisation
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var communicationButtonItem: UIButton!
    @IBOutlet weak var communicationInfoButtonItem: UIButton!
    
    //location manager
    let locationManager = CLLocationManager()
    
    var fname : String = ""
    let marker = GMSMarker()
    let circle = GMSCircle()
    var mapCamera = GMSCameraPosition()
    var markerReports = [GMSMarker]()
    
    //coordinates
    var userLat : Double!
    var userLong : Double!
    var reportTypeArr = ["All", "Public Spaces", "Suspicious Situation"]
    var mapZoom : Float = 16.0
    
    var loadFromInit = true
	
	//user defaults
	let uds = UserDefaults.standard
    let authService = AuthService()
    let chatService = ChatService()
    let fcmNotificationName = Notification.Name(rawValue: fcm_new_message)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromInit = true
        self.createMenu()
        self.navColor()
        SocketIOManager.shared.connectSocket() // --> should only called once
        // SocketIOManager.shared.getNewMessage() // --> can add callback
        //loadInfo()
        self.initMapView(reportType: "All", reportId: nil)
        self.initView()
        self.createObservers()
        authService.userRefresh { success in
            if (success) {
                self.updateBadge()
  
            } else {
                let alert = UIAlertController(title: "Your token has expired.", message: "Please login again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }
                    
                    // go to login
                    pushToNextVC(sbName: "Initial", controllerID: "loginVC", origin: self)
                }))
                
                self.present(alert, animated: true)
            }
        }
        
        self.refreshFirebaseToken { (success) in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view)
        self.updateBadge()
        let isVolunteer = self.uds.bool(forKey: user_is_volunteer)

        self.communicationButtonItem.isHidden = isVolunteer
        self.communicationButtonItem.isEnabled = !isVolunteer
        self.communicationInfoButtonItem.isHidden = isVolunteer
        self.communicationInfoButtonItem.isEnabled = !isVolunteer
        
    }
    
    @IBAction func showSendReport(_ sender: Any) {
        loadFromInit = false
		let teamId = self.uds.string(forKey: user_team_id) ?? nil
		let isTeamApproved = self.uds.bool(forKey: user_team_is_approved)
		let isVolunteer = self.uds.bool(forKey: user_is_volunteer)
        
        let hostLong = self.uds.double(forKey: user_host_long)
        let hostLat = self.uds.double(forKey: user_host_lat)

		let title = NSLocalizedString("send-report", comment: "")
		let desc = NSLocalizedString("send-report-invalid-approval", comment: "")
		
        print("TEAM_ID: \(teamId)")
        print("TEAM_IS_APPROVED: \(isTeamApproved)")
        print("TEAM_IS_VOLUNTEER: \(isVolunteer)")
        
		if teamId != nil {

			if !isVolunteer && !isTeamApproved {
				defaultDialog(vc: self, title: title, message: desc)
				self.disableSendReportButton()
			} else {

				self.requestPermission { (hasGranted, result) in
					for markerReport in self.markerReports {
						markerReport.map?.clear()
					}
					
					if hasGranted {
						loadingDismiss()
						self.makeNotifConstraint.constant = 0
						self.sendReport.isHidden = true
						animateLayout(view: self.view, timeInterval: 0.6)
					} else {
                        self.getAddressFromLatLon(lat: hostLat, long: hostLong) { (success, location) in
                            // defaultDialog(vc: self, title: "Permission", message: result)
                            if success {
                                self.customMarker (mView : self.mapView, marker: self.marker, title: "Report ", address : location, lat : hostLat , long : hostLong)
                            } else {
                                self.customMarker (mView : self.mapView, marker: self.marker, title: "Report ", address : "Unknown location", lat : hostLat , long : hostLong)
                            }
                            self.initMapRadius(lat: hostLat, long: hostLong)
                            loadingDismiss()
                            self.makeNotifConstraint.constant = 0
                            self.sendReport.isHidden = true
                            animateLayout(view: self.view, timeInterval: 0.6)
                        }
						
					}
				}
				
			}

			
		} else {
			defaultDialog(vc: self, title: title, message: desc)
			self.disableSendReportButton()
		}

        
    }
    
    @IBAction func makeNotifDismiss(_ sender: Any) {
        self.makeNotifConstraint.constant = 800
        sendReport.isHidden = false
        
        animateLayout(view: self.view, timeInterval: 0.6)
    }
    
    @IBAction func makeNotif(_ sender: Any) {
        //saving location to local data
        let uds = UserDefaults.standard
        uds.set(location.text!, forKey: user_loc_address)
        uds.set(userLat, forKey: user_loc_lat)
        uds.set(userLong, forKey: user_loc_long)
        
        self.makeNotifConstraint.constant = 800
        self.selecReportTypeConstraint.constant = 0
        
        animateLayout(view: self.view, timeInterval: 0.6)
    }
    
    @IBAction func selectReportTypeDismiss(_ sender: UIButton) {
        self.selecReportTypeConstraint.constant = 800
        sendReport.isHidden = false
        
        animateLayout(view: self.view, timeInterval: 0.6)
    }
    
    
    @IBAction func showSuspiciousReport(_ sender: UIButton) {
        let suspiciousReportVC = self.storyboard?.instantiateViewController(withIdentifier: "SendSuspiciousReportVC") as! SendSuspiciousReportVC
        suspiciousReportVC.mapViewDelegate = self
        
    }
    
    
    @IBAction func suspiciousInfo(_ sender: UIButton) {
        let title = NSLocalizedString("suspicious-situation", comment: "")
        let desc = NSLocalizedString("suspicious-desc", comment: "")
        defaultDialog(vc: self, title: title, message: desc)
    }
    
    @IBAction func communicationInfo(_ sender: Any) {
        let title = NSLocalizedString("suspicious-situation", comment: "")
        let desc = NSLocalizedString("suspicious-desc", comment: "")
        defaultDialog(vc: self, title: title, message: desc)
    }
    @IBAction func showCommunicationReport(_ sender: Any) {
        let communicationReportVC = self.storyboard?.instantiateViewController(withIdentifier: "SendCommunicationReportVC") as! SendCommunicationReportVC
        
        communicationReportVC.mapViewDelegate = self
    }
    
    @IBAction func showPublicSpaceReport(_ sender: UIButton) {
        let publicSpacesReportVC = self.storyboard?.instantiateViewController(withIdentifier: "SendSuspiciousReportVC") as! SendPublicSpaceReportVC
        publicSpacesReportVC.mapViewDelegate = self
    }
    
    @IBAction func publicSpaceInfo(_ sender: UIButton) {
        let desc = NSLocalizedString("public-space-desc", comment: "")
        let title = NSLocalizedString("public-space-title", comment: "")
        defaultDialog(vc: self, title: title, message: desc)
    }
    

    
    @IBAction func zoomIn(_ sender: UIButton) {
        self.mapZoom += 1
        self.mapView.animate(toZoom: self.mapZoom)
    }
    
    @IBAction func zoomOut(_ sender: UIButton) {
        self.mapZoom -= 1
        self.mapView.animate(toZoom: self.mapZoom)
    }
	
}








// for implementing functions
extension MainVC : MapViewDelegate, UITextFieldDelegate {
    
    // map view delegate
    func refresh() {
        self.createMenu()
        self.navColor()
        self.initMapView(reportType: "All", reportId: nil)
    }
    
    // textfield delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("CALLING_THIS")
        
        for markerReport in self.markerReports {
            markerReport.map?.clear()
        }
        
        switch textField {
        case reportTypeTextField:
            if textField.text == "Public Spaces" {
                self.initMapView(reportType: "A", reportId: nil)
            } else if textField.text == "Suspicious Situation" {
                self.initMapView(reportType: "B", reportId: nil)
            } else {
                self.initMapView(reportType: "All", reportId: nil)
            }
        default:
            break
        }
    }
    
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
    
    func initView() -> Void {
        let kbToolBar = UIToolbar()
        kbToolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.keyBoardDismiss))
        
        kbToolBar.setItems([doneBtn], animated: false)
        self.reportTypeTextField.loadDropdownData(data: self.reportTypeArr)
        self.reportTypeTextField.inputAccessoryView = kbToolBar
    }
    
    // dismiss function of keyboard
    @objc func keyBoardDismiss() -> Void {
        view.endEditing(true)
    }
    
    // initialised map view
    func initMapView(reportType: String, reportId: String?) -> Void {
        
        let reportService = ReportService()
        let uds = UserDefaults.standard
        
        let userModel = UserModel()
        let userID = userModel.getDataFromUSD(key: user_id)
        let hostLat = userModel.host_lat ?? uds.double(forKey: host_reg_lat)
        let hostLong = userModel.host_long ?? uds.double(forKey: host_reg_long)
        let userRadius : Double = 10000
        print("HOST_COORDINATES: (\(hostLong), \(hostLat))")
        loadingShow(vc: self)
        
        self.initMapCamera(lat: hostLat, long: hostLong)
        self.initMapRadius(lat: hostLat, long: hostLong)
		
        print("user_id: \(userModel.getDataFromUSD(key: user_id))")
        print("host_lat_mapview: \(hostLat)")
        print("host_long_mapview: \(hostLong)")
        
        self.requestPermission {
            (success, string) in
        }
        
        reportService.getReportNear(reporterId: userID, lat: hostLat, long: hostLong, radius: userRadius) { (success, message, reportModel) in
            
            if success {
                for reportMap in reportModel! {
                    if reportType == "All" {
                        self.reportMarker(mView: self.mapView, reportMapModel: reportMap, reportId: reportId)
                    } else if reportType == reportMap.reportType?.code {
                        self.reportMarker(mView: self.mapView, reportMapModel: reportMap, reportId: reportId)
                    } else {
                        loadingDismiss()
                    }
                }
                print("REPORTS_LOADED")
                // self.uds.removeObject(forKey: new_sent_report)
            } else {
                print("ERROR_REPORTS_LOADED")
                let title = NSLocalizedString("fetching-near-reports", comment: "")
                let desc = NSLocalizedString("no-available-reports", comment: "")
                defaultDialog(vc: self, title: title, message: desc)
                loadingDismiss()
            }
        }
        
        
    }
    
    // init map view with custome coordinates
    func initMapViewCustom(lat: Double, long: Double, reportType: String, reportId: String?) -> Void {
        
        let reportService = ReportService()
        let uds = UserDefaults.standard
        
        let userModel = UserModel()
        let userID = userModel.getDataFromUSD(key: user_id)
        let hostLat = userModel.host_lat ?? uds.double(forKey: host_reg_lat)
        let hostLong = userModel.host_long ?? uds.double(forKey: host_reg_long)
        let userRadius : Double = 10000
        print("HOST_COORDINATES: (\(hostLong), \(hostLat))")
        loadingShow(vc: self)
        
        self.initMapCamera(lat: lat, long: lat)
        self.initMapRadius(lat: hostLat, long: hostLong)
        
        print("user_id: \(userModel.getDataFromUSD(key: user_id))")
        print("host_lat_mapview: \(hostLat)")
        print("host_long_mapview: \(hostLong)")
        
        reportService.getReportNear(reporterId: userID, lat: hostLat, long: hostLong, radius: userRadius) { (success, message, reportModel) in
            
            if success {
                for reportMap in reportModel! {
                    if reportType == "All" {
                        self.reportMarker(mView: self.mapView, reportMapModel: reportMap, reportId: reportId)
                    } else if reportType == reportMap.reportType?.code {
                        self.reportMarker(mView: self.mapView, reportMapModel: reportMap, reportId: reportId)
                    } else {
                        loadingDismiss()
                    }
                }
                print("REPORTS_LOADED")
                // self.uds.removeObject(forKey: new_sent_report)
            } else {
                print("ERROR_REPORTS_LOADED")
                let title = NSLocalizedString("fetching-near-reports", comment: "")
                let desc = NSLocalizedString("no-available-reports", comment: "")
                defaultDialog(vc: self, title: title, message: desc)
                loadingDismiss()
            }
        }
        
        
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
    
    // initialise marker dedicated for sending report
    func customMarker (mView : GMSMapView, marker : GMSMarker, title : String?, address : String, lat : Double, long : Double) -> Void {
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = title!
        marker.snippet = address
        
        marker.icon = UIImage(named: "pin-blank")
        marker.isDraggable = true
        marker.map = mView
        
        location.text = address
        userLat = lat
        userLong = long
        
    }
    
    // initialise marker dedicated for reports
    func reportMarker (mView : GMSMapView, reportMapModel : ReportModel?, reportId: String?) -> Void {
        // Creates a marker in the center of the map.
        let markerReport = GMSMarker()
        self.markerReports.append(markerReport)

        markerReport.position = CLLocationCoordinate2D(latitude: (reportMapModel?.lat)!, longitude: (reportMapModel?.long)!)
        
        markerReport.title = reportMapModel?.mainCategory?.name?.shorten(limit: 20)
        markerReport.snippet = NSLocalizedString("view-report", comment: "") // reportMapModel?.location
        
        
        switch reportMapModel?.status {
        case "NEW":
            markerReport.icon = UIImage(named: "pin-new")
        case "INPROGRESS":
            markerReport.icon = UIImage(named: "pin-inprogress")
        case "DONE":
            markerReport.icon = UIImage(named: "pin-done")
        case "EXPIRED":
            markerReport.icon = UIImage(named: "pin-expired")
        default:
            markerReport.icon = UIImage(named: "pin-done")
        }
        
        markerReport.map = mView
        // data for report view
        markerReport.reportModel = reportMapModel!
        
        location.text = reportMapModel?.location
        userLat = reportMapModel?.lat
        userLong = reportMapModel?.long
        self.setReportImage(reportMapModel: reportMapModel) { (success) in
            

            loadingDismiss()
        }
        
        let newReportId = self.uds.string(forKey: new_sent_report)
        // print("IMAGE_HAS_BEEN_LOADED: \(success) + NEW_REPORT_ID: \(newReportId) + REPORT_ID: \(reportMapModel?.id!)")
        if newReportId != nil && reportMapModel != nil {
            
            if (reportMapModel?.attachments?.count)! > 0 {
                
                let attachments = reportMapModel!.attachments![0]
                let imageUrl = attachments["secure_url"] as? String
                
                self.getReportImage(imageUrl: imageUrl!) { (success, image) in
                    
                    if success {
                        reportMapModel?.setReportImage(reportImage: image)
                    } else {
                        reportMapModel?.setReportImage(reportImage: UIImage(named: "no-photo-" + NSLocalizedString("language", comment: ""))!)
                    }
                
                    
                    if newReportId! == reportMapModel?.id! {
                        if reportMapModel?.lat != nil && reportMapModel?.long != nil {
                            self.initMapCamera(lat: reportMapModel?.lat ?? 0.0, long: reportMapModel?.long ?? 0.0)
                        }
                        self.mapView.selectedMarker = markerReport
                    }
                    
                    self.uds.removeObject(forKey: new_sent_report)
                    
                }
                
            } else {
                reportMapModel?.setReportImage(reportImage: UIImage(named: "no-photo-" + NSLocalizedString("language", comment: ""))!)
                if newReportId! == reportMapModel?.id! {
                    if reportMapModel?.lat != nil && reportMapModel?.long != nil {
                        self.initMapCamera(lat: reportMapModel?.lat ?? 0.0, long: reportMapModel?.long ?? 0.0)
                    }
                    self.mapView.selectedMarker = markerReport
                }
                
                self.uds.removeObject(forKey: new_sent_report)
                loadingDismiss()
            }
            
        }
        
        
        debugPrint("report map marker loc: \(String(describing: reportMapModel?.location))")
        
    }
    
    func setReportImage(reportMapModel : ReportModel?, completion: @escaping (Bool)->Void) -> Void {
        
        if (reportMapModel?.attachments?.count)! > 0 {
            
            let attachments = reportMapModel!.attachments![0]
            let imageUrl = attachments["secure_url"] as? String
            
            self.getReportImage(imageUrl: imageUrl!) { (success, image) in
                
                if success {
                    reportMapModel?.setReportImage(reportImage: image)
                    completion(true)
                } else {
                    reportMapModel?.setReportImage(reportImage: UIImage(named: "no-photo-" + NSLocalizedString("language", comment: ""))!)
                    completion(false)
                }
                
            }
            
        } else {
            reportMapModel?.setReportImage(reportImage: UIImage(named: "no-photo-" + NSLocalizedString("language", comment: ""))!)
            loadingDismiss()
        }
    }
    
    // fetching image url then return ui image data
    func getReportImage(imageUrl : String, completion: @escaping (Bool, UIImage?)->Void ) -> Void {
        
        Alamofire.request(URL(string: imageUrl)!).responseImage { response in
            
            if let img = response.result.value {
                print("report map image: \(img)")
                DispatchQueue.main.async {
                    completion(true, img)
                }
            } else {
                completion(false, nil)
            }
        }
    }
    
    
}




// dedicated for google maps delegates
extension MainVC : GMSMapViewDelegate, CLLocationManagerDelegate {
    
    // getting coordinatas after end dragging the GMSMarker
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        getAddressFromLatLon(lat: marker.position.latitude, long: marker.position.longitude, completion: { hasAdd , response in
            
            if  hasAdd {
                self.customMarker (mView : mapView, marker: marker, title: "Report Category", address : response, lat : marker.position.latitude , long : marker.position.longitude)
            } else {
                let desc = NSLocalizedString("unidentified-location", comment: "")
                defaultDialog(vc: self, title: "Unidentified Location", message: desc)
            }
            
        })
        
        getHostNameFromGeocode(lat: marker.position.latitude, long: marker.position.longitude) {
            hostName in
            
            let hostService = HostService()
            
            hostService.getHostByName(hostName: hostName) {
                success, host in
                
                if success && host != nil {
                    self.hostSelectionBasedOnLoc(host: host!)
                    print("HOST_DATA: ID: \(host?.id!), hostName: \(host?.hostName)")
                } else {
                    // add alert dialog here
                    let title = NSLocalizedString("error-host-not-found", comment: "")
                    let message = NSLocalizedString("error-reporting-outside-netherlands", comment: "")
                    // defaultDialog(vc: self, title: title, message: message)
                    alertDialogWithPositiveButton(vc: self, title: title, message: message, positiveBtnName: "OK") { UIAlertAction in
                        print("RELOADING")
                        pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
                    }
                    
                }
            }
        }
        
    }

    // creating custom marker
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let view = UIView()
        
        if marker != self.marker {
            view.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width * 0.70, height: 120)
            
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 6
            
            
            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 0, width: view.frame.size.width * 0.50
                , height: 70))
            lbl1.text = marker.title
            lbl1.lineBreakMode = .byWordWrapping
            lbl1.numberOfLines = 3
            view.addSubview(lbl1)
            
            let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width * 0.50, height: 20))
            
            lbl2.text = marker.reportModel?.createdAt?.toDate(format: nil)
            lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
            lbl2.lineBreakMode = .byWordWrapping
            lbl2.numberOfLines = 3
            view.addSubview(lbl2)
            
            let lbl3 = UILabel(frame: CGRect.init(x: lbl2.frame.origin.x, y: lbl2.frame.origin.y + lbl2.frame.size.height + 3, width: view.frame.size.width * 0.50, height: 20))
            
            lbl3.text = marker.snippet
            lbl3.font = UIFont.systemFont(ofSize: 14, weight: .light)
            lbl3.lineBreakMode = .byWordWrapping
            lbl3.numberOfLines = 3
            view.addSubview(lbl3)
            
            let img = UIImageView(frame: CGRect.init(x: lbl1.frame.size.width + 20, y: 0, width: view.frame.size.width * 0.40, height: view.frame.height))
            
            let imgPlaceholder = UIImage(named: "no-photo-" + NSLocalizedString("language", comment: ""))
            
            if marker.reportModel != nil {
                print("CLICKED")
                img.image = marker.reportModel!.getReportImage()
            } else {
                img.image = imgPlaceholder
            }
            
            img.contentMode = .scaleToFill
            img.layer.cornerRadius = 6
            view.addSubview(img)
        }
        
        return view
    }
    
    // present view report when tapped info windows of marker
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        var reportImages = [String]()
        print("CLICKING_MARKER")
        if marker != self.marker {
            
            if (marker.reportModel?.attachments?.count)! > 0 {
                let attachments = marker.reportModel?.attachments
                
                for reportImg in attachments! {
                    reportImages.append((reportImg["secure_url"] as? String)!)
                }
                
            }
            debugPrint("report array image append: \(reportImages)")
            
            self.saveToUserDefault(reportMapModel: marker.reportModel!, reportImages: reportImages, completion: {success in
                if success {
                    let viewReportVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewReportVC") as! ViewMapReportVC
                    viewReportVC.reportDelegate = self
                    self.present(viewReportVC, animated: true, completion: nil)
                }
            })
            
            
        }
        
    }
    
    // getting the address from coordinates
    func getAddressFromLatLon(lat: Double , long: Double, completion: @escaping ( Bool, String) -> Void ) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = lat
        let lon: Double = long
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
                if placemarks != nil {
                    debugPrint(placemarks)
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        
//                        if pm.administrativeArea != nil {
//                            addressString += pm.administrativeArea!
//                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + " "
                        }

                        if pm.subThoroughfare != nil {
                            addressString = addressString + pm.subThoroughfare! + ", "
                            print("SUB_TF: \(pm.subThoroughfare)")
                        }

                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ""
                        }
                        
                        
                        completion(true, addressString)
                        
                    }
                }
        })
        
    }
    
    // getting host name from geocode
    func getHostNameFromGeocode (lat: Double , long: Double, completion: @escaping (String) -> Void) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = lat
        let lon: Double = long
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var hostName: String = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                    completion("")
                }
                if placemarks != nil {
                    debugPrint(placemarks ?? "")
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                    
                        if pm.locality != nil {
                            hostName = pm.locality!
                        }
                        
                        
                        completion(hostName)
                        
                    }
                }
        })
    }
    
    //getting user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        getAddressFromLatLon(lat: locValue.latitude, long: locValue.longitude, completion: { hasAdd , response in
            let hostLong = self.uds.double(forKey: user_host_long)
            let hostLat = self.uds.double(forKey: user_host_lat)
            
            
            if hasAdd {
                self.initMapCamera(lat: locValue.latitude, long: locValue.longitude)
                self.customMarker (mView : self.mapView, marker: self.marker, title: "Report Category", address : response, lat : locValue.latitude , long : locValue.longitude)
                self.initMapRadius(lat: hostLat, long: hostLong)
                
                if !self.loadFromInit {
                    self.getHostNameFromGeocode(lat: locValue.latitude, long: locValue.longitude) {
                        hostName in
                        
                        let hostService = HostService()
                        
                        hostService.getHostByName(hostName: hostName) {
                            success, host in
                            
                            if success && host != nil {
                                self.hostSelectionBasedOnLoc(host: host!)
                                print("HOST_DATA: ID: \(host?.id!), hostName: \(host?.hostName)")
                            } else {
                                // add alert dialog here
                                let title = NSLocalizedString("error-host-not-found", comment: "")
                                let message = NSLocalizedString("error-reporting-outside-netherlands", comment: "")
                                // defaultDialog(vc: self, title: title, message: message)
                                alertDialogWithPositiveButton(vc: self, title: title, message: message, positiveBtnName: "OK") { UIAlertAction in
                                    print("RELOADING")
                                    pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
                                }
                                
                            }
                        }
                    }
                }
            } else {
                let desc = NSLocalizedString("unidentified-location", comment: "")
                defaultDialog(vc: self, title: "Unidentified Location", message: desc)
                
//
//                self.initMapCamera(lat: hostLat, long: hostLong)
//                self.customMarker (mView : self.mapView, marker: self.marker, title: "Report Category", address : response, lat : hostLat , long : hostLong)
//                self.initMapRadius(lat: hostLat, long: hostLong)
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
    
    func saveToUserDefault(reportMapModel : ReportModel , reportImages : [String], completion : @escaping (Bool)->Void) -> Void {
        
        let uds = UserDefaults.standard
        let fullname = reportMapModel.reporter?.firstname
        let reporterUsername = reportMapModel.reporter?.username
        
        uds.set(reportMapModel.mainCategory?.name, forKey: report_category)
        uds.set(reportMapModel.getStatus(), forKey: report_status_detail_view)
        uds.set(reportMapModel.status, forKey: report_status_value)
        uds.set(reportMapModel.location, forKey: report_address)
        uds.set(reportMapModel.lat, forKey: report_lat)
        uds.set(reportMapModel.long, forKey: report_long)
        uds.set(reportMapModel.description, forKey: report_message)
        uds.set(reportMapModel.createdAt, forKey: report_created_at)
        uds.set(reporterUsername, forKey: report_reporter_username)
        
        uds.set(reportMapModel.mainCategory?.id, forKey: report_category_id)
        uds.set(reportMapModel.mainCategory?.code, forKey: report_category_code)
        
        uds.set(reportMapModel.reportTypeCode, forKey: report_type_code)
        
        
        uds.set(fullname, forKey: report_reporter_fullname)
        uds.set(reportImages, forKey: report_images)
        uds.set(reportMapModel.reporterId, forKey: report_reporter_id)
        uds.set(reportMapModel.id, forKey: report_id)
        uds.set(reportMapModel.isPublic, forKey: report_is_public)
        
        completion(true)
    }
	
	func disableSendReportButton() {
		self.sendReport.isEnabled = false
		self.sendReport.backgroundColor = UIColor.lightGray
	}
	
	func enableSendReportButton() {
		self.sendReport.isEnabled = true
		self.sendReport.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
	}
    
    func hostSelectionBasedOnLoc (host: HostModel) -> Void {
        uds.set(host.id, forKey: report_host_id)
        uds.set(host.hostName, forKey: report_host_name)
        uds.set(host.long, forKey: report_host_long)
        uds.set(host.lat, forKey: report_host_lat)
        uds.set(host.email, forKey: report_host_email)
    }
}

extension GMSMarker {
    var reportModel : ReportModel? {
        set(reportModel) { self.userData = reportModel }
        get { return self.userData as? ReportModel}
    }
}


extension MainVC: ReportDelegate {
    func didReportUpdated (didUpdate: Bool) {
        if didUpdate {
            let parent = view.superview
            view.removeFromSuperview()
            view = nil
            parent?.addSubview(view)
        }
    }
}

extension MainVC {
    func refreshFirebaseToken (completion: @escaping(Bool) -> Void) {
        let firebaseToken = uds.string(forKey: firebase_token)
        let user = UserModel()
        let authService = AuthService()
        if let userId = user.id, let email = user.email, let fcmToken = firebaseToken {
            print("REFRESHING_FIREBASE_TOKEN: \(firebaseToken)")
            if firebaseToken != "" {
                authService.addUpdateFirebaseToken(userId: userId, email: email, firebaseToken: fcmToken, completion: completion)
            }
        }
    }
    
    func updateBadge () {
        let user = UserModel()
        self.chatService.getUnreadMessageCount(userId: user.id!) { (success, response) in
            
            let a = response!["a"].int
            let b = response!["b"].int
            let c = response!["c"].int
            let team = response!["team"].int
            
            var value = a!
            value += b!
            value += c!
            value += team!
            
            if value > 0 {
                self.chatBarButtonItem.addBadge(number: value)
            } else {
                self.chatBarButtonItem.removeBadge()
            }
            
            
        }
    }
    
    func createObservers () {
        NotificationCenter.default.addObserver(self, selector: #selector(PublicSpaceVC.getNewMessage(notification:)), name: fcmNotificationName, object: nil)
    }
    
    @objc func getNewMessage (notification: NSNotification) {
        self.updateBadge()
    }
}
