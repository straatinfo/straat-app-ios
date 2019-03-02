//
//  TeamDetailsVC.swift
//  Straat
//
//  Created by Global Array on 01/03/2019.
//

import UIKit

class TeamDetailsVC: UIViewController {

    @IBOutlet weak var editTeam: UIBarButtonItem!
    var sampleArr = ["Jose Marie Chan", "Jose Rizal", "Andres Bonifacio"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navColor()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}


extension TeamDetailsVC : UITableViewDataSource, UITableViewDelegate {
    
    // setting navigation bar colors
    func navColor() -> Void {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.title = "Team Profile"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sampleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! TeamMemberTVC
        
        row.teamMemberName.text = self.sampleArr[indexPath.row]
        
        return row
    }

}
