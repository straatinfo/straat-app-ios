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
    
    var img : Data?

    @IBOutlet weak var teamNameTxtBox: UITextField!
    @IBOutlet weak var teamEmailTxtBox: UITextField!
    @IBOutlet weak var imageTeamLogo: UIImageView!
//    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func importTeamLogo(_ sender: UIButton) {
        importImage()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRegisterPress(_ sender: Any) {
        self.register() { (success, message) in
            if success == true {
                let uds = UserDefaults.standard;
                
                let prefix = "user-data-"
                
                let userId = uds.object(forKey: prefix + "id") as? String
                
                self.createTeam(userId: userId!) { (success, message) in
                    
                    if success == true {
                        pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
                    }
                    
                }
            }
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
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageTeamLogo.image = image
            
            img = image.jpegData(compressionQuality: CGFloat.leastNormalMagnitude)!
            
        } else {
            print("importing img: error in uploading image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func createTeam (userId: String, completion: @escaping (Bool, String) -> Void) {
        let userData = getInputs()
        let apiHandler = ApiHandler()
        var parameters : Parameters = [:]
        parameters["_host"] = userData.hostId ?? ""
        parameters["isVolunteer"] = userData.isVolunteer ?? true
        parameters["teamName"] = teamNameTxtBox.text ?? ""
        parameters["teamEmail"] = teamEmailTxtBox.text ?? ""
        
        let url = URL(string: "https://straatinfo-backend-v2.herokuapp.com/v1/api/team/new/" + userId)
        
        apiHandler.executeMultiPart(url!, parameters: parameters, imageData: img, fileName: teamNameTxtBox.text!, photoFieldName: "team-logo", pathExtension: ".jpeg", method: .post, headers: [:]) { (response, err) in
            // go to main view
            completion(true, "Success")
        }
        
    }

    func getInputs () -> UserRegistrationModel {
        let uds = UserDefaults.init()
        let prefix = "reg-user-data-"
        
        let gender = uds.object(forKey: prefix + "gender") as? String? ?? ""
        let fname = uds.object(forKey: prefix + "fname") as? String? ?? ""
        let lname = uds.object(forKey: prefix + "lname") as? String? ?? ""
        let username = uds.object(forKey: prefix + "username") as? String? ?? ""
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
        
        let hostPrefix = "host-reg"
        
        let hostId = uds.object(forKey: hostPrefix + "id") as? String? ?? nil
        
        let long = uds.object(forKey: hostPrefix + "long") as? Double? ?? nil
        
        let lat = uds.object(forKey: hostPrefix + "lat") as? Double? ?? nil
        
        let team = TeamModel(teamId: teamId, teamName: teamName, teamEmail: teamEmail)
        
        let userData = UserRegistrationModel(gender: gender, firstname: fname, lastname: lname, username: username, postalCode: postalCode, postalNumber: postalNumber, street: street, town: town, email: email, phoneNumber: phoneNumber, password: password, tac: tac, isVolunteer: isVolunteer, hostId: hostId, long: long, lat: lat, team: team)
        
        return userData
    }
    
    func register (completion: @escaping (Bool, String) -> Void) -> Void {
        let userData = getInputs()
        let apiHandler = ApiHandler()
        var parameters : Parameters = [:]
        
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
        parameters["isVolunteer"] = userData.isVolunteer ?? true
        parameters["register_option"] = "MOBILE_APP"
        parameters["lat"] = userData.lat ?? ""
        parameters["lng"] = userData.long ?? ""
        parameters["isReporter"] = true
        parameters["_host"] = userData.hostId ?? ""
        parameters["logoUrl"] = ""
        parameters["logoSecuredUrl"] = ""
        parameters["_team"] = userData.team?.teamId ?? ""
        parameters["code"] = "SeTT0"
        
        apiHandler.execute(URL(string: signup_v3)!, parameters: parameters, method: .post, destination: .httpBody) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                defaultDialog(vc: self, title: "Error Response", message: error.localizedDescription)
                completion(false, error.localizedDescription)
                // loadingDismiss()
                
            } else if let data = response {
                // save user data and token here
                
                let uds = UserDefaults.standard;
                
                let prefix = "user-data-"
                
                let dataObject = data["data"] as? Dictionary<String, Any>
                
                let user = dataObject?["user"] as? Dictionary<String, Any>
                
                let userId = user?["_id"] as? String
                
                uds.set(userId, forKey: prefix + "id")
                
            
                
                let userObject = dataObject?["user"] as? Dictionary <String, Any>
                
                let userModel = UserModel(fromLogin: userObject!)
                
                //saving user model to loca data
                userModel.saveToLocalData()
//                loadingDismiss(indicator: self.activityIndicator)
                
                
                completion(true, "Success")
                
                print("response:  \(String(describing: data))")
                
            }
        }
        
    }
    
}
