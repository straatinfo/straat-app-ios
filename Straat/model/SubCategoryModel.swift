//
//  SubCategoryModel.swift
//  Straat
//
//  Created by John Higgins M. Avila on 17/02/2019.
//

import Foundation


class SubCategoryModel {
    var id: String?
    var name: String?
    var description: String?
    var mainCategoryName : String?
    var mainCategoryId: String?
    
    init () {
        
    }
    
    init(id: String?, name: String?, description: String?, mainCategoryName : String?) {
        self.id = id
        self.name = name
        self.description = description
//        self.mainCategoryName = mainCategoryName
    }
    
    init (subCategoryData: Dictionary<String, Any>) {
        self.id = subCategoryData["_id"] as? String
        self.name = subCategoryData["name"] as? String
        self.description = subCategoryData["description"] as? String
        
//        let mainCategory = subCategoryData["_mainCategory"] as? Dictionary<String, Any>
//        if mainCategory != nil {
//            self.mainCategoryId = mainCategory!["_id"] as? String
//        }
    }
}
