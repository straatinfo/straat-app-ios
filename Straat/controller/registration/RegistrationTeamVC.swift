//
//  RegistrationTeamVC.swift
//  Straat
//
//  Created by Global Array on 07/02/2019.
//

import UIKit
import iOSDropDown

class RegistrationTeamVC: UIViewController {

    @IBOutlet weak var teamDropdown: DropDown!
    @IBOutlet weak var teamListView: UIView!
    
    var apiHandler = ApiHandler()
    var teamList = [String]()
    var teamListModel = [TeamListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.defaultView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinExistingTeam(_ sender: Any) {
        self.showTeamList()
    }
    
    
}


// for implementing functions
extension RegistrationTeamVC {
    
    // executing default view of registration team section
    func defaultView() {
        teamListView.isHidden = true
    }
    
    // show team list and fetch team list data
    func showTeamList() {
        self.loadTeamData()
        teamListView.isHidden = false
    }
    
    // loading data of team list
    func loadTeamData() {
        
        apiHandler.execute(URL(string: request_team)!, parameters: nil, method: .get, destination: .queryString) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                defaultDialog(vc: self, title: "Error Response", message: error.localizedDescription)
                loadingDismiss()
                
            } else if let data = response {
                
                let dataObject = data["data"] as! [[String: Any]]
                
                for teams in dataObject {
                    let teamID = teams["_id"] as? String
                    let teamName = teams["teamName"] as? String
                    let teamEmail = teams["teamEmail"] as? String
                   
                    self.teamListModel.append(TeamListModel(teamID: teamID, teamName: teamName, teamEmail: teamEmail))
                    self.teamList.append(teamName!)
                    
                }
                
                loadingDismiss()
                
            }
            
            self.loadDropDown(teamList: self.teamList, teamListModel: self.teamListModel)
            //            print("team list: \(String(describing: self.teamList))" )
        }
        
    }
    
    
    
    // populate team list data to dropdown
    func loadDropDown(teamList : [String]!, teamListModel : [TeamListModel]!) {
        
        teamDropdown.optionArray = teamList
        teamDropdown.selectedRowColor = UIColor.lightGray
        
        teamDropdown.didSelect { (selectedItem, index, id) in
            print("selected team_id: \(String(describing: teamListModel[index].id))")
        }
    }
    
}
