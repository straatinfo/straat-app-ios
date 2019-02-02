//
//  Messages.swift
//  Straat
//
//  Created by Global Array on 02/02/2019.
//

import UIKit

class Messages: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navColor()
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

    
    func createMenu() {
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        } else {
            print("problem in SWRVC")
        }
    }
    
    func navColor() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1)
        //        navigationController?.navigationBar.tintColor = UIColor.init(displayP3Red: 79, green: 106, blue: 133, alpha: 1)
        //        navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 110, green: 133, blue: 161, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.title = "Messages"
    }
}
