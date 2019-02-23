//
//  PublicSpaceVC.swift
//  Straat
//
//  Created by Global Array on 14/02/2019.
//

import UIKit
import Alamofire
import AlamofireImage

class PublicSpaceVC: UIViewController {

    @IBOutlet weak var publicReportTableView: UITableView!
    
    let reportService = ReportService()
    var reports = [ReportModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        loadingShow(vc: self)
        self.reportService.getPublicReport(reporterId: "5c63e92035086200156f93e0", reportType: "A") { (success, message, reportModels) in
            
            if success {
                for reportModel in reportModels {
                    self.reports.append(reportModel)
                }
                loadingDismiss()
                self.publicReportTableView.reloadData()
            }
        }
    }



}


extension PublicSpaceVC : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(self.reports.count)" )
        return self.reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! PublicSpaceTVC
        
        let mainCategory = self.reports[indexPath.row].mainCategory?.name
        let date = self.reports[indexPath.row].createdAt

        row.reportCategory.text = mainCategory
        row.dateOfReport.text = date

        if (self.reports[indexPath.row].attachments?.count)! > 0 {
            
            let rootImage = self.reports[indexPath.row].attachments![0]
            let imageUrl = rootImage["secure_url"] as? String
            
            Alamofire.request(URL(string: imageUrl!)!).responseImage { response in
                
                if let img = response.result.value {
                    print("report image downloaded: \(img)")
                    
                    DispatchQueue.main.async {
                        row.reportImage?.image = img
                    }                    
                }
            }
            
        }
        
        return row
        
    }
    
    
}
