//
//  EnterCode.swift
//  Straat
//
//  Created by Global Array on 29/01/2019.
//

import Foundation
import UIKit
import Alamofire

class EnterCodeVC: UIViewController {
    
    @IBOutlet weak var tfCode: UITextField!
    let apiHandler = ApiHandler()
    let userModel = UserModel()
    
    override func viewDidLoad() {

    }
    
    @IBAction func btnOkay(_ sender: UIButton) {
        
        let tf : [UITextField] = [tfCode]
        
        if validateTextField(tf: tf) {

            loadingShow(vc: self)
            code(params: [ "code" : tfCode.text! ])
            
            
            print("code: " + tfCode.text!)
        } else {
            // creates an alert for this result
            defaultDialog(vc: self, title: "Enter Code", message: "Please fill up all the empty fields")
        }
        
    }
    
    
}


// for implementing functions
extension EnterCodeVC : UITextFieldDelegate {
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // fetching data based on access code of user input
    func code( params : Parameters ) {
        
        apiHandler.execute(URL(string: request_host)!, parameters: params, method: .post, destination: .httpBody) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                defaultDialog(vc: self, title: "Error Response", message: error.localizedDescription)
                loadingDismiss()
                // creates an alert for this error response
                
            } else if let data = response {
                
                loadingDismiss()
                
                let dataObject = data["data"] as? Dictionary <String, Any>
                
                let id = dataObject?["_id"] as? String
                let lat = dataObject?["_lat"] as? String
                let long = dataObject?["long"] as? String
                let email = dataObject?["email"] as? String
                let hostName = dataObject?["hostName"] as? String
                let username = dataObject?["username"] as? String
                let streetName = dataObject?["streetName"] as? String
                let city = dataObject?["city"] as? String
                let country = dataObject?["country"] as? String
                let postalCode = dataObject?["postalCode"] as? String
                let phoneNumber = dataObject?["phoneNumber"] as? String
                let isVolunteer = dataObject?["isVolunteer"] as? Bool
                let language = dataObject?["language"] as? String
                
                print("response:  \(String(describing: dataObject))")
                
                
                let host = HostModel(hostID: id, hostLat: lat, hostLong: long, hostEmail: email, username: username, streetName: streetName, city: city, country: country, postalCode: postalCode, phoneNumber: phoneNumber, isVolunteer: isVolunteer, language: language)
                
                self.saveToLocalData(host: host) {success, message in
                    if success {
                        // go to login view controller
                        pushToNextVC(sbName: "Initial", controllerID: "loginVC", origin: self)
                    } else {
                        print(message ?? "An error occured")
                    }
                }
                
            }
            
        }
        
    }
    typealias OnFinish = ( Bool, String?) -> Void
    func saveToLocalData (host: HostModel, completion: @escaping OnFinish) {
        let uds = UserDefaults.standard;
        
        uds.set(host.id, forKey: host_reg_id)
        uds.set(host.lat, forKey: host_reg_lat)
        uds.set(host.long, forKey: host_reg_long)
        uds.set(host.email, forKey: host_reg_email)
        uds.set(host.city, forKey: host_reg_city)
        uds.set(host.country, forKey: host_reg_country)
        uds.set(host.hostName, forKey: host_reg_host_name)
        uds.set(host.isVolunteer, forKey: host_reg_is_volunteer)
        uds.set(host.postalCode, forKey: host_reg_postal_code)
        uds.set(host.phoneNumber, forKey: host_reg_phone_number)
        uds.set(host.language, forKey: host_reg_language)
        
        completion(true, "Success")
    }
    
    
    
    
}

