//
//  ReportService.swift
//  Straat
//
//  Created by John Higgins M. Avila on 22/02/2019.
//

import Foundation
import Alamofire
import SwiftyJSON

class ReportService {
    
    let uds = UserDefaults.standard
    
    let apiHandler = ApiHandler()
    init () {
        
    }
    
    func parsePhotos (reportUploadedPhotos: [[String: Any]]) -> String {
        var string = ""
        
        string += "["
        
        for count in 1...reportUploadedPhotos.count {
            
            let photo = reportUploadedPhotos[count - 1]
            string += "{"
            
            
            string += "\"fieldname\":\"\(photo["fieldname"]!)\","
            string += "\"originalname\":\"\(photo["originalname"]!)\","
            string += "\"encoding\":\"\(photo["encoding"]!)\","
            string += "\"mimetype\":\"\(photo["mimetype"]!)\","
            string += "\"public_id\":\"\(photo["public_id"]!)\","
            string += "\"version\":\"\(photo["version"]!)\","
            string += "\"signature\":\"\(photo["signature"]!)\","
            string += "\"width\":\(photo["width"]!),"
            string += "\"height\":\(photo["height"]!),"
            string += "\"format\":\"\(photo["format"]!)\","
            string += "\"resource_type\":\"\(photo["resource_type"]!)\","
            string += "\"created_at\":\"\(photo["created_at"]!)\","
            string += "\"tags\":[],"
            string += "\"bytes\":\(photo["bytes"]!),"
            string += "\"type\":\"\(photo["type"]!)\","
            string += "\"etag\":\"\(photo["etag"]!)\","
            string += "\"placeholder\":\"\(photo["placeholder"]!)\","
            string += "\"url\":\"\(photo["url"]!)\","
            string += "\"secure_url\":\"\(photo["secure_url"]!)\","
            string += "\"original_filename\":\"\(photo["original_filename"]!)\""
            
            if count == reportUploadedPhotos.count {
                string += "}"
            } else {
                string += "},"
            }
        }
        
        
        string += "]"
        return string
    }
    
    func sendReport (reportDetails: SendReportModel, completion: @escaping (Bool, String) -> Void) {
        var parameters = reportDetails.toHTTPParams()
        
        print("reportUploadedPhotos - data \(parameters["reportUploadedPhotos"])")
        
		debugPrint("params: \(parameters)")
//        parameters["reportUploadedPhotos"] = "[{\"fieldname\": \"photo\",\"originalname\": \"AdvancedReactRedux.jpg\",\"encoding\": \"7bit\",\"mimetype\": \"image/jpeg\",\"public_id\": \"reports/AdvancedReactRedux.jpg_Mon Feb 25 2019 01:19:05 GMT+0100 (Central European Standard Time)\",\"version\": 1551053947,\"signature\": \"d73f2f1b12095682ab0801f452ffbeafbaf1adcb\",\"width\": 1600,\"height\": 1194,\"format\": \"jpg\",\"resource_type\": \"image\",\"created_at\": \"2019-02-25T00:19:07Z\",\"tags\": [],\"bytes\": 1115671,\"type\": \"upload\",\"etag\": \"824910d7180cf6a2814dfdddb9b74448\",\"placeholder\": false,\"url\": \"http://res.cloudinary.com/hvina6sjo/image/upload/v1551053947/reports/AdvancedReactRedux.jpg_Mon%20Feb%2025%202019%2001:19:05%20GMT%2B0100%20%28Central%20European%20Standard%20Time%29.jpg\",\"secure_url\": \"https://res.cloudinary.com/hvina6sjo/image/upload/v1551053947/reports/AdvancedReactRedux.jpg_Mon%20Feb%2025%202019%2001:19:05%20GMT%2B0100%20%28Central%20European%20Standard%20Time%29.jpg\",\"original_filename\": \"file\"}]"
        
//        let dic = reportDetails.reportUploadedPhotos
//        let encoder = JSONEncoder()
//        if let jsonData = try? JSONSerialization.jsonObject(with: <#T##Data#>, options: <#T##JSONSerialization.ReadingOptions#>)(dic) {
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                print(jsonString)
//            }
//        }
        if reportDetails.reportUploadedPhotos != nil && reportDetails.reportUploadedPhotos!.count > 0 {
            parameters["reportUploadedPhotos"] = self.parsePhotos(reportUploadedPhotos: reportDetails.reportUploadedPhotos!)
        }
        
//        debugPrint("report desc: \(parameters)")
        
        apiHandler.executeWithHeaders(URL(string: send_report)!, parameters: parameters, method: .post, destination: .httpBody, headers: [:]) { (response, err) in

            if let error = err {
                print("error reponse: \(error.localizedDescription)")
				
                completion(false, error.localizedDescription)
            } else if let data = response {
				
                let json = JSON(data)
                let jsonData = json["data"]
				
				debugPrint("report sending: \(jsonData)")
				
                let desc = NSLocalizedString("send-report-success", comment: "")
                if let reportId = jsonData["_id"].string {
                    print("REPORT_ID: \(reportId)")
                    self.uds.set(reportId, forKey: new_sent_report)
                }
                completion(true, desc)
            }
        }
    }
	
	// Send Report Type C with implemenation of new apiHandler.executeWithHeadersV3
	func sendReportTypeC (reportDetails: SendReportModel, completion: @escaping (Bool, String) -> Void) {
		var parameters = reportDetails.toHTTPParamsReportC()
		
		print("reportUploadedPhotos - data \(String(describing: parameters["reportUploadedPhotos"]))")
		

		if reportDetails.reportUploadedPhotos != nil && reportDetails.reportUploadedPhotos!.count > 0 {
			parameters["reportUploadedPhotos"] = self.parsePhotos(reportUploadedPhotos: reportDetails.reportUploadedPhotos!)
		}
		
		apiHandler.executeWithHeadersV3(URL(string: send_report)!, parameters: parameters, method: .post, destination: JSONEncoding.default, headers: [:]) { (response, err) in
			if let error = err {
				print("error reponse: \(error.localizedDescription)")

				completion(false, error.localizedDescription)
			} else if let data = response {

				let json = JSON(data)
				let jsonData = json["data"]

				debugPrint("report sending: \(jsonData)")

				let desc = NSLocalizedString("send-report-success", comment: "")
				if let reportId = jsonData["_id"].string {
					print("REPORT_ID: \(reportId)")
					self.uds.set(reportId, forKey: new_sent_report)
				}
				completion(true, desc)
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
				let dataObject = data["data"] as? Dictionary <String, Any> ?? [:]
                
				if dataObject != nil || dataObject.count > 0 {
					let reportDetails = ReportModel(report: dataObject)
                    completion(true, "Success", reportDetails)
                } else {
                    completion(false, "Failed", nil)
                }
                
            }
        }
        
    }
    
    // for my reports
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
    
    func getReportNear (reporterId: String, lat: Double, long: Double, radius: Double, completion: @escaping (Bool, String, [ReportModel]?) -> Void) {
        var parameters: Parameters = [:]
        parameters["language"] = "nl"
        parameters["_reporter"] = reporterId
        
        let url = "\(report_near)/\(long)/\(lat)/\(100000)"
        
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
//                    debugPrint("report near: \(dataObject)")
                    completion(true, "Success", reports)
                } else {
                    completion(false, "No Available Reports", nil)
                }
                

                
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
    
    func updateReportStatus (reportId: String, status: String, completion: @escaping(Bool) -> Void) {
        let user = UserModel()
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = user.userToken
        var parameters: Parameters = [:]
        parameters["status"] = status
        
        apiHandler.executeWithHeaders(URL(string: report_api_v1 + "/" + reportId)!, parameters: parameters, method: .put, destination: .httpBody, headers: headers) { (response, err) in
            if let error = err {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func makeReportPublic (reportId: String, completion: @escaping(Bool) -> Void) {
        let user = UserModel()
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = user.userToken
        var parameters: Parameters = [:]
        parameters["isPublic"] = true
        
        apiHandler.executeWithHeaders(URL(string: report_api_v1 + "/" + reportId)!, parameters: parameters, method: .put, destination: .httpBody, headers: headers) { (response, err) in
            if let error = err {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
