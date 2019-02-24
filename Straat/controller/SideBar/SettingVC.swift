//
//  SettingVC.swift
//  Straat
//
//  Created by Global Array on 22/02/2019.
//

import UIKit
import iOSDropDown

class SettingVC: UIViewController {
    
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var radiusDropDown: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createMenu()
        self.navColor()
        self.loadSettingDropDown()
        // Do any additional setup after loading the view.
    }
    
}

extension SettingVC {
    
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
    
    // setting navigation bar colors
    func navColor() -> Void {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.title = "Straat.info"
    }
    
    func loadSettingDropDown() -> Void {
        let raduisArr = ["100m", "300", "600m", "1k", "3k"]
        self.radiusDropDown.optionArray = raduisArr
        self.radiusDropDown.selectedRowColor = UIColor.lightGray
        self.radiusDropDown.didSelect { (selectedItem, index, id) in
            print("selectedItem: \(selectedItem)")
        }
    }
    
}
