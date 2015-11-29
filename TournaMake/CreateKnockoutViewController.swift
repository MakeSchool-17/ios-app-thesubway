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
    var bracketSlots : [String]!
    var slotsNotEntered : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bracketSlots = BracketCalculator.calculateBrackets(groups, tournamentData: tournamentData)
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
        
        for var i = 0; i < self.bracketSlots.count; i += 2 {
            let vw = UIView()
            vw.heightAnchor.constraintEqualToConstant(matchHeight).active = true
            vw.widthAnchor.constraintEqualToConstant(matchWidth).active = true
            vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            
            for var j = 0; j < 2; j++ {
                let eachSlot = self.bracketSlots[i + j]
                let labelTop = UITextField(frame: CGRect(x: 0, y: CGFloat(j) * matchHeight / 2, width: matchWidth, height: matchHeight / 2))
                labelTop.text = eachSlot
                vw.addSubview(labelTop)
                let buttonBracket = PickerBracketButton(frame: CGRect(x: 0, y: 0, width: labelTop.frame.size.width, height: labelTop.frame.size.height))
                buttonBracket.slotName = eachSlot
                buttonBracket.slotIdx = i + j
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
            else if String(selectedString!) == GlobalConstants.strEmpty {
                //set current entrant from array to empty.
                self.bracketSlots[sender.slotIdx] = GlobalConstants.strEmpty
                self.slotsNotEntered.append(sender.slotName)
            }
            else {
                self.bracketSlots[sender.slotIdx] = selectedString as! String
                self.slotsNotEntered = AlgorithmUtil.removedFromArr(self.slotsNotEntered, element: selectedString as! String)
                if sender.slotName != GlobalConstants.strEmpty {
                    self.slotsNotEntered.append(sender.slotName)
                }
            }
            self.reloadStackViewBracket()
        }
    }

    @IBAction func submitPressed(sender: AnyObject) {
        //save tournament to core data.
        //save tournament's matches to tournamentData object.
        tournamentData.groups = self.groups
        CoreDataUtil.addTournament(tournamentData)
        //save tournament's participants to core data.
    }
}
