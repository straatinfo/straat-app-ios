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
        
        if textField(tf: tf) {
            
            loadingShow(vc: self)
            
            login(params: [
                "loginName" : email.text!,
                "password" : password.text!
                ])
            
        } else {
            // creates an alert for this result
            dialog(vc: self, title: "Login", message: "Please fill up all the empty fields")
            print("false")
        }
        
    }
    
    
    func login( params: Parameters) {

        apiHandler.execute(URL(string: auth)!, parameters: params, method: .post) { (response, err) in

            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                dialog(vc: self, title: "Error Response", message: error.localizedDescription)
                loadingDismiss()
                // creates an alert for this error response
                
            } else if let data = response {
                
                loadingDismiss()
                
                let dataObject = data["data"] as? Dictionary <String, Any>
                let userObject = dataObject?["user"] as? Dictionary <String, Any>

                let firstname = userObject?["fname"] as? String
                let lastname = userObject?["lname"] as? String
                let email = userObject?["email"] as? String
                let user = userObject?["username"] as? String

                let userModel = UserModel(firstname: firstname, lastname: lastname, email: email, username: user)

                //saving user model to loca data
                self.saveToLocalData(usermodel: userModel)
                self.pushToNextVC()
                
            }

        }
        
    }
    
    func pushToNextVC() {
        
        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = sb.instantiateViewController(withIdentifier: "SWRevealViewControllerID") as! SWRevealViewController
        self.show(mainVC, sender: self)
        
    }
    
    func saveToLocalData( usermodel : UserModel ) {
        
        UserDefaults.standard.set( usermodel.firstname!, forKey: "user_fname")
        UserDefaults.standard.set( usermodel.lastname!, forKey: "user_lname")
        UserDefaults.standard.set( usermodel.email!, forKey: "user_email")
        UserDefaults.standard.set( usermodel.username!, forKey: "user_name")
        
    }
    
    
    
}
