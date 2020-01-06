//
//  TeamChatListTVC.swift
//  Straat
//
//  Created by Global Array on 25/03/2019.
//

import UIKit

class TeamChatListTVC: UITableViewCell {

	@IBOutlet weak var teamName: UILabel!
	@IBOutlet weak var teamEmail: UILabel!
	@IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var messageCounter: UILabel!
    
    var reporterId: String?
	var convoId: String?
    var conversationId: String?
    var type = "TEAM"
    var teamId: String?
    var chatTitle: String?
    var userId: String?
    
	override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		let uds = UserDefaults.standard
		
		uds.set(userId, forKey: chat_vc_user_id)
		uds.set(conversationId, forKey: chat_vc_conversation_id)
        uds.set(type, forKey: chat_vc_type)
        uds.set(chatTitle, forKey: chat_vc_title)
        uds.set(teamId, forKey: chat_vc_team_id)
        // uds.set()
        
        /*
         let userId = uds.string(forKey: user_id) ?? ""
         let reporterId = uds.string(forKey: reporter_id) ?? ""
         let conversationId = uds.string(forKey: report_conversation_id) ?? ""
         let chatTitile = uds.string(forKey: chat_vc_title) ?? ""
         let chatType = uds.string(forKey: chat_vc_type) ?? ""
         let teamId = uds.string(forKey: chat_vc_team_id)
         let reportId = uds.string(forKey: chat_vc_report_id)
         */

    }

}
