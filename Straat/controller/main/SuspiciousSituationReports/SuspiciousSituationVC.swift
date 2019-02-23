//
//  SuspiciousSituationVC.swift
//  Straat
//
//  Created by Global Array on 15/02/2019.
//

import UIKit
import Alamofire
import AlamofireImage

class SuspiciousSituationVC: UIViewController {


    @IBOutlet weak var suspiciousReportTableView: UITableView!
    
    let reportService = ReportService()
    var reports = [ReportModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingShow(vc: self)
        self.reportService.getPublicReport(reporterId: "5c63e92035086200156f93e0", reportType: "B") { (success, message, reportModels) in
            
            if success {
                for reportModel in reportModels {
                    self.reports.append(reportModel)
                }
                loadingDismiss()
                self.suspiciousReportTableView.reloadData()
            }
        }

    }

}

extension SuspiciousSituationVC : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! SuspiciousTVC
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reportModel = self.reports[indexPath.row]
        let photoModel = reportModel.parsedUploadedPhotos
        var reportImageURL = [String]()
        
//        for imageURL in photoModel! {
//            reportImageURL.append(imageURL.secure_url!)
//        }

        print("row: \(indexPath.row)")
//        pushToNextVC(sbName: "Main", controllerID: "ViewReportID", origin: self)
        
//        self.saveToUserDefault(reportModel: reportModel, reportImages: reportImageURL)
    }
    
    
    
    func saveToUserDefault(reportModel : ReportModel , reportImages : [String]) -> Void {

        let uds = UserDefaults.standard
        
        let fullname = "\(String(describing: reportModel.reporter?.firstname)) \(String(describing: reportModel.reporter?.lastname))"
        
        uds.set(reportModel.mainCategory?.name, forKey: report_category)
        uds.set(reportModel.status, forKey: report_status_detail_view)
        uds.set(reportModel.description, forKey: report_message)
        uds.set(reportModel.location, forKey: report_address)
        uds.set(reportModel.lat, forKey: report_lat)
        uds.set(reportModel.long, forKey: report_long)
        uds.set(reportImages, forKey: report_images)
        uds.set(reportModel.createdAt, forKey: report_created_at)
        uds.set(fullname, forKey: report_reporter_fullname)
        
    }
    
}
