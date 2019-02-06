//
//  HostModel.swift
//  Straat
//
//  Created by Global Array on 07/02/2019.
//

import Foundation

class HostModel {
    var id : String?
    var lat : String?
    var long : String?
    
    init( hostID : String? , hostLat : String? , hostLong : String?) {
        
        id = hostID
        lat = hostLat
        long = hostLong
        
    }
}
