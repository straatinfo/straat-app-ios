//
//  ConversationModel.swift
//  Straat
//
//  Created by Global Array on 21/03/2019.
//

import Foundation

class ChatModel {
    var convoId: String? // _conversation _id
    var createdAt: String?
    var author: AuthorModel?
    var body: String?
	
	var imageUrl: String? // for chat tab
	init() {
		
	}
	
    init(conversation: Dictionary<String,Any>) {
        self.convoId = conversation["_conversation"] as? String? ?? ""
        self.body = conversation["body"] as? String? ?? ""
		self.createdAt = conversation["createdAt"] as? String? ?? ""
		
        let author = conversation["_author"] as? Dictionary<String,Any> ?? [:]
        self.author = AuthorModel(author: author)
    }
	
	init(teamMemberConversation: Dictionary<String,Any>) {
		let messageObj = teamMemberConversation["messages"] as? [[String:Any]] ?? []

		for msgObj in messageObj {
			
			let latestSenderObj = msgObj["_author"] as? [String:Any] ?? [:]
			let userSender = latestSenderObj["username"] as? String ?? ""
			let msg = msgObj["body"] as? String? ?? ""
			
			self.convoId = msgObj["_conversation"] as? String? ?? ""
			self.body = "\(userSender): \(msg ?? "")"
			self.createdAt = msgObj["createdAt"] as? String? ?? ""

		}
		
		let authorObj = teamMemberConversation["participants"] as? [[String:Any]] ?? []
		self.author = AuthorModel(userTeamConversations: authorObj)
		
		let profilePicObj = teamMemberConversation["_profilePic"] as? [String:Any] ?? [:]
		self.imageUrl = profilePicObj["secure_url"] as? String ?? ""
		debugPrint("payload image: \(self.imageUrl)")
	}
	
	
    
    
}

class AuthorModel {
    var id: String?
    var fname: String?
    var lname: String?
    var userName: String?
	var imageUrl: String? // for chat tab
	
	init() {
	}
	
    init(author: Dictionary<String,Any>) {
        self.id = author["_id"] as? String? ?? ""
        self.fname = author["fname"] as? String? ?? ""
        self.lname = author["lname"] as? String? ?? ""
        self.userName = author["username"] as? String? ?? ""
		

    }
	
	init(userTeamConversations: [[String:Any]]) {
		
		for userTeamConvo in userTeamConversations {
			let userObj = userTeamConvo["_user"] as? [String:Any] ?? [:]
			let imageUrlObj = userObj["_profilePic"] as? [String:Any] ?? [:]
			
			self.id = userObj["_id"] as? String? ?? ""
			self.userName = userObj["username"] as? String? ?? ""
			self.imageUrl = imageUrlObj["secure_url"] as? String ?? ""
//			debugPrint("profile image obj: \(self.imageUrl)")
		}
		
		
	}
}
