//
//  CreateTeamVC.swift
//  Straat
//
//  Created by Global Array on 10/02/2019.
//

import UIKit
import iOSDropDown
import Alamofire

class CreateTeamVC: UIViewController {
    
    var teamLogo : Data?
    let mediaService = MediaService()
	var teamLogoMetaData : Dictionary<String,Any>? = [:]
	var isVolunteer: Bool?
    
    @IBOutlet weak var registerButton: UIButton!
    var isTeamNameValid: Bool = false
    var isTeamEmailValid: Bool = false
	
    @IBOutlet weak var teamNameTxtBox: UITextField!
    @IBOutlet weak var teamEmailTxtBox: UITextField!
    @IBOutlet weak var imageTeamLogo: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let prefix = "reg-user-data-"
		let uds = UserDefaults.standard
		self.isVolunteer = uds.bool(forKey: prefix + "isVolunteer")
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func importTeamLogo(_ sender: UIButton) {
        importImage()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRegisterPress(_ sender: Any) {
        loadingShow(vc: self)
        self.register() { (success, message) in
            if success == true {
    
                let uds = UserDefaults.standard;
                let prefix = "reg-user-data-"
                // let userId = uds.object(forKey: prefix + "id") as? String
                let userIsVolunteer = uds.bool(forKey: prefix + "isVolunteer")
                print("USER_IS_VOLUNTEER: \(userIsVolunteer)")
				if userIsVolunteer == false {
                    self.removeInputs()
					let msgTitle = NSLocalizedString("registration-title", comment: "")
					let msgDesc = NSLocalizedString("registration-message", comment: "")
					
					let alertController = UIAlertController(title: msgTitle, message: msgDesc, preferredStyle: .alert)
					
					alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
                	pushToNextVC(sbName: "Initial", controllerID: "loginVC", origin: self)
					}))
					self.present(alertController, animated: true, completion: nil)

				} else {
                    self.removeInputs()
					pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
				}



				
				
//                self.createTeam(userId: userId!) { (success, message) in
//
//                    if success == true {
//                        let alertController = UIAlertController(title: "Registration", message: message, preferredStyle: .alert)
//
//                        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action:UIAlertAction) in
//                            pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
//                        }))
//                        self.present(alertController, animated: true, completion: nil)
//                    } else {
//                        let alertController = UIAlertController(title: "Registration", message: message, preferredStyle: .alert)
//
//                        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action:UIAlertAction) in
//                            pushToNextVC(sbName: "Initial", controllerID: "loginVC", origin: self)
//                        }))
//                        self.present(alertController, animated: true, completion: nil)
//                    }
//
//                }
            }
        }
    }
    
}

extension CreateTeamVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let authService = AuthService()
        textField.resignFirstResponder()
        switch textField {
        case self.teamNameTxtBox:
            if textField.text?.isValidDescription() ?? false {
                
                authService.validateRegistrationInput(type: "teamName", value: self.teamNameTxtBox.text ?? "") { (isValid) in
                    if (isValid) {
                        self.isTeamNameValid = true
                        self.checkTextFieldValues()
                    } else {
                        let errorTitle = NSLocalizedString("error", comment: "")
                        let errorMessage = NSLocalizedString("team-name-already-in-use", comment: "")
                        validationDialog(vc: self, title: errorTitle, message: errorMessage, buttonText: "Ok")
                        
                        self.isTeamNameValid = false
                        self.teamNameTxtBox.becomeFirstResponder()
                        self.disableCreateTeamButton()
                    }
                }
            } else {
                self.isTeamNameValid = false
                self.teamNameTxtBox.becomeFirstResponder()
                disableCreateTeamButton()
            }
        case self.teamEmailTxtBox:
            if textField.text?.isValidEmail() ?? false {
                self.isTeamEmailValid = true
                checkTextFieldValues()
            } else {
                self.isTeamEmailValid = false
                self.teamEmailTxtBox.becomeFirstResponder()
                disableCreateTeamButton()
            }
        default:break
        }
    }
    
}

// for implementing functions
extension CreateTeamVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func importImage () {
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = UIImagePickerController.SourceType.photoLibrary
        img.allowsEditing = false
        
        self.present(img, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
        loadingShow(vc: self)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.teamLogo = image.jpegData(compressionQuality: CGFloat.leastNormalMagnitude)!
			
			self.mediaService.uploadPhoto(image: self.teamLogo!, fileName: "team-logo") { (success, message, photoMetaData, dataObject) in
				
				if success {
					self.teamLogoMetaData = dataObject
					debugPrint("dataObject: \(String(describing: dataObject))")
					//                        print("public_id: \(String(describing: public_id))")
				} else {
					print("upload image response: \(message)")
				}
				loadingDismiss()
				
			}
            imageTeamLogo.image = image

            
        } else {
            print("importing img: error in uploading image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
//    func createTeam (userId: String, completion: @escaping (Bool, String) -> Void) {
//
//        let userData = getInputs()
//        let apiHandler = ApiHandler()
//        let hostId = userData.hostId ?? ""
//        var parameters : Parameters = [:]
//
//        parameters["isVolunteer"] = userData.isVolunteer ?? true
//        parameters["teamName"] = teamNameTxtBox.text ?? ""
//        parameters["teamEmail"] = teamEmailTxtBox.text ?? ""
//        parameters["creationMethod"] = "MOBILE"
//
////        let url = URL(string: "https://straatinfo-backend-v2.herokuapp.com/v1/api/team/new/" + userId)
//        let url = URL(string: "https://straatinfo-backend-v2.herokuapp.com/v2/api/team?_user=" + userId + "&_host=" + hostId)
//
//        apiHandler.executeMultiPart(url!, parameters: parameters, imageData: self.teamLogo, fileName: teamNameTxtBox.text!, photoFieldName: "photo", pathExtension: ".jpeg", method: .post, headers: [:]) { (response, err) in
//            // go to main view
//            completion(true, "Success")
//        }
//
//    }
    
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
        self.registerButton.isEnabled = false
        self.registerButton.backgroundColor = UIColor.lightGray
    }
    
    func enableCreateTeamButton() {
        self.registerButton.isEnabled = true
        self.registerButton.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
        debugPrint("enable next step")
    }

    func getInputs () -> UserRegistrationModel {
        let uds = UserDefaults.standard
        let prefix = "reg-user-data-"
        
        let gender = uds.object(forKey: prefix + "gender") as? String? ?? ""
        let fname = uds.object(forKey: prefix + "fname") as? String? ?? ""
        let lname = uds.object(forKey: prefix + "lname") as? String? ?? ""

        let user = uds.object(forKey: prefix + "username") as! String? ?? ""
        let userPrefix = uds.object(forKey: prefix + "userPrefix") as! String? ?? ""
        let username = user + userPrefix
        
        let postalCode = uds.object(forKey: prefix + "postalCode") as? String? ?? ""
        let postalNumber = uds.object(forKey: prefix + "postalNumber") as? String? ?? ""
        let street = uds.object(forKey: prefix + "street") as? String? ?? ""
        let town = uds.object(forKey: prefix + "town") as? String? ?? ""
        let email = uds.object(forKey: prefix + "email") as? String? ?? ""
        let phoneNumber = uds.object(forKey: prefix + "phoneNumber") as? String? ?? ""
        let password = uds.object(forKey: prefix + "password") as? String? ?? ""
        let tac = uds.object(forKey: prefix + "tac") as? Bool? ?? false
        
        let isVolunteer = uds.object(forKey: prefix + "isVolunteer") as? Bool? ?? true
        
        let teamName = uds.object(forKey: prefix + "teamName") as? String? ?? nil
        let teamId = uds.object(forKey: prefix + "teamId") as? String? ?? nil
        let teamEmail = uds.object(forKey: prefix + "teamEmail") as? String? ?? nil
        
        
        let hostId = uds.object(forKey: host_reg_id) as? String? ?? nil
        let long = uds.object(forKey: host_reg_long) as? Double? ?? nil        
        let lat = uds.object(forKey: host_reg_lat) as? Double? ?? nil
        
        let team = TeamModel(teamId: teamId, teamName: teamName, teamEmail: teamEmail)
        
        let userData = UserRegistrationModel(gender: gender, firstname: fname, lastname: lname, username: username, postalCode: postalCode, postalNumber: postalNumber, street: street, town: town, email: email, phoneNumber: phoneNumber, password: password, tac: tac, isVolunteer: isVolunteer, hostId: hostId, long: long, lat: lat, team: team)
        
        return userData
    }
    
    func register (completion: @escaping (Bool, String) -> Void) -> Void {
        let userData = getInputs()
        let apiHandler = ApiHandler()
        var parameters: Parameters = [:]
		var logoUrl: String = ""
		var logoSecuredUrl: String = ""
		var teamPhotoId: String = ""
		
		if self.teamLogoMetaData?.count ?? 0 > 0 {
			logoUrl = self.teamLogoMetaData!["url"] as? String ?? ""
			logoSecuredUrl = self.teamLogoMetaData!["secure_url"] as? String ?? ""
			teamPhotoId = self.teamLogoMetaData!["_id"] as? String ?? ""
		}
		
		debugPrint("url: \(logoUrl)")
		debugPrint("securedurl: \(logoSecuredUrl)")
		
        parameters["language"] = "nl"
        parameters["gender"] = userData.gender ?? ""
        parameters["fname"] = userData.firstname ?? ""
        parameters["lname"] = userData.lastname ?? ""
        parameters["username"] = userData.username ?? ""
        parameters["password"] = userData.password ?? ""
        parameters["streetName"] = userData.street ?? ""
        parameters["houseNumber"] = userData.postalNumber ?? ""
        parameters["postalCode"] = userData.postalCode ?? ""
        parameters["city"] = userData.town ?? ""
        parameters["email"] = userData.email ?? ""
        parameters["phoneNumber"] = userData.phoneNumber ?? ""
        if (userData.isVolunteer != nil && userData.isVolunteer == true) {
            parameters["isVolunteer"] = "true"
        } else {
            parameters["isVolunteer"] = "false"
        }
        parameters["register_option"] = "MOBILE_APP"
        parameters["lat"] = userData.lat ?? ""
        parameters["long"] = userData.long ?? ""
        parameters["isReporter"] = "true"
        parameters["_host"] = userData.hostId ?? ""
        parameters["logoUrl"] = logoUrl
        parameters["logoSecuredUrl"] = logoSecuredUrl
        parameters["teamPhotoId"] = teamPhotoId
//        if (userData.team != nil && userData.team?.teamId != nil && userData.team?.teamId != "") {
//            parameters["_team"] = userData.team?.teamId
//        }
        parameters["teamName"] = teamNameTxtBox.text ?? ""
        parameters["teamEmail"] = teamEmailTxtBox.text ?? ""
    
        parameters["code"] = "SeTT0"
        
        apiHandler.execute(URL(string: signup_v3)!, parameters: parameters, method: .post, destination: .httpBody) { (response, err) in

            if let error = err {
                print("error reponse: \(error.localizedDescription)")

                let title = NSLocalizedString("error-response", comment: "")
                defaultDialog(vc: self, title: title, message: error.localizedDescription)

                completion(false, error.localizedDescription)
                // loadingDismiss()

            } else if let data = response {
                // save user data and token here
//                let uds = UserDefaults.standard;
//                let prefix = "user-data-"

                let dataObject = data["data"] as? Dictionary<String, Any> ?? [:]
//                let user = dataObject?["user"] as? Dictionary<String, Any>
//                let userId = user?["_id"] as? String
//
//                uds.set(userId, forKey: prefix + "id")

				let userObject = dataObject["user"] as? Dictionary <String, Any> ?? [:]
				let settingObject = dataObject["setting"] as? Dictionary <String, Any> ?? [:]
				let activeDesignObject = dataObject["_activeDesign"] as? Dictionary<String, Any> ?? [:]
				
				let teamObject = userObject["_activeTeam"] as? Dictionary <String, Any> ?? [:]
				let hostObject = userObject["_host"] as? Dictionary<String, Any> ?? [:]
				
				
				let hostId = hostObject["_id"] as? String ?? ""
				let isVolunteer = userObject["isVolunteer"] as? Bool ?? true
				
				let userModel = UserModel(fromLogin: userObject)
				let userSettingModel = UserModel(fromLoginSetting: settingObject)
				let userTeamModel = UserModel(fromLoginTeam: teamObject)
                let userOtherModel = UserModel(fromLoginHostId: hostId, fromLoginIsVolunteer: isVolunteer)
				let userActiveDesignModel = UserModel(fromLoginActiveDesign: activeDesignObject)
				

                //saving user model to loca data
                userModel.saveToLocalData()
				userSettingModel.saveSettingToLocalData()
				userTeamModel.saveTeamToLocalData()
				userOtherModel.saveOtherToLocalData()
				userActiveDesignModel.saveActiveDesignToLocalData()
                
                let uds = UserDefaults.standard
                let userToken = dataObject["token"] as? String ?? ""
                uds.set(userToken, forKey: token)
                
                completion(true, "Success")

                print("response:  \(String(describing: data))")

            }
        }
		
    }
    
    func removeInputs () {
        let uds = UserDefaults.standard
        let prefix = "reg-user-data-"
        
        uds.removeObject(forKey: prefix + "gender")
        uds.removeObject(forKey: prefix + "fname")
        uds.removeObject(forKey: prefix + "lname")
        
        uds.removeObject(forKey: prefix + "username")
        uds.removeObject(forKey: prefix + "userPrefix")
        
        uds.removeObject(forKey: prefix + "postalCode")
        uds.removeObject(forKey: prefix + "postalNumber")
        uds.removeObject(forKey: prefix + "street")
        uds.removeObject(forKey: prefix + "town")
        uds.removeObject(forKey: prefix + "email")
        uds.removeObject(forKey: prefix + "phoneNumber")
        uds.removeObject(forKey: prefix + "password")
        uds.removeObject(forKey: prefix + "tac")
        
        uds.removeObject(forKey: prefix + "isVolunteer")
        
        uds.removeObject(forKey: prefix + "teamName")
        uds.removeObject(forKey: prefix + "teamId")
        uds.removeObject(forKey: prefix + "teamEmail")
    }
    
}
