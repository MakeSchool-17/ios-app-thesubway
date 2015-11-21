//
//  BracketSlot.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/19/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class BracketMatch {
    //constants:
    let groupWinner = "Winner"
    let groupRunnerUp = "Runner-up"
    let group3rd = "3rd-place Wild-Card"
    let bye = "BYE"
    let undecided = "-"
    
    //properties:
    var groupPlacingLeftTeam : String!
    var groupLetterLeftTeam : String!
    
    var groupPlacingRightTeam : String!
    var groupLetterRightTeam : String!
    
    func printMatch() {
        print("\(self.groupPlacingLeftTeam) \(self.groupLetterLeftTeam) vs \(self.groupPlacingRightTeam) \(self.groupLetterRightTeam)")
    }
}
