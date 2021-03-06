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
                //if roundNum is 2
                if (n == 2) {
                    let fallAmount = getFallAmount(k, roundNum: n)
                    let newIdx = idxOfPrevMatch - fallAmount
                    //after I have already found the index I need.
                    var lowerIdx = idxOfPrevMatch
                    var upperIdx = idxOfPrevMatch
                    while upperIdx < round1Cutoff - 1 {
                        upperIdx += 1
                    }
                    while (round1Cutoff - lowerIdx) <= previous - 1 {
                        lowerIdx -= 1
                    }
                    let changeAmount = (upperIdx - lowerIdx + 1) / 2
                    if newIdx - changeAmount < (lowerIdx - fallAmount) {
                        //my adjusted result is newIdx + changeAmount
                        return (newIdx + changeAmount, true)
                    }
                    else if newIdx + changeAmount > (upperIdx - fallAmount) {
                        return (newIdx - changeAmount, true)
                    }
                    //got the range. Figured out if this new index was in bottom/top of range.
                }
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
    
    class func getFallAmount2(k: Int, roundNum: Int) -> Int {
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
    
    class func getRangesIdxInclusive(k: Int, roundNum: Int, newIdx: Int?) -> (Int, Int) {
        var i = 0
        var startIdx = 0
        var endIdx = 0
        let fallAmount = self.getFallAmount2(k, roundNum: roundNum)
        while i < 100 {
            //when is it, that getFallAmount will start returning the right amount? Start range here
            //fallAmount is not doing the right thing here.
            if i == fallAmount {
                startIdx = i
                break
            }
            i += 1
        }
        while true {
            //when is it, that getFallAmount will STOP returning the right amount? Start range here
            if i > fallAmount {
                endIdx = i - 1
                break
            }
            i += 1
        }
        return (startIdx, endIdx)
    }
    
    class func loserGetPrevious(k : Int, i: Int) -> (Int, Int!) {
        //assumed, i < k
        //first, get the roundNum.
        var roundNum = 0
        let round1Cutoff = k - k / (MathHelper.powerOf(2, power: 2))
        if i >= k {
            roundNum = -1
            return (roundNum, nil)
        }
        else if i >= round1Cutoff {
            roundNum = 1
            //get previousBottomIdx, nil
            return (roundNum, nil)
        }
        roundNum = 2
        var interval = k / (MathHelper.powerOf(2, power: 2))
        var previous = round1Cutoff //is now 12
        while true {
            previous -= interval
            if i >= previous {
                break
            }
            if roundNum % 2 == 1 {
                interval /= 2
            }
            if interval <= 0 {
                break
            }
            roundNum += 1
        }
        //at this point we know the right roundNum
        //if roundNum is even, subtract interval.
        // 11 and 10 become 7? makes it 7 and 6 become 3.
        // want 7 to be 10
        // so (n - 4) / 2 + 4
        if roundNum % 2 == 0 {
            return (roundNum, i + interval)
        }
        else {
            return (roundNum, (i - interval) * 2 + interval)
        }
    }
    
    class func loserGetNext(k: Int, i: Int) -> (Int, Int!) {
        var roundNum = 0
        let round1Cutoff = k - k / (MathHelper.powerOf(2, power: 2)) //cutoff conveniently 3/4 of k
        var interval = k / (MathHelper.powerOf(2, power: 2)) //interval is k / 4
        if i >= k {
            roundNum = -1
            return (roundNum, nil)
        }
        else if i >= round1Cutoff {
            roundNum = 1
            //first round, and odd rounds, simply subtract by interval
            //and then face dropdown from winner's bracket
            return (roundNum, i - interval)
        }
        roundNum = 2
        var previous = round1Cutoff
        while true {
            previous -= interval
            if i >= previous {
                break
            }
            if roundNum % 2 == 0 {
                //because in loser-bracket, number of matches only changes every 2 rounds.
                interval /= 2
            }
            if interval <= 0 {
                break
            }
            roundNum += 1
        }
        if roundNum % 2 == 1 {
            return (roundNum, i - interval)
        }
        else {
            return (roundNum, interval + (i - interval) / 2)
        }
    }
    
}