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
    
    class func isPlayerId(idStr: String?) -> Bool {
        if idStr != nil && idStr != GlobalConstants.bye {
            return true
        }
        return false
    }
    
    //stack overflow helper:
    class func compareAnyObjectType(a: AnyObject?, b: AnyObject?) -> Bool {
        if let va = a as? Int, vb = b as? Int {
            if va == vb {
                return true
            }
        }
        else if let va = a as? Float, vb = b as? Float {
            if va == vb {
                return true
            }
        }
        else if let va = a as? Bool, vb = b as? Bool {
            if va == vb {
                return true
            }
        }
        // not a type we expected
        return false
    }
    
    class func winnerOfMatch(match: Match) -> String? {
        if match.leftId == GlobalConstants.bye && match.rightId != nil {
            return match.rightId
        }
        else if match.leftId != nil && match.rightId == GlobalConstants.bye {
            return match.leftId
        }
        else if !self.isPlayerId(match.leftId) || !self.isPlayerId(match.rightId) {
            return nil
        }
        if match.leftScore == nil || match.rightScore == nil {
            return nil
        }
        if match.leftScore?.floatValue > match.rightScore?.floatValue {
            return match.leftId
        }
        else if match.leftScore?.floatValue < match.rightScore?.floatValue {
            return match.rightId
        }
        return nil
    }
    
    class func loserOfMatch(match: Match) -> String? {
        if self.winnerOfMatch(match) == nil {
            return nil
        }
        if self.winnerOfMatch(match) == match.leftId {
            return match.rightId
        }
        if self.winnerOfMatch(match) == match.rightId {
            return match.leftId
        }
        return nil
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