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
	@IBOutlet weak var nextBtn: UIButton!
	
	var teamList = [TeamModel]()
	
	// for user defaults
	var selectedTeams = [TeamModel]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.disableSendReportButton()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func btnBack(_ sender: UIButton) {
        pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
	}
	
	
	@IBAction func btnNextStep(_ sender: UIButton) {

		let sendCommReviewVC = storyboard?.instantiateViewController(withIdentifier: "SendCommunicationReviewVC") as! SendCommunicationReviewVC
		sendCommReviewVC.selectedTeams(teamModels: self.selectedTeams)
		
		present(sendCommReviewVC, animated: true, completion: nil)
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



extension SendCommunicationTeamsVC: ItemDelegate {
	func select(row: Int) {
		let team: TeamModel = self.teamList[row]
		self.selectedTeams.append(team)
		self.enableSendReportButton()
//		debugPrint("team selected: \(team)")
	}
	
	func deSelect(row: Int) {
		let team: TeamModel = self.teamList[row]

		for (index, teamModel) in self.selectedTeams.enumerated() {
			if (teamModel.teamId == team.teamId) {
				self.selectedTeams.remove(at: index)
				break
			}
		}
		
		if (row == 0) {
			self.disableSendReportButton()
		}
		debugPrint("team deselected: \(row)")
	}
	
	
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
	
	typealias cb = (Bool) -> Void
	func saveTeam (completion: @escaping cb) -> Void {
//		let uds = UserDefaults.standard
//		let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.selectedTeams)
//		uds.set(encodedData, forKey: report_c_teams)
		debugPrint("saving selected teams")
		completion(true)
	}
	
	func disableSendReportButton() {
		self.nextBtn.isEnabled = false
		self.nextBtn.backgroundColor = UIColor.lightGray
	}

	func enableSendReportButton() {
		self.nextBtn.isEnabled = true
		self.nextBtn.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
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
		
		row.index = indexPath.row
		
		row.teamName.text = self.teamList[indexPath.row].teamName
		row.teamEmail.text = self.teamList[indexPath.row].teamEmail
		
		row.delegate = self

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
		
		row.selectTeam.isEnabled = true
		row.selectTeam.isSelected = true
		
		debugPrint("team selected: \(String(describing: self.teamList[indexPath.row].teamName))")
		
		debugPrint("index \(indexPath.row)")
	}
	



}
