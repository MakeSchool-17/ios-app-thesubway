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
            let tupleTeams = [teamHome, teamAway]
            for var j = 0; j < 2; j++ {
                let labelTop = UITextField(frame: CGRect(x: 0, y: CGFloat(j) * matchHeight / 2, width: matchWidth, height: matchHeight / 2))
                labelTop.text = tupleTeams[j]
                vw.addSubview(labelTop)
                let buttonBracket = PickerBracketButton(frame: CGRect(x: 0, y: 0, width: labelTop.frame.size.width, height: labelTop.frame.size.height))
                buttonBracket.slotName = tupleTeams[j]
                buttonBracket.addTarget(self, action: "bracketSlotPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                labelTop.addSubview(buttonBracket)
            }
            
            stackViewBracket.addArrangedSubview(vw)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bracketSlotPressed(sender: PickerBracketButton) {
        var slotArr : [String] = self.slotsNotEntered
        slotArr.append(GlobalConstants.strEmpty)
        if sender.slotName != GlobalConstants.strEmpty {
            slotArr.append(sender.slotName)
        }
        MMPickerView.showPickerViewInView(self.view, withObjects: slotArr, withOptions: nil, objectToStringConverter: nil) { (selectedString : AnyObject!) -> Void in
            if String(selectedString!) == sender.slotName {
                return
            }
        }
    }

    @IBAction func submitPressed(sender: AnyObject) {
        print("submit")
    }
}
