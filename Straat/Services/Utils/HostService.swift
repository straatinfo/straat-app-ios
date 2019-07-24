//
//  HostService.swift
//  Straat
//
//  Created by John Higgins M. Avila on 19/07/2019.
//

import Foundation
import Alamofire
import SwiftyJSON

class HostService {
    let uds = UserDefaults.standard
    init () {
        
    }
    
    func getHostByName (hostName: String, completion: @escaping (Bool, HostModel?) -> Void) -> Void {
        let urlString = get_host_by_name + hostName.replaceSpace()
        let parameters: Parameters = [:]
        var headers: HTTPHeaders = [:]
        let userToken = uds.string(forKey: token) ?? ""
        headers["Authorization"] = "Bearer \(userToken)"
        
        print("URL: \(URL(string: urlString)!)")
        
        
        Alamofire.request(URL(string: urlString)!, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            print(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["_host"].exists() {
                    let hostJson = JSON(json["_host"])
                    let host = HostModel(json: hostJson)
                    completion(true, host)
                } else {
                    print("NO_HOST_EXISTS")
                    completion(false, nil)
                }
            case .failure(let error):
                print("ERROR_REG_VAL: \(error.localizedDescription)")
                completion(false, nil)
            }
        }
    }
}
