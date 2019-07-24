//
//  UtilsService.swift
//  Straat
//
//  Created by John Higgins M. Avila on 05/07/2019.
//

import Foundation

// string extensions
extension String {
    func shorten (limit: Int) -> String {
        if (self.count <= limit - 3) {
            return self
        } else {
            let shortenString = String(self.prefix(limit - 3))
            
            return "\(shortenString)..."
        }
    }
    
    func toDate (format: String?) -> String {
        let f = format ?? "d MMM yyyy"
        
        let dateFormatter = DateFormatter()
        let dateFormat = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: NSLocalizedString("date-locale", comment: ""))
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormat.dateFormat = f
        let stringDate = dateFormatter.date(from: self)
        return dateFormat.string(for: stringDate) ?? self
    }
    
    func replaceSpace () -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
}

class UtilsService {
    init() {}
}
