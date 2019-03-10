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
    
    var sampleArr = ["Jose Marie Chan", "Jose Rizal", "Andres Bonifacio"]

    
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
        let teamName = uds.string(forKey: team_name)
        let teamEmail = uds.string(forKey: team_email)
        let teamLogo = uds.string(forKey: team_logo)
        
        self.teamName.text = teamName
        self.teamEmail.text = teamEmail
        
        loadingShow(vc: self)
        self.getImage(imageUrl: teamLogo!) { (success, teamLogo) in
            if success == true {
                self.teamLogo.image = teamLogo
                loadingDismiss()
            }
        }
        // Do any additional setup after loading the view.
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

extension TeamDetailsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sampleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! TeamMemberTVC
        
        row.teamMemberName.text = self.sampleArr[indexPath.row]
        
        return row
    }

}
