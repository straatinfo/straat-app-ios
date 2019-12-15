//
//  AuthService.swift
//  Straat
//
//  Created by John Higgins M. Avila on 25/06/2019.
//

import Foundation
import Alamofire
import SwiftyJSON


class AuthService {
    init () {
        
    }
    
    let apiHandler = ApiHandler()
    
    let uds = UserDefaults.standard
    
    func validateRegistrationInput (type: String, value: String, completion: @escaping (Bool) -> Void) {
        var parameters: Parameters = [:]
        
        parameters[type] = value
        
        Alamofire.request(URL(string: registration_input_validation)!, method: .post, parameters: parameters, headers: [:]).validate().responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("REG_VALIDATION_RESPONSE: \(response)")
                
                if let message = json["message"].string {
                    print("REG_VALIDATION_RESPONSE_MESSAGE: \(message)")
                    if (message == "Invalid Input" || message == "already taken" || message == "User Error") {
                        completion(false)
                    } else {
                        print("VALID_INPUT")
                        completion(true)
                    }
                } else {
                    print("HEY")
                    completion(true)
                }
            case .failure(let error):
                print("ERROR_REG_VAL: \(error.localizedDescription)")
                completion(false)
            }
        }
        
        /*
         if let error = err {
         print(error.localizedDescription)
         completion(false)
         } else if let resp = response {
         
         let responseJson = JSON(resp)
         print("REG_VALIDATION:, \(String(describing: resp))")
         
         print("REG_VALIDATION", responseJson.string)
         
         if let message = responseJson["data"]["message"].string {
         if (message == "Invalid Input" || message == "already taken") {
         completion(false)
         } else {
         completion(true)
         }
         } else {
         completion(false)
         }
         
         }
         */
    }
    
    func userRefresh (completion: @escaping (Bool) -> Void) {
        var parameters: Parameters = [:]
        var headers: HTTPHeaders = [:]
        let userEmail = uds.string(forKey: user_email) ?? ""
        let userToken = uds.string(forKey: token) ?? ""
        
        print("USER_TOKEN_FETCH: \(userToken)")
        
        parameters["email"] = userEmail
        headers["Authorization"] = "Bearer \(userToken)"
        
        Alamofire.request(URL(string: refresh_token)!, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                print("REFRESH_TOKEN_VALUE: \(value)")
                let result = JSON(value)
                if result["data"].exists() {
                    let json = result["data"]
                    if json["user"].exists() {
                        let userJson = json["user"]
                        let user = UserModel(json: userJson)
                        let userToken = json["token"].string
                        
                        self.uds.set(userToken, forKey: token)
                        user.saveToLocalData()
                        
                        print("REFRESH_TOKEN: \(json)")
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func addUpdateFirebaseToken (userId: String, email: String, firebaseToken: String, completion: @escaping(Bool) -> Void) {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        let url = URL(string: add_update_firebase_token)
        var parameters: Parameters = [:]
        var headers: HTTPHeaders = [:]
        let userToken = uds.string(forKey: token) ?? ""
    
        
        parameters["reporterId"] = userId
        parameters["email"] = email
        parameters["deviceId"] = deviceId!
        parameters["token"] = firebaseToken
        parameters["platform"] = "IOS"
        headers["Authorization"] = "Bearer \(userToken)"
        
        Alamofire.request(url!, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                completion(true)
            case .failure(let error):
                print("FCM_TOKEN_UPDATE: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
