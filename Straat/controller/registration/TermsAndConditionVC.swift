//
//  TermsAndCondition.swift
//  Straat
//
//  Created by Global Array on 04/02/2019.
//

import UIKit

class TermsAndConditionVC: UIViewController {


    @IBOutlet weak var mainContainer: UIView!
    var acceptTACDele : acceptTACDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadBorderedVIew(viewContainer: mainContainer, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))

        // Do any additional setup after loading the view.
    }
    
    @IBAction func accept(_ sender: Any) {

        self.acceptTACDele?.state(state: true)
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancel(_ sender: Any) {
        self.acceptTACDele?.state(state: false)
        dismiss(animated: true, completion: nil)
    }

    
}


protocol acceptTACDelegate {
    
    func state( state : Bool)
    
}
