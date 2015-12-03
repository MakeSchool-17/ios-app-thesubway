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
    
    var headToHeadTiebreakerOpponents = Dictionary<String, EntrantRecord>()
    
    init(wins: Int, ties: Int, losses: Int, points: Int, pointsFor : Float = 0, pointsAgainst: Float = 0.0, diff: Float = 0.0) {
        self.wins = wins
        self.ties = ties
        self.losses = losses
        self.pointsAgainst = pointsAgainst
        self.pointsFor = pointsFor
        self.points = points
        self.diff = diff
    }
    
    func compareTo(opponentRecord : EntrantRecord, tiebreakerType: TieBreakerType) -> Int {
        switch tiebreakerType {
        case .Points:
            if self.points < opponentRecord.points{
                return -1
            }
            else if self.points > opponentRecord.points {
                return 1
            }
        case .HeadToHead:
            //go to head-to-head tiebreaker:
            let headToHeadResult = self.headToHeadGroupStage(opponentRecord)
            if headToHeadResult != 0 {
                return headToHeadResult
            }
        case .ScoringDifferential :
            if self.diff < opponentRecord.diff {
                return -1
            }
            else if self.diff > opponentRecord.diff {
                return 1
            }
        }
        return 0
    }
    
    func headToHeadGroupStage(opponent: EntrantRecord) -> Int {
        let tiebreakDict = NSMutableDictionary(object: [self, opponent], forKey: GlobalConstants.entrants)
        NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.headToHeadTiebreak, object: nil, userInfo: tiebreakDict as [NSObject : AnyObject])
        var matches = CoreDataUtil.getMatchesForEntrant(self.entrant)
        //double filter:
        matches = matches!.filter({$0.group != nil && $0.isFinished == true})
        matches = matches!.filter({$0.leftId == "\(opponent.entrant.id!)" || $0.rightId == "\(opponent.entrant.id!)"})
        let headToHeadRecord = StandingsCalculator.getRecordFromMatches(matches!, ownId: "\(self.entrant.id!)")
        //do NOT save headToHeadRecord, this is intentionally temporary
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

enum TieBreakerType {
    case Points
    case HeadToHead
    case ScoringDifferential
}
