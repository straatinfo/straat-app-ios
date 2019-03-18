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
    let imageActivityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        loadingShow(vc: self)
        self.reports.removeAll()
        self.reportService.getPublicReport(reporterId: "5c63e92035086200156f93e0", reportType: "A") { (success, message, reportModels) in
            
            if success {
                for reportModel in reportModels {
                    self.reports.append(reportModel)
                    debugPrint("report description public: \(String(describing: reportModel.description))")

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
            
            self.getReportImage(imageUrl: imageUrl!) { (hasImage, image) in
                if hasImage {
                    row.reportImage?.image = image
                }
            }

            
        }
        
        return row
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reportModel = self.reports[indexPath.row]
        let images = reportModel.attachments
        var reportImageURL = [String]()
        
        //        print("images: \(images)")        
        for image in images! {
            if image["secure_url"] != nil {
                reportImageURL.append(image["secure_url"] as! String)
            }
        }
        
        self.saveToUserDefault(reportModel: reportModel, reportImages: reportImageURL)
//        pushToNextVC(sbName: "Main", controllerID: "ViewReportID", origin: self)        
    }
    
    
    
    func getReportImage(imageUrl: String, completion: @escaping (Bool, UIImage?) -> Void) -> Void {
        
        Alamofire.request(URL(string: imageUrl)!).responseImage { response in
            
            if let img = response.result.value {
                print("report image downloaded: \(img)")
                
                completion(true, img)
            } else {
                completion(false, nil)
            }
        }
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
