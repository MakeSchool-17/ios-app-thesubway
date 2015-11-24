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
    var slotsNotEntered : [String] = []
    
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
            
            let labelTop = UITextField(frame: CGRect(x: 0, y: 0, width: matchWidth, height: matchHeight / 2))
            labelTop.text = teamHome
            vw.addSubview(labelTop)
            let buttonBracketHome = PickerBracketButton(frame: CGRect(x: 0, y: 0, width: labelTop.frame.size.width, height: labelTop.frame.size.height))
            buttonBracketHome.addTarget(self, action: "bracketSlotPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            labelTop.addSubview(buttonBracketHome)
            
            let labelBottom = UITextField(frame: CGRect(x: 0, y: matchHeight / 2, width: matchWidth, height: matchHeight / 2))
            labelBottom.text = teamAway
            vw.addSubview(labelBottom)
            let buttonBracketAway = PickerBracketButton(frame: CGRect(x: 0, y: 0, width: labelBottom.frame.size.width, height: labelBottom.frame.size.height))
            buttonBracketAway.addTarget(self, action: "bracketSlotPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            labelBottom.addSubview(buttonBracketAway)
            
            stackViewBracket.addArrangedSubview(vw)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bracketSlotPressed(sender: PickerGroupButton) {
        print("press bracket slot")
    }

    @IBAction func submitPressed(sender: AnyObject) {
        print("submit")
    }
}
