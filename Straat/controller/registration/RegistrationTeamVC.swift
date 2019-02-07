//
//  RegistrationTeamVC.swift
//  Straat
//
//  Created by Global Array on 07/02/2019.
//

import UIKit

class RegistrationTeamVC: UIViewController {

    @IBOutlet weak var teamSV: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        loadDropDown(teamName: "team 1")
//        loadDropDown(teamName: "team 2")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")
//        loadDropDown(teamName: "team 3")

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
    
    
    func loadDropDown( teamName : String ) {
        // add width, action
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        button.setTitle( teamName , for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(getAction(sender:)), for: .touchUpInside)
        
        self.teamSV.addArrangedSubview(button)
        
    }
    
    @objc func getAction( sender : UIButton) {
        print("button-name: " + sender.currentTitle!)
    }
}
