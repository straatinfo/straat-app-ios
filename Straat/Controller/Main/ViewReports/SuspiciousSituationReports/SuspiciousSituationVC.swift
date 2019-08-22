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
    let chatService = ChatService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onNewMessageReceived()
    }
	
	override func viewWillAppear(_ animated: Bool) {
        self.reports.removeAll()
        self.loadChatRooms()
	}
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}

extension SuspiciousSituationVC : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = UserModel()
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! SuspiciousTVC

        if self.reports.count > 0 && self.reports.count - 1 >= indexPath.row {
            let report = self.reports[indexPath.row]
            let mainCategory = report.mainCategory?.name
            let date = report.createdAt
            let messageCount = report.unreadConversationCount ?? 0
            
            row.reportCategory.text = mainCategory
            row.dateOfReport.text = date?.toDate(format: nil)
            row.messageCount.text = "\(String(describing: messageCount))"
            
            row.reportId = report.id
            row.conversationId = report.conversationId
            row.chatTitle = report.mainCategory?.name
            row.userId = user.id
            row.isUrgentMarker.isHidden = !(report.isUrgent != nil && report.isUrgent!)
            
            if (self.reports[indexPath.row].attachments?.count)! > 0 {
                
                let rootImage = self.reports[indexPath.row].attachments![0]
                let imageUrl = rootImage["secure_url"] as? String
                
                self.getReportImage(imageUrl: imageUrl!) { (hasImage, image) in
                    if hasImage {
                        row.reportImage?.image = image
                    }
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

// chat functions

extension SuspiciousSituationVC {
    func updateBadgeValue () {
        let user = UserModel()
        
        self.chatService.getUnreadMessageCount(userId: user.id!) { (success, response) in
            if success && response != nil {
                let unreadMessageCount = response!["b"].int
                if unreadMessageCount != nil && unreadMessageCount! > 0 {
                    self.tabBarItem.badgeValue = String(unreadMessageCount!)
                } else {
                    self.tabBarItem.badgeValue = nil
                }
            }
        }
    }
    
    func loadChatRooms () {
        let user = UserModel()
        self.reportService.getPublicReport(reporterId: user.id!, reportType: "B") { (success, message, reportModels) in
            
            if success {
                for reportModel in reportModels {
                    self.reports.append(reportModel)
                    //                    debugPrint("report description suspicious: \(String(describing: reportModel.description))")
                    //                    debugPrint("_conversation: \(String(describing: reportModel.conversationId))")
                    //                    debugPrint("messages: \(String(describing: reportModel.messages))")
                }
                self.suspiciousReportTableView.reloadData()
            }
        }
    }
}

// socket management
extension SuspiciousSituationVC {
    func onNewMessageReceived () {
        SocketIOManager.shared.getNewMessage { (success) in
            self.reports.removeAll()
            self.loadChatRooms()
        }
    }
}

