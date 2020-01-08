//
//  CategoryService.swift
//  Straat
//
//  Created by John Higgins M. Avila on 17/02/2019.
//

import Foundation
import Alamofire
import SwiftyJSON

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
                
                let categories = data["data"] as? [[String: Any]] ?? []
                print("TEST: \(String(describing: categories))")
				
				if categories.count > 0 {
					for category in categories {
						
						let mainCategory = self.parseMainCategory(category: category)
//                    if mainCategory.code != nil && mainCategory.code == "A" {
//                        mainCategories.append(mainCategory)
//                    }
						mainCategories.append(mainCategory)
						print("response: \(category)")
					}
					
                	completion(true, "Success", mainCategories)
				} else {
                	completion(false, "No List", [])
				}


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
                
                let categories = data["data"] as? [[String: Any]] ?? []
				
				if categories.count > 0 {
					for category in categories {
						let reportType = category["_reportType"] as? Dictionary<String, Any>
						let code = reportType!["code"] as? String
						debugPrint("code: \(code)")
						
						if code == "B" {
							let mainCategory = self.parseMainCategory(category: category)
							mainCategories.append(mainCategory)
						}
					}
					
					completion(true, "Success", mainCategories)
				} else {
					completion(false, "No List", [])
				}

            }
        }
    }
	
	func getMainCategoryC (language: String?, completion: @escaping (Bool, String, [MainCategoryModel]) -> Void) {
		
		var parameters: Parameters = [:]
		parameters["language"] = language ?? "nl"
		parameters["code"] = "C"
		
//		apiHandler.executeWithHeaders(URL(string: get_default_categories)!, parameters: parameters, method: .get, destination: .queryString, headers: [:]) { (response, err) in
//			var mainCategories: [MainCategoryModel] = []
//			if let error = err {
//				completion(false, error.localizedDescription, [])
//
//			} else if let data = response {
//
//				let categories = data["data"] as? [[String: Any]] ?? []
//
//				if categories.count > 0 {
//					for category in categories {
//						let reportType = category["_reportType"] as? Dictionary<String, Any>
//						let code = reportType!["code"] as? String
//						debugPrint("code: \(code)")
//
//						if code == "B" {
//							let mainCategory = self.parseMainCategory(category: category)
//							mainCategories.append(mainCategory)
//						}
//					}
//
//					completion(true, "Success", mainCategories)
//				} else {
//					completion(false, "No List", [])
//				}
//
//			}
//		}
		

		apiHandler.executeWithHeadersV2(URL(string: get_default_categories)!, parameters: parameters, method: .get, destination: .queryString, headers: [:]) { (response, err) in
			var mainCategories: [MainCategoryModel] = []
			if let error = err {
				completion(false, error.localizedDescription, [])
			} else if let data = response {
				let categories = data["data"].arrayValue
				
				if categories.count > 0 {
					for category in categories {
						let code = category["_reportType"]["code"]
						// to be continue
						
						if code == "C" {
							let mainCategory = self.parseMainCategoryV2(category: category)
							mainCategories.append(mainCategory)
						}
					}
					
					completion(true, "success", mainCategories)
				} else {
					completion(false, "Empty List", [])
				}

			}
		}
	}
}

extension CategoryService { // helper functions
    
    func parseMainCategory (category: Dictionary<String, Any>) -> MainCategoryModel {
        var subCategories = [SubCategoryModel]()
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
//            let subCatDescription = subCat["description"] as? String

            let subCategory = SubCategoryModel(id: subCatId, name: subCatName, description: "", mainCategoryName: name)
//            print("parse sub id: \(subCatId)")
//            print("parse sub categs: \(subCategory)")

            subCategories.append(SubCategoryModel(id: subCatId, name: subCatName, description: "", mainCategoryName: name))
        }
        
        let mainCategory = MainCategoryModel(
            id: id, name: name,
            description: description,
//            code: code,
//            codeName: reportTypeName,
//            codeId: codeId,
            subCategories: subCategories
            
        )
        return mainCategory
    }
	
	// to be continue
	func parseMainCategoryV2 (category: JSON) -> MainCategoryModel {
		var subCategories = [SubCategoryModel]()
		
		let id = category["_id"].stringValue
		let name = category["name"].stringValue
		let description = category["description"].stringValue
//		let reportType = category["_reportType"]
//		let code = reportType["code"].stringValue
//		let reportTypeName = reportType["name"].stringValue
//		let codeId = reportType["_id"].stringValue
		
		let subCats = category["subCategories"].arrayValue
		
		if subCats.count > 0 {
			for subCat in subCats {
				let subCatId = subCat["_id"].stringValue
				let subCatName = subCat["name"].stringValue
				//            let subCatDescription = subCat["description"] as? String
				
				let subCategory = SubCategoryModel(id: subCatId, name: subCatName, description: "", mainCategoryName: name)
				//            print("parse sub id: \(subCatId)")
				//            print("parse sub categs: \(subCategory)")
				
				subCategories.append(SubCategoryModel(id: subCatId, name: subCatName, description: "", mainCategoryName: name))
			}
		}
		
		let mainCategory = MainCategoryModel(
			id: id, name: name,
			description: description,
			//            code: code,
			//            codeName: reportTypeName,
			//            codeId: codeId,
			subCategories: subCategories
		)
		
		return mainCategory
	}
    
}
