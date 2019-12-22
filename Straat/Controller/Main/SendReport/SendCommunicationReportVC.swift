//
//  SendCommunicationReportVC.swift
//  Straat
//
//  Created by John Higgins M. Avila on 06/12/2019.
//

import UIKit
import iOSDropDown
import Photos
import UITextView_Placeholder

class SendCommunicationReportVC: UIViewController {
	
	@IBOutlet weak var mainCategoryDropDown: DropDown!
	@IBOutlet weak var emergencyNotif: UISwitch!
	@IBOutlet weak var showInMap: UISwitch!
	@IBOutlet weak var message: UITextView!
	@IBOutlet weak var img1: UIImageView!
	@IBOutlet weak var img2: UIImageView!
	@IBOutlet weak var img3: UIImageView!
	@IBOutlet weak var userLocation: UILabel!
	
	@IBOutlet weak var nextBtn: UIButton!
	
	var mainCategory = [MainCategoryModel]()
	var mainCategoryName = [String]() // for dropdown
	
	// error variables
	var errorTitle: String? = ""
	var errorDesc: String? = ""
	
	//image view tags
	var imgViewTag : Int!
	
	//image meta datas
	var imageMetaData1: Dictionary <String, Any>?
	var imageMetaData2: Dictionary <String, Any>?
	var imageMetaData3: Dictionary <String, Any>?
	
	//validations
	var isMainCategValid: Bool = false
	var isReportDescriptionValid: Bool = true
	
	//report service
	let reportService = ReportService()
	
	//media service
	let mediaService = MediaService()
	
	//map view delegate
	var mapViewDelegate : MapViewDelegate?
	
	//send report image data
	var sendReportImage: Data?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setImageTapGestures()
		self.errorTitle = NSLocalizedString("wrong-input", comment: "")
    }
	
	
	@IBAction func emergencyToggle(_ sender: UISwitch) {
		
		if sender.isOn {
			alertDialogWithPositiveButton(vc: self, title: "Emergency Notification", message: "Please call 911", positiveBtnName: "Got it") { (alert) in
			}
		}
		
	}
	@IBAction func goToSelectTeams(_ sender: UIButton) {
		
		pushToNextVC(sbName: "Main", controllerID: "SendCommunicationTeamsVC", origin: self)
		
	}
	

}

// for form validation
extension SendCommunicationReportVC : UITextFieldDelegate, UITextViewDelegate {
	
	func disableSendReportButton() {
		self.nextBtn.isEnabled = false
		self.nextBtn.backgroundColor = UIColor.lightGray
	}
	
	func enableSendReportButton() {
		self.nextBtn.isEnabled = true
		self.nextBtn.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
	}
	
	func checkValues() {
		
		var allBool = [self.isMainCategValid, true]
		var numberOfTrue = 0
		var numberOfFalse = 0
		
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

// image picker and other dependent functions
extension SendCommunicationReportVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	
	func setImageTapGestures() -> Void {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
		let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
		let gesture3 = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
		
		img1.isUserInteractionEnabled = true
		img2.isUserInteractionEnabled = true
		img3.isUserInteractionEnabled = true
		
		img1.addGestureRecognizer(gesture)
		img2.addGestureRecognizer(gesture2)
		img3.addGestureRecognizer(gesture3)
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
						self.img1.image = image
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
						self.img2.image = image
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
						self.img3.image = image
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
