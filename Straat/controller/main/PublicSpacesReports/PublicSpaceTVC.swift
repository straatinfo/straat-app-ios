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
    
    var id : String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func messageShow(_ sender: Any) {
        print("id: " + id!)
    }
}