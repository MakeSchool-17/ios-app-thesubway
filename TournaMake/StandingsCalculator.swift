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
        switch tiebreakerType {
        case TieBreakerType.Points:
            var tiedArr : [EntrantRecord] = []
            for var i = 0; i < inputArr.count; i++ {
                let eachRecord = inputArr[i]
                if tiedArr.count <= 0 {
                    tiedArr.append(eachRecord)
                }
                else if eachRecord.points == tiedArr[0].points {
                    tiedArr.append(eachRecord)
                }
                else if eachRecord.points != tiedArr[0].points {
                    //end of array.
                    resultArrs.append(tiedArr)
                    //reset tiedArr
                    tiedArr = []
                    i--
                }
            }
            //if for-loop is finished, append final array.
            resultArrs.append(tiedArr)
        case TieBreakerType.HeadToHead:
            var tiedArr : [EntrantRecord] = []
            for var i = 0; i < inputArr.count; i++ {
                let eachRecord = inputArr[i]
                if tiedArr.count <= 0 {
                    tiedArr.append(eachRecord)
                }
                else if eachRecord.headToHeadTiebreak == tiedArr[0].headToHeadTiebreak {
                    tiedArr.append(eachRecord)
                }
                else if eachRecord.headToHeadTiebreak != tiedArr[0].headToHeadTiebreak {
                    //end of array.
                    resultArrs.append(tiedArr)
                    //reset tiedArr
                    tiedArr = []
                    i--
                }
            }
            //if for-loop is finished, append final array.
            resultArrs.append(tiedArr)
        case TieBreakerType.ScoringDifferential:
            print("")
        }
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
    
}
