//
//  ViewController.swift
//  Straat
//
//  Created by Global Array on 29/01/2019.
//

import UIKit

class SplashScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interval()
    }


    func interval() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            
            self.performSegue(withIdentifier: "nextVC", sender: nil)
            
        }
    }
}

