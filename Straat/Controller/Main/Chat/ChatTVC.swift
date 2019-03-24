//
//  ChatTVC.swift
//  Straat
//
//  Created by Global Array on 21/03/2019.
//

import UIKit

class ChatTVC: UITableViewCell {

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

        // Configure the view for the selected state
    }

}
