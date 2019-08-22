//
//  UserModel.swift
//  Straat
//
//  Created by Global Array on 06/02/2019.
//

import Foundation
import SwiftyJSON


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
    
    var team_id: String?
    var team_name: String?
    var team_email: String?
	var team_is_approved: Bool?
    var team_is_volunteer: Bool?
	
    var host_id: String?
    var host_name: String?
    var host_email: String?
    var host_long: Double?
    var host_lat: Double?
    var host: HostModel?
    
    
    var isVolunteer: Bool?

	// active design
	var colorOne: String?
	var colorTwo: String?
	var colorThree: String?
	var profileImageUrl: String?
    
    var userToken: String?
	
    let uds = UserDefaults.standard
    
    init() {
        self.id = uds.string(forKey: user_id)
        self.firstname = uds.string(forKey: user_fname)
        self.lastname = uds.string(forKey: user_lname)
        self.email = uds.string(forKey: user_email)
        self.username = uds.string(forKey: user_username)
        self.houseNumber = uds.string(forKey: user_house_number)
        self.postalCode = uds.string(forKey: user_postal_code)
        self.phoneNumber = uds.string(forKey: user_phone_number)
        self.streetName = uds.string(forKey: user_street_name)
        self.city = uds.string(forKey: user_city)
        self.gender = uds.string(forKey: user_gender)
        self.isVolunteer = uds.bool(forKey: user_is_volunteer)
        self.profileImageUrl = uds.string(forKey: user_actdes_image_url)
        self.host_id = uds.string(forKey: user_host_id)
        self.host_name = uds.string(forKey: user_host_name)
        self.host_email = uds.string(forKey: user_host_email)
        self.host_long = uds.double(forKey: user_host_long)
        self.host_lat = uds.double(forKey: user_host_lat)
        self.userToken = uds.string(forKey: token)
    }
    
    init (fromUds: Bool) {
        if fromUds {
            self.id = uds.string(forKey: user_id)
            self.firstname = uds.string(forKey: user_fname)
            self.lastname = uds.string(forKey: user_lname)
            self.email = uds.string(forKey: user_email)
            self.username = uds.string(forKey: user_username)
            self.houseNumber = uds.string(forKey: user_house_number)
            self.postalCode = uds.string(forKey: user_postal_code)
            self.phoneNumber = uds.string(forKey: user_phone_number)
            self.streetName = uds.string(forKey: user_street_name)
            self.city = uds.string(forKey: user_city)
            self.gender = uds.string(forKey: user_gender)
            self.isVolunteer = uds.bool(forKey: user_is_volunteer)
            self.profileImageUrl = uds.string(forKey: user_actdes_image_url)
            self.host_id = uds.string(forKey: user_host_id)
            self.host_name = uds.string(forKey: user_host_name)
            self.host_email = uds.string(forKey: user_host_email)
            self.host_long = uds.double(forKey: user_host_long)
            self.host_lat = uds.double(forKey: user_host_lat)
            self.userToken = uds.string(forKey: token)
        }
    }
    
    init (json: JSON) {
        self.id = json["_id"].string
        self.firstname = json["fname"].string
        self.lastname = json["lname"].string
        self.email = json["email"].string
        self.username = json["username"].string
        self.houseNumber = json["houseNumber"].string
        self.postalCode = json["postalCode"].string
        self.phoneNumber = json["phoneNumber"].string
        self.streetName = json["streetName"].string
        self.city = json["city"].string
        self.gender = json["gender"].string
        
        let profilePicObject = json["_profilePic"]
        
        if (profilePicObject["secure_url"].exists()) {
            let secureUrl = profilePicObject["secure_url"].string
            
            if (secureUrl != nil) {
                self.profileImageUrl = secureUrl
            }
        }
        
        if json["_host"].exists() {
            let host = json["_host"]
            if host["_id"].exists() {
                self.host = HostModel(json: json["_host"])
            }
            
            if let hostId = host["_id"].string {
                self.host_id = hostId
            }
            
            if let hostName = host["hostName"].string {
                self.host_name = hostName
            }
            
            if let hostEmail = host["email"].string {
                self.host_email = hostEmail
            }
            
            if let hostLong = host["long"].double {
                self.host_long = hostLong
            }
            
            if let hostLat = host["lat"].double {
                self.host_lat = hostLat
            }
        }
        
        if json["_activeTeam"].exists() {
            let team = json["_activeTeam"]
            if let teamId = team["_id"].string {
                print("TEAM_ID: \(teamId)")
                self.team_id = teamId
            }
            
            if let teamName = team["teamName"].string {
                print("TEAM_NAME: \(teamName)")
                self.team_name = teamName
            }
            
            if let teamEmail = team["teamEmail"].string {
                print("TEAM_NAME: \(teamEmail)")
                self.team_email = teamEmail
            }
            
            if let teamIsApproved = team["isApproved"].bool {
                self.team_is_approved = teamIsApproved
            }
            
            if let teamIsVolunteer = team["isVolunteer"].bool {
                self.team_is_volunteer = teamIsVolunteer
            }
        }
        
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
        self.isVolunteer = fromLogin["isVolunteer"] as? Bool
        
        let profilePicObject = fromLogin["_profilePic"] as? Dictionary <String, Any> ?? nil
        
        if (profilePicObject != nil) {
            let secureUrl = profilePicObject?["secure_url"] as? String
            
            if (secureUrl != nil) {
                self.profileImageUrl = secureUrl
            }
        }
        
        let hostData = fromLogin["_host"] as? Dictionary <String, Any> ?? nil
        
        if (hostData != nil) {
            if let hostId = hostData?["_id"] {
                self.host_id = hostId as? String
            }
            if let hostName = hostData?["hostName"] {
                self.host_name = hostName as? String
            }
            if let hostEmail = hostData?["email"] {
                self.host_email = hostEmail as? String
            }
            if let hostLong = hostData?["long"] {
                self.host_long = hostLong as? Double
            }
            if let hostLat = hostData?["lat"] {
                self.host_lat = hostLat as? Double
            }
            
        }
    }
    
    init(fromLoginSetting : Dictionary <String, Any>) {
        self.isNotification = fromLoginSetting["isNotification"] as? Bool
        self.vibrate = fromLoginSetting["vibrate"] as? Bool
        self.sound = fromLoginSetting["sound"] as? Bool
        self.radius = fromLoginSetting["radius"] as? Float
    }

    // init(fromUserDefaults: Bool) {
    //     if fromUserDefaults {
    //         self.id = uds.string(forKey: user_id)
    //         self.firstname = uds.string(forKey: user_fname)
    //         self.lastname = uds.string(forKey: user_fname)
    //     }
    // }
    
    init(fromLoginTeam: Dictionary <String, Any>) {
        self.team_id = fromLoginTeam["_id"] as? String
        self.team_name = fromLoginTeam["teamName"] as? String
        self.team_email = fromLoginTeam["teamEmail"] as? String
        self.team_is_approved = fromLoginTeam["isApproved"] as? Bool
    }
    
	init(fromLoginHostId: String, fromLoginIsVolunteer: Bool) {
        self.host_id = fromLoginHostId
        self.isVolunteer = fromLoginIsVolunteer
    }
	
	init (fromLoginActiveDesign: Dictionary<String, Any>) {
		self.colorOne = fromLoginActiveDesign["colorOne"] as? String ?? ""
		self.colorTwo = fromLoginActiveDesign["colorTwo"] as? String ?? ""
		
		let profilePicObj = fromLoginActiveDesign["_profilePic"] as? [String:Any] ?? [:]
//        self.profileImageUrl = profilePicObj["secure_url"] as? String ?? ""
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
        uds.set( self.profileImageUrl, forKey: user_actdes_image_url)
        uds.set( self.isVolunteer, forKey: user_is_volunteer)
        
        uds.set(self.host_id, forKey: user_host_id)
        uds.set(self.host_name, forKey: user_host_name)
        uds.set(self.host_email, forKey: user_host_email)
        uds.set(self.host_long, forKey: user_host_long)
        uds.set(self.host_lat, forKey: user_host_lat)
        
        uds.set( self.isNotification, forKey: user_is_notification)
        uds.set( self.vibrate, forKey: user_vibration)
        uds.set( self.sound, forKey: user_sound)
        uds.set( self.radius, forKey: user_radius)
        
        uds.set( self.team_id, forKey: user_team_id)
        uds.set( self.team_name, forKey: user_team_name)
        uds.set( self.team_email, forKey: user_team_email)
        uds.set( self.team_is_approved, forKey: user_team_is_approved)
        
        uds.set( self.host_id, forKey: user_host_id)
        uds.set( self.isVolunteer, forKey: user_is_volunteer)
        
        uds.set( self.colorOne, forKey: user_actdes_color_one)
        uds.set( self.colorTwo, forKey: user_actdes_color_two)
        
        // uds.set(self.userToken, forKey: token)
    }
    
    func saveSettingToLocalData() {
        uds.set( self.isNotification, forKey: user_is_notification)
        uds.set( self.vibrate, forKey: user_vibration)
        uds.set( self.sound, forKey: user_sound)
        uds.set( self.radius, forKey: user_radius)
    }
    
    func saveTeamToLocalData() {
        uds.set( self.team_id, forKey: user_team_id)
        uds.set( self.team_name, forKey: user_team_name)
        uds.set( self.team_email, forKey: user_team_email)
		uds.set( self.team_is_approved, forKey: user_team_is_approved)
    }
    
    func saveOtherToLocalData() {
        uds.set( self.host_id, forKey: user_host_id)
        uds.set( self.isVolunteer, forKey: user_is_volunteer)
    }
	
	func saveActiveDesignToLocalData() {
		uds.set( self.colorOne, forKey: user_actdes_color_one)
		uds.set( self.colorTwo, forKey: user_actdes_color_two)
		// uds.set( self.profileImageUrl, forKey: user_actdes_image_url)
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

class ActiveDesignModel {
	var profileImageUrl: String?
	
	init() {
		
	}
	
	init(activeDesign: Dictionary<String,Any>) {
		let activeDesignObj = activeDesign["_profilePic"] as? [String:Any] ?? [:]
		self.profileImageUrl = activeDesignObj["secure_url"] as? String ?? ""
	}
}
