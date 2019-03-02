//
//  ReportTVC.swift
//  Straat
//
//  Created by Global Array on 01/03/2019.
//

import UIKit

class ReportTVC: UITableViewCell {

    @IBOutlet weak var reportCategory: UILabel!
    @IBOutlet weak var dateOfReport: UILabel!
    @IBOutlet weak var messageCount: UILabel!
    @IBOutlet weak var reportImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func messageShow(_ sender: UIButton) {
        print("message show button pressed")
    }
}
