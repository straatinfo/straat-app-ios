//
//  MediaService.swift
//  Straat
//
//  Created by John Higgins M. Avila on 22/02/2019.
//

import Foundation
import Alamofire

class MediaService {
    let apiHandler = ApiHandler()
    init () {
        
    }
    
    func uploadPhoto (image: Data, fileName: String, completion: @escaping (Bool, String, PhotoModel?, Dictionary<String, Any>?) -> Void) {
        let parameters : Parameters = [:]
        apiHandler.executeMultiPart(URL(string: upload_photo)!, parameters: parameters, imageData: image, fileName: fileName, photoFieldName: "photo", pathExtension: ".jpeg", headers: [:]) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                
                completion(false, error.localizedDescription, nil, nil)
            } else if let data = response {
                let dataObject = data["data"] as? Dictionary <String, Any>
                
                if dataObject != nil {
                    let photoMetaData = PhotoModel(photoData: dataObject!)
                    completion(true, "Success", photoMetaData, dataObject)
                } else {
                    completion(false, "Failed", nil, nil)
                }
                
            }
            
        }
    }
}
