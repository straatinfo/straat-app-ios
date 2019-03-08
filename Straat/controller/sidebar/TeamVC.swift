//
//  TeamVC.swift
//  Straat
//
//  Created by Global Array on 22/02/2019.
//

import UIKit

class TeamVC: UIViewController {
    
    @IBOutlet weak var menu: UIBarButtonItem!
    var teamNameArr = ["team1", "team2", "team3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createMenu()
        self.navColor()
        
        let teamService = TeamService()
        let uds = UserDefaults.standard
        let userId = uds.string(forKey: user_id)

        teamService.getTeamList(userId: userId!) { (success, message, teamModel) in

            if success == true {
                print("teamService: \(String(describing: teamModel))")
            }
        }

    }
    
}

extension TeamVC : UITableViewDelegate, UITableViewDataSource {
    
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
    
    // for table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teamNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! TeamTVC
        
        row.teamName.text = self.teamNameArr[indexPath.row]
        row.teamEmail.text = "sample@email.com"
        
        return row
    }
    
}
