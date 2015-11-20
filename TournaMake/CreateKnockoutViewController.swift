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
                print("\(numRounds) >= \(numTeamsAdvance)")
                break
            }
            numRounds++
        }
        print(numRounds)
    }

}
