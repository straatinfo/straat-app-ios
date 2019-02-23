//
//  CategoryService.swift
//  Straat
//
//  Created by John Higgins M. Avila on 17/02/2019.
//

import Foundation
import Alamofire

class CategoryService {
    init() {
        
    }
    
    let apiHandler = ApiHandler()
    
    func getMainCategoryA (hostId: String, language: String?, completion: @escaping (Bool, String?, [MainCategoryModel]) -> Void) {
        
        var parameters: Parameters = [:]
        parameters["language"] = language ?? "nl"
 
        apiHandler.executeWithHeaders(URL(string: get_categories_by_host + hostId)!, parameters: parameters, method: .get, destination: .queryString, headers: [:]) { (response, err) in
            var mainCategories: [MainCategoryModel] = []
            if let error = err {
                completion(false, error.localizedDescription, [])
                
            } else if let data = response {
                let categories = data["data"] as? [[String: Any]]
                for category in categories! {
                    
                    let mainCategory = self.parseMainCategory(category: category)
                    
                    if mainCategory.code != nil && mainCategory.code == "A" {
                        mainCategories.append(mainCategory)
                    }
                }
                
                completion(true, "Success", mainCategories)
            }
        }
    }
    
    func getMainCategoryB (language: String?, completion: @escaping (Bool, String, [MainCategoryModel]) -> Void) {

        var parameters: Parameters = [:]
        parameters["language"] = language ?? "nl"
        parameters["code"] = "ABC"

        apiHandler.executeWithHeaders(URL(string: get_default_categories)!, parameters: parameters, method: .get, destination: .queryString, headers: [:]) { (response, err) in
            var mainCategories: [MainCategoryModel] = []
            if let error = err {
                completion(false, error.localizedDescription, [])
                
            } else if let data = response {
                let categories = data["data"] as? [[String: Any]]
                for category in categories! {
                    let mainCategory = self.parseMainCategory(category: category)
                    
                    if mainCategory.code != nil && mainCategory.code == "B" {
                        mainCategories.append(mainCategory)
                    }
                    
                }
                
                completion(true, "Success", mainCategories)
            }
        }
    }
}

extension CategoryService { // helper functions
    
    func parseMainCategory (category: Dictionary<String, Any>) -> MainCategoryModel {
        var subCategories : [SubCategoryModel] = []
        let id = category["_id"] as? String
        let name = category["name"] as? String
        let description = category["description"] as? String
        let reportType = category["_reportType"] as? Dictionary<String, Any>
        let code = reportType?["code"] as? String
        let reportTypeName = reportType?["name"] as? String
        let codeId = reportType?["_id"] as? String
        let subCats = category["subCategories"] as? [[String: Any]]
        
        for subCat in subCats! {
            let subCatId = subCat["_id"] as? String
            let subCatName = subCat["name"] as? String
            let subCatDescription = subCat["description"] as? String
            
            let subCategory = SubCategoryModel(id: subCatId, name: subCatName, description: subCatDescription, mainCategoryName: name)
            
            subCategories.append(subCategory)
        }
        let mainCategory = MainCategoryModel(
            id: id, name: name,
            description: description
//            code: code,
//            codeName: reportTypeName,
//            codeId: codeId,
//            subCategories: subCategories
        )
        return mainCategory
    }
    
}
