//
//  NotificationVC.swift
//  Straat
//
//  Created by Global Array on 22/02/2019.
//

import UIKit
import Alamofire
import AlamofireImage

class ReportVC: UIViewController {
    
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var myReportTableView: UITableView!
    
    var sampleArr = ["repot1", "report2", "report3"]
    let reportService = ReportService()
    var reports = [ReportModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createMenu()
        self.navColor()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uds = UserDefaults.standard
        let userId = uds.string(forKey: user_id)
        
        loadingShow(vc: self)
        self.reports.removeAll()
        self.reportService.getUserReports(userId: userId!) { (success, message, reportModel) in
            if success == true {
                    self.reports = reportModel
            }
            loadingDismiss()
            self.myReportTableView.reloadData()
        }
        
//        self.reportService.getPublicReport(reporterId: "5c63e92035086200156f93e0", reportType: "A") { (success, message, reportModels) in
//
//            if success {
//                for reportModel in reportModels {
//                    self.reports.append(reportModel)
//                    debugPrint("report description public: \(String(describing: reportModel.description))")
//
//                }
//                loadingDismiss()
//                self.myReportTableView.reloadData()
//            }
//        }

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
        return self.reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! ReportTVC
        
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
