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
    @IBOutlet var stackViewBracket: UIStackView!
    @IBOutlet var defaultButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    var bracketSlots : [String]!
    var slotsNotEntered : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = GlobalConstants.backgroundColorVc
        self.defaultButton.backgroundColor = GlobalConstants.buttonGreenColor
        self.defaultButton.tintColor = UIColor.whiteColor()
        self.defaultButton.titleLabel?.font = UIFont.systemFontOfSize(40)
        self.defaultButton.layer.cornerRadius = 5.0
        self.clearButton.backgroundColor = GlobalConstants.buttonRedColor
        self.clearButton.tintColor = UIColor.whiteColor()
        self.clearButton.titleLabel!.font = UIFont.systemFontOfSize(40)
        self.clearButton.layer.cornerRadius = 5.0
        
        if self.tournamentData.format == GlobalConstants.groupStageKnockout {
            self.bracketSlots = BracketCalculator.calculateGroupBrackets(groups, tournamentData: self.tournamentData)
        }
        else {
            self.defaultButton.setTitle("Randomize", forState: UIControlState.Normal)
            self.bracketSlots = BracketCalculator.calculatePureBrackets(self.tournamentData)
        }
        self.reloadStackViewBracket()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadStackViewBracket() {
        UIHelper.removeSubviewsFrom(self.stackViewBracket)
        
        stackViewBracket.spacing = 10
        stackViewBracket.alignment = UIStackViewAlignment.Center
        
        let matchHeight : CGFloat = 100
        let matchWidth : CGFloat = 250
        
        for i in 0.stride(to: self.bracketSlots.count, by: 2) {
            let vw = UIView()
            vw.heightAnchor.constraintEqualToConstant(matchHeight).active = true
            vw.widthAnchor.constraintEqualToConstant(matchWidth).active = true
            vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            vw.backgroundColor = GlobalConstants.grayVeryLight
            
            for j in 0 ..< 2 {
                let eachSlot = self.bracketSlots[i + j]
                let labelTop = UITextField(frame: CGRect(x: 0, y: CGFloat(j) * matchHeight / 2, width: matchWidth, height: matchHeight / 2))
                labelTop.text = eachSlot
                vw.addSubview(labelTop)
                let buttonBracket = PickerBracketButton(frame: CGRect(x: 0, y: 0, width: labelTop.frame.size.width, height: labelTop.frame.size.height))
                buttonBracket.slotName = eachSlot
                buttonBracket.slotIdx = i + j
                buttonBracket.addTarget(self, action: #selector(CreateKnockoutViewController.bracketSlotPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                buttonBracket.imageView?.contentMode = UIViewContentMode.ScaleToFill
                buttonBracket.setImage(UIImage(named: "dropDownSelectBox"), forState: UIControlState.Normal)
                labelTop.addSubview(buttonBracket)
            }
            stackViewBracket.addArrangedSubview(vw)
        }
        self.updateButton()
    }
    
    func updateButton() {
        //if self.slotsNotEntered.count > 0 && self.hasEmptySlots() {
        if self.hasEmptySlots() || self.duplicateByes() {
            self.submitButton.backgroundColor = UIColor.redColor()
            self.submitButton.tintColor = UIColor.whiteColor()
        }
        else {
            self.submitButton.backgroundColor = UIColor.greenColor()
            self.submitButton.tintColor = UIColor.blackColor()
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
    
    func clearGroups() {
        for i in 0 ..< self.bracketSlots.count {
            if self.bracketSlots[i] != GlobalConstants.strEmpty {
                self.slotsNotEntered.append(self.bracketSlots[i])
            }
            self.bracketSlots[i] = GlobalConstants.strEmpty
        }
        self.reloadStackViewBracket()
    }
    
    func hasEmptySlots() -> Bool {
        for i in 0 ..< self.bracketSlots.count {
            if self.bracketSlots[i] == GlobalConstants.strEmpty {
                return true
            }
        }
        return false
    }
    
    func duplicateByes() -> Bool {
        //if two byes face each other
        for i in 0.stride(to: self.bracketSlots.count, by: 2) {
            if self.bracketSlots[i] == GlobalConstants.bye && self.bracketSlots[i+1] == GlobalConstants.bye {
                return true
            }
        }
        return false
    }

    @IBAction func submitPressed(sender: AnyObject) {
        //save tournament to core data.
        //save tournament's matches to tournamentData object.
        if self.slotsNotEntered.count > 0 && self.hasEmptySlots() {
            var strMissing = "\nEntrants missing:"
            for eachMissing in self.slotsNotEntered {
                strMissing += "\n\(eachMissing)"
            }
            /*strMissing += "\n\nWould you like to replace the missing entrants with byes (this will remove the missing entrants)?"
            let alert = UIAlertController(title: title, message: strMissing, preferredStyle: UIAlertControllerStyle.Alert)
            let noAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { _ in
            })
            alert.addAction(noAction)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { _ in
                for var i = 0; i < self.bracketSlots.count; i++ {
                    if self.bracketSlots[i] == GlobalConstants.strEmpty {
                        self.bracketSlots[i] = GlobalConstants.bye
                    }
                }
                self.reloadStackViewBracket()
            })
            alert.addAction(yesAction)*/
            UIHelper.showAlertOnVc(self, title: "", message: strMissing)
            //self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if self.duplicateByes() {
            UIHelper.showAlertOnVc(self, title: "", message: "Each match can only have 1 \(GlobalConstants.bye)")
            return
        }
        
        tournamentData.groups = self.groups
        tournamentData.bracketSlots = self.bracketSlots
        CoreDataUtil.addTournament(tournamentData)
//        print(CoreDataUtil.getMatchesForTournament(tournament))
//        print("Getting bracket:")
//        print(tournament.bracket?.slots!)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func defaultPressed(sender: AnyObject) {
        self.slotsNotEntered = []
        if self.tournamentData.format == GlobalConstants.groupStageKnockout {
            self.bracketSlots = BracketCalculator.calculateGroupBrackets(groups, tournamentData: self.tournamentData)
        }
        else {
            self.bracketSlots = BracketCalculator.calculatePureBrackets(self.tournamentData)
        }
        self.reloadStackViewBracket()
        DataAnalytics.sharedInstance.trackEvent(GlobalConstants.buttonPressed, properties: [GlobalConstants.buttonName: GlobalConstants.defaultStr])
    }
    
    @IBAction func clearPressed(sender: AnyObject) {
        self.clearGroups()
        DataAnalytics.sharedInstance.trackEvent(GlobalConstants.buttonPressed, properties: [GlobalConstants.buttonName: GlobalConstants.clear])
    }
    
}
