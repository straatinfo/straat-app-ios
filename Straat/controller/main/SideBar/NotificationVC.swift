//
//  NotificationVC.swift
//  Straat
//
//  Created by Global Array on 22/02/2019.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createMenu()
        // Do any additional setup after loading the view.
    }
    
}


extension NotificationVC {
    
    func createNagivationBar() -> Void {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 10, width: self.view.frame.width, height: 50))
        
        navBar.barTintColor = UIColor.lightGray
        self.view.addSubview(navBar)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        
        let navBatItem = UINavigationItem(title: "Title")
        navBatItem.rightBarButtonItem = cancelButton
        navBatItem.leftBarButtonItem = doneButton
        
        navBar.items = [navBatItem]
    }
    
    // for revealing side bar menu
    func createMenu() -> Void {
        if revealViewController() != nil {
            
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = UIScreen.main.bounds.size.width - 100
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        } else {
            print("problem in SWRVC")
        }
    }
}
