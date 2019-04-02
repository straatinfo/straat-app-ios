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
    @IBOutlet weak var individualReporterButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    var apiHandler = ApiHandler()
    var teamList = [String]()
    var teamListModel = [TeamListModel]()
	var isVolunteer: Bool?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.defaultView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinExistingTeam(_ sender: Any) {
        self.showTeamList()
    }
    
    
    @IBAction func onRegisterPress(_ sender: Any) {
		let title = NSLocalizedString("registration-title", comment: "")
		
        loadingShow(vc: self)
        self.register() { (success, message) in
            if success == true {
				
				let desc = NSLocalizedString("registration-success-desc", comment: "")
                let alertController = UIAlertController(title: title, message: desc, preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
					if self.isVolunteer ?? false {
						pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
					} else {
                    	pushToNextVC(sbName: "Initial", controllerID: "loginVC", origin: self)
					}

					}))
                self.present(alertController, animated: true, completion: nil)
                // go to landing page

            } else {
				let desc = NSLocalizedString("registration-fail-desc", comment: "")
                let alertController = UIAlertController(title: title, message: desc, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                    pushToNextVC(sbName: "Initial", controllerID: "loginVC", origin: self)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            loadingDismiss()
        }
    }
}


// for implementing functions
extension RegistrationTeamVC {
    
    // executing default view of registration team section
    func defaultView() {
        teamListView.isHidden = true
        self.individualReporterButton.isEnabled = false
        self.individualReporterButton.backgroundColor = UIColor.lightGray
        self.registerButton.isEnabled = false
        self.registerButton.backgroundColor = UIColor.lightGray
		
		let prefix = "reg-user-data-"
		let uds = UserDefaults.init()
		self.isVolunteer = uds.bool(forKey: prefix + "isVolunteer")
		self.disableRegisterButton()
    }
    
    // show team list and fetch team list data
    func showTeamList() {
        self.loadTeamData()
        teamListView.isHidden = false
    }
    
    // loading data of team list
    func loadTeamData() {
        loadingShow(vc: self)
        apiHandler.execute(URL(string: request_team)!, parameters: nil, method: .get, destination: .queryString) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                let title = NSLocalizedString("error-response", comment: "")
                defaultDialog(vc: self, title: title, message: error.localizedDescription)
                
                loadingDismiss()
                
            } else if let data = response {
                
                let dataObject = data["data"] as! [[String: Any]]

				for teams in dataObject {
					
					let isVolunteerTeam = teams["isVolunteer"] as? Bool ?? false
					let isApproved = teams["isApproved"] as? Bool ?? false
//					debugPrint("isvolunteer: \(self.isVolunteer)")

					if isVolunteerTeam == self.isVolunteer {
						var teamID: String = ""
						var teamName: String = ""
						var teamEmail: String = ""

						if isVolunteerTeam == false && isApproved == true {
							teamID = teams["_id"] as? String ?? ""
							teamName = teams["teamName"] as? String ?? ""
							teamEmail = teams["teamEmail"] as? String ?? ""
							
							self.populateTeamToDropdown(teamID: teamID, teamName: teamName, teamEmail: teamEmail)
						} else if isVolunteerTeam {
							teamID = teams["_id"] as? String ?? ""
							teamName = teams["teamName"] as? String ?? ""
							teamEmail = teams["teamEmail"] as? String ?? ""
							
							self.populateTeamToDropdown(teamID: teamID, teamName: teamName, teamEmail: teamEmail)
						}
					}
                }
                
                loadingDismiss()
                
            }
            
            self.loadDropDown(teamList: self.teamList, teamListModel: self.teamListModel)
            //            print("team list: \(String(describing: self.teamList))" )
        }
        
    }
	
	func populateTeamToDropdown (teamID: String, teamName: String, teamEmail: String) {
		self.teamListModel.append(TeamListModel(teamID: teamID, teamName: teamName, teamEmail: teamEmail))
		self.teamList.append(teamName)
	}
    
    
    // populate team list data to dropdown
    func loadDropDown(teamList : [String]!, teamListModel : [TeamListModel]!) {
        
        teamDropdown.optionArray = teamList
        teamDropdown.selectedRowColor = UIColor.lightGray
        
        teamDropdown.didSelect { (selectedItem, index, id) in
            print("selected team_id: \(String(describing: teamListModel[index].id))")

            self.setTeam(teamId: teamListModel[index].id ?? "", teamName: teamListModel[index].name ?? "", teamEmail: teamListModel[index].email ?? "")
				self.enableRegisterButton()
            
        }
    }
    
    func setTeam (teamId: String, teamName: String, teamEmail: String) {
        let uds = UserDefaults.init()
        
        let prefix = "reg-user-data-"
        
        uds.set(teamId, forKey: prefix + "teamId")
        uds.set(teamName, forKey: prefix + "teamName")
        uds.set(teamEmail, forKey: prefix + "teamEmail")
    }
    
//    func register (completion: @escaping (Bool, String) -> Void) -> Void {
//        let userData = getInputs()
//        let apiHandler = ApiHandler()
//        var parameters : Parameters = [:]
//
//        parameters["language"] = "nl"
//        parameters["gender"] = userData.gender ?? ""
//        parameters["fname"] = userData.firstname ?? ""
//        parameters["lname"] = userData.lastname ?? ""
//        parameters["username"] = userData.username ?? ""
//        parameters["password"] = userData.password ?? ""
//        parameters["streetName"] = userData.street ?? ""
//        parameters["houseNumber"] = userData.postalNumber ?? ""
//        parameters["postalCode"] = userData.postalCode ?? ""
//        parameters["city"] = userData.town ?? ""
//        parameters["email"] = userData.email ?? ""
//        parameters["phoneNumber"] = userData.phoneNumber ?? ""
//        parameters["isVolunteer"] = userData.isVolunteer ?? true
//        parameters["register_option"] = "MOBILE_APP"
//        parameters["lat"] = userData.lat ?? ""
//        parameters["lng"] = userData.long ?? ""
//        parameters["isReporter"] = true
//        parameters["_host"] = userData.hostId ?? ""
//        parameters["logoUrl"] = ""
//        parameters["logoSecuredUrl"] = ""
//        parameters["_team"] = userData.team?.teamId ?? ""
//        parameters["code"] = "SeTT0"
//
//        apiHandler.execute(URL(string: signup_v3)!, parameters: parameters, method: .post, destination: .httpBody) { (response, err) in
//
//            if let error = err {
//                print("error reponse: \(error.localizedDescription)")
//                defaultDialog(vc: self, title: "Error Response", message: error.localizedDescription)
//                completion(false, error.localizedDescription)
//                // loadingDismiss()
//
//            } else if let data = response {
//
//                let dataObject = data["data"] as? Dictionary <String, Any>
//                let userObject = dataObject?["user"] as? Dictionary <String, Any>
//
//                let userModel = UserModel(fromLogin: userObject!)
//
//                //saving user model to loca data
//                userModel.saveToLocalData()
//
//                completion(true, "Success")
//
//                print("response:  \(String(describing: data))")
//
//            }
//        }
//
//    }

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
                completion(false, error.localizedDescription)

            } else if let data = response {
                // save user data and token here
//                let uds = UserDefaults.standard;
//                let prefix = "user-data-"

				let dataObject = data["data"] as? Dictionary<String, Any> ?? [:]
//                let user = dataObject?["user"] as? Dictionary<String, Any>
//                let userId = user?["_id"] as? String
//
//                uds.set(userId, forKey: prefix + "id")

				let userObject = dataObject["user"] as? Dictionary <String, Any> ?? [:]
				let settingObject = dataObject["setting"] as? Dictionary <String, Any> ?? [:]
				let activeDesignObject = dataObject["_activeDesign"] as? Dictionary<String, Any> ?? [:]
				
				let teamObject = userObject["_activeTeam"] as? Dictionary <String, Any> ?? [:]
				let hostObject = userObject["_host"] as? Dictionary<String, Any> ?? [:]
				
				
				let hostId = hostObject["_id"] as? String ?? ""
				let isVolunteer = userObject["isVolunteer"] as? Bool ?? true
				
				let userModel = UserModel(fromLogin: userObject)
				let userSettingModel = UserModel(fromLoginSetting: settingObject)
				let userTeamModel = UserModel(fromLoginTeam: teamObject)
                let userOtherModel = UserModel(fromLoginHostId: hostId, fromLoginIsVolunteer: isVolunteer)
				let userActiveDesignModel = UserModel(fromLoginActiveDesign: activeDesignObject)

                //saving user model to loca data
                userModel.saveToLocalData()
				userSettingModel.saveSettingToLocalData()
				userTeamModel.saveTeamToLocalData()
				userOtherModel.saveOtherToLocalData()
				userActiveDesignModel.saveActiveDesignToLocalData()
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
        
        let user = uds.object(forKey: prefix + "username") as! String? ?? ""
        let userPrefix = uds.object(forKey: prefix + "userPrefix") as! String? ?? ""
        let username = user + userPrefix
        
        let postalCode = uds.object(forKey: prefix + "postalCode") as? String? ?? ""
        let postalNumber = uds.object(forKey: prefix + "postalNumber") as? String? ?? ""
        let street = uds.object(forKey: prefix + "street") as? String? ?? ""
        let town = uds.object(forKey: prefix + "town") as? String? ?? ""
        let email = uds.object(forKey: prefix + "email") as? String? ?? ""
        let phoneNumber = uds.object(forKey: prefix + "phoneNumber") as? String? ?? ""
        let password = uds.object(forKey: prefix + "password") as? String? ?? ""
        let tac = uds.object(forKey: prefix + "tac") as? Bool? ?? false
        
        let isVolunteer = uds.object(forKey: prefix + "isVolunteer") as? Bool? ?? true
        
        let teamName = uds.object(forKey: prefix + "teamName") as? String? ?? ""
        let teamId = uds.object(forKey: prefix + "teamId") as? String? ?? ""
        let teamEmail = uds.object(forKey: prefix + "teamEmail") as? String? ?? ""
        
        
        let hostId = uds.object(forKey: host_reg_id) as? String? ?? ""
        let long = uds.object(forKey: host_reg_long) as? Double? ?? nil
        let lat = uds.object(forKey: host_reg_lat) as? Double? ?? nil
        
        let team = TeamModel(teamId: teamId, teamName: teamName, teamEmail: teamEmail)
        
        let userData = UserRegistrationModel(gender: gender, firstname: fname, lastname: lname, username: username, postalCode: postalCode, postalNumber: postalNumber, street: street, town: town, email: email, phoneNumber: phoneNumber, password: password, tac: tac, isVolunteer: isVolunteer, hostId: hostId, long: long, lat: lat, team: team)
        
        return userData
    }
	
	func disableRegisterButton() {
		self.registerButton.isEnabled = false
		self.registerButton.backgroundColor = UIColor.lightGray
	}
	
	func enableRegisterButton() {
		self.registerButton.isEnabled = true
		self.registerButton.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
	}
}
