//
//  NotificationVC.swift
//  Straat
//
//  Created by Global Array on 22/02/2019.
//

import UIKit

class ReportVC: UIViewController {
    
    @IBOutlet weak var menu: UIBarButtonItem!
    var sampleArr = ["repot1", "report2", "report3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createMenu()
        self.navColor()
        // Do any additional setup after loading the view.
    }
    
}


extension ReportVC : UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sampleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! ReportTVC
        
        row.reportCategory.text = self.sampleArr[indexPath.row]
        
        return row
    }
    
}
