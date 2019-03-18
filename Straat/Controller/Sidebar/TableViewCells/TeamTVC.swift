//
//  TeamTVC.swift
//  Straat
//
//  Created by Global Array on 01/03/2019.
//

import UIKit

class TeamTVC: UITableViewCell {
    
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamEmail: UILabel!
    @IBOutlet weak var teamMemberCount: UILabel!
    @IBOutlet weak var viewMemberRequest: UIButton!
    var teamId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.teamMemberCount.isHidden = true
        self.viewMemberRequest.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func viewMemberRequestTapped(_ sender: UIButton) {
        let uds = UserDefaults.standard
        uds.set(self.teamId, forKey: team_id)
        
        debugPrint("teamId: \(teamId)")
    }
}
