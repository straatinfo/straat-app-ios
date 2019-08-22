//
//  ChatService.swift
//  Straat
//
//  Created by Global Array on 21/03/2019.
//

import Foundation
import Alamofire
import SwiftyJSON

class ChatService {

    let apiHandler = ApiHandler()
    let uds = UserDefaults.standard
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
				let dataObject = data["payload"] as? Dictionary<String,Any> ?? [:]
				
				if dataObject.count > 0 {
					let conversationId = dataObject["_id"] as? String? ?? ""
					completion(true, "Successfully created conversation",conversationId!)
				} else {
					completion(false, "Problem in Creating Conversation", nil)
				}
				
			}
		}
	}
    
    // remove unread messages
    func readUnreadMessages (conversationId: String, userId: String, completion: @escaping (Bool, String?) -> Void) -> Void {
        let url = "\(unread_messages)/\(conversationId)/\(userId)"
        let user = UserModel()
        var parameters: Parameters = [:]
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(user.userToken ?? "")"
        
        apiHandler.executeWithHeaders(URL(string: url)!, parameters: parameters, method: .delete, destination: .queryString, headers: headers) { (response, err) in
            
            if let error = err {
                completion(false, error.localizedDescription)
            } else if let data = response {
                completion(true, nil)
            }
        }
    }
    
    func getUnreadMessageCount (userId: String, completion: @escaping(Bool, JSON?) -> Void) {
        let url = "\(get_unread_message_count)/\(userId)"
        // print("LOADING_GETUNREAD_MSG_COUNT")
        let user = UserModel()
        var parameters: Parameters = [:]
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(user.userToken ?? "")"
        
        apiHandler.executeWithHeaders(URL(string: url)!, parameters: parameters, method: .get, destination: .queryString, headers: headers) { (response, err) in
            // print("LOADING_GETUNREAD_MSG_COUNT_DATA: \(response), err: \(err)")
            if let error = err {
                completion(false, nil)
            } else {
                let data = JSON(response)
                if data["a"].exists() && data["b"].exists() && data["team"].exists() {
                    completion(true, data)
                } else {
                    completion(false, nil)
                }
            }
            
            
        }
    }
    
}
