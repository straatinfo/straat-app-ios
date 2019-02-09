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
    var apiHandler = ApiHandler()
    var teamList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTeamData()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadTeamData() {
        
        apiHandler.execute(URL(string: request_team)!, parameters: nil, method: .get) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                defaultDialog(vc: self, title: "Error Response", message: error.localizedDescription)
                loadingDismiss()
                
            } else if let data = response {
                
                let dataObject = data["data"] as! [[String: Any]]

                for teams in dataObject {
                    let team = teams["teamName"] as? String
                    let teamID = teams["_id"] as? Int
                    self.teamList.append(team!)

                }
                
                loadingDismiss()
                
            }

            self.loadDropDown(teamList: self.teamList)
//            print("team list: \(String(describing: self.teamList))" )
        }
        
    }
    
    
    func loadDropDown(teamList : [String]!) {
        
        teamDropdown.optionArray = teamList
        teamDropdown.selectedRowColor = UIColor.lightGray
        
        teamDropdown.didSelect { (selectedItem, index, id) in
            self.title = "selected id: \(id)"
        }
    }
}
