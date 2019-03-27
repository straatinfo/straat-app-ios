//
//  SendReportVC.swift
//  Straat
//
//  Created by Global Array on 10/02/2019.
//

import UIKit
import Photos
import iOSDropDown
import UITextView_Placeholder

class SendSuspiciousReportVC: UIViewController {

    // UI Views
    @IBOutlet weak var MainContainer: UIView!
    @IBOutlet weak var ChooseCategView: UIView!
    @IBOutlet weak var EmergencyView: UIView!
    @IBOutlet weak var DescriptionView: UIView!
    @IBOutlet weak var DescriptionTextView: UIView!
    @IBOutlet weak var PersonsDescriptionView: UIView!
    @IBOutlet weak var VehicleDescriptionView: UIView!
    
    @IBOutlet weak var PersonsInvolvedView: UIView!
    @IBOutlet weak var PersonsInvolvedCountView: UIView!
    @IBOutlet weak var PersonsInvolvedDecriptionView: UIView!
    
    @IBOutlet weak var VehiclesInvolvedView: UIView!
    @IBOutlet weak var VehiclesInvolvedCountView: UIView!
    @IBOutlet weak var VehiclesInvolvedDescriptionView: UIView!
    
    
    
    @IBOutlet weak var ImgUIView1: UIView!
    @IBOutlet weak var ImgUIView2: UIView!
    @IBOutlet weak var ImgUIView3: UIView!
    
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    
    @IBOutlet weak var emergencyNotifButton: UIButton!
    @IBOutlet weak var userLocation: UILabel!
    
    @IBOutlet weak var mainCategDropDown: DropDown!
    @IBOutlet weak var mainCategoryDropDown: UITextField!
    
    
    //dummy data for category
    var sampleArr : [String] = ["main categ 1", "main categ 2", "main categ 3", "main categ 4", "main categ 5", "main categ 6"]
    var numberOfPersons: [String] = []
    var numberOfVechicles: [String] = []
    
    //constraints
    @IBOutlet weak var vehiclesConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadImageConstraint: NSLayoutConstraint!
    
    //image view tags
    var imgViewTag : Int!

    @IBOutlet weak var reportDescription: UITextView!
    
    @IBOutlet weak var personsInvolvedDropDown: DropDown!
    @IBOutlet weak var personInvolvedDropDown: UITextField!
    @IBOutlet weak var personsInvolvedDescription: UITextView!
    
    @IBOutlet weak var vehiclesInvolvedDropDown: DropDown!
    @IBOutlet weak var vehicleInvolvedDropDown: UITextField!
    @IBOutlet weak var vehiclesInvolvedDescription: UITextView!
    
	@IBOutlet weak var sendReportButton: UIButton!
	
    var mainCategory = [MainCategoryModel]()
    var mainCategoryName = [String]() // for dropdown
    
    var mainCategoryId: String?
    var isUrgent: Bool = false
    var isPersonInvolved: Bool = false
    var numberofPersonInvolved: Int = 0
    var isVehicleInvolved: Bool = false
    var numberofVehicleInvolved: Int = 0
    var sendReportImage: Data?
    
    let reportService = ReportService()
    let mediaService = MediaService()
    
    var imageMetaData1: Dictionary <String, Any>?
    var imageMetaData2: Dictionary <String, Any>?
    var imageMetaData3: Dictionary <String, Any>?

    var mapViewDelegate : MapViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
//        self.initKeyBoardToolBar()
        self.initCategories()
        // Do any additional setup after loading the view.
        
        let uds = UserDefaults.standard
        let id = uds.string(forKey: user_id)
//        debugPrint("userID: \(id)")
    
    }
    
    
    @IBAction func emergencyNotifSelected(_ sender: UIButton) {

        if sender.isSelected {
            self.isUrgent = false
            emergencyNotifButton.isSelected = false
        } else {
            self.isUrgent = true
            emergencyNotifButton.isSelected = true
            let title = NSLocalizedString("emergency-notification", comment: "")
            let desc = NSLocalizedString("emergency-notif-desc", comment: "")
            defaultDialog(vc: self, title: title, message: desc)
        }
        debugPrint("isUrgent: \(String(describing: self.isUrgent))")
        
    }
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
//        dismiss(animated: true) {
//            self.mapViewDelegate?.refresh()
//        }
    }
    
    @IBAction func sendReport(_ sender: UIButton) {
        loadingShow(vc: self)
        
        var imageMetaDatas = [[String: Any]]()
        let uds = UserDefaults.standard
        
        let id = uds.string(forKey: user_id)
        let loc_add = uds.string(forKey: user_loc_address)
        let lat = uds.double(forKey: user_loc_lat)
        let long = uds.double(forKey: user_loc_long)
        let host_id = uds.string(forKey: user_host_id)
        let team_id = uds.string(forKey: user_team_id)        
        let reportType_id = "5a7888bb04866e4742f74956"
        
        if self.imageMetaData1 != nil {
            imageMetaDatas.append(self.imageMetaData1!)
        }
        
        if self.imageMetaData2 != nil {
            imageMetaDatas.append(self.imageMetaData2!)
        }
        
        if self.imageMetaData3 != nil {
            imageMetaDatas.append(self.imageMetaData3!)
        }
        
        print("image meta datas: \(imageMetaDatas)")
        
        let sendReportModel = SendReportModel(
            title: "Suspicious Situation",
            description: self.reportDescription.text,
            location: loc_add,
            long: long,
            lat: lat,
            reporterId: id,
            hostId: host_id,
            mainCategoryId: self.mainCategoryId,
            isUrgent: self.isUrgent,
            teamId: team_id,
            reportUploadedPhotos: imageMetaDatas,
            isVehicleInvolved: self.isVehicleInvolved,
            vehicleInvolvedCount: self.numberofVehicleInvolved,
            vehicleInvolvedDescription: self.vehiclesInvolvedDescription.text,
            isPeopleInvolved: self.isPersonInvolved,
            peopleInvolvedCount: self.numberofPersonInvolved,
            peopleInvolvedDescription: self.personsInvolvedDescription.text,
            reportTypeId: reportType_id)
        
        self.reportService.sendReport(reportDetails: sendReportModel) { (success, message) in
            if success {
                let alertController = UIAlertController(title: "Dank voor uw melding!", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:UIAlertAction) in

                    pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
                }))

                self.present(alertController, animated: true)
            } else {
                defaultDialog(vc: self, title: "Send Report Error", message: message)
            }
            loadingDismiss()
        }

    }
    

    @IBAction func personsInvolvedToggle(_ sender: UISwitch) {
        let personsInvolvedViews : [UIView] = [PersonsInvolvedCountView, PersonsInvolvedDecriptionView]
        if sender.isOn {
            self.isPersonInvolved = true
            self.viewAppearance(views: personsInvolvedViews, isHidden: false)
            self.vehiclesConstraint.constant = 20
        } else {
            self.isPersonInvolved = false
            self.viewAppearance(views: personsInvolvedViews, isHidden: true)
            self.vehiclesConstraint.constant = -265
        }
        animateLayout(view: self.view, timeInterval: 0.8)
        debugPrint("isperson_involved: \(String(describing: self.isPersonInvolved))")
    }
    
    @IBAction func vehiclesInvolvedToggle(_ sender: UISwitch) {

        let vehiclesInvolvedViews : [UIView] = [VehiclesInvolvedCountView, VehiclesInvolvedDescriptionView]
        
        if sender.isOn {
            self.isVehicleInvolved = true
            self.viewAppearance(views: vehiclesInvolvedViews, isHidden: false)
            self.uploadImageConstraint.constant = 320
        } else {
            self.isVehicleInvolved = false
            self.viewAppearance(views: vehiclesInvolvedViews, isHidden: true)
            self.uploadImageConstraint.constant = 20
        }
        
        animateLayout(view: self.view, timeInterval: 0.8)
        debugPrint("isperson_involved: \(String(describing: self.isVehicleInvolved))")
    }
    
}



extension SendSuspiciousReportVC : UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
            case mainCategoryDropDown:
                for checkMainCateg in self.mainCategory {
                    if textField.text == checkMainCateg.name {
                        self.mainCategoryId = checkMainCateg.id
                        print("selectedItem maincateg: \(String(describing: checkMainCateg.id))")
                    }
                }
            case personInvolvedDropDown:
                self.numberofPersonInvolved = Int(textField.text!) ?? 0
//                debugPrint("selectedItem: \(textField.text)")
            case vehicleInvolvedDropDown:
                self.numberofVehicleInvolved = Int(textField.text!) ?? 0
//                debugPrint("selectedItem: \(textField.text)")
            default:
            break
        }
    }
	
	func textViewDidEndEditing(_ textView: UITextView) {
		textView.resignFirstResponder()
		switch textView {
			case self.reportDescription:
				if textView.text.isValidDescription() {
					enableSendReportButton()
				} else {
					validationDialog(vc: self, title: "Invalid input", message: "Please check your description content", buttonText: "Ok")
					self.reportDescription.becomeFirstResponder()
					disableSendReportButton()
				}
			case self.personsInvolvedDescription:
				if self.isPersonInvolved {
					if textView.text.isValidDescription() {
						enableSendReportButton()
					} else {
						validationDialog(vc: self, title: "Invalid input", message: "Please check your description content", buttonText: "Ok")
						self.personsInvolvedDescription.becomeFirstResponder()
						disableSendReportButton()
					}
				}
			case self.vehiclesInvolvedDescription:
				if self.isVehicleInvolved {
					if textView.text.isValidDescription() {
						enableSendReportButton()
					} else {
						validationDialog(vc: self, title: "Invalid input", message: "Please check your description content", buttonText: "Ok")
						self.vehiclesInvolvedDescription.becomeFirstResponder()
						disableSendReportButton()
					}
				}
		default:
			break
		}
	}
	
	func disableSendReportButton() {
		self.sendReportButton.isEnabled = false
		self.sendReportButton.backgroundColor = UIColor.lightGray
	}
	
	func enableSendReportButton() {
		self.sendReportButton.isEnabled = true
		self.sendReportButton.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
	}
	
	func checkTextFieldValues() {
		
		if self.textFieldHasValues(tf: [self.mainCategoryDropDown]) {
			enableSendReportButton()
		} else {
			disableSendReportButton()
		}
	}
	
	func textFieldHasValues (tf: [UITextField]) -> Bool {
		
		if validateTextField(tf: tf) {
			return true
		} else {
			return false
		}
	}
    
}

// for implementing function
extension SendSuspiciousReportVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // initialised default view
    func initView() -> Void {
        var countPerson = 0
        var countVehicle = 0
        var views = [UIView]()
        var hideViews = [UIView]()

        views = [ChooseCategView, EmergencyView, DescriptionView, DescriptionTextView,
                 PersonsInvolvedView, PersonsInvolvedCountView, PersonsInvolvedDecriptionView, VehiclesInvolvedView, VehiclesInvolvedCountView, VehiclesInvolvedDescriptionView, ImgUIView1, ImgUIView2, ImgUIView3, PersonsDescriptionView, VehicleDescriptionView]
        
        hideViews = [PersonsInvolvedCountView, PersonsInvolvedDecriptionView, VehiclesInvolvedCountView, VehiclesInvolvedDescriptionView]

        self.setBorders(views: views)
        self.viewAppearance(views: hideViews, isHidden: true)
        self.setImageTapGestures()
        self.vehiclesConstraint.constant = -265
        self.uploadImageConstraint.constant = 20
        
        userLocation.text = UserDefaults.standard.string(forKey: "user_loc_address")
        
        while self.numberOfPersons.count < 100 {
            countPerson += 1
            let stringNumber = String(countPerson)
            self.numberOfPersons.append(stringNumber)
        }
        
        while self.numberOfVechicles.count < 100 {
            countVehicle += 1
            let stringNumber = String(countVehicle)
            self.numberOfVechicles.append(stringNumber)
        }

		self.reportDescription.placeholder = "Vul hier uw teskt in"
        let desc = NSLocalizedString("persons-involved-desc", comment: "")
        
		self.personsInvolvedDescription.placeholder = desc
		
        self.vehiclesInvolvedDescription.placeholder = "Voer de kenmerken van de betrokken vervoermiddelen in, zoals registratienummer, kleur, merk- en typenummer, opvallende stickers, enz."
		
        //new implementation of dropdown
        self.personInvolvedDropDown.loadDropdownData(data: self.numberOfPersons)
        self.vehicleInvolvedDropDown.loadDropdownData(data: self.numberOfVechicles)
        self.disableSendReportButton()
    }
    
    // initialise categories data
    func initCategories() -> Void {
        loadingShow(vc: self)
        
        let categoryService = CategoryService()
        categoryService.getMainCategoryB(language: "nl") { (success, message, mainCategories) in
            if success == true {
                print("MAIN CAT B", mainCategories)

                for mainCategory in mainCategories {
                    let mainCateg : MainCategoryModel = mainCategory
                    let name = mainCateg.name!
                    
                    self.mainCategory.append(mainCategory)
                    self.mainCategoryName.append(name)
                }
				
				let arrangedCategories = self.arrangedCateg(categoryName: "overige")
                self.mainCategoryDropDown.loadDropdownData(data: arrangedCategories)
                
                loadingDismiss()
            }
        }
    }
    
    // initialise key board toolbar
//    func initKeyBoardToolBar() -> Void {
//        let kbToolBar = UIToolbar()
//        kbToolBar.sizeToFit()
//        
//        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.keyBoardDismiss))
//        
//        kbToolBar.setItems([doneBtn], animated: false)
//        
////        self.reportDescription.inputAccessoryView = kbToolBar
////        self.personsInvolvedDescription.inputAccessoryView = kbToolBar
////        self.vehiclesInvolvedDescription.inputAccessoryView = kbToolBar
////        self.mainCategoryDropDown.inputAccessoryView = kbToolBar
//    }
//    
//    // dismiss function of keyboard
//    @objc func keyBoardDismiss() -> Void {
//        view.endEditing(true)
//    }
	
	func arrangedCateg(categoryName: String) -> [String] {
		var mainCategSorted = self.mainCategoryName.sorted().map {$0.lowercased()}
		let index = mainCategSorted.lastIndex(of: categoryName) ?? nil
		
		if index != nil {
			mainCategSorted.remove(at: index!)
			mainCategSorted.append(categoryName)
		}
		
		return mainCategSorted
	}
    
    // setting tap gesture recognizer for imageview
    func setImageTapGestures() -> Void {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
        
        imgView1.isUserInteractionEnabled = true
        imgView2.isUserInteractionEnabled = true
        imgView3.isUserInteractionEnabled = true
        
        imgView1.addGestureRecognizer(gesture)
        imgView2.addGestureRecognizer(gesture2)
        imgView3.addGestureRecognizer(gesture3)
        
    }
    
    // creating border for array of uiviews
    func setBorders(views : [UIView]) -> Void {
        for view in views {
            loadBorderedVIew(viewContainer: view, borderWidth: 1,
                             color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        }
    }
    
    // change appearance for array of uiviews
    func viewAppearance (views : [UIView], isHidden : Bool) -> Void {
        for view in views {
            view.isHidden = isHidden
        }
    }
    
    // import image via photo library
    @objc func importImage ( gesture : UITapGestureRecognizer) {
        
        let img = UIImagePickerController()
        let view = gesture.view!
        img.delegate = self
        
        let alert = UIAlertController(title: "Image Source", message: "Please choose where to take your image", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            //some shitty code
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                img.sourceType = UIImagePickerController.SourceType.camera
                self.present(img, animated: true, completion: nil)
                self.imgViewTag = view.tag
            } else {
                let desc = NSLocalizedString("camera-not-available", comment: "")
                defaultDialog(vc: self, title: desc, message: nil)
            }

        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            //some shitty code
            
            self.importImagePermission { (hasGranted, result) in
                
                if hasGranted {
                    img.sourceType = UIImagePickerController.SourceType.photoLibrary
                    img.allowsEditing = false
                    
                    self.present(img, animated: true, completion: nil)
                    self.imgViewTag = view.tag
                } else {
//                    defaultDialog(vc: self, title: "Permission denied", message: result)
                }
                
            }

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // getting user selected image via photo library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        loadingShow(vc: self)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            
            self.sendReportImage = image.jpegData(compressionQuality: CGFloat.leastNormalMagnitude)!
            
            switch(self.imgViewTag) {
            case 1:
                self.mediaService.uploadPhoto(image: self.sendReportImage!, fileName: "SuspiciousSituationImage1") { (success, message, photoMetaData, dataObject) in
                    
                    if success {
                        
                        self.imageMetaData1 = dataObject
//                        debugPrint("dataObject: \(String(describing: dataObject))")
//                        print("public_id: \(String(describing: public_id))")
                    } else {
                        print("upload image response: \(message)")
                    }
                    loadingDismiss()
                    
                }
                imgView1.image = image
                break;
            case 2:
                self.mediaService.uploadPhoto(image: self.sendReportImage!, fileName: "SuspiciousSituationImage2") { (success, message, photoModel, dataObject) in
                    
                    if success {
                        self.imageMetaData2 = dataObject
                        print("dataObject: \(String(describing: dataObject))")
                    } else {
                        print("upload image response: \(message)")
                    }
                    loadingDismiss()
                    
                }
                imgView2.image = image
                break;
            case 3:
                self.mediaService.uploadPhoto(image: self.sendReportImage!, fileName: "SuspiciousSituationImage3") { (success, message, photoModel, dataObject) in
                    
                    if success {
                        self.imageMetaData3 = dataObject
                        print("dataObject: \(String(describing: dataObject))")
                    } else {
                        print("upload image response: \(message)")
                    }
                    loadingDismiss()
                    
                }
                imgView3.image = image
                break
            default:
                let desc = NSLocalizedString("import-image-error", comment: "")
                defaultDialog(vc: self, title: "Import Image", message: desc)
                print("error in importing image")
                break
            }
            
        } else {
            loadingDismiss()
            print("importing img: error in uploading image")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    
    //photo library image permission
    func importImagePermission( completion: @escaping (Bool , String?) -> Void) -> Void {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
            case .authorized:
                completion(true, "Access granted")
                print("Access is granted by user")
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                        case .authorized:
                            completion(true, "Access granted")
                        
                        case .denied:
                            completion(false, "User has denied the permission.")

                        case .restricted:
                            completion(false, "User do not have access to photo album.")

                        case .notDetermined:
                            completion(false, "It is not determined until now")

                    }
                }
                
                completion(false, "It is not determined until now")
                print("It is not determined until now")
            
            case .restricted:
                // same same
                completion(false, "User do not have access to photo album.")
                print("User do not have access to photo album.")
            
            case .denied:
                // same same
                completion(false, "User has denied the permission.")
                print("User has denied the permission.")
            
            
        }
        

    }
    
    // populate main categ list data to dropdown
    func loadMainCategDropDown(mainCategList : [String]!) {
        
        mainCategDropDown.optionArray = mainCategList
        mainCategDropDown.selectedRowColor = UIColor.lightGray
        
        mainCategDropDown.didSelect { (selectedItem, index, id) in
            // insert code to identify the main category item if it has
            // sub category then show sub categ dropdown
            
            //code for appearing sub categ
            for checkMainCateg in self.mainCategory {
                if selectedItem == checkMainCateg.name {
                    self.mainCategoryId = checkMainCateg.id
                    print("selectedItem maincateg: \(String(describing: checkMainCateg.id))")
                }
            }
        }
    }
    
//    //populates persons involved count in dropdown
//    func loadPersonsInvolvedDropDown( numberOfPersons : [String]) -> Void {
//
//        self.personsInvolvedDropDown.optionArray = numberOfPersons
//        self.personsInvolvedDropDown.selectedRowColor = UIColor.lightGray
//
//        self.personsInvolvedDropDown.didSelect { (selectedItem, index, id) in
//            self.numberofPersonInvolved = index + 1
//            debugPrint("selectedItem: \(selectedItem)")
//        }
//
//    }
//
//    //populates persons involved count in dropdown
//    func loadVehiclesInvolvedDropDown( numberOfVehicles : [String]) -> Void {
//
//        self.vehiclesInvolvedDropDown.optionArray = numberOfVehicles
//        self.vehiclesInvolvedDropDown.selectedRowColor = UIColor.lightGray
//
//        self.vehiclesInvolvedDropDown.didSelect { (selectedItem, index, id) in
//            self.numberofVehicleInvolved = index + 1
//            debugPrint("selectedItem: \(selectedItem)")
//        }
//
//    }
    
}


