//
//  BracketCalculator.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/20/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class BracketCalculator {
    class func calculateBrackets(groups : [[String]]!, tournamentData : TournamentData!) -> [BracketMatch] {
        //assuming 6-16 teams in tournament:
        let numTeamsAdvance = self.getNumTeamsAdvancing(tournamentData)
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
            //3rd place teams will exist.
            if groups.count == 5 {
                let match1 = BracketMatch()
                match1.groupLetterLeftTeam = "\(groupNames[0])"
                match1.groupPlacingLeftTeam = match1.groupWinner
                match1.groupLetterRightTeam = match1.undecided
                match1.groupPlacingRightTeam = match1.bye
                bracketTop.append(match1)
                
                let match2 = BracketMatch()
                match2.groupLetterLeftTeam = "\(groupNames[0])"
                match2.groupPlacingLeftTeam = match2.groupRunnerUp
                match2.groupLetterRightTeam = match2.undecided
                match2.groupPlacingRightTeam = match2.group3rd
                bracketBottom.append(match2)
                
                let match3 = BracketMatch()
                match3.groupLetterLeftTeam = "\(groupNames[1])"
                match3.groupPlacingLeftTeam = match3.groupRunnerUp
                match3.groupLetterRightTeam = "\(groupNames[3])"
                match3.groupPlacingRightTeam = match3.groupRunnerUp
                bracketTop.append(match3)
                
                let match4 = BracketMatch()
                match4.groupLetterLeftTeam = "\(groupNames[1])"
                match4.groupPlacingLeftTeam = match4.groupWinner
                match4.groupLetterRightTeam = match4.undecided
                match4.groupPlacingRightTeam = match4.bye
                bracketBottom.append(match4)
                
                let match5 = BracketMatch()
                match5.groupLetterLeftTeam = "\(groupNames[2])"
                match5.groupPlacingLeftTeam = match5.groupWinner
                match5.groupLetterRightTeam = match5.undecided
                match5.groupPlacingRightTeam = match5.bye
                bracketTop.append(match5)
                
                let match6 = BracketMatch()
                match6.groupLetterLeftTeam = "\(groupNames[2])"
                match6.groupPlacingLeftTeam = match6.groupRunnerUp
                match6.groupLetterRightTeam = "\(groupNames[4])"
                match6.groupPlacingRightTeam = match6.groupRunnerUp
                bracketBottom.append(match6)
                
                let match7 = BracketMatch()
                match7.groupLetterLeftTeam = "\(groupNames[4])"
                match7.groupPlacingLeftTeam = match7.groupWinner
                match7.groupLetterRightTeam = match7.undecided
                match7.groupPlacingRightTeam = match7.group3rd
                bracketTop.append(match7)
                
                let match8 = BracketMatch()
                match8.groupLetterLeftTeam = "\(groupNames[3])"
                match8.groupPlacingLeftTeam = match8.groupWinner
                match8.groupLetterRightTeam = match8.undecided
                match8.groupPlacingRightTeam = match8.bye
                bracketBottom.append(match8)
            }
            else if groups.count == 6 || groups.count == 12 {
                //A1 vs. 3rd place
                for var i = 0; i < groups.count; i += 6 {
                    let match1 = BracketMatch()
                    match1.groupLetterLeftTeam = "\(groupNames[0+i])"
                    match1.groupPlacingLeftTeam = match1.groupWinner
                    match1.groupLetterRightTeam = match1.undecided
                    match1.groupPlacingRightTeam = match1.group3rd
                    bracketTop.append(match1)
                    
                    let match2 = BracketMatch()
                    match2.groupLetterLeftTeam = "\(groupNames[1+i])"
                    match2.groupPlacingLeftTeam = match2.groupRunnerUp
                    match2.groupLetterRightTeam = "\(groupNames[5+i])"
                    match2.groupPlacingRightTeam = match2.groupRunnerUp
                    bracketTop.append(match2)
                    
                    let match3 = BracketMatch()
                    match3.groupLetterLeftTeam = "\(groupNames[2+i])"
                    match3.groupPlacingLeftTeam = match3.groupWinner
                    match3.groupLetterRightTeam = match3.undecided
                    match3.groupPlacingRightTeam = match3.group3rd
                    bracketTop.append(match3)
                    
                    let match4 = BracketMatch()
                    match4.groupLetterLeftTeam = "\(groupNames[4+i])"
                    match4.groupPlacingLeftTeam = match4.groupWinner
                    match4.groupLetterRightTeam = "\(groupNames[3+i])"
                    match4.groupPlacingRightTeam = match4.groupRunnerUp
                    bracketTop.append(match4)
                    
                    let match5 = BracketMatch()
                    match5.groupLetterLeftTeam = "\(groupNames[5+i])"
                    match5.groupPlacingLeftTeam = match5.groupWinner
                    match5.groupLetterRightTeam = "\(groupNames[4+i])"
                    match5.groupPlacingRightTeam = match5.groupRunnerUp
                    bracketBottom.append(match5)
                    
                    let match6 = BracketMatch()
                    match6.groupLetterLeftTeam = "\(groupNames[1+i])"
                    match6.groupPlacingLeftTeam = match6.groupWinner
                    match6.groupLetterRightTeam = match6.undecided
                    match6.groupPlacingRightTeam = match6.group3rd
                    bracketBottom.append(match6)
                    
                    let match7 = BracketMatch()
                    match7.groupLetterLeftTeam = "\(groupNames[3+i])"
                    match7.groupPlacingLeftTeam = match7.groupWinner
                    match7.groupLetterRightTeam = match7.undecided
                    match7.groupPlacingRightTeam = match7.group3rd
                    bracketBottom.append(match7)
                    
                    let match8 = BracketMatch()
                    match8.groupLetterLeftTeam = "\(groupNames[0+i])"
                    match8.groupPlacingLeftTeam = match8.groupRunnerUp
                    match8.groupLetterRightTeam = "\(groupNames[2+i])"
                    match8.groupPlacingRightTeam = match8.groupRunnerUp
                    bracketBottom.append(match8)
                }

            }
            else if groups.count == 7 {
                let match1 = BracketMatch()
                match1.groupLetterLeftTeam = "\(groupNames[0])"
                match1.groupPlacingLeftTeam = match1.groupWinner
                match1.groupLetterRightTeam = match1.undecided
                match1.groupPlacingRightTeam = match1.group3rd
                bracketTop.append(match1)
                
                let match2 = BracketMatch()
                match2.groupLetterLeftTeam = "\(groupNames[1])"
                match2.groupPlacingLeftTeam = match2.groupRunnerUp
                match2.groupLetterRightTeam = "\(groupNames[2])"
                match2.groupPlacingRightTeam = match2.groupRunnerUp
                bracketTop.append(match2)
                
                let match3 = BracketMatch()
                match3.groupLetterLeftTeam = "\(groupNames[3])"
                match3.groupPlacingLeftTeam = match3.groupWinner
                match3.groupLetterRightTeam = "\(groupNames[4])"
                match3.groupPlacingRightTeam = match3.groupRunnerUp
                bracketTop.append(match3)
                
                let match4 = BracketMatch()
                match4.groupLetterLeftTeam = "\(groupNames[5])"
                match4.groupPlacingLeftTeam = match4.groupWinner
                match4.groupLetterRightTeam = "\(groupNames[6])"
                match4.groupPlacingRightTeam = match4.groupRunnerUp
                bracketTop.append(match4)
                
                let match5 = BracketMatch()
                match5.groupLetterLeftTeam = "\(groupNames[1])"
                match5.groupPlacingLeftTeam = match5.groupWinner
                match5.groupLetterRightTeam = match5.undecided
                match5.groupPlacingRightTeam = match5.group3rd
                bracketBottom.append(match5)
                
                let match6 = BracketMatch()
                match6.groupLetterLeftTeam = "\(groupNames[7])"
                match6.groupPlacingLeftTeam = match6.groupWinner
                match6.groupLetterRightTeam = "\(groupNames[0])"
                match6.groupPlacingRightTeam = match6.groupRunnerUp
                bracketBottom.append(match6)
                
                let match7 = BracketMatch()
                match7.groupLetterLeftTeam = "\(groupNames[2])"
                match7.groupPlacingLeftTeam = match7.groupWinner
                match7.groupLetterRightTeam = "\(groupNames[3])"
                match7.groupPlacingRightTeam = match7.groupRunnerUp
                bracketBottom.append(match7)
                
                let match8 = BracketMatch()
                match8.groupLetterLeftTeam = "\(groupNames[4])"
                match8.groupPlacingLeftTeam = match8.groupWinner
                match8.groupLetterRightTeam = "\(groupNames[5])"
                match8.groupPlacingRightTeam = match8.groupRunnerUp
                bracketBottom.append(match8)
            }
        }
        return bracketTop + bracketBottom
    }
    class func getNumTeamsAdvancing(tournamentData : TournamentData) -> Double {
        if tournamentData.entrants.count <= 8 {
            return 4
        }
        else if tournamentData.entrants.count <= 11 {
            return 6
        }
        else if tournamentData.entrants.count <= 16 {
            return 8
        }
        else if tournamentData.entrants.count <= 20 {
            return 12
        }
        else if tournamentData.entrants.count <= 32 {
            return 16
        }
        else if tournamentData.entrants.count <= 40 {
            return 24
        }
        else if tournamentData.entrants.count <= 64 {
            return 32
        }
        return 0
    }
}
