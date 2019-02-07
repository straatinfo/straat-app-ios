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

        loadDropDown()
        loadDropDown()
        loadDropDown()
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
    
    
    func loadDropDown() {
        // add width, action
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        button.setTitle("pota", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: .normal)
        button.frame.size = CGSize(width: 200, height: 30)
        
        self.teamSV.addArrangedSubview(button)
        
    }
}
