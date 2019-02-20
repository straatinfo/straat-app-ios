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
    
    init(id: String?, name: String?, description: String?, mainCategoryName : String?) {
        self.id = id
        self.name = name
        self.description = description
        self.mainCategoryName = mainCategoryName
    }
}
