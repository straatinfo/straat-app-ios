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




extension String {
    
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        return self.filter {okayChars.contains($0) }
    }
}
