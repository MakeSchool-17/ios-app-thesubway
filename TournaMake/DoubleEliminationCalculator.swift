//
//  DoubleEliminationCalculator.swift
//  TournaMake
//
//  Created by Dan Hoang on 7/13/16.
//  Copyright © 2016 Dan Hoang. All rights reserved.
//

import UIKit

class DoubleEliminationCalculator {
    
    class func getLoserMatchId(k: Int, idxOfPrevMatch: Int) -> (Int?, Bool) {
        //figure out what round the loss was from.
        //round 2 and later, go by different fall formulas.
        //round 2 is
        var isLeft = true
        let round1Cutoff = k * 3 / 2 - 1
        if idxOfPrevMatch >= round1Cutoff {
            //it's round 1, and they fall (n+1)/2 times.
            if idxOfPrevMatch % 2 == 1 {
                isLeft = false
            }
            return ((idxOfPrevMatch + 1 ) / 2, isLeft)
        }
        // cutoff is 23. 23 - anything from 22-19 should be <=4.
        // round 2 is >= round1Cutoff - k/4; 22-19 falls to 11-8
        // round 3 is >= round1cutoff - k/8; 23 - 18-17 should be <=(4+2).
        //so subtract round1Cutoff from number, and get result.
        //check if it's more than k/(2^n) or not, starting n=2
        //If not, keep doubling n.
        //If yes, treat n as round num, and they fall (2 additions before subtract 1)
        var n = 2
        var previous = k / (MathHelper.powerOf(2, power: n))
        while true {
            print("\(round1Cutoff) - \(idxOfPrevMatch) <= \(k) / \(MathHelper.powerOf(2, power: n))")
            // want a function where round2 returns 4, round3 returns 6, round4 returns 7.
            if (round1Cutoff - idxOfPrevMatch) <= previous {
                return (idxOfPrevMatch - getFallAmount(k, roundNum: n), true)
            }
            if k / (MathHelper.powerOf(2, power: n)) < 1 {
                break
            }
            n += 1
            previous += k / (MathHelper.powerOf(2, power: n))
        }
        return (nil, isLeft)
    }
    
    class func getFallAmount(k: Int, roundNum: Int) -> Int {
        var n = k / 2
        var total = 0
        var idx = 0
        while idx < roundNum {
            total += n
            n /= 2
            idx += 1
        }
        total -= 1
        return total
    }
    
}