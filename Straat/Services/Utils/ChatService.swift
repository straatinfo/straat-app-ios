//
//  ChatService.swift
//  Straat
//
//  Created by Global Array on 21/03/2019.
//

import Foundation
import Alamofire

class ChatService {

    let apiHandler = ApiHandler()
    
    init () {
        
    }
    
    // for my reports
    func getReportConversation (userId: String, conversationId: String, completion: @escaping (Bool, String, [ChatModel]?) -> Void) {
		
        var parameters: Parameters = [:]
        parameters["_conversation"] = conversationId
        parameters["keyword"] = "all"
        parameters["_reporter"] = userId
        
        apiHandler.executeWithHeaders(URL(string: chat_list)!, parameters: parameters, method: .get, destination: .queryString, headers: [:]) { (response, err) in
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription, [])
            } else if let data = response {
                let dataObject = data["payload"] as? [[String: Any]] ?? []
                var chatModel: [ChatModel] = []
//                debugPrint("debug: \(dataObject)")
				
                if dataObject.count > 0 {
                    for conversations in dataObject {
                        let conversation = ChatModel(conversation: conversations)

                        chatModel.append(conversation)
                    }
                    completion(true, "Success", chatModel)

                } else {
                    completion(false, "Empty Chat", nil)
                }
			
            }
        }
    }
	
	// for my reports
	func getTeamMemberConversation (userId: String, completion: @escaping (Bool, String, [ChatModel]?) -> Void) {
		
		var parameters: Parameters = [:]
		parameters["_user"] = userId
		
		apiHandler.executeWithHeaders(URL(string: team_chat_list)!, parameters: parameters, method: .get, destination: .queryString, headers: [:]) { (response, err) in
			if let error = err {
				print("error reponse: \(error.localizedDescription)")
				
				completion(false, error.localizedDescription, [])
			} else if let data = response {
				let dataObject = data["payload"] as? [[String: Any]] ?? []
				var chatModel: [ChatModel] = []
				
//				                debugPrint("debug: \(dataObject)")
				
				if dataObject.count > 0 {
					for conversations in dataObject {

						debugPrint("debug team chat: \(conversations)")
						let conversation = ChatModel(teamMemberConversation: conversations)
						chatModel.append(conversation)
					}
					completion(true, "Success", chatModel)
					
				} else {
					completion(false, "Empty Chat", nil)
				}
				
			}
		}
	}
	
	// for my reports
	func sendMessage (authorId: String, message: String, conversationId: String, completion: @escaping (Bool, String) -> Void) {
		let url = send_message + conversationId
		
		var parameters: Parameters = [:]
		parameters["_author"] = authorId
		parameters["body"] = message
		
		apiHandler.executeWithHeaders(URL(string: url)!, parameters: parameters, method: .post, destination: .httpBody, headers: [:]) { (response, err) in
			if let error = err {
				print("error reponse: \(error.localizedDescription)")
				completion(false, "Message not send")
				
			} else if let data = response {
				let statusCode = data["statusCode"] as? Double
				
				if statusCode == 200 {
					completion(true, "Successfully sent")					
				} else {
					completion(false, "Message not send")
				}
				
			}
		}
	}
	
	// for my reports
	func createConverstation (authorId: String, chatee: String, completion: @escaping (Bool, String, String?) -> Void) {
		
		var parameters: Parameters = [:]
		parameters["_author"] = authorId
		parameters["_chatee"] = chatee
		
		apiHandler.executeWithHeaders(URL(string: create_conversation)!, parameters: parameters, method: .post, destination: .httpBody, headers: [:]) { (response, err) in
			if let error = err {
				print("error reponse create convo: \(error.localizedDescription)")
				completion(false, error.localizedDescription, nil)
				
			} else if let data = response {
				let dataObject = data["payload"] as? Dictionary<String,Any>
				
				if dataObject?.count ?? 0 > 0 {
					let conversationId = dataObject?["_id"] as? String? ?? ""
					completion(true, "Successfully created conversation",conversationId!)
				} else {
					completion(false, "Problem in Creating Conversation", nil)
				}
				
			}
		}
	}
    
}
