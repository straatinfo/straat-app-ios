//
//  ReportMapService.swift
//  Straat
//
//  Created by Global Array on 19/02/2019.
//

import Foundation
import Alamofire

class ReportMapService {
    
    
    let apiHandler = ApiHandler()
    var reportImageModel = [ReportImageModel]()
    var reportMapModel = [ReportMapModel]()
    init()
    {
        
    }
    
    func getUserReport (userID : String, completion: @escaping (Bool, String, [ReportMapModel]) -> Void ) -> Void
    {
        
        apiHandler.executeWithHeaders(URL(string: report_map)!, parameters: [:], method: HTTPMethod.get, destination: .queryString, headers: [:]) { (response, err) in
            
            if let error = err {
                completion(false, error.localizedDescription, [])
                
            } else if let data = response {
                let reports = data["data"] as? [[String: Any]]
                

                for report in reports! {
//                    let reportCoord = report["reportCoordinate"] as? [String: Any]
                    let reporter = report["_reporter"] as? [String:Any]
                    let reporter_id = reporter!["_id"] as? String
                    let category = report["_mainCategory"] as? [String:Any]
                    let attachments = report["attachments"] as? [[String:Any]]
                    
                    if reporter_id == userID {
                        
                        let category_name = category!["name"] as? String
                        let status = report["status"] as? String
                        let message = report["description"] as? String
                        let address = report["location"] as? String
                        let lat = report["lat"] as? Double
                        let long = report["long"] as? Double
                        
                        self.reportImageModel = self.parseReportImage(attachments: attachments!)
                        
                        self.reportMapModel.append(
                            ReportMapModel(category: category_name, images: self.reportImageModel,status: status, message: message, address: address, lat: lat, long: long)
                        )
                        
//                        print("category_name: \(String(describing: category_name))")
//                        print("status: \(String(describing: status))")
//                        print("message: \(String(describing: message))")
//                        print("address: \(String(describing: address))")
                        print("lat: \(String(describing: lat))")
                        print("long: \(String(describing: long))")
//                        print("attachments: \(String(describing: attachments))")
                    }
                    
                }

//                print("all reports: \(String(describing: reports))")
                completion(true, "Success", self.reportMapModel)
            }
            
        }
    }
    
    func parseReportImage (attachments : [[String: Any]]) -> [ReportImageModel] {
        
        for attach in attachments {
            let image_url = attach["secure_url"] as? String
            self.reportImageModel.append(ReportImageModel(imageUrl: image_url))
        }
        
        return self.reportImageModel
    }

    //    category or notification type
    //    images []
    //    status
    //    message
    //    address
    //    long
    //    lat
    
}
