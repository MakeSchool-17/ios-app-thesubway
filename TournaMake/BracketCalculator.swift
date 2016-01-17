//
//  BracketCalculator.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/20/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class BracketCalculator {
    
    class func calculatePureBrackets(tournamentData: TournamentData) -> [String] {
        let numSlots = MathHelper.closestPowerOf2LargerThanOrEqualTo(tournamentData.entrants.count)
        let numByes = numSlots - tournamentData.entrants.count
        var entrantsCopy = AlgorithmUtil.shuffleArr(tournamentData.entrants)
        var bracketTop : [String] = []
        var bracketBottom : [String] = []
        var entrantNum = 0
        while entrantNum < numSlots / 2 {
            bracketTop.append(entrantsCopy[entrantNum])
            entrantNum++
        }
        if numByes > 0 {
            for _ in 0 ... numByes - 1 {
                bracketBottom.append(GlobalConstants.bye)
            }
        }
        while bracketBottom.count < bracketTop.count {
            bracketBottom.append(entrantsCopy[entrantNum])
            entrantNum++
        }
        var finalArr : [String] = []
        for var i = 0; i < bracketTop.count; i++ {
            finalArr.append(bracketTop[i])
            finalArr.append(bracketBottom[i])
        }
        return finalArr
    }
    
    class func calculateGroupBrackets(groups : [[String]]!, tournamentData : TournamentData!) -> [String] {
        let numTeamsAdvance = self.getNumTeamsAdvancing(tournamentData.entrants)
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
        if groups.count == 1 {
            let match1 = BracketMatch()
            match1.groupLetterLeftTeam = "\(groupNames[0])"
            match1.groupPlacingLeftTeam = GlobalConstants.groupWinner
            match1.groupLetterRightTeam = "\(groupNames[0])"
            match1.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
            bracketTop.append(match1)
            
            let match2 = BracketMatch()
            match2.groupLetterLeftTeam = GlobalConstants.undecided
            match2.groupPlacingLeftTeam = GlobalConstants.group3rd
            match2.groupLetterRightTeam = GlobalConstants.undecided
            match2.groupPlacingRightTeam = GlobalConstants.group4th
            bracketTop.append(match2)
        }
        else if num3rdPlace == 0 {
            //since num3rdPlace == 0, we know numTeamsAdvance == numTopTwo,
            //but in tournaments of 9, we get numTeamsAdvance == 6.
            //which means num groups always divisible by 2.
            if MathHelper.isPowerOfTwo(Int(numTeamsAdvance)) {
                for var i = 0; i < groups.count; i += 2 {
                    let match1 = BracketMatch()
                    match1.groupLetterLeftTeam = "\(groupNames[i])"
                    match1.groupPlacingLeftTeam = GlobalConstants.groupWinner
                    match1.groupLetterRightTeam = "\(groupNames[i+1])"
                    match1.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                    bracketTop.append(match1)
                    
                    let match2 = BracketMatch()
                    match2.groupLetterLeftTeam = "\(groupNames[i+1])"
                    match2.groupPlacingLeftTeam = GlobalConstants.groupWinner
                    match2.groupLetterRightTeam = "\(groupNames[i])"
                    match2.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                    bracketBottom.append(match2)
                }
            }
            else {
                //this means there are 6 teams, but no 3rd-place teams.
                let match1 = BracketMatch()
                match1.groupLetterLeftTeam = "\(groupNames[0])"
                match1.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match1.groupLetterRightTeam = GlobalConstants.undecided
                match1.groupPlacingRightTeam = GlobalConstants.bye
                bracketTop.append(match1)
                
                let match2 = BracketMatch()
                match2.groupLetterLeftTeam = "\(groupNames[0])"
                match2.groupPlacingLeftTeam = GlobalConstants.groupRunnerUp
                match2.groupLetterRightTeam = "\(groupNames[2])"
                match2.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketBottom.append(match2)
                
                let match3 = BracketMatch()
                match3.groupLetterLeftTeam = "\(groupNames[2])"
                match3.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match3.groupLetterRightTeam = "\(groupNames[1])"
                match3.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketTop.append(match3)
                
                let match4 = BracketMatch()
                match4.groupLetterLeftTeam = "\(groupNames[1])"
                match4.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match4.groupLetterRightTeam = GlobalConstants.undecided
                match4.groupPlacingRightTeam = GlobalConstants.bye
                bracketBottom.append(match4)
            }
        }
        else {
            //3rd place teams will exist.
            if groups.count == 3 {
                let match1 = BracketMatch()
                match1.groupLetterLeftTeam = "\(groupNames[0])"
                match1.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match1.groupLetterRightTeam = GlobalConstants.undecided
                match1.groupPlacingRightTeam = GlobalConstants.group3rd
                bracketTop.append(match1)
                
                let match2 = BracketMatch()
                match2.groupLetterLeftTeam = "\(groupNames[2])"
                match2.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match2.groupLetterRightTeam = "\(groupNames[1])"
                match2.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketTop.append(match2)
                
                let match3 = BracketMatch()
                match3.groupLetterLeftTeam = "\(groupNames[1])"
                match3.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match3.groupLetterRightTeam = GlobalConstants.undecided
                match3.groupPlacingRightTeam = GlobalConstants.group3rd
                bracketBottom.append(match3)
                
                let match4 = BracketMatch()
                match4.groupLetterLeftTeam = "\(groupNames[0])"
                match4.groupPlacingLeftTeam = GlobalConstants.groupRunnerUp
                match4.groupLetterRightTeam = "\(groupNames[2])"
                match4.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketBottom.append(match4)
            }
            else if groups.count == 5 {
                let match1 = BracketMatch()
                match1.groupLetterLeftTeam = "\(groupNames[0])"
                match1.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match1.groupLetterRightTeam = GlobalConstants.undecided
                match1.groupPlacingRightTeam = GlobalConstants.bye
                bracketTop.append(match1)
                
                let match2 = BracketMatch()
                match2.groupLetterLeftTeam = "\(groupNames[0])"
                match2.groupPlacingLeftTeam = GlobalConstants.groupRunnerUp
                match2.groupLetterRightTeam = GlobalConstants.undecided
                match2.groupPlacingRightTeam = GlobalConstants.group3rd
                bracketBottom.append(match2)
                
                let match3 = BracketMatch()
                match3.groupLetterLeftTeam = "\(groupNames[1])"
                match3.groupPlacingLeftTeam = GlobalConstants.groupRunnerUp
                match3.groupLetterRightTeam = "\(groupNames[3])"
                match3.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketTop.append(match3)
                
                let match4 = BracketMatch()
                match4.groupLetterLeftTeam = "\(groupNames[1])"
                match4.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match4.groupLetterRightTeam = GlobalConstants.undecided
                match4.groupPlacingRightTeam = GlobalConstants.bye
                bracketBottom.append(match4)
                
                let match5 = BracketMatch()
                match5.groupLetterLeftTeam = "\(groupNames[2])"
                match5.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match5.groupLetterRightTeam = GlobalConstants.undecided
                match5.groupPlacingRightTeam = GlobalConstants.bye
                bracketTop.append(match5)
                
                let match6 = BracketMatch()
                match6.groupLetterLeftTeam = "\(groupNames[2])"
                match6.groupPlacingLeftTeam = GlobalConstants.groupRunnerUp
                match6.groupLetterRightTeam = "\(groupNames[4])"
                match6.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketBottom.append(match6)
                
                let match7 = BracketMatch()
                match7.groupLetterLeftTeam = "\(groupNames[4])"
                match7.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match7.groupLetterRightTeam = GlobalConstants.undecided
                match7.groupPlacingRightTeam = GlobalConstants.group3rd
                bracketTop.append(match7)
                
                let match8 = BracketMatch()
                match8.groupLetterLeftTeam = "\(groupNames[3])"
                match8.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match8.groupLetterRightTeam = GlobalConstants.undecided
                match8.groupPlacingRightTeam = GlobalConstants.bye
                bracketBottom.append(match8)
            }
            else if groups.count == 6 || groups.count == 12 {
                //A1 vs. 3rd place
                for var i = 0; i < groups.count; i += 6 {
                    let match1 = BracketMatch()
                    match1.groupLetterLeftTeam = "\(groupNames[0+i])"
                    match1.groupPlacingLeftTeam = GlobalConstants.groupWinner
                    match1.groupLetterRightTeam = GlobalConstants.undecided
                    match1.groupPlacingRightTeam = GlobalConstants.group3rd
                    bracketTop.append(match1)
                    
                    let match2 = BracketMatch()
                    match2.groupLetterLeftTeam = "\(groupNames[1+i])"
                    match2.groupPlacingLeftTeam = GlobalConstants.groupRunnerUp
                    match2.groupLetterRightTeam = "\(groupNames[5+i])"
                    match2.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                    bracketTop.append(match2)
                    
                    let match3 = BracketMatch()
                    match3.groupLetterLeftTeam = "\(groupNames[2+i])"
                    match3.groupPlacingLeftTeam = GlobalConstants.groupWinner
                    match3.groupLetterRightTeam = GlobalConstants.undecided
                    match3.groupPlacingRightTeam = GlobalConstants.group3rd
                    bracketTop.append(match3)
                    
                    let match4 = BracketMatch()
                    match4.groupLetterLeftTeam = "\(groupNames[4+i])"
                    match4.groupPlacingLeftTeam = GlobalConstants.groupWinner
                    match4.groupLetterRightTeam = "\(groupNames[3+i])"
                    match4.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                    bracketTop.append(match4)
                    
                    let match5 = BracketMatch()
                    match5.groupLetterLeftTeam = "\(groupNames[5+i])"
                    match5.groupPlacingLeftTeam = GlobalConstants.groupWinner
                    match5.groupLetterRightTeam = "\(groupNames[4+i])"
                    match5.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                    bracketBottom.append(match5)
                    
                    let match6 = BracketMatch()
                    match6.groupLetterLeftTeam = "\(groupNames[1+i])"
                    match6.groupPlacingLeftTeam = GlobalConstants.groupWinner
                    match6.groupLetterRightTeam = GlobalConstants.undecided
                    match6.groupPlacingRightTeam = GlobalConstants.group3rd
                    bracketBottom.append(match6)
                    
                    let match7 = BracketMatch()
                    match7.groupLetterLeftTeam = "\(groupNames[3+i])"
                    match7.groupPlacingLeftTeam = GlobalConstants.groupWinner
                    match7.groupLetterRightTeam = GlobalConstants.undecided
                    match7.groupPlacingRightTeam = GlobalConstants.group3rd
                    bracketBottom.append(match7)
                    
                    let match8 = BracketMatch()
                    match8.groupLetterLeftTeam = "\(groupNames[0+i])"
                    match8.groupPlacingLeftTeam = GlobalConstants.groupRunnerUp
                    match8.groupLetterRightTeam = "\(groupNames[2+i])"
                    match8.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                    bracketBottom.append(match8)
                }

            }
            else if groups.count == 7 {
                let match1 = BracketMatch()
                match1.groupLetterLeftTeam = "\(groupNames[0])"
                match1.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match1.groupLetterRightTeam = GlobalConstants.undecided
                match1.groupPlacingRightTeam = GlobalConstants.group3rd
                bracketTop.append(match1)
                
                let match2 = BracketMatch()
                match2.groupLetterLeftTeam = "\(groupNames[1])"
                match2.groupPlacingLeftTeam = GlobalConstants.groupRunnerUp
                match2.groupLetterRightTeam = "\(groupNames[2])"
                match2.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketTop.append(match2)
                
                let match3 = BracketMatch()
                match3.groupLetterLeftTeam = "\(groupNames[3])"
                match3.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match3.groupLetterRightTeam = "\(groupNames[4])"
                match3.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketTop.append(match3)
                
                let match4 = BracketMatch()
                match4.groupLetterLeftTeam = "\(groupNames[5])"
                match4.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match4.groupLetterRightTeam = "\(groupNames[6])"
                match4.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketTop.append(match4)
                
                let match5 = BracketMatch()
                match5.groupLetterLeftTeam = "\(groupNames[1])"
                match5.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match5.groupLetterRightTeam = GlobalConstants.undecided
                match5.groupPlacingRightTeam = GlobalConstants.group3rd
                bracketBottom.append(match5)
                
                let match6 = BracketMatch()
                match6.groupLetterLeftTeam = "\(groupNames[7])"
                match6.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match6.groupLetterRightTeam = "\(groupNames[0])"
                match6.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketBottom.append(match6)
                
                let match7 = BracketMatch()
                match7.groupLetterLeftTeam = "\(groupNames[2])"
                match7.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match7.groupLetterRightTeam = "\(groupNames[3])"
                match7.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketBottom.append(match7)
                
                let match8 = BracketMatch()
                match8.groupLetterLeftTeam = "\(groupNames[4])"
                match8.groupPlacingLeftTeam = GlobalConstants.groupWinner
                match8.groupLetterRightTeam = "\(groupNames[5])"
                match8.groupPlacingRightTeam = GlobalConstants.groupRunnerUp
                bracketBottom.append(match8)
            }
        }
        let finalBrackets = bracketTop + bracketBottom
        var finalStr : [String] = []
        for eachBracket in finalBrackets {
            var teamHome = ""
            var teamAway = ""
            (teamHome, teamAway) = eachBracket.getMatchStr()
            finalStr.append(teamHome)
            finalStr.append(teamAway)
        }
        return finalStr
    }
    
    class func getNumTeamsAdvancing(tournamentDataEntrants : [String]) -> Double {
        if tournamentDataEntrants.count <= 5 {
            return 2
        }
        else if tournamentDataEntrants.count <= 8 {
            return 4
        }
        else if tournamentDataEntrants.count <= 11 {
            return 6
        }
        else if tournamentDataEntrants.count <= 16 {
            return 8
        }
        else if tournamentDataEntrants.count <= 20 {
            return 12
        }
        else if tournamentDataEntrants.count <= 32 {
            return 16
        }
        else if tournamentDataEntrants.count <= 40 {
            return 24
        }
        else if tournamentDataEntrants.count <= 64 {
            return 32
        }
        return 0
    }
    
    class func getMatchupsFromPureBracket(tournament: Tournament) {
        var bracketMatches = tournament.bracket?.matches?.allObjects as! [Match]
        var bracketSlots = tournament.bracket?.slots?.allObjects as! [BracketSlot]
        bracketMatches.sortInPlace({$0.id?.integerValue < $1.id?.integerValue})
        bracketSlots.sortInPlace({$0.slotNum?.integerValue < $1.slotNum?.integerValue})
        for var i = 0; i < bracketSlots.count; i++ {
            let eachSlot = bracketSlots[i]
            let eachMatch = bracketMatches[i]
            CoreDataUtil.updateEntrantsInMatch(eachMatch, leftId: eachSlot.seedLeft, rightId: eachSlot.seedRight)
            //translate slot to other number.
        }
    }
    
    //this displays who would face who, if play-offs started now (based on current standings).
    class func getMatchupsFromBracket(tournament: Tournament) {
        //assume bracket is from group-stage format.
        //get the standings.
        var groupRecordsArr : [[EntrantRecord]] = []
        var thirdPlaceArr : [EntrantRecord] = []
        (groupRecordsArr, thirdPlaceArr) = StandingsCalculator.getStandingsFromTournament(tournament)
        //get the Bracket from tournament.
        var bracketMatches = tournament.bracket?.matches?.allObjects as! [Match]
        var bracketSlots = tournament.bracket?.slots?.allObjects as! [BracketSlot]
        bracketMatches.sortInPlace({$0.id?.integerValue < $1.id?.integerValue})
        bracketSlots.sortInPlace({$0.slotNum?.integerValue < $1.slotNum?.integerValue})
        var thirdIdx = 0
        for var i = 0; i < bracketSlots.count; i++ {
            let eachSlot = bracketSlots[i]
            let eachMatch = bracketMatches[i]
            let slotSeeds = [eachSlot.seedLeft!, eachSlot.seedRight!]
            var entrantIds : [String] = []
            for var j = 0; j < slotSeeds.count; j++ {
                let eachSeed = slotSeeds[j]
                //decode the string
                var seedPlace : Int!
                var seedLetter  : String!
                (seedPlace, seedLetter) = self.decodeSeed(eachSeed)
                let seedLetterObjC : NSString! = seedLetter
                //now use standings bracket to get that team.
                var currentRecord : EntrantRecord!
                if seedPlace == nil {
                    //bye, so leave as nil
                }
                else if seedPlace <= 1 || seedPlace == 3 {
                    //this means seedPlace represents group-winner or group-runner-up
                    let letterUnichar = seedLetterObjC.characterAtIndex(0)
                    //A becomes 0, B becomes 1.. to get the index
                    let letterIdx = Int(letterUnichar) - 65
                    currentRecord = groupRecordsArr[letterIdx][seedPlace]
                }
                else if seedPlace == 2 {
                    //third place, so take the highest third-place, then increment thirdIdx.
                    currentRecord = thirdPlaceArr[thirdIdx]
                    thirdIdx++
                }
                if currentRecord != nil {
                    entrantIds.append(String(currentRecord!.entrant!.id!))
                }
                else {
                    entrantIds.append(GlobalConstants.bye)
                }
            }
            CoreDataUtil.updateEntrantsInMatch(eachMatch, leftId: entrantIds[0], rightId: entrantIds[1])
        }
    }
    
    //should return (Int groupLetter, String groupPlace)
    private class func decodeSeed(bracketSeed: String) -> (Int!, String!) {
        if bracketSeed == GlobalConstants.group3rd {
            //3rd-place means index 2 in array.
            return (2, nil)
        }
        if bracketSeed == GlobalConstants.group4th {
            return (3, "A")
        }
        if bracketSeed == GlobalConstants.bye {
            return (nil, nil)
        }
        //else this is a group winner/runner-up from specific group.
        let seedArr = bracketSeed.componentsSeparatedByString(" ")
        let seedGroupPlace = seedArr[0]
        let seedGroupLetter = seedArr[1]
        if seedGroupPlace == GlobalConstants.groupWinner {
            return (0, seedGroupLetter)
        }
        //it should only reach this point if seedGroupPlace is runner-up.
        return (1, seedGroupLetter)
    }
}
