//
//  RegistrationData.swift
//  Straat
//
//  Created by Global Array on 04/02/2019.
//

import UIKit

class RegistrationData: UIViewController {
    
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func selectedGender(_ sender: UIButton) {
        
        
//        var gender: UIButton!
        
//
//        if sender.isSelected {
//
//            if sender.tag == 1 {
//                sender.isSelected = true
////                gender = female
//            } else if sender.tag == 2{
//                sender.isSelected = true
////                gender = male
//            }
//
//        } else {
//            sender.isSelected = false
//        }
//

//        diselect(sender: gender)
    }
    
    
    func diselect(sender: UIButton) {
        sender.isSelected = false
    }
    
    
}
