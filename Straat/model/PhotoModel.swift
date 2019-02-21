//
//  PhotoModel.swift
//  Straat
//
//  Created by John Higgins M. Avila on 22/02/2019.
//

import Foundation

class PhotoModel {
    
    var public_id: String?
    var mimetype: String?
    var url: String?
    var secure_url: String?
    var format: String?
    var etag: String?
    var width: Double?
    var height: Double?
    
    init () {
        
    }
    
    init (photoData: Dictionary<String, Any>) {
        self.public_id = photoData["public_id"] as? String
        self.mimetype = photoData["mimetype"] as? String
        self.url = photoData["url"] as? String
        self.secure_url = photoData["secure_url"] as? String
        self.format = photoData["format"] as? String
        self.etag = photoData["etag"] as? String
        self.width = photoData["width"] as? Double
        self.height = photoData["height"] as? Double
    }
}

extension PhotoModel {
    func toDictionary () -> Dictionary<String, Any> {
        var photoData: Dictionary<String, Any> = [:]
        photoData["public_id"] = self.public_id
        photoData["mimetype"] = self.mimetype
        photoData["url"] = self.url
        photoData["secure_url"] = self.secure_url
        photoData["format"] = self.format
        photoData["etag"] = self.etag
        photoData["width"] = self.width
        photoData["height"] = self.height
        
        return photoData
    }
}

/*
 public_id: { type: String, unique: true, required: true },
 mimetype: { type: String, required: true },
 url: { type: String, required: true },
 secure_url: { type: String, required: true },
 format: { type: String, required: true },
 etag: { type: String, required: true },
 width: Number,
 height: Number
 */
