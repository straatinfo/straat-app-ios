//
//  TeamChatListMemberTVC.swift
//  Straat
//
//  Created by Global Array on 17/01/2020.
//

import UIKit

class TeamChatListMemberTVC: UITableViewCell {

	@IBOutlet weak var memberImage: UIImageView!
	@IBOutlet weak var memberName: UILabel!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var lastConvo: UILabel!
	
	var reporterId: String?
	var convoId: String?

	
	var teamId: String?
	var teamName: String?
	var type: String = "TEAM"
	var conversationId: String?
	var userId: String?
	var chatTitle: String?

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		saveDetails()
        // Configure the view for the selected state
    }
	
	func saveDetails() -> Void {
		let uds = UserDefaults.standard
		uds.removeObject(forKey: chat_vc_team_id)
		uds.removeObject(forKey: chat_vc_team_name)
		uds.removeObject(forKey: chat_vc_type)
		uds.removeObject(forKey: chat_vc_conversation_id)
		uds.removeObject(forKey: chat_vc_user_id)
		uds.removeObject(forKey: chat_vc_title)
		
		uds.set(teamId, forKey: chat_vc_team_id)
		uds.set(teamName, forKey: chat_vc_team_name)
		uds.set(type, forKey: chat_vc_type)
		uds.set(conversationId, forKey: chat_vc_conversation_id)
		uds.set(userId, forKey: chat_vc_user_id)
		uds.set(chatTitle, forKey: chat_vc_title)
	}

}
