//
//  ForgotPass.swift
//  Straat
//
//  Created by Global Array on 04/02/2019.
//

import UIKit

class ForgotPassVC: UIViewController {

    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBorderedVIew(viewContainer: mainView, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        // Do any additional setup after loading the view.
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
