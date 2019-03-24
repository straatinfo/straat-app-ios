//
//  TeamMemberTVC.swift
//  Straat
//
//  Created by Global Array on 02/03/2019.
//

import UIKit

class TeamMemberTVC: UITableViewCell {

    @IBOutlet weak var teamMemberName: UILabel!
	var teamMemberId: String?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
	@IBAction func openConversation(_ sender: UIButton) {
		let uds = UserDefaults.standard
		uds.set(self.teamMemberId, forKey: team_member_id)
		
		debugPrint("team_member_id: \(self.teamMemberId)")
	}
	
}
