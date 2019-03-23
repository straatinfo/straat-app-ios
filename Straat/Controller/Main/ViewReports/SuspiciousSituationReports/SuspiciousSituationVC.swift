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

    }
	
	override func viewWillAppear(_ animated: Bool) {
		let uds = UserDefaults.standard
		let userId = uds.string(forKey: user_id) ?? ""
		
		loadingShow(vc: self)
		self.reports.removeAll()
		self.reportService.getPublicReport(reporterId: userId, reportType: "B") { (success, message, reportModels) in
			
			if success {
				for reportModel in reportModels {
					self.reports.append(reportModel)
					//                    debugPrint("report description suspicious: \(String(describing: reportModel.description))")
					//                    debugPrint("_conversation: \(String(describing: reportModel.conversationId))")
					//                    debugPrint("messages: \(String(describing: reportModel.messages))")
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

		let reports = self.reports[indexPath.row]
        let mainCategory = reports.mainCategory?.name
        let date = reports.createdAt
		let messageCount = reports.messages!.count
		
		row.reportId = reports.reporter?.id
		row.conversationId = reports.conversationId
        row.reportCategory.text = mainCategory
        row.dateOfReport.text = date
		row.messageCount.text = "\(String(describing: messageCount))"
        
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
        
        print("reporter: \(fullname)")
        
        uds.set(reportModel.mainCategory?.name, forKey: report_category)
        uds.set(reportModel.status, forKey: report_status_detail_view)
        uds.set(reportModel.description, forKey: report_message)
        uds.set(reportModel.location, forKey: report_address)
        uds.set(reportModel.lat, forKey: report_lat)
        uds.set(reportModel.long, forKey: report_long)
        uds.set(reportModel.conversationId, forKey: report_conversation_id)
        uds.set(reportImages, forKey: report_images)
        uds.set(reportModel.createdAt, forKey: report_created_at)
        uds.set(fullname, forKey: report_reporter_fullname)

        
    }
    
}
