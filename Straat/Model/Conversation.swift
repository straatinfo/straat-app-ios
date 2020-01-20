//
//  Conversation.swift
//  Straat
//
//  Created by Global Array on 20/01/2020.
//

import Foundation
import SwiftyJSON

class Conversation {
	var id: String? = ""
	var type: String? = ""
	var messagePreview: JSON?
	var chatMate: JSON?
	var chatName: String? = ""
	var unreadMessageCount: Int = 0
	var profilePicUrl: String? = ""
	
	init() {
		
	}
	
	init(conversation: JSON) {
//		this.id = if (jsonObject.has("_id")) jsonObject.getString("_id") else null
//		this.type = if (jsonObject.has("type")) jsonObject.getString("type") else null
//		this.messagePreview = if (jsonObject.has("messagePreview")) jsonObject.getJSONObject("messagePreview") else null
//		this.chatMate = if (jsonObject.has("chatMate")) jsonObject.getJSONObject("chatMate") else null
//
//		this.unreadMessageCount = if (jsonObject.has("unreadMessageCount")) jsonObject.getInt("unreadMessageCount") else 0
//
//		if (jsonObject.has("chatMate")) {
//			val chatMate = if (jsonObject.has("chatMate")) jsonObject.getJSONObject("chatMate") else null
//			if (chatMate != null) {
//				this.chatName = if (chatMate.has("username")) chatMate.getString("username") else null
//				val profilePic = if (chatMate.has("_profilePic")) chatMate.getJSONObject("_profilePic") as JSONObject else null
//				if (profilePic != null) {
//					this.profilePicUrl = if (profilePic.has("secure_url")) profilePic.getString("secure_url") else null
//				}
//			}
//		}
//
//		if (jsonObject.has("type") && jsonObject.getString("type") == "TEAM") {
//			this.profilePicUrl = if (jsonObject.has("profilePicUrl")) jsonObject.getString("profilePicUrl") else null
//			this.chatName = if (jsonObject.has("chatName")) jsonObject.getString("chatName") else null
//		}
		
		self.id = conversation["_id"].stringValue
		self.type = conversation["type"].stringValue
		self.messagePreview = conversation["messagePreview"]
		self.chatMate = conversation["chatMate"]
		self.unreadMessageCount = conversation["unreadMessageCount"].intValue
		
		if self.chatMate != nil || self.chatMate!.count > 0 {
			self.chatName = self.chatMate!["username"].stringValue
			let profilePic = self.chatMate!["_profilePic"]
			
			if profilePic != "" {
				self.profilePicUrl = profilePic["secure_url"].stringValue
			}
		}
		
		if self.type == "TEAM" {
			self.profilePicUrl = conversation["profilePicUrl"].stringValue
			self.chatName = conversation["chatName"].stringValue
		}
		
	}
}
