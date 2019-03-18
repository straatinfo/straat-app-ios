//
//  RegistrationStep2VCViewController.swift
//  Straat
//
//  Created by John Higgins M. Avila on 12/02/2019.
//

import UIKit

class RegistrationStep2VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func onStep1TabPress(_ sender: Any) {
    }
    
    @IBAction func onAsVolunteerPress(_ sender: Any) {
        
        self.goToStep3(isVolunteer: true)
    }
    
    @IBAction func onAsNonVolunteerPress(_ sender: Any) {
        
        self.goToStep3(isVolunteer: false)
    }

}

extension RegistrationStep2VC {
    // register functions here
    func goToStep3 (isVolunteer: Bool) -> Void {
        let prefix = "reg-user-data-"
        let uds = UserDefaults.init()
        uds.set(isVolunteer, forKey: prefix + "isVolunteer")
        pushToNextVC(sbName: "Registration", controllerID: "step3VC", origin: self)
    }
}
