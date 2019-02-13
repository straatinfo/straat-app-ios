//
//  RegistrationStep2VCViewController.swift
//  Straat
//
//  Created by John Higgins M. Avila on 12/02/2019.
//

import UIKit

class RegistrationStep2VCViewController: UIViewController {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RegistrationStep2VCViewController {
    // register functions here
    func goToStep3 (isVolunteer: Bool) -> Void {
        let prefix = "reg-user-data-"
        let uds = UserDefaults.init()
        uds.set(isVolunteer, forKey: prefix + "isVolunteer")
        pushToNextVC(sbName: "Registration", controllerID: "step3VC", origin: self)
    }
}
