//
//  SendReportModel.swift
//  Straat
//
//  Created by John Higgins M. Avila on 22/02/2019.
//

import Foundation
import Alamofire

class SendReportModel {
    
    var title: String? // title
    var description: String? // description
    var location: String? // location
    var long: Double? // long
    var lat: Double? // lat
    var reporterId: String? // _reporter
    var hostId: String? // _host
    var mainCategoryId: String? // _mainCategory
    var subCategoryId: String? // _subCategory
    var isUrgent: Bool? // isUrgent
    var teamId: String? // _team
    var reportUploadedPhotos: [[String: Any]]? // reportUploadedPhotos
    var isVehicleInvolved: Bool? = false // isVehicleInvolved
    var vehicleInvolvedCount: Int? = 0 // vehicleInvolvedCount
    var vehicleInvolvedDescription: String? //vehicleInvolvedDescription
    var isPeopleInvolved: Bool? = false // isPeopleInvolved
    var peopleInvolvedCount: Int? = 0 // peopleInvolvedCount
    var peopleInvolvedDescription: String? // peopleInvolvedDescription
    var reportTypeId: String? // _reportType
    var attachments: [[String: Any]]? // attachments
    
    init () {
        
    }
    
    // constructor for report type a
    init (
        title: String?,
        description: String?,
        location: String?,
        long: Double?,
        lat: Double?,
        reporterId: String?,
        hostId: String?,
        mainCategoryId: String?,
        subCategoryId: String?,
        isUrgent: Bool?,
        teamId: String?,
        reportUploadedPhotos: [[String: Any]],
        isVehicleInvolved: Bool?,
        vehicleInvolvedCount: Int?,
        vehicleInvolvedDescription: String?,
        isPeopleInvolved: Bool?,
        peopleInvolvedCount: Int?,
        peopleInvolvedDescription: String?,
        reportTypeId: String?
    ) {
        self.title = title
        self.description = description
        self.location = location
        self.long = long
        self.lat = lat
        self.reporterId = reporterId
        self.hostId = hostId
        self.mainCategoryId = mainCategoryId
        self.subCategoryId = subCategoryId
        self.isUrgent = isUrgent
        self.teamId = teamId
        self.reportUploadedPhotos = reportUploadedPhotos
        self.isVehicleInvolved = isVehicleInvolved
        self.vehicleInvolvedCount = vehicleInvolvedCount
        self.vehicleInvolvedDescription = vehicleInvolvedDescription
        self.isPeopleInvolved = isPeopleInvolved
        self.peopleInvolvedCount = peopleInvolvedCount
        self.peopleInvolvedDescription = peopleInvolvedDescription
        self.reportTypeId = reportTypeId
    }
    
    // constructor for report type b
    init (
        title: String?,
        description: String?,
        location: String?,
        long: Double?,
        lat: Double?,
        reporterId: String?,
        hostId: String?,
        mainCategoryId: String?,
        isUrgent: Bool?,
        teamId: String?,
        reportUploadedPhotos: [[String: Any]],
        isVehicleInvolved: Bool?,
        vehicleInvolvedCount: Int?,
        vehicleInvolvedDescription: String?,
        isPeopleInvolved: Bool?,
        peopleInvolvedCount: Int?,
        peopleInvolvedDescription: String?,
        reportTypeId: String?
        ) {
        self.title = title
        self.description = description
        self.location = location
        self.long = long
        self.lat = lat
        self.reporterId = reporterId
        self.hostId = hostId
        self.mainCategoryId = mainCategoryId
        self.isUrgent = isUrgent
        self.teamId = teamId
        self.reportUploadedPhotos = reportUploadedPhotos
        self.isVehicleInvolved = isVehicleInvolved
        self.vehicleInvolvedCount = vehicleInvolvedCount
        self.vehicleInvolvedDescription = vehicleInvolvedDescription
        self.isPeopleInvolved = isPeopleInvolved
        self.peopleInvolvedCount = peopleInvolvedCount
        self.peopleInvolvedDescription = peopleInvolvedDescription
        self.reportTypeId = reportTypeId
    }
    
}

extension SendReportModel {
    func toHTTPParams () -> Parameters {
        var params: Parameters = [:]
        params["title"] = self.title!
        params["description"] = self.description!
        params["location"] = self.location!
        params["long"] = self.long!
        params["lat"] = self.lat!
        params["_reporter"] = self.reporterId!
        params["_host"] = self.hostId!
        params["_mainCategory"] = self.mainCategoryId!
        params["isUrgent"] = self.isUrgent!
        params["reportUploadedPhotos"] = self.reportUploadedPhotos!
        params["_reportType"] = self.reportTypeId!
        
        if self.subCategoryId != nil {
            params["_subCategory"] = self.subCategoryId!
        }
        if self.teamId != nil {
            params["_team"] = self.teamId!
        }
        if self.isVehicleInvolved != nil {
            params["isVehicleInvolved"] = self.isVehicleInvolved
            params["vehicleInvolvedCount"] = self.vehicleInvolvedCount ?? 1
            params["vehicleInvolvedDescription"] = self.vehicleInvolvedDescription ?? ""
        }
        if self.isPeopleInvolved != nil {
            params["isPeopleInvolved"] = self.isPeopleInvolved
            params["peopleInvolvedCount"] = self.peopleInvolvedCount ?? 1
            params["peopleInvolvedDescription"] = self.peopleInvolvedDescription ?? ""
        }
        
        return params
    }
    
}
