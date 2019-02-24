//
//  SettingVC.swift
//  Straat
//
//  Created by Global Array on 22/02/2019.
//

import UIKit
import iOSDropDown

class SettingVC: UIViewController {
    
    let userService = UserService()
    let uds = UserDefaults.standard
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
    
    // MARK: for revealing side bar menu
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
    
    // MARK: setting navigation bar colors
    func navColor() -> Void {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.title = "Straat.info"
    }
    
    func loadSettingDropDown() -> Void {
        let raduisArr = ["100m", "300m", "600m", "1km", "3km"]
        let radiusValue = [100, 300, 600, 1000, 3000]
        self.radiusDropDown.optionArray = raduisArr
        self.radiusDropDown.selectedRowColor = UIColor.lightGray
        self.radiusDropDown.didSelect { (selectedItem, index, id) in
            print("selectedItem: \(selectedItem)")
            let radius = Double(radiusValue[index])
            let userId = self.uds.string(forKey: user_id) ?? ""
            
            self.updateRadius(userId: userId, radius: radius) {
                (success, text) in
                if success {
                    defaultDialog(vc: self, title: "Success", message: "Successfully updated radius value")
                    
                    // @TODO set user default here
                    self.uds.set(radius, forKey: "user_radius")
                } else {
                    defaultDialog(vc: self, title: "Failed", message: "Please try again")
                }
            }
        }
    }
    
}

// MARK: - Setting VC API Calls
extension SettingVC {
    func updateRadius (userId: String, radius: Double, completion: @escaping (Bool, String) -> Void) {
        userService.setUserRadius(userId: userId, radius: radius) {
            (success, text) in
            
            completion(success, text)
        }
    }
}
