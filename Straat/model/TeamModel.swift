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
    
    var leaderID: String?
    var profilePic: String?
    
    init(teamId: String?, teamName: String?, teamEmail: String?) {
        self.teamId = teamId
        self.teamName = teamName
        self.teamEmail = teamEmail
    }
    
    init(fromMyTeam: Dictionary<String, Any>) {
        let profilePicObj = fromMyTeam["_profilePic"] as? [String: Any] ?? nil
        
        self.teamId = fromMyTeam["_id"] as? String
        self.teamName = fromMyTeam["teamName"] as? String
        self.teamEmail = fromMyTeam["teamEmail"] as? String
        
        if profilePicObj != nil {
            self.profilePic = profilePicObj!["secure_url"] as? String
        }
        

        
    }
    
}
