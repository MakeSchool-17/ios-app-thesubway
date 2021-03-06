//
//  GlobalConstants.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/23/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

struct GlobalConstants {
    
    static let groupStageKnockout = "Group Stage + Knockout"
    static let knockout = "Knockout"
    static let doubleElimination = "Double Elimination"
    static let strEmpty = "*Select Entrant*"
    static let groupWinner = "Winner"
    static let groupRunnerUp = "Runner-up"
    static let group3rd = "3rd-place Wild-Card"
    static let group4th = "4th-place Wild-Card"
    static let bye = "*BYE*"
    static let undecided = "-"
    static let groupNames = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ123456".characters)
    static let headToHeadTiebreak = "headToHeadTieBreak"
    static let entrants = "entrants"
    static let wins = "wins"
    static let losses = "losses"
    static let arrHeader = ["Name", "Wins", "Losses", "Ties", "Points", "For", "Against", "Differential"]
    static let tie = "*TIE*"
    
    //colors:
    static let orangeVitaminC = UIColor(red: 253/255.0, green: 116/255.0, blue: 0/255.0, alpha: 1.0)
    static let tealVitaminC = UIColor(red: 31/255.0, green: 138/255.0, blue: 112/255.0, alpha: 1.0)
    static let blueVitaminC = UIColor(red: 0/255.0, green: 67/255.0, blue: 88/255.0, alpha: 1.0)
    static let yellowVitaminC = UIColor(red: 255 / 255.0, green: 225 / 255.0, blue: 26 / 255.0, alpha: 1.0)
    static let greenVitaminC = UIColor(red: 190 / 255.0, green: 219 / 255.0, blue: 57 / 255.0, alpha: 1.0)
    static let grayVeryLight = UIColor(red: 235 / 255.0, green: 235 / 255.0, blue: 235 / 255.0, alpha: 1.0)
    static let mediumGray = UIColor(red: 128 / 255.0, green: 128 / 255.0, blue: 128 / 255.0, alpha: 1.0)
    static let buttonGreenColor = UIColor(red: 43 / 255.0, green: 195 / 255.0, blue: 158 / 255.0, alpha: 1.0)
    static let buttonRedColor = UIColor(red: 225 / 255.0, green: 49 / 255.0, blue: 79 / 255.0, alpha: 1.0)
    //change backgroundColor used for custom vc's here:
    static let backgroundColorVc = UIColor.whiteColor()
    
    //labels:
    static let bracketStageStarted = "Bracket stage has started"
    
    //notifications:
    static let pickerDidScroll = "pickerDidScroll"
    
    //data analytics:
    static let firstTime = "First Time"
    static let isFirst = "Is First"
    static let tournamentCreated = "Tournament Created"
    static let tournamentDeleted = "Tournament Deleted"
    static let numEntrants = "Num Entrants"
    static let format = "Format"
    static let formatSelected = "Format Selected"
    static let buttonPressed = "Button Pressed"
    static let buttonName = "Button Name"
    static let randomize = "randomize"
    static let clear = "clear"
    static let defaultStr = "default"
    static let startBracket = "Start Bracket"
    static let matchUpdated = "Match Updated"
    static let matchType = "Match Type"
    static let groupMatch = "Group Match"
    static let knockoutMatch = "Knockout Match"
    
}