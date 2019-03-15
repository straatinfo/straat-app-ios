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
    
    func getTeamRequest(teamId : String, completion: @escaping (Bool, String, [TeamModel]?)->Void) {
        let url = team_request + teamId
     
        apiHandler.executeWithHeaders(URL(string: url)!, parameters: [:], method: .get, destination: .queryString, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription, nil)
            } else if let data = response {
                
                let dataObject = data["data"] as? [[String:Any]] ?? []
                var teamRequestModel = [TeamModel]()
                
                if dataObject.count > 0 {
                    
                    for teamRequestModels in dataObject {
                        let teamRequestUsers = teamRequestModels["_user"] as? Dictionary<String,Any> ?? [:]
                        let requestId = teamRequestModels["_id"] as? String ?? ""

                        let teamRequestModelItem = TeamModel(fromTeamRequest: teamRequestUsers, requestId: requestId)
                        teamRequestModel.append(teamRequestModelItem)
                    }
                    
                    completion(true, "Success", teamRequestModel)
                } else {
                    completion(false, "Failed", nil)
                }
                
            }
        }
    }
    
    func getTeamMembers(teamId : String, completion: @escaping (Bool, String, [TeamModel]?)->Void) {
        let url = team_info_members + teamId
        
        apiHandler.executeWithHeaders(URL(string: url)!, parameters: [:], method: .get, destination: .queryString, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                completion(false, error.localizedDescription, nil)
                
            } else if let data = response {
                
                let dataObject = data["data"] as? Dictionary<String,Any> ?? [:]
                var teamMemberModels = [TeamModel]()
                
                debugPrint("dataobject: \(dataObject)")
                
                if dataObject.count > 0 {
                    let teamMemberObject = dataObject["teamMembers"] as? [[String:Any]] ?? []
                    
                    for teamMemberModel in teamMemberObject {
                        let teamMembers = teamMemberModel["_user"] as? Dictionary<String,Any> ?? [:]
                        let teamMemberModelItem = TeamModel(fromTeamMembers: teamMembers)
                        teamMemberModels.append(teamMemberModelItem)

                     }

                    completion(true, "Success", teamMemberModels)
                } else {
                    completion(false, "Failed", nil)
                }
                
            }
        }
    }
    
    func acceptMember (teamId: String, userId: String, completion: @escaping (Bool, String) ->Void) -> Void {
        let url = team_accept_user + userId + "/" + teamId
        debugPrint("url: \(url)")
        apiHandler.executeWithHeaders(URL(string: url)!, parameters: [:], method: .get, destination: .queryString, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                completion(false, error.localizedDescription)                
            } else {
                completion(true, "Success")
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
