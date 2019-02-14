//
//  RegistrationTeamVC.swift
//  Straat
//
//  Created by Global Array on 07/02/2019.
//

import UIKit
import iOSDropDown
import Alamofire

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
    
    
    @IBAction func onRegisterPress(_ sender: Any) {
        self.register() { (success, message) in
            if success == true {
                // go to landing page
                pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
            } else {
                print(message)
            }
        }
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
                print(data)
                for teams in dataObject {
                    let teamID = teams["_id"] as? String ?? ""
                    let teamName = teams["teamName"] as? String ?? ""
                    let teamEmail = teams["teamEmail"] as? String ?? ""
                   
                    self.teamListModel.append(TeamListModel(teamID: teamID, teamName: teamName, teamEmail: teamEmail))
                    self.setTeam(teamId: teamID, teamName: teamName, teamEmail: teamEmail)
                    self.teamList.append(teamName)
                    
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
    
    func setTeam (teamId: String, teamName: String, teamEmail: String) {
        let uds = UserDefaults.init()
        
        let prefix = "reg-user-data-"
        
        uds.set(teamId, forKey: prefix + "teamId")
        uds.set(teamName, forKey: prefix + "teamName")
        uds.set(teamEmail, forKey: prefix + "teamEmail")
    }
    
    func register (completion: @escaping (Bool, String) -> Void) -> Void {
        let userData = getInputs()
        let apiHandler = ApiHandler()
        var parameters : Parameters = [:]
        
        parameters["language"] = "nl"
        parameters["gender"] = userData.gender ?? ""
        parameters["fname"] = userData.firstname ?? ""
        parameters["lname"] = userData.lastname ?? ""
        parameters["username"] = userData.username ?? ""
        parameters["password"] = userData.password ?? ""
        parameters["streetName"] = userData.street ?? ""
        parameters["houseNumber"] = userData.postalNumber ?? ""
        parameters["postalCode"] = userData.postalCode ?? ""
        parameters["city"] = userData.town ?? ""
        parameters["email"] = userData.email ?? ""
        parameters["phoneNumber"] = userData.phoneNumber ?? ""
        parameters["isVolunteer"] = userData.isVolunteer ?? true
        parameters["register_option"] = "MOBILE_APP"
        parameters["lat"] = userData.lat ?? ""
        parameters["lng"] = userData.long ?? ""
        parameters["isReporter"] = true
        parameters["_host"] = userData.hostId ?? ""
        parameters["logoUrl"] = ""
        parameters["logoSecuredUrl"] = ""
        parameters["_team"] = userData.team?.teamId ?? ""
        parameters["code"] = "SeTT0"
        
        apiHandler.execute(URL(string: signup_v3)!, parameters: parameters, method: .post, destination: .httpBody) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                defaultDialog(vc: self, title: "Error Response", message: error.localizedDescription)
                completion(false, error.localizedDescription)
                // loadingDismiss()
                
            } else if let data = response {
                // save user data and token here
                
                completion(true, "Success")
                
                print("response:  \(String(describing: data))")
                
            }
        }

    }
    
    func getInputs () -> UserRegistrationModel {
        let uds = UserDefaults.init()
        let prefix = "reg-user-data-"
        
        let gender = uds.object(forKey: prefix + "gender") as? String? ?? ""
        let fname = uds.object(forKey: prefix + "fname") as? String? ?? ""
        let lname = uds.object(forKey: prefix + "lname") as? String? ?? ""
        let username = uds.object(forKey: prefix + "username") as? String? ?? ""
        let postalCode = uds.object(forKey: prefix + "postalCode") as? String? ?? ""
        let postalNumber = uds.object(forKey: prefix + "postalNumber") as? String? ?? ""
        let street = uds.object(forKey: prefix + "street") as? String? ?? ""
        let town = uds.object(forKey: prefix + "town") as? String? ?? ""
        let email = uds.object(forKey: prefix + "email") as? String? ?? ""
        let phoneNumber = uds.object(forKey: prefix + "phoneNumber") as? String? ?? ""
        let password = uds.object(forKey: prefix + "password") as? String? ?? ""
        let tac = uds.object(forKey: prefix + "tac") as? Bool? ?? false
        
        let isVolunteer = uds.object(forKey: prefix + "isVolunteer") as? Bool? ?? true
        
        let teamName = uds.object(forKey: prefix + "teamName") as? String? ?? nil
        let teamId = uds.object(forKey: prefix + "teamId") as? String? ?? nil
        let teamEmail = uds.object(forKey: prefix + "teamEmail") as? String? ?? nil
        
        let hostPrefix = "host-reg"
        
        let hostId = uds.object(forKey: hostPrefix + "id") as? String? ?? nil
        
        let long = uds.object(forKey: hostPrefix + "long") as? Double? ?? nil
        
        let lat = uds.object(forKey: hostPrefix + "lat") as? Double? ?? nil
        
        let team = TeamModel(teamId: teamId, teamName: teamName, teamEmail: teamEmail)
        
        let userData = UserRegistrationModel(gender: gender, firstname: fname, lastname: lname, username: username, postalCode: postalCode, postalNumber: postalNumber, street: street, town: town, email: email, phoneNumber: phoneNumber, password: password, tac: tac, isVolunteer: isVolunteer, hostId: hostId, long: long, lat: lat, team: team)
        
        return userData
    }
    
}
