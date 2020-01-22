//
//  SuspiciousTVC.swift
//  Straat
//
//  Created by Global Array on 24/02/2019.
//

import UIKit

class SuspiciousTVC: UITableViewCell {


    @IBOutlet weak var reportCategory: UILabel!
    @IBOutlet weak var dateOfReport: UILabel!
    @IBOutlet weak var messageCount: UILabel!
    @IBOutlet weak var reportImage: UIImageView!
    @IBOutlet weak var isUrgentMarker: UILabel!
    
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

    @IBAction func messageShow(_ sender: Any) {
		let uds = UserDefaults.standard
		uds.removeObject(forKey: chat_vc_user_id)
		uds.removeObject(forKey: chat_vc_conversation_id)
		uds.removeObject(forKey: chat_vc_type)
		uds.removeObject(forKey: chat_vc_title)
		uds.removeObject(forKey: chat_vc_report_id)
		
        uds.set(userId, forKey: chat_vc_user_id)
        uds.set(conversationId, forKey: chat_vc_conversation_id)
        uds.set(type, forKey: chat_vc_type)
        uds.set(chatTitle, forKey: chat_vc_title)
        uds.set(reportId, forKey: chat_vc_report_id)
    }
    
}
