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
    
    let apiHandler = ApiHandler()
    let userModel = UserModel()
    
    override func viewDidLoad() {
        self.userModel.removeFromLocalData()
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
