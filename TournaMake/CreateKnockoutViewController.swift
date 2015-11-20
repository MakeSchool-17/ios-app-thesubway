//
//  CreateKnockoutViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/19/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class CreateKnockoutViewController: UIViewController {

    var groups : [[String]]!
    var tournamentData : TournamentData!
    var advancingSlots : [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculateBrackets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateBrackets() {
        //assuming 6-16 teams in tournament:
        var numTeamsAdvance : Double = 0
        if tournamentData.entrants.count <= 8 {
            numTeamsAdvance = 4
        }
        else if tournamentData.entrants.count <= 11 {
            numTeamsAdvance = 6
        }
        else if tournamentData.entrants.count <= 16 {
            numTeamsAdvance = 8
        }
        else if tournamentData.entrants.count <= 20 {
            numTeamsAdvance = 12
        }
        else if tournamentData.entrants.count <= 32 {
            numTeamsAdvance = 16
        }
        else if tournamentData.entrants.count <= 40 {
            numTeamsAdvance = 24
        }
        else if tournamentData.entrants.count <= 64 {
            numTeamsAdvance = 32
        }
        var numRounds = 1.0
        while true {
            if pow(2.0, numRounds) >= numTeamsAdvance {
                break
            }
            numRounds++
        }
        let numTopTwo : Double = Double(self.groups.count) * 2
        //top two always advance. Question is how many 3rd-place will advance.
        let num3rdPlace = numTeamsAdvance - numTopTwo
//        num3rdPlace = numTeamsAdvance - (tournamentData.entrants.count / 2)
        let groupNames = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ123456".characters)
        
        /*bracketTop and bracketBottom ensure that group-winners and group-runner-ups
        from same group will not face each other, unless they both reach the end of the bracket
        (whether it's championship match, or 3rd-place match)*/
        var bracketTop : [BracketMatch] = []
        var bracketBottom : [BracketMatch] = []
        
        if num3rdPlace == 0 {
            //since num3rdPlace == 0, we know numTeamsAdvance == numTopTwo,
            //which means numTopTwo is always divisible by 4,
            //which means num groups always divisible by 2.
            for var i = 0; i < self.groups.count; i += 2 {
                let match1 = BracketMatch()
                match1.groupLetterLeftTeam = "\(groupNames[i])"
                match1.groupPlacingLeftTeam = match1.groupWinner
                match1.groupLetterRightTeam = "\(groupNames[i+1])"
                match1.groupPlacingRightTeam = match1.groupRunnerUp
                bracketTop.append(match1)
                
                let match2 = BracketMatch()
                match2.groupLetterLeftTeam = "\(groupNames[i+1])"
                match2.groupPlacingLeftTeam = match2.groupWinner
                match2.groupLetterRightTeam = "\(groupNames[i])"
                match2.groupPlacingRightTeam = match2.groupRunnerUp
                bracketBottom.append(match2)
            }
        }
        //print out brackets:
        for eachBracket in bracketTop {
            eachBracket.printMatch()
        }
        for eachBracket in bracketBottom {
            eachBracket.printMatch()
        }
    }

}
