//
//  MathHelper.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/20/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class MathHelper {
    class func isPowerOfTwo(num : Int) -> Bool {
        var i = 1
        while i <= num {
            if i == num {
                return true
            }
            i *= 2
        }
        return false
    }
    class func closestPowerOf2SmallerThanOrEqualTo(num : Int) -> Int! {
        if num < 1 {
            return nil
        }
        var i = 1
        while i <= num {
            if i * 2 > num {
                return i
            }
            i *= 2
        }
        return nil
    }
}
