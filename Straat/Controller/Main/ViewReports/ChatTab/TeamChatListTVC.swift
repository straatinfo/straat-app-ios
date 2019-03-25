//
//  TeamChatListTVC.swift
//  Straat
//
//  Created by Global Array on 25/03/2019.
//

import UIKit

class TeamChatListTVC: UITableViewCell {

	@IBOutlet weak var teamName: UILabel!
	@IBOutlet weak var teamLatestMessage: UILabel!
	@IBOutlet weak var teamLogo: UIImageView!
	
	var reporterId: String?
	var convoId: String?
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

		let uds = UserDefaults.standard
		
		uds.set(reporterId, forKey: reporter_id)
		uds.set(convoId, forKey: report_conversation_id)

    }

}
