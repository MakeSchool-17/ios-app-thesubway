//
//  StandingsCalculator.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/2/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class StandingsCalculator {
    
    //return actual object
    // somehow store head-to-head.
    //or I can store to core data every update of match.
    //also store id of each entrant
    class func getGroupRecordForEntrant(entrant: Entrant) -> EntrantRecord {
        let matches = CoreDataUtil.getMatchesForEntrant(entrant)!
        let entrantRecord = self.getRecordFromMatches(matches, ownId: "\(entrant.id!)")
        entrantRecord.entrant = entrant
        return entrantRecord
    }
    
    class func computeStandings(entrantRecords : [EntrantRecord]) -> [EntrantRecord] {
        //compare array
        let tiebreakArr = [TieBreakerType.Points, TieBreakerType.ScoringDifferential, TieBreakerType.HeadToHead]
        var twoDimensionalArr = [entrantRecords]
        for var i = 0; i < tiebreakArr.count; i++ {
            var new2DArr : [[EntrantRecord]] = []
            for var j = 0; j < twoDimensionalArr.count; j++ {
                var eachGroup = twoDimensionalArr[j]
                if tiebreakArr[i] == TieBreakerType.HeadToHead {
                    eachGroup = StandingsCalculator.sortHeadToHead(eachGroup)
                }
                else {
                    eachGroup.sortInPlace({$0.compareTo($1, tiebreakerType: tiebreakArr[i]) > 0})
                }
                //next, split arrays by tiebreaking factor, use StandingsCalculator
                new2DArr += StandingsCalculator.splitArr(eachGroup, tiebreakerType: tiebreakArr[i])
            }
            twoDimensionalArr = new2DArr
        }
        //separate back into single arr
        var oneDimensionalArr : [EntrantRecord] = []
        for eachArr in twoDimensionalArr {
            for eachRecord in eachArr {
                oneDimensionalArr.append(eachRecord)
            }
        }
        return oneDimensionalArr
    }
    
    class func getRecordFromMatches(matches: [Match], ownId: String) -> EntrantRecord {
        var wins = 0
        var losses = 0
        var ties = 0
        var points = 0
        var pointsFor: Float = 0
        var pointsAgainst: Float = 0
        var diff : Float = 0
        var opponentDict = Dictionary<String, Dictionary<String, Float>>()
        for var i = 0; i < matches.count; i++ {
            let groupMatch = matches[i]
            if groupMatch.isFinished != true {
                continue
            }
            if groupMatch.group == nil {
                continue
            }
            //figure out whether left or right player.
            var ownScore : Float = 0
            var opponentScore : Float = 0
            var opponentId : String!
            if groupMatch.leftId == ownId {
                ownScore = (groupMatch.leftScore?.floatValue)!
                opponentScore = (groupMatch.rightScore?.floatValue)!
                opponentId = groupMatch.rightId
            }
            else {
                ownScore = (groupMatch.rightScore?.floatValue)!
                opponentScore = (groupMatch.leftScore?.floatValue)!
                opponentId = groupMatch.leftId
            }
            var headToHeadDict = Dictionary<String, Float>()
            if opponentDict[opponentId!] == nil {
                headToHeadDict = [GlobalConstants.wins: 0, GlobalConstants.losses: 0]
            }
            else {
                headToHeadDict = opponentDict[opponentId!]!
            }
            pointsFor += ownScore
            pointsAgainst += opponentScore
            diff = pointsFor - pointsAgainst
            if ownScore > opponentScore {
                wins++
                headToHeadDict[GlobalConstants.wins]!++
            }
            else if ownScore < opponentScore {
                losses++
                headToHeadDict[GlobalConstants.losses]!++
            }
            else if ownScore == opponentScore {
                ties++
            }
            points = ties + 3 * wins
            opponentDict[opponentId!] = headToHeadDict
        }
        let entrantRecord = EntrantRecord(wins: wins, ties: ties, losses: losses, points: points, pointsFor: pointsFor, pointsAgainst: pointsAgainst, diff: diff)
        entrantRecord.opponentDict = opponentDict
        return entrantRecord
    }
    
    class func splitArr(inputArr: [EntrantRecord], tiebreakerType: TieBreakerType) -> [[EntrantRecord]] {
        var resultArrs : [[EntrantRecord]] = []
        var ownProperty : AnyObject!
        var otherProperty : AnyObject!
        var tiedArr : [EntrantRecord] = []
        for var i = 0; i < inputArr.count; i++ {
            let eachRecord = inputArr[i]
            if tiedArr.count <= 0 {
                //then there is nothing to compare to. Add to new arr.
                tiedArr.append(eachRecord)
                continue
            }
            switch tiebreakerType {
            case TieBreakerType.Points:
                ownProperty = eachRecord.points
                otherProperty = tiedArr[0].points
            case TieBreakerType.HeadToHead:
                ownProperty = eachRecord.headToHeadTiebreak
                otherProperty = tiedArr[0].headToHeadTiebreak
            case TieBreakerType.ScoringDifferential:
                ownProperty = eachRecord.diff
                otherProperty = tiedArr[0].diff
            }
            if AlgorithmUtil.compareAnyObjectType(ownProperty, b: otherProperty) {
                //same value, store in same array
                tiedArr.append(eachRecord)
            }
            else if !AlgorithmUtil.compareAnyObjectType(ownProperty, b: otherProperty) {
                //end of array.
                resultArrs.append(tiedArr)
                //reset tiedArr
                tiedArr = []
                i--
            }
        }
        //if for-loop is finished, append final array.
        resultArrs.append(tiedArr)
        return resultArrs
    }
    
    class func sortHeadToHead(inputRecords: [EntrantRecord]) -> [EntrantRecord] {
        //make sure this ideally does not get called if wins = 0 and losses = 0
        var records = inputRecords
        //create 2 dictionaries to retrieve eachRecord, by id or name
        for var i = 0; i < records.count; i++ {
            let eachRecord = records[i]
            for var j = 0; j < records.count; j++ {
                if i == j {
                    continue
                }
                let opponentId = "\(records[j].entrant.id!)"
                if eachRecord.opponentDict[opponentId] != nil {
                    let headToHeadDict = eachRecord.opponentDict[opponentId]
                    //assign headToHead points:
                    eachRecord.headToHeadTiebreak += Int(headToHeadDict![GlobalConstants.wins]!)
                    eachRecord.headToHeadTiebreak -= Int(headToHeadDict![GlobalConstants.losses]!)
                }
            }
        }
        records.sortInPlace({$0.headToHeadTiebreak > $1.headToHeadTiebreak})
        //sort by that.
        return records
    }
    
    class func getStandingsFromTournament(tournament : Tournament) -> ([[EntrantRecord]], [EntrantRecord]) {
        var groupRecordsArr : [[EntrantRecord]] = []
        var thirdPlaceArr : [EntrantRecord] = []
        var groupStage = tournament.groupStage?.allObjects as! [Group]
        groupStage.sortInPlace({$0.id?.integerValue < $1.id?.integerValue})
        for eachGroup in groupStage {
            let entrants = eachGroup.entrants?.allObjects as! [Entrant]
            var entrantsInGroup : [EntrantRecord] = []
            for eachEntrant in entrants {
                let eachRecord = self.getGroupRecordForEntrant(eachEntrant)
                entrantsInGroup.append(eachRecord)
            }
            let groupRecord = self.computeStandings(entrantsInGroup)
            //get third place team from each group
            if groupRecord.count > 2 {
                thirdPlaceArr.append(groupRecord[2])
            }
            groupRecordsArr.append(groupRecord)
        }
        thirdPlaceArr = self.computeStandings(thirdPlaceArr)
        return (groupRecordsArr, thirdPlaceArr)
    }
    
}
