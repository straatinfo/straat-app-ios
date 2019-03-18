//
//  TeamMemberRequestTVC.swift
//  Straat
//
//  Created by Global Array on 14/03/2019.
//

import UIKit

class TeamMemberRequestTVC: UITableViewCell {

    @IBOutlet weak var teamMemberName: UILabel!
    var userId: String?
    var memberRequestDele: MemberRequestDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func acceptUser(_ sender: UIButton) {
        
        let teamService = TeamService()
        let uds = UserDefaults.standard
        let teamId = uds.string(forKey: team_id) ?? ""

        teamService.acceptMember(teamId: teamId, userId: self.userId!) { (success, message) in
            if success == true {
                self.memberRequestDele?.result(title: "Accepting Member", message: message)
                debugPrint("accepting: \(message)")
            } else {
                self.memberRequestDele?.result(title: "Accepting Member", message: message)
                debugPrint("error: \(message)")
            }
        }
//        debugPrint("teamId: \(teamId)")
//        debugPrint("userId: \(self.userId)")
        
        
    }
}

protocol MemberRequestDelegate {
    func result(title: String, message: String) -> Void
}
