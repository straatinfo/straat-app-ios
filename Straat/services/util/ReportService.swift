//
//  ReportService.swift
//  Straat
//
//  Created by John Higgins M. Avila on 22/02/2019.
//

import Foundation
import Alamofire

class ReportService {
    
    let apiHandler = ApiHandler()
    init () {
        
    }
    
    func sendReport (reportDetails: SendReportModel, completion: @escaping (Bool, String) -> Void) {
        let parameters = reportDetails.toHTTPParams()
        apiHandler.executeWithHeaders(URL(string: send_report)!, parameters: parameters, method: .post, destination: .httpBody, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription)
            } else {
                completion(true, "Success")
            }
        }
    }
    
    func getReportById (reportId: String, completion: @escaping (Bool, String, ReportModel?) -> Void) {
        let parameters: Parameters = ["language": "nl"]
        apiHandler.executeWithHeaders(URL(string: "\(report)/\(reportId)")!, parameters: parameters, method: .get, destination: .queryString, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription, nil)
            } else if let data = response {
                let dataObject = data["data"] as? Dictionary <String, Any>
                
                if dataObject != nil {
                    let reportDetails = ReportModel(report: dataObject!)
                    completion(true, "Success", reportDetails)
                } else {
                    completion(false, "Failed", nil)
                }
                
            }
        }
        
    }
    
    func getUserReports (userId: String, completion: @escaping (Bool, String, [ReportModel]) -> Void) {
        var parameters: Parameters = [:]
        parameters["language"] = "nl"
        parameters["user_id"] = userId
        apiHandler.executeWithHeaders(URL(string: report)!, parameters: parameters, method: .get, destination: .queryString, headers: [:]) { (response, err) in
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription, [])
            } else if let data = response {
                let dataObject = data["data"] as? [[String: Any]] ?? []
                
                var reports: [ReportModel] = []
                
                if dataObject.count > 0 {
                    for reportData in dataObject {
                        let reportItem = ReportModel(report: reportData)
                        
                        reports.append(reportItem)
                    }
                }
                
                completion(true, "Success", reports)
                
            }
        }
    }
    
    func getReportNear (reporterId: String, lat: Double, long: Double, radius: Double, completion: @escaping (Bool, String, [ReportModel]) -> Void) {
        var parameters: Parameters = [:]
        parameters["language"] = "nl"
        parameters["_reporter"] = reporterId
        
        let url = "\(report_near)/\(long)/\(lat)/\(radius)"
        
        apiHandler.executeWithHeaders(URL(string: url)!, parameters: parameters, method: .get, destination: .queryString, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription, [])
            } else if let data = response {
                let dataObject = data["data"] as? [[String: Any]] ?? []
                
                var reports: [ReportModel] = []
                
                if dataObject.count > 0 {
                    for reportData in dataObject {
                        let reportItem = ReportModel(report: reportData)
                        
                        reports.append(reportItem)
                    }
                }
                
                completion(true, "Success", reports)
                
            }
        }
    }
    
    func getPublicReport(reporterId: String, reportType: String?, completion: @escaping(Bool, String, [ReportModel]) -> Void) {
        
        // @TODO add this to constant
        let A = "5a7888bb04866e4742f74955"
        let B = "5a7888bb04866e4742f74956"
        let C = "5a7888bb04866e4742f74957"
        
        var reportTypeId: String;
        
        if reportType == "A" {
            reportTypeId = A
        } else if reportType == "B" {
            reportTypeId = B
        } else if reportType == "C" {
            reportTypeId = C
        } else {
            reportTypeId = A
        }
        
        
        var parameters: Parameters = [:]
        parameters["language"] = "nl"
        parameters["_reportType"] = reportTypeId
        parameters["_reporter"] = reporterId
        
        
        apiHandler.executeWithHeaders(URL(string: report_public)!, parameters: parameters, method: .get, destination: .queryString, headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription, [])
            } else if let data = response {
                let dataObject = data["data"] as? [[String: Any]] ?? []
                
                var reports: [ReportModel] = []
                
                if dataObject.count > 0 {
                    for reportData in dataObject {
                        let reportItem = ReportModel(report: reportData)
                        
                        reports.append(reportItem)
                    }
                }
                
                completion(true, "Success", reports)
                
            }
            
        }
    }
    
    func updateStatus (reportId: String, status: String, completion: @escaping(Bool, String) -> Void) {
        // [ 'NEW', 'INPROGRESS', 'DONE', 'EXPIRED'] -> Accepted status
        
        if status != "NEW" || status != "INPROGRESS" || status != "DONE" {
            completion(false, "Invalid Parameter: Status")
        } else {
            let parameters: Parameters = ["status": status]
            let url = "\(report_status)/\(reportId)"
            
            apiHandler.executeWithHeaders(URL(string: url)!, parameters: parameters, method: .put, destination: .httpBody, headers: [:]) { (response, err) in
                
                if let error = err {
                    print("error reponse: \(error.localizedDescription)")
                    
                    completion(false, error.localizedDescription)
                } else {
                    
                    completion(true, "Success")
                }
                
            }
        }
        
        
    }
    
    
}
