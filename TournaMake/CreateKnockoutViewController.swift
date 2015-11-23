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
    var bracketMatches : [BracketMatch]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bracketMatches = BracketCalculator.calculateBrackets(groups, tournamentData: tournamentData)
        self.reloadStackViewBracket()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadStackViewBracket() {
        //clear previous data
        for var i = 0; i < self.stackViewBracket.arrangedSubviews.count; i++ {
            let eachSubview = self.stackViewBracket.arrangedSubviews[i]
            eachSubview.removeFromSuperview()
            self.stackViewBracket.removeArrangedSubview(eachSubview)
            i--
        }
        
        stackViewBracket.spacing = 10
        stackViewBracket.alignment = UIStackViewAlignment.Center
        
        let matchHeight : CGFloat = 100
        let matchWidth : CGFloat = 250
        
        for eachBracket in self.bracketMatches {
            let vw = UIView()
            vw.heightAnchor.constraintEqualToConstant(matchHeight).active = true
            vw.widthAnchor.constraintEqualToConstant(matchWidth).active = true
            vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            
            var teamHome = ""
            var teamAway = ""
            (teamHome, teamAway) = eachBracket.getMatchStr()
            
            let labelTop = UILabel(frame: CGRect(x: 0, y: 0, width: matchWidth, height: matchHeight / 2))
            labelTop.text = teamHome
            vw.addSubview(labelTop)
            
            let labelBottom = UILabel(frame: CGRect(x: 0, y: matchHeight / 2, width: matchWidth, height: matchHeight / 2))
            labelBottom.text = teamAway
            vw.addSubview(labelBottom)
            
            stackViewBracket.addArrangedSubview(vw)
        }
    }

    @IBAction func submitPressed(sender: AnyObject) {
        print("submit")
    }
}
