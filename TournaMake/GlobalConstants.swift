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
    static let strEmpty = "*Select Entrant*"
    static let groupWinner = "Winner"
    static let groupRunnerUp = "Runner-up"
    static let group3rd = "3rd-place Wild-Card"
    static let bye = "*BYE*"
    static let undecided = "-"
    static let groupNames = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ123456".characters)
    static let headToHeadTiebreak = "headToHeadTieBreak"
    static let entrants = "entrants"
    static let wins = "wins"
    static let losses = "losses"
    static let arrHeader = ["Name", "Wins", "Losses", "Ties", "Points", "For", "Against", "Differential"]
    
    //colors:
    static let orangeVitaminC = UIColor(red: 253/255.0, green: 116/255.0, blue: 0/255.0, alpha: 1.0)
    static let tealVitaminC = UIColor(red: 31/255.0, green: 138/255.0, blue: 112/255.0, alpha: 1.0)
    static let blueVitaminC = UIColor(red: 0/255.0, green: 67/255.0, blue: 88/255.0, alpha: 1.0)
    static let yellowVitaminC = UIColor(red: 255 / 255.0, green: 225 / 255.0, blue: 26 / 255.0, alpha: 1.0)
    static let greenVitaminC = UIColor(red: 190 / 255.0, green: 219 / 255.0, blue: 57 / 255.0, alpha: 1.0)
    static let grayVeryLight = UIColor(red: 235 / 255.0, green: 235 / 255.0, blue: 235 / 255.0, alpha: 1.0)
    static let mediumGray = UIColor(red: 128 / 255.0, green: 128 / 255.0, blue: 128 / 255.0, alpha: 1.0)
    //change backgroundColor used for custom vc's here:
    static let backgroundColorVc = UIColor.whiteColor()
    
    //labels:
    static let bracketStageStarted = "Bracket stage has started"
}