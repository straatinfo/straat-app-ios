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
    
    init(conversation: Dictionary<String,Any>) {
        self.convoId = conversation["_conversation"] as? String? ?? ""
        self.body = conversation["body"] as? String? ?? ""
		self.createdAt = conversation["createdAt"] as? String? ?? ""
		
        let author = conversation["_author"] as? Dictionary<String,Any> ?? [:]
        self.author = AuthorModel(author: author)
    }
    
    
}

class AuthorModel {
    var id: String?
    var fname: String?
    var lname: String?
    var userName: String?
    
    init(author: Dictionary<String,Any>) {
        self.id = author["_id"] as? String? ?? ""
        self.fname = author["fname"] as? String? ?? ""
        self.lname = author["lname"] as? String? ?? ""
        self.userName = author["username"] as? String? ?? ""
    }
}
