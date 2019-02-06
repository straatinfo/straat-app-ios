//
//  EnterCode.swift
//  Straat
//
//  Created by Global Array on 29/01/2019.
//

import Foundation
import UIKit

class EnterCodeVC: UIViewController {
    
    @IBOutlet weak var tfCode: UITextField!
    
    override func viewDidLoad() {
            //some shit code
    }
    
    @IBAction func btnOkay(_ sender: UIButton) {
        print(tfCode.text!)
    }
}
