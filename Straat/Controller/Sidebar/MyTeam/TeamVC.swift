//
//  TeamVC.swift
//  Straat
//
//  Created by Global Array on 22/02/2019.
//

import UIKit
import Alamofire
import AlamofireImage

class TeamVC: UIViewController {
    
    @IBOutlet weak var teamListTableView: UITableView!
    @IBOutlet weak var menu: UIBarButtonItem!
    var teamModelArr = [TeamModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createMenu()
        self.navColor()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let teamService = TeamService()
        let uds = UserDefaults.standard
        let userId = uds.string(forKey: user_id)
        
        loadingShow(vc: self)
        self.teamModelArr.removeAll()
        teamService.getTeamList(userId: userId!) { (success, message, teamModels) in
            
            if success == true {
                for teamModel in teamModels! {
                    self.teamModelArr.append(teamModel)
                }
                print("teamService: \(String(describing: teamModels))")
                loadingDismiss()
                self.teamListTableView.reloadData()
            } else {
                let desc = NSLocalizedString("team-leader-accepts-request", comment: "")
                defaultDialog(vc: self, title: "No Team Yet", message: desc)
                loadingDismiss()
            }
        }
    }
    
}

extension TeamVC {

    // for revealing side bar menu
    func createMenu() -> Void {
        if revealViewController() != nil {
            
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = UIScreen.main.bounds.size.width - 100
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        } else {
            print("problem in SWRVC")
        }
    }
    
    // setting navigation bar colors
    func navColor() -> Void {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.title = "Straat.info"
    }
    
    func getTeamRequest(teamId: String, completion: @escaping (Bool, String?)->Void) -> Void {
        let teamService = TeamService()
        teamService.getTeamRequest(teamId: teamId) { (success, message, teamRequestModel) in
            if success == true {
                completion(true, String(teamRequestModel!.count))
                debugPrint("true: \(teamRequestModel!.count)")
            } else {
                completion(false, nil)
                debugPrint("false: \(message)")
            }
            
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
    
    func saveToUserDefault(teamModelItem : TeamModel) -> Void {
        
        let uds = UserDefaults.standard
        
        uds.set(teamModelItem.teamId, forKey: team_id)
        uds.set(teamModelItem.teamName, forKey: team_name)
        uds.set(teamModelItem.teamEmail, forKey: team_email)
        uds.set(teamModelItem.profilePic, forKey: team_logo)
        
    }
    
}

extension TeamVC : UITableViewDelegate, UITableViewDataSource {
    
    // for table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teamModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! TeamTVC
        
        row.teamId = self.teamModelArr[indexPath.row].teamId
        row.teamName.text = self.teamModelArr[indexPath.row].teamName
        row.teamEmail.text = self.teamModelArr[indexPath.row].teamEmail
        
        if self.teamModelArr[indexPath.row].profilePic != nil {
            self.getImage(imageUrl: self.teamModelArr[indexPath.row].profilePic!) { (success, teamLogo) in
                
                if success == true {
                    row.teamLogo.image = teamLogo
                }
                
            }
        }
        
        self.getTeamRequest(teamId: self.teamModelArr[indexPath.row].teamId!, completion: { (success, count) in
            if success == true {
                row.teamMemberCount.isHidden = false
                row.viewMemberRequest.isHidden = false
                row.teamMemberCount.text = count
            }
        })

        
        return row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.saveToUserDefault(teamModelItem: self.teamModelArr[indexPath.row])
    }
    
}
