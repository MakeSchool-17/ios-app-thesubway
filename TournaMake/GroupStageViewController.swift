//
//  GroupStageViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/2/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class GroupStageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var scrollViewMatch: UIScrollView!
    var tournament : Tournament!
    var keyboardHeight : CGFloat = 0
    var keyboardWidth : CGFloat = 0
    var originalFrame : CGRect!
    var tfPoint : CGPoint = CGPointZero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = GlobalConstants.backgroundColorVc
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
        self.reloadStackView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadStackView() {
        for var i = 0; i < self.scrollViewMatch.subviews.count; i++ {
            let eachSubview = self.scrollViewMatch.subviews[i]
            eachSubview.removeFromSuperview()
            i--
        }
        
        var allGroups = self.tournament.groupStage?.allObjects as! [Group]
        allGroups.sortInPlace({ $0.id?.integerValue < $1.id?.integerValue})
        
        let matchHeight : CGFloat = 100
        let matchWidth : CGFloat = 300 //around 300 should be enough for 25 characters
        let paddingX : CGFloat = 20.0
        let labelPadding : CGFloat = 5.0
        let verticalSpacing : CGFloat = 10.0
        var currentY : CGFloat = 0
        
        let tap = UITapGestureRecognizer(target: self, action: "stackViewTapped")
        scrollViewMatch.addGestureRecognizer(tap)
        
        for eachGroup in allGroups {
            var schedule = eachGroup.schedule?.allObjects as! [Match]
            schedule.sortInPlace({ $0.id?.integerValue < $1.id?.integerValue})
            
            let lblHeight : CGFloat = 22.0
            let lbl = UILabel(frame: CGRect(x: paddingX, y: currentY, width: self.scrollViewMatch.frame.size.width, height: lblHeight))
            lbl.text = "Group \(GlobalConstants.groupNames[eachGroup.id!.integerValue])"
            self.scrollViewMatch.addSubview(lbl)
            currentY += lblHeight
            
            for eachMatch in schedule {
                let vw = UIView(frame: CGRect(x: paddingX, y: currentY, width: matchWidth, height: matchHeight))
                vw.tag = (eachMatch.id?.integerValue)!
                vw.layer.cornerRadius = 5.0
                vw.layer.borderWidth = 1
                vw.clipsToBounds = true
                vw.backgroundColor = GlobalConstants.greenVitaminC
                
                for var j = 0; j < 2; j++ {
                    var entrantId = ""
                    var entrant : Entrant!
                    if j == 0 {
                        entrantId = eachMatch.leftId!
                    }
                    else {
                        entrantId = eachMatch.rightId!
                    }
                    if entrantId != GlobalConstants.bye {
                        entrant = CoreDataUtil.getEntrantById(Int(entrantId)!, tournament: self.tournament)![0]
                    }
                    let labelName = UILabel(frame: CGRect(x: labelPadding, y: CGFloat(j) * matchHeight / 2, width: matchWidth * 4 / 5, height: matchHeight / 2))
                    if let anEntrant = entrant {
                        labelName.text = anEntrant.name!
                    }
                    else {
                        labelName.text = entrantId
                    }
                    labelName.tag = j + 102
                    vw.addSubview(labelName)
                    
                    var textFieldScore : UITextField!
                    let scores = [eachMatch.leftScore, eachMatch.rightScore]
                    if eachMatch.leftId != GlobalConstants.bye && eachMatch.rightId != GlobalConstants.bye {
                        textFieldScore = UITextField(frame: CGRect(x: matchWidth * 4 / 5, y: CGFloat(j) * matchHeight / 2 - CGFloat(j), width: matchWidth * 1 / 5, height: matchHeight / 2 + CGFloat(j)))
                        textFieldScore.delegate = self
                        textFieldScore.layer.borderWidth = 1
                        textFieldScore.textAlignment = NSTextAlignment.Center
                        textFieldScore.keyboardType = UIKeyboardType.NumbersAndPunctuation
                        textFieldScore.autocorrectionType = UITextAutocorrectionType.No
                        textFieldScore.tag = j + 100
                        textFieldScore.placeholder = "Score"
                        if scores[j] != nil {
                            textFieldScore.text = "\(scores[j]!)"
                        }
                        vw.addSubview(textFieldScore)
                    }
                }
                self.scrollViewMatch.addSubview(vw)
                currentY += matchHeight + verticalSpacing
            }
        }
        self.scrollViewMatch.contentSize = CGSizeMake(self.view.frame.size.width, currentY + matchHeight)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if self.tournament.bracket?.isStarted == true {
            UIHelper.showAlertOnVc(self, title: "", message: "Bracket stage has already begun.")
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let tfSuperView = textField.superview!
        if textField.tag == 100 {
            (tfSuperView.viewWithTag(101) as! UITextField).becomeFirstResponder()
            return false
        }
        var nextTag = tfSuperView.tag + 1
        //scrollViewMatch.subviews.count does not properly work, so using viewWithTag instead.
        var hasBye = false //should be false if it's there are no more boxes too.
        repeat {
            hasBye = false
            if let boxScore = self.scrollViewMatch.viewWithTag(nextTag) {
                if let nextField = boxScore.viewWithTag(100) as? UITextField {
                    nextField.becomeFirstResponder()
                }
                else {
                    hasBye = true
                    nextTag++
                }
            }
        } while hasBye
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //NOTE: added floatValue property in Extension String in AlgorithmUtil.swift file
        if let textScore = textField.text?.floatValue {
            if AlgorithmUtil.isInteger(textScore) {
                //this is an integer
            }
            CoreDataUtil.updateMatchScore(textScore, matchId: (textField.superview?.tag)!, entrantPos: textField.tag - 100, tournament: self.tournament)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.tfPoint = self.scrollViewMatch.convertPoint(textField.superview!.frame.origin, fromView: self.scrollViewMatch)
        self.tfPoint.x = 0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func stackViewTapped() {
        self.view.endEditing(true)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        self.scrollViewMatch.setContentOffset(self.tfPoint, animated: true)
        /*if self.originalFrame != nil {
            self.view.frame = self.originalFrame
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            var newFrame = self.view.frame
            self.keyboardWidth = self.view.frame.size.width
            self.keyboardHeight = self.view.frame.size.height
            if self.originalFrame == nil {
                self.originalFrame = self.view.frame
            }
            if self.view.frame == self.originalFrame {
                newFrame.origin.y -= keyboardSize.height
            }
            self.view.frame = newFrame
        }*/
    }
    
    func keyboardWillHide(notification: NSNotification) {
        /*if self.originalFrame != nil {
            self.view.frame = self.originalFrame
        }*/
    }

}
