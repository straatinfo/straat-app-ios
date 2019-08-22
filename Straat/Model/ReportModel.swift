//
//  ReportModel.swift
//  Straat
//
//  Created by John Higgins M. Avila on 22/02/2019.
//

import Foundation

class ReportModel : SendReportModel {
    var id: String?
    var host: HostModel?
    var reporter: UserModel?
    var team: TeamModel?
    var mainCategory: MainCategoryModel?
    var subCategory: SubCategoryModel?
    var parsedUploadedPhotos: [PhotoModel]?
    var reportType: ReportTypeModel?
    var createdAt : String?
    var status : String?
    var conversationId: String?
    var messages: [String]?
    var unreadConversationCount: Int?
    
    var reportImage : UIImage? = UIImage(named: "AppIcon")
    
    init (report: Dictionary<String, Any>) {
        super.init()
        self.id = report["_id"] as? String
        self.title = report["title"] as? String
        self.description = report["description"] as? String
        self.location = report["location"] as? String
        self.long = report["long"] as? Double
        self.lat = report["lat"] as? Double
        self.createdAt = report["createdAt"] as? String
        
        // reporter details
        let reporterData = report["_reporter"] as? [String: Any]
        self.reporter = UserModel(reportData: reporterData!)
        self.reporterId = self.reporter!.id
        
        // host details
        let hostData = report["_host"] as? [String: Any]
        self.host = HostModel(hostData: hostData!)
        self.hostId = self.host!.id
        
        // reportType Details
        let reportTypeData = report["_reportType"] as? Dictionary<String, Any>
        self.reportType = ReportTypeModel(reportTypeData: reportTypeData!)
        self.reportTypeId = self.reportType!.id

        // mainCategory Details
        let mainCategoryData = report["_mainCategory"] as? Dictionary<String, Any>
        
        if mainCategoryData != nil {
            self.mainCategory =  MainCategoryModel(mainCategoryData: mainCategoryData!)
            self.mainCategoryId = self.mainCategory?.id
        }


        // subCategory Details
        let subCategoryData = report["_subCategory"] as? Dictionary<String, Any>
        
        if subCategoryData != nil {
            self.subCategory = SubCategoryModel(subCategoryData: subCategoryData!)
            self.subCategoryId = self.subCategory?.id
        }

        
        self.isUrgent = report["isUrgent"] as? Bool
        self.teamId = report["_team"] as? String
        
        self.reportUploadedPhotos = report["reportUploadedPhotos"] as? [[String: Any]] ?? []
        if self.reportUploadedPhotos!.count > 0 {
            for photoData in self.reportUploadedPhotos! {
                let photo = PhotoModel(photoData: photoData)
                
                self.parsedUploadedPhotos?.append(photo)
            }
        }
        
        self.attachments = report["attachments"] as? [[String: Any]] ?? []
       
//            for photoData in self.reportUploadedPhotos! {
//                let photo = PhotoModel(photoData: photoData)
//
//                self.parsedUploadedPhotos?.append(photo)
//            }
        
        self.isVehicleInvolved = report["isVehicleInvolved"] as? Bool
        self.vehicleInvolvedCount = report["vehicleInvolvedCount"] as? Int
        self.vehicleInvolvedDescription = report["vehicleInvolvedDescription"] as? String
        self.isPeopleInvolved = report["isPeopleInvolved"] as? Bool
        self.peopleInvolvedCount = report["peopleInvolvedCount"] as? Int
        self.peopleInvolvedDescription = report["peopleInvolvedDescription"] as? String
        
        self.status = report["status"] as? String
        
        let conversation = report["_conversation"] as? [String:Any] ?? [:]
        self.conversationId = conversation["_id"] as? String? ?? ""
        self.unreadConversationCount = conversation["unreadMessageCount"] as? Int? ?? 0
        self.messages = conversation["messages"] as? [String] ?? []

    }
    
//    init (reportMessageCount: Dictionary<String, Any>) {
//        let conversation = reportMessageCount["_conversation"] as? [String:Any] ?? [:]
//
//    }
    
    
}

extension ReportModel {
 
    func setReportImage(reportImage : UIImage?) {
        self.reportImage = reportImage
    }
    
    func getReportImage() -> UIImage{
		return self.reportImage!
    }
    
}
