//
//  BracketViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/8/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class BracketViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    var tournament : Tournament!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollViewBracket: UIScrollView!
    var largeSubView : UIView!
    @IBOutlet var btnBeginOrEnd: UIButton!
    @IBOutlet var topView: UIView!
    var bracketMatches : [Match] = []
    var keyboardSize : CGSize!
    var originalFrame : CGRect!
    @IBOutlet var scrollViewDistanceContraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = GlobalConstants.backgroundColorVc
        self.addKeyboardNotifications()
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.tournament.type == GlobalConstants.groupStageKnockout && self.tournament!.bracket?.isStarted != true {
            BracketCalculator.getMatchupsFromBracket(self.tournament)
            //set tournament back again.
        }
        self.tournament = CoreDataUtil.getTournamentById(self.tournament.id!.integerValue)
        self.scrollViewBracket.delegate = self
        self.reloadStackViewBracket()
        if self.tournament.type == GlobalConstants.knockout && self.tournament!.bracket?.isStarted != true {
            self.startBracket()
        }
        if self.tournament.bracket?.isStarted != true {
            self.lblTitle.text = "If the bracket stage were to begin now, based on current standings:"
        }
        else {
            self.displayBracketStarted()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if scrollView.subviews.count <= 0 {
            return nil
        }
        return scrollView.subviews[0]
    }
    
    func reloadStackViewBracket() {
        if self.largeSubView != nil {
            for var i = 0; i < self.largeSubView.subviews.count; i++ {
                let eachSubview = self.largeSubView.subviews[i]
                eachSubview.removeFromSuperview()
                i--
            }
        }
        
        let verticalSpacing : CGFloat = 10
        let horizontalSpacing : CGFloat = 15
        let paddingX : CGFloat = 20.0
        let labelPadding : CGFloat = 5.0
        var currentY : CGFloat = 0.0
        //stackViewBracket.spacing = spacing
        //stackViewBracket.alignment = UIStackViewAlignment.Center
        
        let matchHeight : CGFloat = 100
        let matchWidth : CGFloat = 250
        
        let tap = UITapGestureRecognizer(target: self, action: "scrollViewTapped")
        scrollViewBracket.addGestureRecognizer(tap)
        
        //get matches directly from tournament.
        self.bracketMatches = tournament.bracket?.matches?.allObjects as! [Match]
        //sort BACKWARDS, to simplify math calculations.
        bracketMatches.sortInPlace({$0.id?.integerValue > $1.id?.integerValue})
        
        let numFirstRoundMatches = CGFloat(bracketMatches.count) / 2 //for height
        let numRounds = MathHelper.numRoundsForEntrantCount(bracketMatches.count / 2) //for width
        self.scrollViewBracket.contentSize = CGSizeMake((matchWidth + horizontalSpacing) * CGFloat(numRounds) + paddingX, numFirstRoundMatches * (matchHeight + 10))
        self.scrollViewBracket.minimumZoomScale = 0.35
        self.scrollViewBracket.maximumZoomScale = 2.0
        if numRounds <= 2 {
            //If there are only 2 rounds, there must be enough space for 3rd-place match underneath championship match.
            self.scrollViewBracket.contentSize.height += verticalSpacing + matchHeight
        }
        
        if self.largeSubView == nil {
            self.largeSubView = UIView(frame: CGRect(x: 0, y: 0, width: self.scrollViewBracket.contentSize.width, height: self.scrollViewBracket.contentSize.height))
            self.scrollViewBracket.addSubview(self.largeSubView)
        }
        
        var roundNum = 1
        var endIdx = bracketMatches.count / 2
        var startIdx = bracketMatches.count
        var highestViewInRound : UIView!
        var championshipFrame : CGRect!
        for var i = startIdx - 1; i >= endIdx; i-- {
            let eachMatch = bracketMatches[i]
            
            let vw = UIView(frame: CGRect(x: paddingX + CGFloat(roundNum - 1) * (matchWidth + horizontalSpacing), y: currentY, width: matchWidth, height: matchHeight))
            //vw.heightAnchor.constraintEqualToConstant(matchHeight).active = true
            //vw.widthAnchor.constraintEqualToConstant(matchWidth).active = true
            vw.clipsToBounds = false
            //vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            vw.backgroundColor = GlobalConstants.grayVeryLight
            vw.tag = i
            if roundNum != 1 && i >= 1 {
                //so not the first round, and not the third place match.
                //for middle rounds, get the previous round's match, which is i * 2 + 1.
                let previousVwTop : UIView? = self.largeSubView.viewWithTag(i * 2 + 1)
                let previousVwBottom : UIView? = self.largeSubView.viewWithTag(i * 2)
                //this is set to the center of the previous 2 views
                if previousVwTop != nil && previousVwBottom != nil {
                    vw.frame.origin.y = (previousVwTop!.center.y + previousVwBottom!.center.y) / 2 - (matchHeight / 2)
                }
                if i == 1 {
                    championshipFrame = vw.frame
                    let heightOfLabel : CGFloat = 40
                    let lblChampionship = UILabel(frame: CGRect(x: 0, y: 0 - heightOfLabel, width: matchWidth, height: heightOfLabel))
                    lblChampionship.text = "Championship"
                    vw.addSubview(lblChampionship)
                }
            }
            //third-place match will be index 0, and championship is index 1, for math purposes
            else if i == 0 {
                vw.frame.origin.y = championshipFrame.origin.y + 3 / 2 * matchHeight + verticalSpacing
                //add label indicating 3rd-place match:
                let heightOfLabel : CGFloat = 21
                let lbl3rdPlace = UILabel(frame: CGRect(x: 0, y: 0 - heightOfLabel, width: matchWidth, height: heightOfLabel))
                vw.addSubview(lbl3rdPlace)
                lbl3rdPlace.text = "3rd-place Match"
            }
            
            if i == (startIdx - 1) {
                highestViewInRound = vw
            }
            
            let idLeft : String? = eachMatch.leftId
            let idRight : String? = eachMatch.rightId
            let ids : [String?] = [idLeft, idRight]
            
            for j in 0...1 {
                let eachId = ids[j]
                let labelTop = UILabel(frame: CGRect(x: labelPadding, y: CGFloat(j) * matchHeight / 2, width: matchWidth, height: matchHeight / 2))
                if self.tournament.type == GlobalConstants.knockout && AlgorithmUtil.isPlayerId(eachId) {
                    labelTop.text = eachId!
                }
                else if AlgorithmUtil.isPlayerId(eachId) {
                    let eachEntrant = CoreDataUtil.getEntrantById(Int(eachId!)!, tournament: eachMatch.tournament!)![0]
                    labelTop.text = eachEntrant.name!
                }
                else if i >= bracketMatches.count / 2 {
                    //else, that means there is no first-round player in that slot.
                    labelTop.text = GlobalConstants.bye
                    //if i is < half, don't add a bye, because later rounds don't have byes.
                }
                labelTop.tag = j
                
                //if tournament has started, add appropriate score boxes too.
                if self.tournament.bracket?.isStarted == true {
                    
                    //this entire if-statement is solely for the purpose of adding a score box.
                    
                    var textFieldScore : UITextField!
                    let scores = [eachMatch.leftScore, eachMatch.rightScore]
                    if AlgorithmUtil.isPlayerId(eachMatch.leftId) && AlgorithmUtil.isPlayerId(eachMatch.rightId) {
                        textFieldScore = UITextField(frame: CGRect(x: matchWidth * 4 / 5, y: CGFloat(j) * matchHeight / 2 - CGFloat(j), width: matchWidth * 1 / 5, height: matchHeight / 2 + CGFloat(j)))
                        textFieldScore.delegate = self
                        textFieldScore.layer.borderWidth = 1
                        textFieldScore.textAlignment = NSTextAlignment.Center
                        textFieldScore.keyboardType = UIKeyboardType.NumbersAndPunctuation
                        textFieldScore.autocorrectionType = UITextAutocorrectionType.No
                        textFieldScore.tag = j + 100
                        if scores[j] != nil {
                            textFieldScore.text = "\(scores[j]!)"
                        }
                        vw.addSubview(textFieldScore)
                    }
                }
                vw.addSubview(labelTop)
            }
            //if i is even, add a vertical line that extends to previous box.
            if i % 2 == 0 && (roundNum != numRounds) {
                let previousVw : UIView? = self.largeSubView.viewWithTag(i + 1)
                if let prevVw = previousVw {
                    let distanceToPrevious = vw.center.y - prevVw.center.y
                    //this is a negative-y position:
                    let verticalLine = UILabel(frame: CGRect(x: matchWidth - 1, y: matchHeight / 2 - distanceToPrevious, width: 1, height: distanceToPrevious))
                    verticalLine.backgroundColor = UIColor.blackColor()
                    
                    let horizontalLine = UILabel(frame: CGRect(x: 0, y: verticalLine.frame.size.height / 2, width: horizontalSpacing + 1, height: 1))
                    horizontalLine.backgroundColor = UIColor.blackColor()
                    verticalLine.addSubview(horizontalLine)
                    
                    vw.addSubview(verticalLine)
                }
            }
            //constraint may not be helpful here.
            //what I want is a subview
            self.largeSubView.addSubview(vw)
            currentY += matchHeight + verticalSpacing
            if i == endIdx {
                currentY = highestViewInRound.frame.origin.y + (matchHeight + verticalSpacing) / 2
                roundNum++
                startIdx = endIdx
                endIdx = startIdx / 2
                if endIdx <= 1 {
                    //because final round has 2 matches, including the 3rd-place match.
                    endIdx = 0
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let tagSuper = textField.superview!.tag
        let tagTf = textField.tag
        if tagTf == 100 {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        //end editing AFTER retrieving superview's tag value, and after removing notifications
        self.view.endEditing(true)
        if tagTf == 100 {
            let viewSuper : UIView = (self.scrollViewBracket.viewWithTag(tagSuper))!
            let nextTf : UITextField = viewSuper.viewWithTag(101) as! UITextField
            nextTf.becomeFirstResponder()
            //re-add notifications after temporarily turning them off:
            self.addKeyboardNotifications()
        }
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //NOTE: added floatValue property in Extension String in AlgorithmUtil.swift file
        if let textScore = textField.text?.floatValue {
            //store to core data match:
            let matchIdx = (textField.superview?.tag)!
            let matchId = self.bracketMatches[matchIdx].id!.integerValue
            let updatedMatch = CoreDataUtil.updateMatchScore(textScore, matchId: matchId, entrantPos: textField.tag - 100, tournament: self.tournament)
            //check if updatedMatch has a winner.
            let winnerId = AlgorithmUtil.winnerOfMatch(updatedMatch!)
            self.updateLaterMatchWithWinner(winnerId, idxOfPrevMatch: matchIdx)
            if matchIdx == 2 || matchIdx == 3 {
                //semi-final losers must be added to 3rd-place match.
                let loserId = AlgorithmUtil.loserOfMatch(updatedMatch!)
                self.updateBronzeMatchWithLoser(loserId, idxOfPrevMatch: matchIdx)
            }
            self.reloadStackViewBracket()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func scrollViewTapped() {
        self.view.endEditing(true)
    }
    
    @IBAction func btnPressed(sender: AnyObject?) {
        let alert = UIAlertController(title: title, message: "Are you sure you want to start the bracket? You may not change group stage scores after bracket starts.", preferredStyle: UIAlertControllerStyle.Alert)
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { _ in
            self.startBracket()
        })
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { _ in
        })
        alert.addAction(noAction)
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func startBracket() {
        //start the tournament
        CoreDataUtil.setBracket(self.tournament.bracket!, isStarted: true)
        //check for byes, and advance the opponents.
        for var matchIdx = self.bracketMatches.count - 1; matchIdx >= 0; matchIdx-- {
            let eachMatch = self.bracketMatches[matchIdx]
            let winnerId = AlgorithmUtil.winnerOfMatch(eachMatch)
            self.updateLaterMatchWithWinner(winnerId, idxOfPrevMatch: matchIdx)
        }
        self.reloadStackViewBracket()
        self.displayBracketStarted()
    }
    
    func displayBracketStarted() {
        self.lblTitle.text = GlobalConstants.bracketStageStarted
        self.btnBeginOrEnd.hidden = true
    }
    
    func updateLaterMatchWithWinner(winnerId: String?, idxOfPrevMatch: Int) {
        if winnerId != nil && idxOfPrevMatch > 1 {
            let nextId = idxOfPrevMatch / 2
            let nextMatch = self.bracketMatches[nextId]
            //remember, matchId is the correct variable here.
            if idxOfPrevMatch % 2 != 0 {
                //it is the top match. update leftId
                CoreDataUtil.updateEntrantsInMatch(nextMatch, leftId: "\(winnerId!)", rightId: nextMatch.rightId)
            }
            else {
                //it is the bottom match. update rightId
                CoreDataUtil.updateEntrantsInMatch(nextMatch, leftId: nextMatch.leftId, rightId: "\(winnerId!)")
            }
        }
    }
    
    func updateBronzeMatchWithLoser(loserId: String?, idxOfPrevMatch: Int) {
        if loserId != nil {
            let bronzeMatch = self.bracketMatches[0]
            if idxOfPrevMatch % 2 != 0 {
                CoreDataUtil.updateEntrantsInMatch(bronzeMatch, leftId: "\(loserId!)", rightId: bronzeMatch.rightId)
            }
            else {
                CoreDataUtil.updateEntrantsInMatch(bronzeMatch, leftId: bronzeMatch.leftId, rightId: "\(loserId!)")
            }
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            var newFrame = self.view.frame
            self.keyboardSize = CGSize(width: keyboardSize.width, height: keyboardSize.height)
            if self.originalFrame == nil {
                self.originalFrame = self.view.frame
            }
            if self.view.frame == self.originalFrame {
                newFrame.origin.y -= keyboardSize.height
            }
            self.view.frame = newFrame
            self.scrollViewDistanceContraint.constant = keyboardSize.height - self.topView.frame.size.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame = self.originalFrame
        self.scrollViewDistanceContraint.constant = 0
    }
    
    func addKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

}
