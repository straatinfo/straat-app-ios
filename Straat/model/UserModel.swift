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
    
    init (firstname fname: String?, lastname lname: String?, email emailAddress: String?, username user: String?) {
        
        firstname = fname
        lastname = lname
        email = emailAddress
        username = user
    }
    
}
