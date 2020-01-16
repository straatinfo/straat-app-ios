//
//  ApiHandler.swift
//  Straat
//
//  Created by Global Array on 06/02/2019.
//

import Foundation
import Alamofire
import SwiftyJSON


class ApiHandler {
    
    typealias ApiResponse = ( Dictionary <String, Any>?, Error?) -> Void
	//version 2
	typealias ApiResponseV2 = (JSON?, Error?) -> Void
    
    
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
             
                debugPrint(response.result.error ?? "An erro occured")
            }
        
        
    }
    
    func executeWithHeaders (_ url: URL, parameters: Parameters?, method: HTTPMethod, destination: URLEncoding.Destination, headers: HTTPHeaders, completion: @escaping ApiResponse) {

        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding(destination: destination), headers: headers)
            .validate().responseJSON
            { response in
                
                if let error = response.error {
					debugPrint("api handler err: \(response.error)")
                    completion(nil, error)
                    
                } else if let jsonArr =  response.result.value as? Dictionary <String, Any> {
                    
                    completion(jsonArr, nil)
                    
                } else if let jsonDict = response.result.value as? Dictionary <String, Any> {
                    
                    completion(jsonDict, nil)
                    
                }
                
                debugPrint(response.result.error ?? "No Errors")
        }
    }
	
	//Version 2
	func executeWithHeadersV2 (_ url: URL, parameters: Parameters?, method: HTTPMethod, destination: URLEncoding.Destination, headers: HTTPHeaders, completion: @escaping ApiResponseV2) {
		
		Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding(destination: destination), headers: headers)
			.validate().responseJSON
			{ response in
				
				if let error = response.error {
					completion(nil, error)
					
				} else if let jsonArr =  response.result.value {
					
					let response = JSON(jsonArr)
					completion(response, nil)
					
				} else if let jsonDict = response.result.value {
					
					let response = JSON(jsonDict)
					completion(response, nil)
					
				}
				
				debugPrint(response.result.error ?? "No Errors")
		}
	}
	
	//Version 3 with JSONEncoding
	func executeWithHeadersV3 (_ url: URL, parameters: Parameters?, method: HTTPMethod, destination: JSONEncoding, headers: HTTPHeaders, completion: @escaping ApiResponseV2) {
		
		Alamofire.request(url, method: method, parameters: parameters, encoding: destination, headers: headers)
			.validate().responseJSON
			{ response in
				
				if let error = response.error {
					completion(nil, error)
					
				} else if let jsonArr =  response.result.value {
					
					let response = JSON(jsonArr)
					completion(response, nil)
					
				} else if let jsonDict = response.result.value {
					
					let response = JSON(jsonDict)
					completion(response, nil)
					
				}
				
				debugPrint(response.result.error ?? "No Errors")
		}
	}
	
	
    func executeMultiPart (_ url: URL, parameters: Parameters?, imageData: Data?, fileName: String?, photoFieldName: String?, pathExtension: String?, method: HTTPMethod, headers: HTTPHeaders?, completion: @escaping ApiResponse) {
        var heads = headers

        heads?["Content-type"] = "multipart/form-data"
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters! {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData {
                multipartFormData.append(data, withName: photoFieldName!, fileName: "\(fileName!).\(pathExtension!)", mimeType: "\(fileName!)/\(pathExtension!)")
            }
        }, usingThreshold: UInt64.init(), to: url, method: method, headers: heads) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let error = response.error {
                        
                        completion(nil, error)
                        
                    } else if let jsonArr =  response.result.value as? Dictionary <String, Any> {
                        
                        completion(jsonArr, nil)
                        
                    } else if let jsonDict = response.result.value as? Dictionary <String, Any> {
                        
                        completion(jsonDict, nil)
                        
                    }
                    print("upload: \(String(describing: response.result.description))")
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion(nil, error)
            }
        }

    }
    
}
