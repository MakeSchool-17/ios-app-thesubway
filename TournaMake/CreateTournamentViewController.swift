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
    let entrants : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.labelTotalTeams.text = "Total entrants: 0\n(Must be between 6-64 entrants)"
        //self.textFieldTournamentName.text = "Tournament 1"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func typePressed(sender: UIButton) {
        self.view.endEditing(true)
        let typeArr : [String] = [GlobalConstants.groupStageKnockout, GlobalConstants.knockout]
        MMPickerView.showPickerViewInView(self.view, withObjects: typeArr, withOptions: nil, objectToStringConverter: nil) { (selectedString : AnyObject!) -> Void in
            self.typePicker.text = selectedString as? String
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
        let tournamentData = TournamentData(entrants: fullNameArr, name: self.textFieldTournamentName!.text!, format: self.typePicker.text!)
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
        self.labelTotalTeams.text = "Total entrants: \(teams.count)\n(Must be between 6-64 entrants)"
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == self.textFieldTournamentName {
            self.textViewEntrants.becomeFirstResponder()
        }
        return false
    }
    
}
