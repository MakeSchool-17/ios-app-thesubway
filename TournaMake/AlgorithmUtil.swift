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
    
    class func shuffleArr(inArr: [String]) -> [String] {
        var newArr : [String] = []
        var copyArr = inArr
        while copyArr.count > 0 {
            let randomIdx = Int(arc4random_uniform(UInt32(copyArr.count)))
            newArr.append(copyArr[randomIdx])
            copyArr.removeAtIndex(randomIdx)
        }
        return newArr
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
        else if match.leftScore?.floatValue == match.rightScore?.floatValue {
            return GlobalConstants.tie
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
        if self.winnerOfMatch(match) == GlobalConstants.tie {
            return GlobalConstants.tie
        }
        return nil
    }
    
    class func stringToDateJSON(dateString : String) -> NSDate {
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
        return dateFormatter.dateFromString(dateString)!
    }
    
    class func dateToStringWithMinutes(date : NSDate) -> String {
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    class func dateToStringWithTimeZone(date : NSDate) -> String {
        return NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.FullStyle)
    }
    
    //from stack overflow:
    class func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
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