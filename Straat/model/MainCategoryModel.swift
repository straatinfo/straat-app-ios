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
    var subCategories: [SubCategoryModel]
    
    init (
        id: String?,
        name: String?,
        description: String?,
        code: String?,
        codeName: String?,
        codeId: String?,
        subCategories: [SubCategoryModel]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.code = code
        self.codeId = codeId
        self.codeName = codeName
        self.subCategories = subCategories
    }
}
