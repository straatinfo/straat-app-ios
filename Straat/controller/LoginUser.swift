//
//  LoginUser.swift
//  Straat
//
//  Created by Global Array on 29/01/2019.
//

import UIKit
import Alamofire

class LoginUser: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let apiHandler = ApiHandler()
    
    override func viewDidLoad() {
        //some shitty code
    }
    
    
    @IBAction func loginUser(_ sender: Any) {
        
        let params : Parameters = [
            "loginName" : email.text!,
            "password" : password.text!
        ]
        
        apiHandler.execute(URL(string: auth)!, parameters: params, method: .post) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
            } else if let data = response {
                
                let dataObject = data["data"] as? Dictionary <String, Any>
                let userObject = dataObject?["user"] as? Dictionary <String, Any>
                
                let firstname = userObject?["fname"] as? String
                let lastname = userObject?["lname"] as? String
                let email = userObject?["email"] as? String
                let user = userObject?["username"] as? String
                
                let userModel = UserModel(firstname: firstname, lastname: lastname, email: email, username: user)
                
//                print("firstname: " + userModel.firstname!)
                
            }
            
        }
    }
    
}
