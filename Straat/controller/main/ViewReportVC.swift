//
//  ViewReport.swift
//  Straat
//
//  Created by Global Array on 18/02/2019.
//

import UIKit

class ViewReportVC: UIViewController {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var reportBy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initReportMapDetails()
        // Do any additional setup after loading the view.
    }


    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewReportVC {
    func initReportMapDetails() -> Void{
        let uds = UserDefaults.standard

        let category = uds.string(forKey: "report-category")
        let status = uds.string(forKey: "report-status")
        let message = uds.string(forKey: "report-message")
        let address = uds.string(forKey: "report-address")
        let lat = uds.double(forKey: "report-lat")
        let long = uds.double(forKey: "report-long")
        
        self.location.text = address
        self.status.text = status
        self.notification.text = category
        self.message.text = message
        
        print("report view: \(String(describing: category))")
        

        
    }
}
