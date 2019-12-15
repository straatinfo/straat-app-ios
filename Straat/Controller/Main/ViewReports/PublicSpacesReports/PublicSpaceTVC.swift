//
//  PublicSpaceTVC.swift
//  Straat
//
//  Created by Global Array on 15/02/2019.
//

import UIKit

class PublicSpaceTVC: UITableViewCell {

    
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
    
    /*
     let userId = uds.string(forKey: user_id) ?? ""
     let reporterId = uds.string(forKey: reporter_id) ?? ""
     let conversationId = uds.string(forKey: chat_vc_conversation_id) ?? ""
     let chatTitile = uds.string(forKey: chat_vc_title) ?? ""
     let chatType = uds.string(forKey: chat_vc_type) ?? ""
     let teamId = uds.string(forKey: chat_vc_team_id)
     let reportId = uds.string(forKey: chat_vc_report_id)
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("CONVERSATION_ID: \(conversationId ?? "EMPTY")")
        // Configure the view for the selected state
    }

    @IBAction func chatShow(_ sender: Any) {
        let uds = UserDefaults.standard
        
        uds.set(userId, forKey: chat_vc_user_id)
        uds.set(conversationId, forKey: chat_vc_conversation_id)
        uds.set(type, forKey: chat_vc_type)
        uds.set(chatTitle, forKey: chat_vc_title)
        uds.set(reportId, forKey: chat_vc_report_id)
    }
}
