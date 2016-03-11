//
//  CreateTournamentViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/17/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class CreateTournamentViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet var typePicker: UITextField!
    @IBOutlet var textFieldTournamentName: UITextField!
    @IBOutlet var textViewEntrants: UITextView!
    @IBOutlet var labelTotalTeams: UILabel!
    @IBOutlet var btnNext: UIButton!
    let typeArr : [String] = [GlobalConstants.knockout, GlobalConstants.groupStageKnockout]
    let entrants : [String] = []
    var pickerInfo : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.tag = 350 //to distinguish from CreateGroup, or CreateKnockout.
        self.view.backgroundColor = GlobalConstants.backgroundColorVc
        self.btnNext.backgroundColor = GlobalConstants.buttonGreenColor
        self.btnNext.titleLabel!.font = UIFont.systemFontOfSize(40)
        self.btnNext.tintColor = UIColor.whiteColor()
        self.btnNext.layer.cornerRadius = 5.0
        
        let typeButton = UIButton(frame: CGRect(x: 0, y: 0, width: typePicker.frame.width, height: typePicker.frame.height))
        self.typePicker.addSubview(typeButton)
        typePicker.text = GlobalConstants.knockout
        typeButton.addTarget(self, action: "typePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        typeButton.imageView?.contentMode = UIViewContentMode.ScaleToFill
        typeButton.setImage(UIImage(named: "dropDownSelectBox"), forState: UIControlState.Normal)
        self.textViewEntrants.layer.borderWidth = 1
        self.textViewEntrants.delegate = self
        self.textViewEntrants.autocorrectionType = UITextAutocorrectionType.No
        
        self.textFieldTournamentName.autocapitalizationType = UITextAutocapitalizationType.Words
        self.textFieldTournamentName.delegate = self
        self.labelTotalTeams.text = "Total entrants: 0\n(Must be between 4-64 entrants)"
        //self.textFieldTournamentName.text = "Tournament 1"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func typePressed(sender: UIButton) {
        self.view.endEditing(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pickerDidScroll:", name: "pickerDidScroll", object: nil)
        MMPickerView.showPickerViewInView(self.view, withObjects: self.typeArr, withOptions: nil, objectToStringConverter: nil) { (selectedString : AnyObject!) -> Void in
            self.typePicker.text = selectedString as? String
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        self.displayInfoForType(self.typeArr[0])
    }
    
    func pickerDidScroll(notification: NSNotification) {
        let i = notification.object as! Int
        self.displayInfoForType(self.typeArr[i])
    }
    
    func displayInfoForType(formatType : String) {
        if let picker : UIView = self.view.viewWithTag(300) {
            if self.pickerInfo != nil {
                self.pickerInfo.removeFromSuperview()
                self.pickerInfo = nil
            }
            self.pickerInfo = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height / 2))
            self.pickerInfo.tag = 301
            pickerInfo.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            let labelInfo = UILabel(frame: CGRect(x: 10, y: (self.navigationController?.navigationBar.frame.size.height)!, width: pickerInfo.frame.size.width - 20, height: pickerInfo.frame.size.height))
            labelInfo.numberOfLines = 0
            labelInfo.font = UIFont(name: (labelInfo.font?.fontName)!, size: 16.0)
            if formatType == GlobalConstants.knockout {
                labelInfo.text = "Each competitor in the knockout stage is paired against another competitor. Winner of each match advances, and loser is eliminated. Semi-final losers get a chance to play each other for 3rd place. If a competitor is paired against a *Bye*, that competitor automatically advances to the next round."
            }
            else if formatType == GlobalConstants.groupStageKnockout {
                labelInfo.font = UIFont(name: (labelInfo.font?.fontName)!, size: 15.0)
                labelInfo.text = "Competitors are divided into groups. Each group has its own inner round-robin tournament, where every competitor faces its other group members one time each. Standings are calculated based on each match result. Top 2 competitors from each group advance to the knockout stage. In some cases, depending on how many competitors are in the tournament, the best 3rd-place wild cards may also advance to the knockout stage."
            }
            pickerInfo.addSubview(labelInfo)
            
            picker.addSubview(self.pickerInfo)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getEntrants() -> [String] {
        let fullNameArr = self.textViewEntrants.text.characters.split{$0 == "\n"}.map(String.init)
        var nonEmptyNames : [String] = []
        //remove empty names:
        for eachName in fullNameArr {
            if AlgorithmUtil.hasNonWhiteSpaceChar(eachName) == true {
                nonEmptyNames.append(eachName)
            }
        }
        return nonEmptyNames
    }
    
    func checkDuplicates(strArr : [String]) -> String! {
        let entrantDict = NSMutableDictionary()
        for eachEntrant in strArr {
            if entrantDict[eachEntrant] == nil {
                entrantDict[eachEntrant] = 0
            }
            else {
                return eachEntrant
            }
        }
        return nil
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        if self.textFieldTournamentName.text == "" {
            UIHelper.showAlertOnVc(self, title: "", message: "Please enter tournament name")
            return
        }
        if self.typePicker.text == nil || self.typePicker.text == "" {
            UIHelper.showAlertOnVc(self, title: "", message: "Please select tournament type")
            return
        }
        let fullNameArr = self.getEntrants()
        if fullNameArr.count < 4 {
            UIHelper.showAlertOnVc(self, title: "", message: "Please include at least 4 entrants")
            return
        }
        if fullNameArr.count > 64 {
            UIHelper.showAlertOnVc(self, title: "", message: "Limit number of entrants is 64")
            return
        }
        let duplicateName = self.checkDuplicates(fullNameArr)
        if duplicateName != nil {
            UIHelper.showAlertOnVc(self, title: "", message: "Duplicate entrant name: \(duplicateName)")
            return
        }
        let tournamentData = TournamentData(entrants: fullNameArr, name: self.textFieldTournamentName!.text!, format: self.typePicker.text!)
        DataAnalytics.sharedInstance.trackEvent(GlobalConstants.formatSelected, properties: [GlobalConstants.format:tournamentData.format, GlobalConstants.numEntrants:tournamentData.entrants.count])
        if self.typePicker.text == GlobalConstants.groupStageKnockout {
            let createGroupStage = self.storyboard?.instantiateViewControllerWithIdentifier("createGroupStage") as! CreateGroupStageViewController
            createGroupStage.tournamentData = tournamentData
            self.navigationController?.pushViewController(createGroupStage, animated: true)
        }
        else if self.typePicker.text == GlobalConstants.knockout {
            let createKnockout = self.storyboard?.instantiateViewControllerWithIdentifier("createKnockout") as! CreateKnockoutViewController
            createKnockout.groups = nil
            createKnockout.tournamentData = tournamentData
            self.navigationController?.pushViewController(createKnockout, animated: true)
        }
    }
    
    //function implemented with stack overflow:
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 20
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        //NOTE: does not account for copy-pasting characters.
        //prevent typing after character limit
        let fullNameArr = self.textViewEntrants.text.characters.split{$0 == "\n"}.map(String.init)
        //increment currentPos, until it passes current word:
        var currentPos = 0
        for eachName in fullNameArr {
            let eachLength = eachName.characters.count
            currentPos += eachLength
            if currentPos >= range.location {
                if eachName.characters.count > 24 {
                    if text.characters.count == 0 {
                        //delete was pressed
                        break
                    }
                    if text == "\n" {
                        break
                    }
                    return false
                }
                break
            }
            currentPos += 1
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        let teams = self.getEntrants()
        self.labelTotalTeams.text = "Total entrants: \(teams.count)\n(Must be between 4-64 entrants)"
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == self.textFieldTournamentName {
            self.textViewEntrants.becomeFirstResponder()
        }
        return false
    }
    
}
