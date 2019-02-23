//
//  ViewController.swift
//  Straat
//
//  Created by Global Array on 29/01/2019.
//

import UIKit

class SplashScreenVC: UIViewController {

    let userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.interval()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.interval()
    }
    
    func interval() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
        

                self.performSegue(withIdentifier: "nextVC", sender: nil)

        

            
        }
        
        
    }
}

