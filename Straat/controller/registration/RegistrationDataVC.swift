//
//  RegistrationData.swift
//  Straat
//
//  Created by Global Array on 04/02/2019.
//

import UIKit

class RegistrationDataVC: UIViewController {
    
    
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    @IBOutlet weak var termsAndCondition: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func selectedGender(_ sender: UIButton) {
        
        var buttonSelected: UIButton!
        
        // Conditional statement to identify the selected button
        // if has a tag 1 (Male) or 2 (female)
        if sender.tag == 1 {
            sender.isSelected = true
            buttonSelected = female
            print("male")
        } else if sender.tag == 2{
            sender.isSelected = true
            buttonSelected = male
            print("female")
        }

        diselect(sender: buttonSelected)
    }
    
    @IBAction func selectTAC(_ sender: Any) {
        let tacVC = storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionID") as! TermsAndConditionVC
        tacVC.acceptTACDele = self
        present(tacVC, animated: true, completion: nil)
    }

    
}


//for implementating delegate
extension RegistrationDataVC : acceptTACDelegate {
    func state(state: Bool) {
        self.termsAndCondition.isSelected = state
        print("state: \(state)" )
    }
}


// for implementing functions
extension RegistrationDataVC {
    
    func diselect(sender: UIButton) {
        sender.isSelected = false
    }
    
}
