//
//  GroupStageViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/2/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class GroupStageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var stackViewMatch: UIStackView!
    var tournament : Tournament!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
        self.reloadStackView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadStackView() {
        for var i = 0; i < self.stackViewMatch.arrangedSubviews.count; i++ {
            let eachSubview = self.stackViewMatch.arrangedSubviews[i]
            eachSubview.removeFromSuperview()
            self.stackViewMatch.removeArrangedSubview(eachSubview)
            i--
        }
        
        var allGroups = self.tournament.groupStage?.allObjects as! [Group]
        allGroups.sortInPlace({ $0.id?.integerValue < $1.id?.integerValue})
        
        
        stackViewMatch.spacing = 10
        stackViewMatch.alignment = UIStackViewAlignment.Center
        
        let matchHeight : CGFloat = 100
        let matchWidth : CGFloat = 250
        
        let tap = UITapGestureRecognizer(target: self, action: "stackViewTapped")
        stackViewMatch.addGestureRecognizer(tap)
        
        for eachGroup in allGroups {
            var schedule = eachGroup.schedule?.allObjects as! [Match]
            schedule.sortInPlace({ $0.id?.integerValue < $1.id?.integerValue})
            
            let lbl = UILabel()
            lbl.text = "Group \(GlobalConstants.groupNames[eachGroup.id!.integerValue])"
            self.stackViewMatch.addArrangedSubview(lbl)
            
            for eachMatch in schedule {
                let vw = UIView()
                vw.tag = (eachMatch.id?.integerValue)!
                vw.heightAnchor.constraintEqualToConstant(matchHeight).active = true
                vw.widthAnchor.constraintEqualToConstant(matchWidth).active = true
                vw.layer.cornerRadius = 5.0
                vw.layer.borderWidth = 1
                vw.clipsToBounds = true
                
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
                    let labelName = UILabel(frame: CGRect(x: 0, y: CGFloat(j) * matchHeight / 2, width: matchWidth * 4 / 5, height: matchHeight / 2))
                    if let anEntrant = entrant {
                        labelName.text = anEntrant.name!
                    }
                    else {
                        labelName.text = entrantId
                    }
                    labelName.tag = j
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
                        textFieldScore.tag = j
                        if scores[j] != nil {
                            textFieldScore.text = "\(scores[j]!)"
                        }
                        vw.addSubview(textFieldScore)
                    }
                }
                self.stackViewMatch.addArrangedSubview(vw)
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //NOTE: added floatValue property in Extension String in AlgorithmUtil.swift file
        if let textScore = textField.text?.floatValue {
            if textScore - floor(textScore) > 0.000001 {
                //this is an integer
            }
            //store to core data match:
            let updatedMatch = CoreDataUtil.updateMatchScore(textScore, matchId: (textField.superview?.tag)!, entrantPos: textField.tag, tournament: self.tournament)
            print(updatedMatch)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func stackViewTapped() {
        self.view.endEditing(true)
    }

}
