//
//  ReportTypeModel.swift
//  Straat
//
//  Created by John Higgins M. Avila on 22/02/2019.
//

import Foundation

class ReportTypeModel {
    
    var id: String?
    var code: String?
    var name: String?
    
    init () {
        
    }
    
    init (id: String?, code: String?, name: String?) {
        self.id = id
        self.code = code
        self.name = name
    }
    
    init (reportTypeData: Dictionary<String, Any>) {
        self.id = reportTypeData["_id"] as? String
        self.code = reportTypeData["code"] as? String
        self.name = reportTypeData["name"] as? String
    }
}

/*
 "_id": "5a7888bb04866e4742f74955",
 "updatedAt": "2019-02-21T17:39:14.054Z",
 "createdAt": "2018-06-07T00:51:23.380Z",
 "code": "A",
 "name": "Public Space",
 */


