//
//  GovernmentTVC.swift
//  Straat
//
//  Created by Global Array on 12/01/2020.
//

import UIKit

class GovernmentTVC: UITableViewCell {
	
	@IBOutlet weak var reportCategory: UILabel!
	@IBOutlet weak var dateOfReport: UILabel!
	@IBOutlet weak var messageCount: UILabel!
	
	@IBOutlet weak var reportImage: UIImageView!
	
	var reportId: String?
	var conversationId: String?
	var type = "REPORT"
	var chatTitle: String?
	var userId: String?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

	@IBAction func messageShow(_ sender: UIButton) {
		let uds = UserDefaults.standard
		uds.set(userId, forKey: chat_vc_user_id)
		uds.set(conversationId, forKey: chat_vc_conversation_id)
		uds.set(type, forKey: chat_vc_type)
		uds.set(chatTitle, forKey: chat_vc_title)
		uds.set(reportId, forKey: chat_vc_report_id)
		
		debugPrint("message selected")
	}
}
