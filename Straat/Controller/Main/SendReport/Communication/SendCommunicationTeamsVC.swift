//
//  SendCommunicationTeamsVC.swift
//  Straat
//
//  Created by Global Array on 20/12/2019.
//

import UIKit
import Alamofire
import AlamofireImage

class SendCommunicationTeamsVC: UIViewController {

	@IBOutlet weak var teamListTV: UITableView!
	
	var teamList = [TeamModel]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func btnBack(_ sender: UIButton) {
				pushToNextVC(sbName: "Main", controllerID: "mainID", origin: self)
	}
	
	
	@IBAction func btnNextStep(_ sender: UIButton) {
				pushToNextVC(sbName: "Main", controllerID: "SendCommunicationReviewVC", origin: self)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.fetchTeams()
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

extension SendCommunicationTeamsVC {
	func fetchTeams() -> Void {
		
		let teamService = TeamService()
		let uds = UserDefaults.standard
		let userId = uds.string(forKey: user_id) ?? ""
		

		loadingShow(vc: self)
		self.teamList.removeAll()
		
		teamService.getTeamListByUserId(userId: userId) { (success, message, teamModels) in
			
			if success {

				if (teamModels?.count ?? 0 > 0) {
					self.teamList = teamModels!
				debugPrint("teamsss: \(String(describing: self.teamList))")
				}
			} else {
				defaultDialog(vc: self, title: "Fetch Team", message: "No Team Yet")
			}
			self.teamListTV.reloadData()
			loadingDismiss()
		}
	}
	
	func getImage(imageUrl: String, completion: @escaping (Bool, UIImage?) -> Void) -> Void {
		
		Alamofire.request(URL(string: imageUrl)!).responseImage { response in
			
			if let img = response.result.value {
				completion(true, img)
			} else {
				completion(false, nil)
			}
		}
	}
}

extension SendCommunicationTeamsVC: UITableViewDelegate,
UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		debugPrint("teamlist count: \(self.teamList.count)")
		return self.teamList.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! SendCommunicationTeamsTVC
		
		row.teamName.text = self.teamList[indexPath.row].teamName
		row.teamEmail.text = self.teamList[indexPath.row].teamEmail

		if self.teamList[indexPath.row].profilePic != nil {
			let imageUrl = self.teamList[indexPath.row].profilePic!

			self.getImage(imageUrl: imageUrl) { (success, teamLogo) in

				if success {
					row.teamImg.image = teamLogo
				}

			}
		}
		return row
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! SendCommunicationTeamsTVC
		
		if row.isSelected {
			row.selectTeam.isSelected = false
		} else {
			row.selectTeam.isSelected = true
		}
	}


}
