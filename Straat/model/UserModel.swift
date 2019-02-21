//
//  UserModel.swift
//  Straat
//
//  Created by Global Array on 06/02/2019.
//

import Foundation


class UserModel {
    
    var firstname: String?
    var lastname: String?
    var email: String?
    var username: String?
    
    var id: String?
    var gender: String?
    
    
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
    
    
}
