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
    @IBOutlet var stackViewBracket: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BracketCalculator.calculateBrackets(groups, tournamentData: tournamentData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitPressed(sender: AnyObject) {
        print("submit")
    }
}
