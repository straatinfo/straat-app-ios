//
//  SendCommunicationReviewVC.swift
//  Straat
//
//  Created by Global Array on 20/12/2019.
//

import UIKit
import iOSDropDown

class SendCommunicationReviewVC: UIViewController {

	@IBOutlet weak var cagetory: UITextField!
	@IBOutlet weak var message: UITextField!
	@IBOutlet weak var teamList: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		getInputs()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func btnBack(_ sender: UIButton) {
		pushToNextVC(sbName: "Main", controllerID: "SendCommunicationTeamsVC", origin: self)
	}
	
	override func viewWillAppear(_ animated: Bool) {
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SendCommunicationReviewVC {
	func selectedTeams(teamModels: [TeamModel]) {
		var teamNames = [String]()
		DispatchQueue.main.async {
			for teams in teamModels {
				teamNames.append(teams.teamName!)
			}
			
			debugPrint("teamName \(teamNames)")
			self.teamList.loadDropdownData(data: teamNames)
		}

	}
	
	func getInputs() -> Void {
		let uds = UserDefaults.standard
		let categoryName = uds.string(forKey: report_c_category)
		let notif = uds.bool(forKey: report_c_is_notif)
		let showMap = uds.bool(forKey: report_c_show_map)
		let message = uds.string(forKey: report_c_message)
		
		self.cagetory.text = categoryName
		self.message.text = message
	}
}
