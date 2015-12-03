//
//  FormValidation.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/17/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class AlgorithmUtil {
    class func hasNonWhiteSpaceChar(str : String) -> Bool {
        let trimmedStr = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if trimmedStr == "" {
            return false
        }
        return true
    }
    
    class func removedFromArr(inArr : [String], element : String) -> [String] {
        let outArr = inArr.filter() { $0 != element }
        return outArr
    }
    
    class func isInteger(num : Float) -> Bool {
        return  num - floor(num) > 0.000001
    }
}

extension String {
    var doubleValue: Double? {
        return Double(self)
    }
    var floatValue: Float? {
        return Float(self)
    }
    var integerValue: Int? {
        return Int(self)
    }
}