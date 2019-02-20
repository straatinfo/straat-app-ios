//
//  ReportMapModel.swift
//  Straat
//
//  Created by Global Array on 19/02/2019.
//

import Foundation
// create a model
//    category or notification type
//    date *
//    time *
//    images []
//    status
//    private *
//    message
//    reporter *
//    address
//    long
//    lat

class ReportMapModel {
    var category: String?
    var images : [ReportImageModel]?
    var status : String?
    var message : String?
    var address : String?
    var lat : Double?
    var long : Double?
    
    init(category : String?, images : [ReportImageModel]?, status : String?, message : String?, address : String?, lat : Double?, long : Double?) {
        
        self.category = category
        self.images = images
        self.status = status
        self.message = message
        self.address = address
        self.lat = lat
        self.long = long
    }
    
}

class ReportImageModel {
    var imageUrl : String?
    
    init(imageUrl : String?) {
        self.imageUrl = imageUrl
    }
}
