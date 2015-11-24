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
    
    var homeTeamStr = ""
    var awayTeamStr = ""
    
    //properties:
    var groupPlacingLeftTeam : String! {
        didSet {
            self.homeTeamStr = self.getTeamStr(true)
        }
    }
    var groupLetterLeftTeam : String! {
        didSet {
            self.homeTeamStr = self.getTeamStr(true)
        }
    }
    var groupPlacingRightTeam : String! {
        didSet {
            self.awayTeamStr = self.getTeamStr(false)
        }
    }
    var groupLetterRightTeam : String! {
        didSet {
            self.awayTeamStr = self.getTeamStr(false)
        }
    }
    
    func getMatchStr() -> (String, String) {
        return (self.homeTeamStr, self.awayTeamStr)
    }
    
    func getTeamStr(isHome : Bool) -> String {
        var finalStr = ""
        var groupLetter = ""
        if isHome == true {
            finalStr += "\(self.groupPlacingLeftTeam)"
            groupLetter = self.groupLetterLeftTeam
        }
        else {
            finalStr += "\(self.groupPlacingRightTeam)"
            groupLetter = self.groupLetterRightTeam
        }
        if groupLetter != GlobalConstants.undecided {
            finalStr += " \(groupLetter)"
        }
        return finalStr
    }
}
