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
    
    var homeTeamStr = ""
    var awayTeamStr = ""
    
    //properties:
    var groupPlacingLeftTeam : String! {
        didSet {
            self.homeTeamStr = "\(self.groupPlacingLeftTeam) \(self.groupLetterLeftTeam)"
        }
    }
    var groupLetterLeftTeam : String! {
        didSet {
            self.homeTeamStr = "\(self.groupPlacingLeftTeam) \(self.groupLetterLeftTeam)"
        }
    }
    var groupPlacingRightTeam : String! {
        didSet {
            self.awayTeamStr = "\(self.groupPlacingRightTeam) \(self.groupLetterRightTeam)"
        }
    }
    var groupLetterRightTeam : String! {
        didSet {
            self.awayTeamStr = "\(self.groupPlacingRightTeam) \(self.groupLetterRightTeam)"
        }
    }
    
    func getMatchStr() -> (String, String) {
        return (self.homeTeamStr, self.awayTeamStr)
    }
}
