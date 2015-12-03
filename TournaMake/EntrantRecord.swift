//
//  EntrantRecord.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/2/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class EntrantRecord {
    var wins = 0
    var ties = 0
    var losses = 0
    var points = 0
    var pointsFor: Float = 0
    var pointsAgainst: Float = 0
    var diff : Float = 0
    var entrant : Entrant!
    
    init(wins: Int, ties: Int, losses: Int, points: Int, pointsFor : Float = 0, pointsAgainst: Float = 0.0, diff: Float = 0.0) {
        self.wins = wins
        self.ties = ties
        self.losses = losses
        self.pointsAgainst = pointsAgainst
        self.pointsFor = pointsFor
        self.points = points
        self.diff = diff
    }
    
    func compareTo(entrantRecord : EntrantRecord) -> Int {
        if self.points < entrantRecord.points{
            return -1
        }
        else if self.points > entrantRecord.points {
            return 1
        }
        //go to head-to-head tiebreaker:
        let headToHeadResult = self.headToHeadGroup(entrantRecord)
        if headToHeadResult != 0 {
            return headToHeadResult
        }
        //go to differential tiebreaker
        if self.diff < entrantRecord.diff {
            return -1
        }
        else if self.diff > entrantRecord.diff {
            return 1
        }
        return 0
    }
    
    func headToHeadGroup(opponent: EntrantRecord) -> Int {
        var matches = CoreDataUtil.getMatchesForEntrant(self.entrant)
        //double filter:
        matches = matches!.filter({$0.group != nil && $0.isFinished == true})
        matches = matches!.filter({$0.leftId == "\(opponent.entrant.id!)" || $0.rightId == "\(opponent.entrant.id!)"})
        let headToHeadRecord = StandingsCalculator.getRecordFromMatches(matches!, ownId: "\(self.entrant.id!)")
        if headToHeadRecord.wins < headToHeadRecord.losses {
            return -1
        }
        else if headToHeadRecord.wins > headToHeadRecord.losses {
            return 1
        }
        return 0
    }
    
    func printSelf() {
        print("\(self.entrant.name!) wins: \(wins), losses: \(losses), ties: \(ties), pt: \(points) PF: \(pointsFor), PA: \(pointsAgainst), Diff: \(diff)")
    }
}