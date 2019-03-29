//
//  LoginUser.swift
//  Straat
//
//  Created by Global Array on 29/01/2019.
//

import UIKit
import Alamofire

class LoginUserVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var errorTitle : String? = nil
    var errorDesc : String? = nil
    
    let apiHandler = ApiHandler()
    let userModel = UserModel()
    
    override func viewDidLoad() {
        self.userModel.removeFromLocalData()
        self.disableLoginButton()
        
        errorTitle = NSLocalizedString("wrong-input", comment: "")
    }
    
    @IBAction func userNameTextField(_ sender: UITextField) {

    }
    @IBAction func passwordTextField(_ sender: UITextField) {
    }
    
    @IBAction func loginUser(_ sender: Any) {
        
        let tf : [UITextField] = [email, password]
        
        if validateTextField(tf: tf) {
            
            loadingShow(vc: self)
            
            login(params: [
                "loginName" : email.text!,
                "password" : password.text!
                ])
            
        } else {
            let desc = NSLocalizedString("fill-up-all-fields", comment: "")
            defaultDialog(vc: self, title: "Login", message: desc)
            print("false")
        }
        
    }
    
}

// for implementing functions
extension LoginUserVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        textField.resignFirstResponder()
        switch(textField) {
            case email:
                if textField.text?.isValidEmail() ?? false {
                    debugPrint("valid email")
                    if self.textFieldHasValues(tf: [email, password]) {
                        enableLoginButton()
                    }
                } else {
                    email.becomeFirstResponder()
                    errorDesc = NSLocalizedString("invalid-email", comment: "")
                    validationDialog(vc: self, title: errorTitle, message: errorDesc, buttonText: "Ok")
                    disableLoginButton()
                    debugPrint("not valid email")
                }
            break
            case password:
                if textField.text?.isValidPassword() ?? false {
                    if self.textFieldHasValues(tf: [email, password]) {
                        enableLoginButton()
                    }
                } else {
                    errorDesc = NSLocalizedString("invalid-password", comment: "")
                    validationDialog(vc: self, title: errorTitle, message: errorDesc, buttonText: "Ok")
                    password.becomeFirstResponder()
                    disableLoginButton()
                    debugPrint("not valid password")
                }
            break
            default:
            //            self.loginButton.isEnabled = true
            //            self.loginButton.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
            break
        }
        
    }
    
    func disableLoginButton() {
        self.loginButton.isEnabled = false
        self.loginButton.backgroundColor = UIColor.lightGray
    }
    
    func enableLoginButton() {
        self.loginButton.isEnabled = true
        self.loginButton.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
    }
    
    func textFieldHasValues (tf: [UITextField]) -> Bool {
        
        if validateTextField(tf: tf) {
            return true
        } else {
            return false
        }
    }
    
    // fetching user data
    func login( params: Parameters) {
        
        apiHandler.execute(URL(string: auth)!, parameters: params, method: .post, destination: .queryString) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                let title = NSLocalizedString("error-response", comment: "")
                let desc = NSLocalizedString("invalid-username-password", comment: "")
                defaultDialog(vc: self, title: title, message: desc)
                
                loadingDismiss()
                
            } else if let data = response {
                
				let dataObject = data["data"] as? Dictionary <String, Any> ?? [:]
				let userObject = dataObject["user"] as? Dictionary <String, Any> ?? [:]
				let settingObject = dataObject["setting"] as? Dictionary <String, Any> ?? [:]
				let activeDesignObject = dataObject["_activeDesign"] as? Dictionary<String, Any> ?? [:]
				
				let teamObject = userObject["_activeTeam"] as? Dictionary <String, Any> ?? [:]
				let hostObject = userObject["_host"] as? Dictionary<String, Any> ?? [:]


				let hostId = hostObject["_id"] as? String
				let isVolunteer = teamObject["isVolunteer"] as? Bool ?? true
                
				let userModel = UserModel(fromLogin: userObject)
				let userSettingModel = UserModel(fromLoginSetting: settingObject)
				let userTeamModel = UserModel(fromLoginTeam: teamObject)
                let userOtherModel = UserModel(fromLoginHostId: hostId!, fromLoginIsVolunteer: isVolunteer)
				let userActiveDesignModel = UserModel(fromLoginActiveDesign: activeDesignObject)
                
                let profilePicObject = userObject["_profilePic"] as? Dictionary <String, Any> ?? [:]
                
                
                
                //saving user model to loca data
                userModel.saveToLocalData()
                userSettingModel.saveSettingToLocalData()
                userTeamModel.saveTeamToLocalData()
                userOtherModel.saveOtherToLocalData()
                userActiveDesignModel.saveActiveDesignToLocalData()
				
                loadingDismiss()
                pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
                
            }
            
        }
        
    }
    
    
}
