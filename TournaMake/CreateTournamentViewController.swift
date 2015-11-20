//
//  CreateTournamentViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/17/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class CreateTournamentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var typePicker: UITextField!
    @IBOutlet var textFieldTournamentName: UITextField!
    @IBOutlet var textViewEntrants: UITextView!
    @IBOutlet var labelTotalTeams: UILabel!
    let groupStageKnockout = "Group Stage + Knock-out"
    let entrants : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let typeButton = UIButton(frame: CGRect(x: 0, y: 0, width: typePicker.frame.width, height: typePicker.frame.height))
        self.typePicker.addSubview(typeButton)
        typePicker.text = groupStageKnockout
        typeButton.addTarget(self, action: "typePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.textViewEntrants.layer.borderWidth = 1
        self.textViewEntrants.delegate = self
        self.textViewEntrants.autocorrectionType = UITextAutocorrectionType.No
        
        self.textFieldTournamentName.autocapitalizationType = UITextAutocapitalizationType.Words
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func typePressed(sender: UIButton) {
        let typeArr : [String] = [groupStageKnockout]
        MMPickerView.showPickerViewInView(self.view, withObjects: typeArr, withOptions: nil, objectToStringConverter: nil) { (selectedString : AnyObject!) -> Void in
            print(selectedString!)
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
            if FormValidation.hasNonWhiteSpaceChar(eachName) == true {
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
    
    @IBAction func submitPressed(sender: AnyObject) {
        if self.textFieldTournamentName.text == "" {
            UIHelper.showAlertOnVc(self, title: "", message: "Please enter tournament name")
            return
        }
        let fullNameArr = self.getEntrants()
        if fullNameArr.count < 6 {
            UIHelper.showAlertOnVc(self, title: "", message: "Please include at least 6 entrants")
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
        let tournamentData = TournamentData(entrants: fullNameArr, name: self.textFieldTournamentName!.text!)
        if self.typePicker.text == self.groupStageKnockout {
            let createGroupStage = self.storyboard?.instantiateViewControllerWithIdentifier("createGroupStage") as! CreateGroupStageViewController
            createGroupStage.tournamentData = tournamentData
            self.navigationController?.pushViewController(createGroupStage, animated: true)
        }
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
        self.labelTotalTeams.text = "Total entrants: \(teams.count)"
    }

}
