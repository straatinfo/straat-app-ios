//
//  UserModel.swift
//  Straat
//
//  Created by Global Array on 06/02/2019.
//

import Foundation


class UserModel {
    // id -
    //fname -
    //lname -
    //address
    //email address -
    //phone number
    //username / chatname -
    var id: String?
    var firstname: String?
    var lastname: String?
    var email: String?
    var username: String?
    var houseNumber: String?
    var postalCode: String?
    var phoneNumber: String?
    var streetName: String?
    var city: String?
    var gender: String?
    
    var isNotification: Bool?
    var vibrate: Bool?
    var sound: Bool?
    var radius: Float?
    
    let uds = UserDefaults.standard
    
    init () {
        
    }
    
    
    init (firstname fname: String?, lastname lname: String?, email emailAddress: String?, username user: String?) {
        
        firstname = fname
        lastname = lname
        email = emailAddress
        username = user
    }
    
    
    init (reportData: Dictionary<String, Any>) {
        self.id = reportData["_id"] as? String
        self.firstname = reportData["fname"] as? String
        self.lastname = reportData["lname"] as? String
        self.email = reportData["email"] as? String
        self.username = reportData["username"] as? String
        self.gender = reportData["gender"] as? String
    }
    
    init(fromLogin : Dictionary<String, Any>) {
        
        self.id = fromLogin["_id"] as? String
        self.firstname = fromLogin["fname"] as? String
        self.lastname = fromLogin["lname"] as? String
        self.email = fromLogin["email"] as? String
        self.username = fromLogin["username"] as? String
        self.houseNumber = fromLogin["houseNumber"] as? String
        self.postalCode = fromLogin["postalCode"] as? String
        self.phoneNumber = fromLogin["phoneNumber"] as? String
        self.streetName = fromLogin["streetName"] as? String
        self.city = fromLogin["city"] as? String
        
        self.gender = fromLogin["gender"] as? String
        
    }
    
    init(fromLoginSetting : Dictionary <String, Any>) {
        self.isNotification = fromLoginSetting["isNotification"] as? Bool
        self.vibrate = fromLoginSetting["vibrate"] as? Bool
        self.sound = fromLoginSetting["sound"] as? Bool
        self.radius = fromLoginSetting["radius"] as? Float
    }
    
    // saving users data to local data
    func saveToLocalData() {

        uds.set( self.id, forKey: user_id)
        uds.set( self.firstname!, forKey: user_fname)
        uds.set( self.lastname!, forKey: user_lname)
        uds.set( self.email!, forKey: user_email)
        uds.set( self.username!, forKey: user_username)
        uds.set( self.houseNumber!, forKey: user_house_number)
        uds.set( self.streetName!, forKey: user_street_name)
        uds.set( self.postalCode!, forKey: user_postal_code)
        uds.set( self.city!, forKey: user_city)
        uds.set( self.gender!, forKey: user_gender)
        uds.set( self.phoneNumber!, forKey: user_phone_number)
    }
    
    func saveSettingToLocalData() {
        uds.set( self.isNotification, forKey: user_is_notification)
        uds.set( self.vibrate, forKey: user_vibration)
        uds.set( self.sound, forKey: user_sound)
        uds.set( self.radius, forKey: user_radius)
    }
    
    func removeFromLocalData() {

        uds.removeObject(forKey: user_id)
        uds.removeObject(forKey: user_fname)
        uds.removeObject(forKey: user_lname)
        uds.removeObject(forKey: user_email)
        uds.removeObject(forKey: user_username)
        uds.removeObject(forKey: user_house_number)
        uds.removeObject(forKey: user_street_name)
        uds.removeObject(forKey: user_postal_code)
        uds.removeObject(forKey: user_city)
        uds.removeObject(forKey: user_gender)
        uds.removeObject(forKey: user_phone_number)
    }
    
    func getDataFromUSD(key : String) -> String {
        return uds.string(forKey: key) ?? ""
    }
}
