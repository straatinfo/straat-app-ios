//
//  TeamChatListMemberTVC.swift
//  Straat
//
//  Created by Global Array on 17/01/2020.
//

import UIKit

class TeamChatListMemberTVC: UITableViewCell {

	@IBOutlet weak var memberImage: UIImageView!
	@IBOutlet weak var memberName: UILabel!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var lastConvo: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
