//
//  UserService.swift
//  Straat
//
//  Created by John Higgins M. Avila on 23/02/2019.
//

import Foundation
import Alamofire

class UserService {
    let apiHandler = ApiHandler()
    init () {
        
    }

    func sendFeedback (reporterId: String, reporterName: String, reporterEmail: String, feedback: String, info: String?, completion: @escaping(Bool, String) -> Void) {
        var parameters: Parameters = [:]
        parameters["reporterName"] = reporterName
        parameters["reporterEmail"] = reporterEmail
        parameters["feedback"] = feedback
        parameters["info"] = info ?? ""
        
        apiHandler.executeWithHeaders(URL(string: "\(reporter_feedback)/\(reporterId)")!, parameters: parameters, method: .post, destination: .httpBody, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription)
            } else {
                
                completion(true, "Success")
            }
        }
    }
    
    func setUserRadius (userId: String, radius: Double, completion: @escaping(Bool, String) -> Void) {
        var parameters: Parameters = [:]
        parameters["radius"] = radius
        let url = "\(user_setting_radius)/\(userId)"
        
        apiHandler.executeWithHeaders(URL(string: url)!, parameters: parameters, method: .put, destination: .httpBody, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription)
            } else {
                
                completion(true, "Success")
            }
            
        }
    }
    
    func getUserDetails (userId: String, completion: @escaping(Bool, String, Dictionary<String, Any>?) -> Void) {
        let url = "\(user_profile)/\(userId)"
        
        apiHandler.executeWithHeaders(URL(string: url)!, parameters: [:], method: .get, destination: .queryString, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription, nil)
            } else if let data = response {
				let dataObject = data["data"] as? Dictionary <String, Any> ?? [:]
              
				if dataObject != nil || dataObject.count > 0 {
                   
                    completion(true, "Success", dataObject)
                } else {
                    completion(false, "Failed", nil)
                }
                
            }
            
        }
    }
    
    func updateUserDetails (userId: String, userInput: Dictionary<String,Any>, completion: @escaping (Bool, String) -> Void) {
        let url = "\(user_profile)/\(userId)"
        apiHandler.executeWithHeaders(URL(string: url)!, parameters: userInput, method: .put, destination: .httpBody, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription)
            } else if let data = response {
				let dataObject = data["data"] as? Dictionary <String, Any> ?? [:]
                
				if dataObject != nil || dataObject.count > 0 {
                    
                    completion(true, "Success")
                } else {
                    completion(false, "Failed")
                }
                
            }
            
        }
    }
    
    func uploadProfilPic (userId: String, image: Data, completion: @escaping (Bool, String) -> Void) {
        let url = "\(user_pic)/\(userId)"
        apiHandler.executeMultiPart(URL(string: url)!, parameters: [:], imageData: image, fileName: "user_\(userId)", photoFieldName: "profile-pic", pathExtension: ".jpeg", method: .put, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription)
            } else if let data = response {
				let dataObject = data["data"] as? Dictionary <String, Any> ?? [:]
                
				if dataObject != nil || dataObject.count > 0 {
					let photoMetaData = PhotoModel(photoData: dataObject)
                    completion(true, "Success")
                } else {
                    completion(false, "Failed")
                }
                
            }
            
        }
    }
    
    func resetPassword (newPassword: String, confirmedPassword: String, completion: @escaping (Bool, String) -> Void) {
        apiHandler.executeWithHeaders(URL(string: user_password)!, parameters: [:], method: .put, destination: .httpBody, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription)
            } else if let data = response {
				let dataObject = data["data"] as? Dictionary <String, Any> ?? [:]
                
				if dataObject != nil || dataObject.count > 0 {                    
                    completion(true, "Success")
                } else {
                    completion(false, "Failed")
                }
                
            }
        }
    }
}


/*
 User input for update
 email: null, username: null, lname: null, fname: null, gender: null,
 houseNumber: null, streetName: null, city: null, state: null,
 country: null, postalCode: null, phoneNumber: null, long: null, lat: null,
 */

// forgot password: newPassword, confirmedPassword
