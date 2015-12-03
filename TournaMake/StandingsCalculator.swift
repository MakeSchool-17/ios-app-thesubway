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
        for var i = 0; i < matches.count; i++ {
            let groupMatch = matches[i]
            if groupMatch.isFinished != true {
                continue
            }
            //figure out whether left or right player.
            var ownScore : Float = 0
            var opponentScore : Float = 0
            if groupMatch.leftId == ownId {
                ownScore = (groupMatch.leftScore?.floatValue)!
                opponentScore = (groupMatch.rightScore?.floatValue)!
            }
            else {
                ownScore = (groupMatch.rightScore?.floatValue)!
                opponentScore = (groupMatch.leftScore?.floatValue)!
            }
            pointsFor += ownScore
            pointsAgainst += opponentScore
            diff = pointsFor - pointsAgainst
            if ownScore > opponentScore {
                wins++
            }
            else if ownScore < opponentScore {
                losses++
            }
            else if ownScore == opponentScore {
                ties++
            }
            points = ties + 3 * wins
        }
        let entrantRecord = EntrantRecord(wins: wins, ties: ties, losses: losses, points: points, pointsFor: pointsFor, pointsAgainst: pointsAgainst, diff: diff)
        return entrantRecord
    }
    
}
