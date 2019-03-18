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
    
    let apiHandler = ApiHandler()
    let userModel = UserModel()
    
    override func viewDidLoad() {
        self.userModel.removeFromLocalData()
        self.disableLoginButton()
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
            defaultDialog(vc: self, title: "Login", message: "Please fill up all the empty fields")
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
                    validationDialog(vc: self, title: "Wrong input", message: "Your e-mail is not valid", buttonText: "Ok")
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
                    validationDialog(vc: self, title: "Wrong input", message: "Your password is not valid or must be atleast 6 characters", buttonText: "Ok")
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
                defaultDialog(vc: self, title: "Error Response", message: error.localizedDescription)
                loadingDismiss()
                
            } else if let data = response {
                
                let dataObject = data["data"] as? Dictionary <String, Any>
                let userObject = dataObject?["user"] as? Dictionary <String, Any>
                let settingObject = dataObject?["setting"] as? Dictionary <String, Any>
                let teamObject = userObject!["_activeTeam"] as? Dictionary <String, Any>
                let hostObject = userObject!["_host"] as? Dictionary<String, Any>

                let hostId = hostObject!["_id"] as? String
                let isVolunteer = teamObject!["isVolunteer"] as? Bool ?? true
                
                let userModel = UserModel(fromLogin: userObject!)
                let userSettingModel = UserModel(fromLoginSetting: settingObject!)
                let userTeamModel = UserModel(fromLoginTeam: teamObject!)
                let userOtherModel = UserModel(fromLoginHostId: hostId!, fromLoginIsVolunteer: isVolunteer)
                
                //saving user model to loca data
                userModel.saveToLocalData()
                userSettingModel.saveSettingToLocalData()
                userTeamModel.saveTeamToLocalData()
                userOtherModel.saveOtherToLocalData()
                
                loadingDismiss()
                pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
                
            }
            
        }
        
    }
    
    
}
