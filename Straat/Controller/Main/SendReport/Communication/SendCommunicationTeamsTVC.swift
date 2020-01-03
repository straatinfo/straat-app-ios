//
//  SendCommunicationTeamsTVC.swift
//  Straat
//
//  Created by Global Array on 25/12/2019.
//

import UIKit

class SendCommunicationTeamsTVC: UITableViewCell {

	@IBOutlet weak var selectTeam: UIButton!
	@IBOutlet weak var teamImg: UIImageView!
	@IBOutlet weak var teamName: UILabel!
	@IBOutlet weak var teamEmail: UILabel!
	
	var index: Int?
	var delegate : ItemDelegate?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }


	@IBAction func selected(_ sender: UIButton) {
		
		if sender.isSelected {
			sender.isSelected = false
			delegate?.deSelect(row: index!)

		} else {
			sender.isSelected = true
			delegate?.select(row: index!)
		}
		
		

	}
	
	
}

protocol ItemDelegate {
	func select (row: Int)
	func deSelect (row: Int)
}
