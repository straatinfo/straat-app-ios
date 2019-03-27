//
//  ProfileVC.swift
//  Straat
//
//  Created by Global Array on 22/02/2019.
//

import UIKit
import Photos
import Alamofire

class ProfileVC: UIViewController {
    
    var didUpdate = false
    var userService = UserService()
    var profilePic: Data?
    var errorTitle : String? = nil
    var errorDesc : String? = nil
	var postCode : String? = nil
	var postNumber : String? = nil
	
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var familyName: UITextField!
    @IBOutlet weak var addressLotNum: UITextField!
    @IBOutlet weak var addressPostalCode: UITextField!
    @IBOutlet weak var addedStreet: UITextField!
    @IBOutlet weak var addedTown: UITextField!
    @IBOutlet weak var contactEmail: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var chatName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var uploadImage: UIImageView!
    
    @IBOutlet weak var changeData: UIButton!
    // MARK: Input text listeners
    
    
    
    @IBAction func fnameEdit(_ sender: Any) {
        self.wasUpdated()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createMenu()
        self.navColor()
        self.setImageTapGestures()
        self.loadProfileData()
        
        errorTitle = NSLocalizedString("wrong-input", comment: "")
        // Do any additional setup after loading the view.
    }
	
	
	@IBAction func postalCode(_ sender: UITextField) {

	}
	
	@IBAction func postalNumber(_ sender: UITextField) {

	}
	
    
    @IBAction func changeMyDataClicked(_ sender: Any) {
        var desc : String? = nil
        if !self.didUpdate {
            desc = NSLocalizedString("no-changes", comment: "")
            defaultDialog(vc: self, title: "Warning", message: desc)
        } else {
            if profilePic != nil {
                self.updateProfilePic() { (success, text) in
                    if success {
                        self.updateProfile() { (success, text) in
                            if success {
                                desc = NSLocalizedString("update-profile-success", comment: "")
                                defaultDialog(vc: self, title: "Update profile", message: desc)
                            } else {
                                desc = NSLocalizedString("error-occured", comment: "")
                                defaultDialog(vc: self, title: "Update profile", message: desc)
                            }
                        }
                    } else {
                        desc = NSLocalizedString("error-occured", comment: "")
                        defaultDialog(vc: self, title: "Update profile", message: desc)
                    }
                }
            } else {
                self.updateProfile() { (success, text) in
                    if success {
                        desc = NSLocalizedString("update-profile-success", comment: "")
                        defaultDialog(vc: self, title: "Update profile", message: desc)
                    } else {
                        desc = NSLocalizedString("error-occured", comment: "")
                        defaultDialog(vc: self, title: "Update profile", message: desc)
                    }
                }
            }
        }
    }
    
}

extension ProfileVC : UITextFieldDelegate {
    
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        switch(textField) {
        case firstName:
            debugPrint("firstname")
            if textField.text?.isValid() ?? false {
                checkTextFieldValues()
            } else {
                firstName.becomeFirstResponder()
                errorDesc = NSLocalizedString("invalid-firstname", comment: "")
                validationDialog(vc: self, title: errorTitle, message: errorDesc, buttonText: "Ok")
                disableChangeDataButton()

            }
        case familyName:
            debugPrint("lastname")
            if textField.text?.isValid() ?? false {
                checkTextFieldValues()
            } else {
                familyName.becomeFirstResponder()
                errorDesc = NSLocalizedString("invalid-lastname", comment: "")
                validationDialog(vc: self, title: errorTitle, message: errorDesc, buttonText: "Ok")
                disableChangeDataButton()
            }
        case chatName:
            debugPrint("username")
            if textField.text?.isValid() ?? false {
                if textField.text?.isUserNameNotValid() ?? false {
					chatName.becomeFirstResponder()
					errorDesc = NSLocalizedString("taken-username", comment: "")
                    validationDialog(vc: self, title: errorTitle, message: errorDesc, buttonText: "Ok")
                }
                checkTextFieldValues()
            } else {
                chatName.becomeFirstResponder()
                errorDesc = NSLocalizedString("invalid-username", comment: "")
                validationDialog(vc: self, title: errorTitle, message: errorDesc, buttonText: "Ok")
                disableChangeDataButton()
            }
        case addressPostalCode:
            debugPrint("postal code")
            if textField.text?.isValid() ?? false {
				
				postNumber = addressPostalCode.text
				if postCode?.count ?? 0 > 0 || postNumber?.count ?? 0 > 0 {
					self.callPostCodeApi(postCode: postCode ?? "", number: postNumber ?? ""){ (success, postalInfo, message) in
						if success == true {
							self.addedStreet.text = postalInfo!.street
							self.addedTown.text = postalInfo!.city
                			self.checkTextFieldValues()
						} else {
							self.addedStreet.text = ""
							self.addedTown.text = ""
							self.disableChangeDataButton()
							self.addressPostalCode.becomeFirstResponder()
						}
					}
				} else {
					disableChangeDataButton()
					addressPostalCode.becomeFirstResponder()
				}
				
			} else {
                addressPostalCode.becomeFirstResponder()
                errorDesc = NSLocalizedString("invalid-postal-code", comment: "")
                validationDialog(vc: self, title: errorTitle, message: errorDesc, buttonText: "Ok")
                disableChangeDataButton()
            }
        case addressLotNum:
            debugPrint("postal number")
            if textField.text?.isValid() ?? false {

				postNumber = addressLotNum.text
				if postCode?.count ?? 0 > 0 || postNumber?.count ?? 0 > 0 {
					self.callPostCodeApi(postCode: postCode ?? "", number: postNumber ?? ""){ (success, postalInfo, message) in
						if success == true {
							self.addedStreet.text = postalInfo!.street
							self.addedTown.text = postalInfo!.city
                			self.checkTextFieldValues()
						} else {
							self.addedStreet.text = ""
							self.addedTown.text = ""
							self.disableChangeDataButton()
							self.addressLotNum.becomeFirstResponder()
						}
					}
				} else {
					self.disableChangeDataButton()
					self.addressLotNum.becomeFirstResponder()
				}

            } else {
                addressLotNum.becomeFirstResponder()
                errorDesc = NSLocalizedString("invalid-post-number", comment: "")
                validationDialog(vc: self, title: errorTitle, message: errorDesc, buttonText: "Ok")
                disableChangeDataButton()
            }
        case contactEmail:
            debugPrint("email")
            if textField.text?.isValidEmail() ?? false {
                checkTextFieldValues()
                debugPrint("valid email")
            } else {
                contactEmail.becomeFirstResponder()
                errorDesc = NSLocalizedString("invalid-email", comment: "")
                validationDialog(vc: self, title: errorTitle, message: errorDesc, buttonText: "Ok")
                disableChangeDataButton()
                debugPrint("not valid email")
            }
        case contactNumber:
            debugPrint("mobile")
            if textField.text?.isMobileNumberValid() ?? false {
				let checkPrefix = textField.text?.prefix(2)
				if checkPrefix == "06" {
                	checkTextFieldValues()
				} else {
                	validationDialog(vc: self, title: errorTitle, message: "Prefix number must be 06", buttonText: "Ok")
				}

            } else {
                errorDesc = NSLocalizedString("invalid-mobile-number", comment: "")
                validationDialog(vc: self, title: errorTitle, message: errorDesc, buttonText: "Ok")
                contactNumber.becomeFirstResponder()
                disableChangeDataButton()
                
            }
        case password:
            debugPrint("pass")
            if textField.text?.isValidPassword() ?? false {
                checkTextFieldValues()
            } else {
                errorDesc = NSLocalizedString("invalid-password", comment: "")
                validationDialog(vc: self, title: errorTitle, message: errorDesc, buttonText: "Ok")
                password.becomeFirstResponder()
                disableChangeDataButton()
                debugPrint("not valid password")
            }
        default: break
        }
        
    }
    
    func disableChangeDataButton() {
        self.changeData.isEnabled = false
        self.changeData.backgroundColor = UIColor.lightGray
    }
    
    func enableChangeDataButton() {
        self.changeData.isEnabled = true
        self.changeData.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
        debugPrint("enable next step")
    }
    
    func checkTextFieldValues() {
        
        if self.textFieldHasValues(tf: [firstName, familyName, chatName, addressPostalCode, addressLotNum, addedStreet, addedTown, contactEmail, contactNumber]) {
            enableChangeDataButton()
        } else {
            disableChangeDataButton()

        }
        
    }
    
    func textFieldHasValues (tf: [UITextField]) -> Bool {
        
        if validateTextField(tf: tf) {
            return true
        } else {
            return false
        }
    }
	
	typealias OnFinish = ( Bool, PostalModel?, String) -> Void
	
	func callPostCodeApi (postCode: String, number: String, completion: @escaping OnFinish) {
		let apiHandler = ApiHandler()
		
		let parameters = [
			"postcode": postCode,
			"number": number
		]
		
		let headers = [
			"content-type": "application/json",
			"x-api-key": "gvuwmtomsB8eRf5Zgsfnj7zs8DE2ihC79DlEbQnb"
			] as! HTTPHeaders
		
		loadingShow(vc: self)
		apiHandler.executeWithHeaders(URL(string: POST_CODE_API)!, parameters: parameters, method: .get, destination: .queryString, headers: headers) { (response, err) in
			
			if let error = err {
				print("error reponse: \(error.localizedDescription)")
				
				let title = NSLocalizedString("error-response", comment: "")
				let desc = NSLocalizedString("invalid-post-code", comment: "")
				defaultDialog(vc: self, title: title, message: desc)
				
				// loadingDismiss()
				
			} else if let data = response {
				
				let dataObject = data["_embedded"] as? Dictionary <String, Any> ?? [:]
				
				let addresses = dataObject["addresses"] as? [Dictionary<String, Any>]
				
				if let postalData = addresses?[0] {
					let postcode = postalData["postcode"] as? String
					let municipality = postalData["municipality"] as? String
					let city = postalData["city"] as? Dictionary<String, Any>
					let cityLabel = city?["label"] as? String
					let street = postalData["street"] as? String
					
					let postalInfo = PostalModel(postcode: postcode, municipality: municipality, city: cityLabel, street: street)
					
					completion(true, postalInfo, "Success")
				} else {
					completion(false, nil, "Error in Response")
				}
				
				
				print("response:  \(String(describing: dataObject))")
				
			}
			loadingDismiss()
		}
	}
    
}


extension ProfileVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // setting tap gesture recognizer for imageview
    func setImageTapGestures() -> Void {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
        
        self.uploadImage.isUserInteractionEnabled = true
        self.uploadImage.layer.cornerRadius = 50
        self.uploadImage.addGestureRecognizer(gesture)

        
    }
    
    // import image via photo library
    @objc func importImage ( gesture : UITapGestureRecognizer) {
        
        let img = UIImagePickerController()
        let view = gesture.view!
        img.delegate = self
        
        let imageSource = NSLocalizedString("image-source", comment: "")
        let imageSourceDesc = NSLocalizedString("image-source-desc", comment: "")
        let alert = UIAlertController(title: imageSource, message: imageSourceDesc, preferredStyle: .actionSheet)
        
        let camera = NSLocalizedString("camera", comment: "")
        let cameraNotAvailable = NSLocalizedString("camera-not-available", comment: "")
        alert.addAction(UIAlertAction(title: camera, style: .default, handler: { (action:UIAlertAction) in
            //some shitty code
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                img.sourceType = UIImagePickerController.SourceType.camera
                self.present(img, animated: true, completion: nil)
            } else {
                defaultDialog(vc: self, title: cameraNotAvailable, message: nil)
            }
            
        }))
        
        let photoLibrary = NSLocalizedString("photo-library", comment: "")
        alert.addAction(UIAlertAction(title: photoLibrary, style: .default, handler: { (action:UIAlertAction) in
            //some shitty code
            
            self.importImagePermission { (hasGranted, result) in
                
                if hasGranted {
                    img.sourceType = UIImagePickerController.SourceType.photoLibrary
                    img.allowsEditing = false
                    
                    self.present(img, animated: true, completion: nil)
                } else {
                    let permissionDenied = NSLocalizedString("permission-denied", comment: "")
                    defaultDialog(vc: self, title: permissionDenied, message: result)
                }
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // getting user selected image via photo library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.uploadImage.image = image
            self.profilePic = image.jpegData(compressionQuality: CGFloat.leastNormalMagnitude)!
            didUpdate = true
            
        } else {
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


// MARK Custom functions
extension ProfileVC {
    func wasUpdated () {
        self.didUpdate = true
    }
    
    func loadProfileData () {
        let u = UserModel()
        self.firstName.text = u.getDataFromUSD(key: user_fname)
        self.familyName.text = u.getDataFromUSD(key: user_lname)
        self.addressLotNum.text = u.getDataFromUSD(key: user_house_number)
        self.addressPostalCode.text = u.getDataFromUSD(key: user_postal_code)
        self.addedStreet.text = u.getDataFromUSD(key: user_street_name)
        self.addedTown.text = u.getDataFromUSD(key: user_city)
        self.contactEmail.text = u.getDataFromUSD(key: user_email)
        self.contactNumber.text = u.getDataFromUSD(key: user_phone_number)
        self.chatName.text = u.getDataFromUSD(key: user_username)
        
        self.addedStreet.isEnabled = false
        self.addedTown.isEnabled = false
        self.password.isEnabled = false
        // self.password.text = u.getDataFromUSD(key: user_fname)
        // self.uploadImage.text = u.getDataFromUSD(key: user_fname)
    }
    
    func getUpdatedProfileData () -> Dictionary<String, Any> {
        var data = Dictionary<String, Any>()
        data["fname"] = self.firstName.text ?? ""
        data["lname"] = self.familyName.text ?? ""
        data["email"] = self.contactEmail.text ?? ""
        data["username"] = self.chatName.text ?? ""
        data["houseNumber"] = self.addressLotNum.text ?? ""
        data["postalCode"] = self.addressPostalCode.text ?? ""
        data["streetName"] = self.addedStreet.text ?? ""
        data["city"] = self.addedTown.text ?? ""
        data["phoneNumber"] = self.contactNumber.text ?? ""
        
        
        return data
    }
    
    func updateProfile (completion: @escaping (Bool, String) -> Void) {
        
        let u = UserModel()
        let userId = u.getDataFromUSD(key: user_id)
        let userInput = self.getUpdatedProfileData()
        self.userService.updateUserDetails(userId: userId, userInput: userInput) {
            (success, text) in
            
            if success {
                var userData = userInput
                userData["gender"] = u.getDataFromUSD(key: user_gender)
                userData["_id"] = u.getDataFromUSD(key: user_id)
                
                let updateUser = UserModel(fromLogin: userData)
                updateUser.saveToLocalData()
            }
            
            completion(success, text)
        }
    }
    
    func updateProfilePic (completion: @escaping (Bool, String) -> Void) {
        let u = UserModel()
        let userId = u.getDataFromUSD(key: user_id)
        if profilePic != nil {
            userService.uploadProfilPic(userId: userId, image: profilePic!) { (success, text) in
                
               completion(success, text)
            }
        }
    }
}
