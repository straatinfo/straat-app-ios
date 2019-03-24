//
//  TeamChatTVC.swift
//  Straat
//
//  Created by Global Array on 23/03/2019.
//

import UIKit

class TeamChatTVC: UITableViewCell {

	@IBOutlet weak var otherUsername: UILabel!
	@IBOutlet weak var otherMessage: UILabel!
	@IBOutlet weak var otherTime: UILabel!
	@IBOutlet weak var yourMessage: UILabel!
	@IBOutlet weak var yourTime: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
