//
//  ForgotPass.swift
//  Straat
//
//  Created by Global Array on 04/02/2019.
//

import UIKit

class ForgotPassVC: UIViewController {

    @IBOutlet weak var mainVIew: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadVIew()
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

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadVIew() {
        mainVIew.layer.borderWidth = 1
        mainVIew.layer.borderColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1).cgColor

        
    }
}
