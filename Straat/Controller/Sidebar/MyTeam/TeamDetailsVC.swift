//
//  TeamDetailsVC.swift
//  Straat
//
//  Created by Global Array on 01/03/2019.
//

import UIKit
import Alamofire
import AlamofireImage

class TeamDetailsVC: UIViewController {

    @IBOutlet weak var editTeam: UIBarButtonItem!
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamEmail: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamRequestTableView: UITableView!
    
    var teamMembersArr = [TeamModel]()
	var userId : String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navColor()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initView()
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}


extension TeamDetailsVC {
    
    // setting navigation bar colors
    func navColor() -> Void {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.title = "Team Profile"
    }
    
    func initView() {
        
        let uds = UserDefaults.standard
        let teamId = uds.string(forKey: team_id)
        let teamName = uds.string(forKey: team_name)
        let teamEmail = uds.string(forKey: team_email)
        let teamLogo = uds.string(forKey: team_logo)
		let userId = uds.string(forKey: user_id)
		
        self.teamName.text = teamName
        self.teamEmail.text = teamEmail
		self.userId = userId
        
        loadingShow(vc: self)
        if teamLogo != nil {
            self.getImage(imageUrl: teamLogo!) { (success, teamLogo) in
                if success == true {
                    self.teamLogo.image = teamLogo
                    loadingDismiss()
                }
            }
        } else {
            loadingDismiss()
        }
		self.teamMembersArr.removeAll()
        self.getTeamMembers(teamId: teamId!)

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
    
    func getTeamMembers(teamId: String) -> Void {
        let teamService = TeamService()
        let uds = UserDefaults.standard
        let teamId = uds.string(forKey: team_id) ?? ""
        
        debugPrint("teamid: \(teamId)")
        teamService.getTeamMembers(teamId: teamId) { (success, message, teamModel) in
            if success == true {
				for teamModelItem in teamModel! {
					if teamModelItem.requestUserId != self.userId {
						self.teamMembersArr.append(teamModelItem)
					}
				}
//                self.teamMembersArr = teamModel ?? []
                debugPrint("teamModel: \(String(describing: teamModel))")
            } else {
                debugPrint("false")
            }
            self.teamRequestTableView.reloadData()
        }
    }
    
}

extension TeamDetailsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teamMembersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! TeamMemberTVC
		
		if self.teamMembersArr[indexPath.row].requestUserId! != self.userId {
			row.teamMemberId = self.teamMembersArr[indexPath.row].requestUserId!
			row.teamMemberName.text = self.teamMembersArr[indexPath.row].requestUserFname! + " " + self.teamMembersArr[indexPath.row].requestUserLname!
		}

        
        return row
    }

}
