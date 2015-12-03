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
    var entrant : Entrant!
    
    init(wins: Int, ties: Int, losses: Int, points: Int, pointsFor : Float = 0, pointsAgainst: Float = 0.0) {
        self.wins = wins
        self.ties = ties
        self.losses = losses
        self.pointsAgainst = pointsAgainst
        self.pointsFor = pointsFor
        self.points = points
    }
    
    func compareTo(entrantRecord : EntrantRecord) -> Int {
        if self.points < entrantRecord.points{
            return -1
        }
        else if self.points > entrantRecord.points {
            return 1
        }
        return 0
    }
    
    func printSelf() {
        print("wins: \(wins), losses: \(losses), ties: \(ties), pt: \(points) PF: \(pointsFor), PA: \(pointsAgainst)")
    }
}
