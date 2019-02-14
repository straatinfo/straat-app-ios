//
//  ApiHandler.swift
//  Straat
//
//  Created by Global Array on 06/02/2019.
//

import Foundation
import Alamofire


class ApiHandler {
    
    typealias ApiResponse = ( Dictionary <String, Any>?, Error?) -> Void
    
    
    func execute (_ url: URL, parameters: Parameters?, method: HTTPMethod, destination: URLEncoding.Destination, completion: @escaping ApiResponse) {
        
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding(destination: destination), headers: nil)
            .validate().responseJSON
            { response in
                
                if let error = response.error {
                
                    completion(nil, error)
                    
                } else if let jsonArr =  response.result.value as? Dictionary <String, Any> {
                    
                    completion(jsonArr, nil)
                    
                } else if let jsonDict = response.result.value as? Dictionary <String, Any> {
                    
                    completion(jsonDict, nil)
                    
                }
             
                debugPrint(response.result.error)
            }
        
        
    }
    
    
}
