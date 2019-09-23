//
//  SendPublicSpaceReportVC.swift
//  Straat
//
//  Created by Global Array on 16/02/2019.
//

import UIKit
import iOSDropDown
import Photos
import UITextView_Placeholder

class SendPublicSpaceReportVC: UIViewController {

    @IBOutlet weak var MainCategView: UIView!
    @IBOutlet weak var SubCategView: UIView!
    
    @IBOutlet weak var EmergencyView: UIView!
    @IBOutlet weak var DescriptionView: UIView!
    @IBOutlet weak var DescriptionTextView: UIView!
    
    @IBOutlet weak var ImgUIView1: UIView!
    @IBOutlet weak var ImgUIView2: UIView!
    @IBOutlet weak var ImgUIView3: UIView!
    
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    
    @IBOutlet weak var emergencyNotifButton: UIButton!
    
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var mainCategDropDown: DropDown!
    @IBOutlet weak var subCategDropDown: DropDown!
    @IBOutlet weak var mainCategoryDropDown: UITextField!
    @IBOutlet weak var subCategoryDropDown: UITextField!
	
    @IBOutlet weak var reportDescription: UITextView!
    @IBOutlet weak var emergencyNotifConstraint: NSLayoutConstraint!
	@IBOutlet weak var sendReportButton: UIButton!
	
    //image view tags
    var imgViewTag : Int!
    
    // dummy data
    var sampleArr : [String] = ["main categ 1", "main categ 2", "main categ 3", "main categ 4", "main categ 5", "main categ 6"]
    var sampleArr2 : [String] = ["sub categ 1", "sub categ 2", "sub categ 3"]
    
    var mainCategory = [MainCategoryModel]()
    var mainCategoryName = [String]() // for dropdown
    var subCategory = [[SubCategoryModel]]()
    var subCategoryName = [String]() // for dropdown

    var mainCategoryId : String?
    var subCategoryId : String?
    var isUrgent : Bool = false
    var sendReportImage: Data?
    
    let reportService = ReportService()
    let mediaService = MediaService()
    
    var imageMetaData1: Dictionary <String, Any>?
    var imageMetaData2: Dictionary <String, Any>?
    var imageMetaData3: Dictionary <String, Any>?
    
    var mapViewDelegate : MapViewDelegate?
	var isMainCategValid: Bool = false
	var isSubCategValid: Bool = false
	var isReportDescriptionValid: Bool = true
	var isMainCategHasSubCateg: Bool = false
	
	var errorTitle: String? = ""
	var errorDesc: String? = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initCategories()
		self.errorTitle = NSLocalizedString("wrong-input", comment: "")
    }
    
    @IBAction func emergencyNotif(_ sender: UIButton) {
        if sender.isSelected {
            emergencyNotifButton.isSelected = false
            self.isUrgent = false
        } else {
            emergencyNotifButton.isSelected = true
            self.isUrgent = true
            let title = NSLocalizedString("emergency-notification", comment: "")
            let desc = NSLocalizedString("emergency-notif-desc", comment: "")
            defaultDialog(vc: self, title: title, message: desc)
        }
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendReport(_ sender: UIButton) {
        loadingShow(vc: self)
        
        var imageMetaDatas = [[String: Any]]()
        let uds = UserDefaults.standard

        let id = uds.string(forKey: user_id)
        let loc_add = uds.string(forKey: user_loc_address)
        let lat = uds.double(forKey: user_loc_lat)
        let long = uds.double(forKey: user_loc_long)
        let host_id = uds.string(forKey: report_host_id) ?? uds.string(forKey: user_host_id) ?? ""
        let team_id = uds.string(forKey: user_team_id)
        let reportType_id = "5a7888bb04866e4742f74955"
        
        if self.imageMetaData1 != nil {
            imageMetaDatas.append(self.imageMetaData1!)
        }
        
        if self.imageMetaData2 != nil {
            imageMetaDatas.append(self.imageMetaData2!)
        }
        
        if self.imageMetaData3 != nil {
            imageMetaDatas.append(self.imageMetaData3!)
        }
        
//        print("image meta datas: \(imageMetaDatas)")
        
        let sendReportModel = SendReportModel(
                title: "Public Space",
                description: self.reportDescription.text,
                location: loc_add,
                long: long,
                lat: lat,
                reporterId: id,
                hostId: host_id,
                mainCategoryId: self.mainCategoryId,
                subCategoryId: self.subCategoryId,
                isUrgent: self.isUrgent,
                teamId: team_id,
                reportUploadedPhotos: imageMetaDatas,
                isVehicleInvolved: false,
                vehicleInvolvedCount: 0,
                vehicleInvolvedDescription: "nil",
                isPeopleInvolved: false,
                peopleInvolvedCount: 0,
                peopleInvolvedDescription: "nil",
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
    
}



extension SendPublicSpaceReportVC : UITextFieldDelegate, UITextViewDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case mainCategoryDropDown:
            // getting main category id
            for checkMainCateg in self.mainCategory {
                if textField.text == checkMainCateg.name?.lowercased() {
                    self.mainCategoryId = checkMainCateg.id
					self.isMainCategValid = true
                    //                    print("selectedItem maincateg: \(checkMainCateg.id)")
				} else if textField.text == "Select Main Category" || textField.text == "Selecteer Hoofdcategorie" {
					self.isMainCategValid = false
					self.disableSendReportButton()
				}
            }
            
            // sub category then show sub categ dropdown
            self.subCategoryName.removeAll()
            
            for checkSubCateg in self.subCategory {
                
                for subCateg in checkSubCateg {
                    
                    if textField.text == subCateg.mainCategoryName!.lowercased() {
                        self.subCategoryName.append(subCateg.name!)
                    }
                    print("sub categ -> main categ name: \(String(describing: subCateg.mainCategoryName))")
                }
            }
            
            let showViews : [UIView] = [self.SubCategView]
            
            if self.subCategoryName.count > 0 {
                //code for appearing sub categ
				let subCategTitle = NSLocalizedString("select-sub-category", comment: "")
				self.isMainCategHasSubCateg = true
				self.isSubCategValid = false
				
                self.viewAppearance(views: showViews, isHidden: false)				
				self.subCategoryName.insert(subCategTitle, at: 0)
                self.subCategoryDropDown.loadDropdownData(data: self.subCategoryName.sorted())
                self.emergencyNotifConstraint.constant = 20
                animateLayout(view: self.view, timeInterval: 0.8)
            } else {
                self.isSubCategValid = true
				self.isMainCategHasSubCateg = false
				
                self.viewAppearance(views: showViews, isHidden: true)
                self.emergencyNotifConstraint.constant = -70
                animateLayout(view: self.view, timeInterval: 0.8)
            }
			self.checkValues()
        case subCategDropDown:
            // getting subcategory id
            for subCategory in self.subCategory {
                print("SUB_CAT_VAL\(textField.text)")
                for subCateg in subCategory {
                    if textField.text == subCateg.name {
                        self.subCategoryId = subCateg.id
						self.isSubCategValid = true
						self.checkValues()
						
                        print("selectedItem subcateg: \(String(describing: subCateg.id))" )
					} else if textField.text == "Select Sub Category" || textField.text == "Selecteer Subcategorie" {
						self.isSubCategValid = false
						disableSendReportButton()
					}
                }
                
            }
            self.checkValues()
        break
        default:
            break
        }
    }
	
	func textViewDidEndEditing(_ textView: UITextView) {
		textView.resignFirstResponder()
		switch textView {
		case self.reportDescription:
			if textView.text.isValidDescription() {
//                self.isReportDescriptionValid = true
//                self.checkValues()
			} else {
//                self.errorDesc = NSLocalizedString("invalid-report-desc", comment: "")
//                validationDialog(vc: self, title: self.errorTitle, message: self.errorDesc, buttonText: "Ok")
//
//                self.isReportDescriptionValid = false
//                self.reportDescription.becomeFirstResponder()
//                disableSendReportButton()
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
	
	func checkValues() {

		var allBool = [self.isMainCategValid, self.isSubCategValid, true]
		var numberOfTrue = 0
		var numberOfFalse = 0
		
		if isMainCategHasSubCateg {
			allBool.append(self.isSubCategValid)
		}
		
		for bools in allBool {
			
			if bools {
				numberOfTrue += 1
			} else {
				numberOfFalse += 1
			}
			
		}
		
		debugPrint("all boolean: \(allBool)")
		debugPrint("trues: \(numberOfTrue)")
		debugPrint("falses: \(numberOfFalse)")
		if numberOfFalse > 0 {
			disableSendReportButton()
			debugPrint("disable")
		} else {
			enableSendReportButton()
			debugPrint("enable")
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


// for implement functions
extension SendPublicSpaceReportVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // initialised default view
    func initView() -> Void {
        
        var views = [UIView]()
        var hideViews = [UIView]()
        
        views = [MainCategView, SubCategView, EmergencyView, DescriptionView, DescriptionTextView, ImgUIView1, ImgUIView2, ImgUIView3]

        hideViews = [SubCategView]
        
        self.setBorders(views: views)
        self.viewAppearance(views: hideViews, isHidden: true)
        self.setImageTapGestures()
        
        self.emergencyNotifConstraint.constant = -70
        userLocation.text = UserDefaults.standard.string(forKey: "user_loc_address")
		
		self.reportDescription.placeholder = "Vul hier uw teskt in"
		self.disableSendReportButton()
    }
    
    func initCategories() -> Void {
        loadingShow(vc: self)
        
        let categoryService = CategoryService()
        let uds = UserDefaults.standard
        let host_id = uds.string(forKey: report_host_id) ?? uds.string(forKey: user_host_id) ?? ""
        print("HOST_ID: \(host_id)")
        categoryService.getMainCategoryA(hostId: host_id, language: "nl") { (success, message, mainCategories) in
            if success == true {

                print("MAIN CAT LIST", mainCategories)
                
                for mainCategory in mainCategories {
                    let mainCateg : MainCategoryModel = mainCategory
                    let name = mainCateg.name!
                    
                    self.mainCategory.append(mainCategory)
                    self.mainCategoryName.append(name)
                    self.subCategory.append(mainCateg.subCategories ?? [])

                    print("MAIN CAT A", mainCateg)
                    print("MAIN CAT A -> Sub categ: ", mainCateg.subCategories!)
                }
				
				let arrangedCategories = self.arrangedCateg(categoryName: "overige")
                self.mainCategoryDropDown.loadDropdownData(data: arrangedCategories)
                loadingDismiss()
            }
        }
        
    }
	
	func arrangedCateg(categoryName: String) -> [String] {
		let mainCategTitle = NSLocalizedString("select-main-category", comment: "")
		var mainCategSorted = self.mainCategoryName.sorted().map {$0.lowercased()}
		let index = mainCategSorted.lastIndex(of: categoryName) ?? nil
		
		if index != nil {
			mainCategSorted.remove(at: index!)
			mainCategSorted.append(categoryName)
		}
		mainCategSorted.insert(mainCategTitle, at: 0)
		return mainCategSorted
	}
//    // initialise key board toolbar
//    func initKeyBoardToolBar() -> Void {
//        let kbToolBar = UIToolbar()
//        kbToolBar.sizeToFit()
//
//        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.keyBoardDismiss))
//
//        kbToolBar.setItems([doneBtn], animated: false)
//        self.reportDescription.inputAccessoryView = kbToolBar
//
//    }
//
//    // dismiss function of keyboard
//    @objc func keyBoardDismiss() -> Void {
//        view.endEditing(true)
//    }
    
//    func extractSubCategory (subCateg : SubCategoryModel , categoryName : String) {
//        print("main categ: \(categoryName) => sub category: \(String(describing: subCateg.name))")
//    }
    
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
//                    print("permission \(result)")
                }
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alert.popoverPresentationController?.sourceView = self.view
		alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.50)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // getting user selected image via photo library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        loadingShow(vc: self)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {

            self.sendReportImage = image.jpeg(.lowest)
            
            switch(self.imgViewTag) {
            case 1:
                self.mediaService.uploadPhoto(image: self.sendReportImage!, fileName: "PublicSpaceImage1") { (success, message, photoMetaData, dataObject) in
                    
                    if success {
                        self.imageMetaData1 = dataObject
                		self.imgView1.image = image
						//                        debugPrint("dataObject: \(String(describing: dataObject))")
//                        print("public_id: \(String(describing: public_id))")
                    } else {
						defaultDialog(vc: self, title: "Uploading Image", message: "Problem occured when uploading image")
                        print("upload image response: \(message)")
                    }
                    loadingDismiss()
                    
                }

                break
            case 2:
                self.mediaService.uploadPhoto(image: self.sendReportImage!, fileName: "PublicSpaceImage2") { (success, message, photoModel, dataObject) in
                    
                    if success {
                        self.imageMetaData2 = dataObject
                		self.imgView2.image = image
                        print("dataObject: \(String(describing: dataObject))")
                    } else {
						defaultDialog(vc: self, title: "Uploading Image", message: "Problem occured when uploading image")
                        print("upload image response: \(message)")
                    }
                    loadingDismiss()
                    
                }
                break
            case 3:
                self.mediaService.uploadPhoto(image: self.sendReportImage!, fileName: "PublicSpaceImage3") { (success, message, photoModel, dataObject) in
                    
                    if success {
                        self.imageMetaData3 = dataObject
                		self.imgView3.image = image
                        print("dataObject: \(String(describing: dataObject))")
                    } else {
						defaultDialog(vc: self, title: "Uploading Image", message: "Problem occured when uploading image")
                        print("upload image response: \(message)")
                    }
                    loadingDismiss()
                    
                }

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
    
    
}
