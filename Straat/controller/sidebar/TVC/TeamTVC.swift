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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
