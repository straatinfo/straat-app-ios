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
    
    var reportId: String?
    var conversationId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func chatShow(_ sender: Any) {
        let uds = UserDefaults.standard
        uds.set(self.reportId, forKey: reporter_id)
        uds.set(self.conversationId, forKey: report_conversation_id)
    }
}
