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
    
    override func viewDidLoad() {
            //some shit code
    }
    
    @IBAction func btnOkay(_ sender: UIButton) {
        
        let tf : [UITextField] = [tfCode]
        
        if validateTextField(tf: tf) {

            loadingShow(vc: self)
            code(params: [ "code" : tfCode.text! ])
            
        } else {
            // creates an alert for this result
            defaultDialog(vc: self, title: "Enter Code", message: "Please fill up all the empty fields")
        }
        
    }
    
    
}


// for implementing functions
extension EnterCodeVC {
 
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
                
                let dataObject = data["data"] as! Dictionary <String, Any>
                let host_id = dataObject["_id"] as! String
                let host_lat = dataObject["lat"] as! Double
                let host_long = dataObject["long"] as! Double
                let host_email = dataObject["email"] as! String
                let host_street = dataObject["streetName"] as! String
                let host_city = dataObject["city"] as! String
                let host_country = dataObject["country"] as! String
                let host_postal = dataObject["postalCode"] as! String
                
                print("host_id:  \(String(describing: host_id))")
                print("host_long:  \(String(describing: host_long))")
                print("host_lat:  \(String(describing: host_lat))")
            
                
                //saving user model to loca data
                self.saveToLocalData(hostModel: HostModel(hostID: host_id, hostLat: host_lat, hostLong: host_long, hostEmail: host_email, hostStreet: host_street, hostCity: host_city, hostCountry: host_country, hostPostalCode: host_postal))
                
                pushToNextVC(sbName: "Initial", controllerID: "loginVC", origin: self)
                
            }
            
        }
        
    }
    typealias OnFinish = ( Bool, String?) -> Void
    func saveToLocalData (host: HostModel, completion: @escaping OnFinish) {
        let uds = UserDefaults.standard;
        
        let prefix = "host-reg"
        
        uds.set(host.id, forKey: prefix + "id")
        uds.set(host.lat, forKey: prefix + "lat")
        uds.set(host.long, forKey: prefix + "long")
        uds.set(host.email, forKey: prefix + "email")
        uds.set(host.city, forKey: prefix + "city")
        uds.set(host.country, forKey: prefix + "country")
        uds.set(host.hostName, forKey: prefix + "hostName")
        uds.set(host.isVolunteer, forKey: prefix + "isVolunteer")
        uds.set(host.postalCode, forKey: prefix + "postalCode")
        uds.set(host.phoneNumber, forKey: prefix + "phoneNumber")
        uds.set(host.language, forKey: prefix + "language")
        completion(true, "Success")
    }
    
    
    // saving host data to local data
    func saveToLocalData( hostModel : HostModel ) {
        
        let uds = UserDefaults.standard
        
        uds.set( hostModel.id!, forKey: "host_id")
        uds.set( hostModel.lat!, forKey: "host_lat")
        uds.set( hostModel.long!, forKey: "host_long")
        uds.set( hostModel.email!, forKey: "host_email")
        uds.set( hostModel.streetName!, forKey: "host_street")
        uds.set( hostModel.city!, forKey: "host_city")
        uds.set( hostModel.country!, forKey: "host_country")
        uds.set( hostModel.postalCode!, forKey: "host_postal")
        
        print("local data: \(String(describing: uds.string(forKey: "host_country")))" )
        
    }
    
    
    
    
}

