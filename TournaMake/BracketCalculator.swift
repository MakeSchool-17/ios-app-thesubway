//
//  BracketCalculator.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/20/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class BracketCalculator {
    class func calculateBrackets(groups : [[String]]!, tournamentData : TournamentData!) {
        //assuming 6-16 teams in tournament:
        var numTeamsAdvance : Double = 0
        if tournamentData.entrants.count <= 8 {
            numTeamsAdvance = 4
        }
        else if tournamentData.entrants.count <= 11 {
            numTeamsAdvance = 6
        }
        else if tournamentData.entrants.count <= 16 {
            numTeamsAdvance = 8
        }
        else if tournamentData.entrants.count <= 20 {
            numTeamsAdvance = 12
        }
        else if tournamentData.entrants.count <= 32 {
            numTeamsAdvance = 16
        }
        else if tournamentData.entrants.count <= 40 {
            numTeamsAdvance = 24
        }
        else if tournamentData.entrants.count <= 64 {
            numTeamsAdvance = 32
        }
        var numRounds = 1.0
        while true {
            if pow(2.0, numRounds) >= numTeamsAdvance {
                break
            }
            numRounds++
        }
        let numTopTwo : Double = Double(groups.count) * 2
        //top two always advance. Question is how many 3rd-place will advance.
        let num3rdPlace = numTeamsAdvance - numTopTwo
        //        num3rdPlace = numTeamsAdvance - (tournamentData.entrants.count / 2)
        let groupNames = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ123456".characters)
        
        /*bracketTop and bracketBottom ensure that group-winners and group-runner-ups
        from same group will not face each other, unless they both reach the end of the bracket
        (whether it's championship match, or 3rd-place match)*/
        var bracketTop : [BracketMatch] = []
        var bracketBottom : [BracketMatch] = []
        
        if num3rdPlace == 0 {
            //since num3rdPlace == 0, we know numTeamsAdvance == numTopTwo,
            //but in tournaments of 9, we get numTeamsAdvance == 6.
            //which means num groups always divisible by 2.
            if MathHelper.isPowerOfTwo(Int(numTeamsAdvance)) {
                for var i = 0; i < groups.count; i += 2 {
                    let match1 = BracketMatch()
                    match1.groupLetterLeftTeam = "\(groupNames[i])"
                    match1.groupPlacingLeftTeam = match1.groupWinner
                    match1.groupLetterRightTeam = "\(groupNames[i+1])"
                    match1.groupPlacingRightTeam = match1.groupRunnerUp
                    bracketTop.append(match1)
                    
                    let match2 = BracketMatch()
                    match2.groupLetterLeftTeam = "\(groupNames[i+1])"
                    match2.groupPlacingLeftTeam = match2.groupWinner
                    match2.groupLetterRightTeam = "\(groupNames[i])"
                    match2.groupPlacingRightTeam = match2.groupRunnerUp
                    bracketBottom.append(match2)
                }
            }
            else {
                //this means there are 6 teams, but no 3rd-place teams.
                let match1 = BracketMatch()
                match1.groupLetterLeftTeam = "\(groupNames[0])"
                match1.groupPlacingLeftTeam = match1.groupWinner
                match1.groupLetterRightTeam = match1.undecided
                match1.groupPlacingRightTeam = match1.bye
                bracketTop.append(match1)
                
                let match2 = BracketMatch()
                match2.groupLetterLeftTeam = "\(groupNames[0])"
                match2.groupPlacingLeftTeam = match2.groupRunnerUp
                match2.groupLetterRightTeam = "\(groupNames[2])"
                match2.groupPlacingRightTeam = match2.groupRunnerUp
                bracketBottom.append(match2)
                
                let match3 = BracketMatch()
                match3.groupLetterLeftTeam = "\(groupNames[2])"
                match3.groupPlacingLeftTeam = match3.groupWinner
                match3.groupLetterRightTeam = "\(groupNames[1])"
                match3.groupPlacingRightTeam = match3.groupRunnerUp
                bracketTop.append(match3)
                
                let match4 = BracketMatch()
                match4.groupLetterLeftTeam = "\(groupNames[1])"
                match4.groupPlacingLeftTeam = match4.groupWinner
                match4.groupLetterRightTeam = match4.undecided
                match4.groupPlacingRightTeam = match4.bye
                bracketBottom.append(match4)
            }
        }
        else {
            //check if numTeamsAdvance is evenly a power of 2.
            if MathHelper.isPowerOfTwo(Int(numTeamsAdvance)) == true {
                //no byes
                print("\(numTeamsAdvance) power of two")
            }
            else {
                //there will be byes
                print("\(numTeamsAdvance) not power of two")
                var numTeamsOnBye = Int(numTeamsAdvance) - MathHelper.closestPowerOf2SmallerThanOrEqualTo(Int(numTeamsAdvance))
                if groups.count == 6 {
                    
                }
            }
        }
        //print out brackets:
        for eachBracket in bracketTop {
            eachBracket.printMatch()
        }
        for eachBracket in bracketBottom {
            eachBracket.printMatch()
        }
    }
}
