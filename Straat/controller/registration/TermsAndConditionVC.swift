//
//  TermsAndCondition.swift
//  Straat
//
//  Created by Global Array on 04/02/2019.
//

import UIKit

class TermsAndConditionVC: UIViewController {

    

    @IBOutlet weak var mainContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadBorderedVIew(viewContainer: mainContainer, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))

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
    
    @IBAction func accept(_ sender: Any) {
        performSegue(withIdentifier: "acceptSegue", sender: self)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! RegistrationDataVC
        vc.isSelected = true
        
    }
    
}
