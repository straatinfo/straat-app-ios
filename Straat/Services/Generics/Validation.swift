//
//  Validation.swift
//  Straat
//
//  Created by Global Array on 06/02/2019.
//

import Foundation


// this class will handle all the func of diff validations and masking

// will improve this validation
    func validateTextField( tf : [UITextField] ) -> Bool {
        var countT : Int = 0
        var countF : Int = 0
        var ret : Bool = false
        
        for item in tf {
            
            if (item.text?.count)! <= 0 {
                countF += 1
            } else {
                countT += 1
            }
        }
        
        if (countF > 0) {
            ret = false
        } else {
            ret = true
        }
        
        
        return ret
    }




//extension String {
//
//    var stripped: String {
//        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
//        return self.filter {okayChars.contains($0) }
//    }
//}

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*\\d)(?=.*[a-z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{6,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: self)
    }
    
    func isMobileNumberValid() -> Bool {
        let mobileNumberRegex = "^[0-9]+$"
        let mobileNumberPredicate = NSPredicate(format: "SELF MATCHES %@", mobileNumberRegex)
        return mobileNumberPredicate.evaluate(with:self)
        
    }
    
    func isValid() -> Bool {
        let stringRegex = "^[A-Za-z0-9]+$"
        let stringPredicate = NSPredicate(format: "SELF MATCHES %@", stringRegex)
        return stringPredicate.evaluate(with:self)

    }
    
    func isUserNameNotValid() -> Bool {
        let specialUsers = ["pol", "politie", "agent", "bureau", "gemeente", "afdeling", "sectie", "dienst"]
        return specialUsers.contains(self.lowercased())
    }
    
}
