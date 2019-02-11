//
//  TeamListModel.swift
//  Straat
//
//  Created by Global Array on 11/02/2019.
//

import Foundation

class TeamListModel {
    var id : String?
    var name : String?
    var email : String?
    
    init(teamID : String? , teamName : String? , teamEmail : String?) {
        id = teamID
        name = teamName
        email = teamEmail
    }
}
