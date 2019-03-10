//
//  TeamService.swift
//  Straat
//
//  Created by John Higgins M. Avila on 09/03/2019.
//

import Foundation
import Alamofire

class TeamService {
    let apiHandler = ApiHandler()
    
    init () {
        
    }
    
    func getTeamList (userId: String, completion: @escaping (Bool, String, [TeamModel]?) -> Void) {
        let url = team_list + userId
        
        apiHandler.executeWithHeaders(URL(string: url)!, parameters: [:], method: .get, destination: .queryString, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription, nil)
            } else if let data = response {
                let dataObject = data["data"] as? [[String:Any]] ?? []
                var teamModel = [TeamModel]()
                
                if dataObject.count > 0 {
                    
                    for teamModels in dataObject {
                        let teamModelItem = TeamModel(fromMyTeam: teamModels)
                        teamModel.append(teamModelItem)
                    }
                    
                    completion(true, "Success", teamModel)
                } else {
                    completion(false, "Failed", nil)
                }
                
            }
        }
    }
    
    func updateTeam (teamId: String, teamName: String, teamEmail: String, img: Data?, completion: @escaping (Bool, String) -> Void) {
        var parameters: Parameters = [:]
        parameters["teamName"] = teamName
        parameters["teamEmail"] = teamEmail
    
        
        let url = URL(string: update_team + teamId)
        
        apiHandler.executeMultiPart(url!, parameters: parameters, imageData: img, fileName: teamName, photoFieldName: "team-logo", pathExtension: ".jpeg", method: .put, headers: [:]) { (response, err) in
            // go to main view
            if let error = err {
                print("Error response: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                completion(true, "Success")
            }
        }
    }
}
