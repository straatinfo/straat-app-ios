//
//  TeamModel.swift
//  Straat
//
//  Created by John Higgins M. Avila on 12/02/2019.
//

import Foundation

class TeamModel {
    var teamId: String?
    var teamName: String?
    var teamEmail: String?
    
    init(teamId: String?, teamName: String?, teamEmail: String?) {
        self.teamId = teamId
        self.teamName = teamName
        self.teamEmail = teamEmail
    }
}
