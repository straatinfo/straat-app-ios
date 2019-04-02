//
//  TeamMemberVC.swift
//  Straat
//
//  Created by Global Array on 14/03/2019.
//

import UIKit

class TeamMemberVC: UIViewController {

    @IBOutlet weak var teamMemberRequest: UITableView!
    var teamRequestArr = [TeamModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initView()
    }
    
}

extension TeamMemberVC {
    
    func initView() -> Void {
        let uds = UserDefaults.standard
        let teamId = uds.string(forKey: team_id) ?? ""
        
        self.getTeamRequest(teamId: teamId)

    }
    
    func getTeamRequest(teamId: String) -> Void {
        let teamService = TeamService()
        teamService.getTeamRequest(teamId: teamId) { (success, message, teamRequestModel) in
            if success == true {
                self.teamRequestArr = teamRequestModel!
                debugPrint("true: \(teamRequestModel!.count)")
            }
            self.teamMemberRequest.reloadData()
        }
    }
}

extension TeamMemberVC: UITableViewDelegate, UITableViewDataSource, MemberRequestDelegate {
    func result(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
			self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teamRequestArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! TeamMemberRequestTVC
        
        row.memberRequestDele = self
        row.userId = self.teamRequestArr[indexPath.row].requestUserId
        row.teamMemberName.text = self.teamRequestArr[indexPath.row].requestUserFname! + " " + self.teamRequestArr[indexPath.row].requestUserLname!
        
        return row
    }
}
