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
    
    override func viewDidLoad() {
        //some shitty code
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
extension LoginUserVC {
    
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
                
                let firstname = userObject?["fname"] as? String
                let lastname = userObject?["lname"] as? String
                let email = userObject?["email"] as? String
                let user = userObject?["username"] as? String
                
                let userModel = UserModel(firstname: firstname, lastname: lastname, email: email, username: user)
                
                //saving user model to loca data
                self.saveToLocalData(usermodel: userModel)
                loadingDismiss()
                pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
                
            }
            
        }
        
    }
    
    // saving users data to local data
    func saveToLocalData( usermodel : UserModel ) {
        
        let uds = UserDefaults.standard
        
        uds.set( usermodel.firstname!, forKey: "user_fname")
        uds.set( usermodel.lastname!, forKey: "user_lname")
        uds.set( usermodel.email!, forKey: "user_email")
        uds.set( usermodel.username!, forKey: "user_name")
        
    }
    
    
}
