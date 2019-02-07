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
    
    var isSelected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        termsAndCondition.isSelected = isSelected
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func selectedGender(_ sender: UIButton) {
        
        
        var buttonSelected: UIButton!
//
//        if sender.isSelected {
//
            if sender.tag == 1 {
                sender.isSelected = true
                buttonSelected = female
                print("male")
            } else if sender.tag == 2{
                sender.isSelected = true
                buttonSelected = male
                print("female")
            }
//
//        } else {
//            sender.isSelected = false
//        }
//

        diselect(sender: buttonSelected)
    }
    
    
    func diselect(sender: UIButton) {
        sender.isSelected = false
    }

    
}
