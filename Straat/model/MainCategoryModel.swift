//
//  MainCategoryModel.swift
//  Straat
//
//  Created by John Higgins M. Avila on 17/02/2019.
//

import Foundation

class MainCategoryModel {
    var id: String?
    var name: String?
    var code: String?
    var codeName: String?
    var codeId: String?
    var description: String?
    var subCategories: [SubCategoryModel]?
    
    init () {
        
    }
    
    init (
        id: String?,
        name: String?,
        description: String?
//        code: String?,
//        codeName: String?,
//        codeId: String?,
//        subCategories: [SubCategoryModel]?
    ) {
        self.id = id
        self.name = name
        self.description = description
//        self.code = code
//        self.codeId = codeId
//        self.codeName = codeName
//        self.subCategories = subCategories
    }
    
    init (mainCategoryData: Dictionary<String, Any>?) {
        self.id = mainCategoryData!["_id"] as? String
        self.name = mainCategoryData!["name"] as? String
        self.description = mainCategoryData!["description"] as? String
//        self.code = mainCategoryData!["code"] as? String
//        self.codeId = mainCategoryData!["_id"] as? String
//        self.codeName = mainCategoryData!["_id"] as? String
//        var subCategories: [SubCategoryModel] = []
//
//        let subCategoryDatas = mainCategoryData!["subCategories"] as? [[String: Any]] ?? []
//
//        if subCategories.count > 0 {
//            for subCategoryData in subCategoryDatas {
//                let subCategory = SubCategoryModel(subCategoryData: subCategoryData)
//                subCategories.append(subCategory)
//            }
//        }
    }
}
