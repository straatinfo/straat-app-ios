//
//  CreateTeamVC.swift
//  Straat
//
//  Created by Global Array on 02/03/2019.
//

import UIKit
import Photos
import Alamofire

class CreateNewTeamVC: UIViewController {

    var img : Data?
    
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamEmailAddress: UITextField!
    @IBOutlet weak var uploadTeamLogo: UIImageView!
	@IBOutlet weak var createTeamButton: UIButton!
	
	var isTeamNameValid: Bool = false
	var isTeamEmailValid: Bool = false
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImageTapGestures()
		self.disableCreateTeamButton()
        // Do any additional setup after loading the view.
    }

    @IBAction func createNewTeam(_ sender: UIButton) {
        let uds = UserDefaults.standard
        let userId = uds.string(forKey: user_id)
        let tfs : [UITextField] = [self.teamName, self.teamEmailAddress]
        
        if validateTextField(tf: tfs) {
            loadingShow(vc: self)
            self.createTeam(userId: userId!) { (success, message) in
                defaultDialog(vc: self, title: "Creating New Team", message: message)
                loadingDismiss()
            }
        } else {
            let desc = NSLocalizedString("fill-up-all-fields", comment: "")
            defaultDialog(vc: self, title: "Empty Field", message: desc)
        }
        

    }
    
}

extension CreateNewTeamVC : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		textField.resignFirstResponder()
		switch textField {
		case self.teamName:
			if textField.text?.isValid() ?? false {
				self.isTeamNameValid = true
				checkTextFieldValues()
			} else {
				self.isTeamNameValid = false
				self.teamName.becomeFirstResponder()
				disableCreateTeamButton()
			}
		case self.teamEmailAddress:
			if textField.text?.isValidEmail() ?? false {
				self.isTeamEmailValid = true
				checkTextFieldValues()
			} else {
				self.isTeamEmailValid = false
				self.teamEmailAddress.becomeFirstResponder()
				disableCreateTeamButton()
			}
		default:break
		}
	}
    
    func createTeam (userId: String, completion: @escaping (Bool, String) -> Void) {
        
        let uds = UserDefaults.standard
        let hostId = uds.string(forKey: user_host_id) ?? ""
		let isVolunteer = uds.bool(forKey: user_is_volunteer)
		var isVol: String = ""
		
        let apiHandler = ApiHandler()
        var parameters : Parameters = [:]

		if isVolunteer {
			isVol = "true"
		} else {
			isVol = "false"
		}
//        parameters["photo"] = self.img
        parameters["teamName"] = self.teamName.text ?? ""
        parameters["teamEmail"] = self.teamEmailAddress.text ?? ""
        parameters["isVolunteer"] = isVol
		parameters["isApproved"] = false
        parameters["creationMethod"] = "MOBILE"
        
        let url = URL(string: "https://straatinfo-backend-v2.herokuapp.com/v2/api/team?_user=" + userId + "&_host=" + hostId)

        apiHandler.executeMultiPart(url!, parameters: parameters, imageData: self.img, fileName: teamName.text!, photoFieldName: "photo", pathExtension: ".jpeg", method: .post, headers: [:]) { (response, err) in
            // go to main view
            if err != nil {
                completion(false, "Team Not Created")
                debugPrint("create team response: \(String(describing: response))")
            } else {
                completion(true, "Success")
            }

        }
        debugPrint("userid: \(userId)")
        debugPrint("hostid: \(hostId)")
        debugPrint("isVolunteer: \(isVol)")
		
    }
	
	func checkTextFieldValues() {
		let bools = [self.isTeamNameValid, self.isTeamEmailValid]
		
		var numberOfTrue = 0
		var numberOfFalse = 0
		
		for bool in bools {
			if bool {
				numberOfTrue += 1
			} else {
				numberOfFalse += 1
			}
		}
		
		if numberOfFalse > 0 {
			disableCreateTeamButton()
		} else {
			enableCreateTeamButton()
		}
		
		debugPrint("nmber of true: \(numberOfTrue)")
		debugPrint("nmber of flase: \(numberOfFalse)")
		
	}
	
	func disableCreateTeamButton() {
		self.createTeamButton.isEnabled = false
		self.createTeamButton.backgroundColor = UIColor.lightGray
	}
	
	func enableCreateTeamButton() {
		self.createTeamButton.isEnabled = true
		self.createTeamButton.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
		debugPrint("enable next step")
	}
}

extension CreateNewTeamVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // setting tap gesture recognizer for imageview
    func setImageTapGestures() -> Void {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
        self.uploadTeamLogo.isUserInteractionEnabled = true
        self.uploadTeamLogo.addGestureRecognizer(gesture)
        
    }
    
    // import image via photo library
    @objc func importImage ( gesture : UITapGestureRecognizer) {
        
        let img = UIImagePickerController()
        img.delegate = self
        
        let alert = UIAlertController(title: "Image Source", message: "Please choose where to take your image", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            //some shitty code
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                img.sourceType = UIImagePickerController.SourceType.camera
                self.present(img, animated: true, completion: nil)
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
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.uploadTeamLogo.image = image
            self.img = image.jpegData(compressionQuality: CGFloat.leastNormalMagnitude)!
            
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

