//
//  DoubleEliminationViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 7/12/16.
//  Copyright © 2016 Dan Hoang. All rights reserved.
//

import UIKit

class DoubleEliminationViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    //TO-DO: double-elimination for 4 or 5 entrants.
    
    var tournament : Tournament!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollViewBracket: UIScrollView!
    var largeSubView : UIView!
    @IBOutlet var btnBeginOrEnd: UIButton!
    @IBOutlet var topView: UIView!
    var bracketMatches : [Match] = []
    var keyboardSize : CGSize!
    var originalFrame : CGRect!
    var k = 0
    @IBOutlet var scrollViewDistanceContraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = GlobalConstants.backgroundColorVc
        self.addKeyboardNotifications()
        self.btnBeginOrEnd.backgroundColor = GlobalConstants.buttonGreenColor
        self.btnBeginOrEnd.titleLabel?.font = UIFont.systemFontOfSize(40)
        self.btnBeginOrEnd.tintColor = UIColor.whiteColor()
        self.btnBeginOrEnd.layer.cornerRadius = 5.0
        
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tournament = CoreDataUtil.getTournamentById(self.tournament.id!.integerValue)
        self.scrollViewBracket.delegate = self
        self.reloadStackViewBracket()
        if self.tournament!.bracket?.isStarted != true {
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
        UIHelper.removeSubviewsFrom(self.largeSubView)
        
        let verticalSpacing : CGFloat = 10
        let horizontalSpacing : CGFloat = 15
        let paddingX : CGFloat = 20.0
        let labelPadding : CGFloat = 5.0
        var currentY : CGFloat = 0.0
        //stackViewBracket.spacing = spacing
        //stackViewBracket.alignment = UIStackViewAlignment.Center
        
        let matchHeight : CGFloat = 100
        let matchWidth : CGFloat = 250
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(BracketViewController.scrollViewTapped))
        scrollViewBracket.addGestureRecognizer(tap)
        
        //get matches directly from tournament.
        self.bracketMatches = tournament.bracket?.matches?.allObjects as! [Match]
        //sort BACKWARDS, to simplify math calculations.
        bracketMatches.sortInPlace({$0.id?.integerValue > $1.id?.integerValue})
        
        let numFirstRoundMatches = CGFloat(bracketMatches.count / 2) / 2 //for height
        let numRounds = MathHelper.numRoundsForEntrantCount(bracketMatches.count / 4) //for width
        let winnerBracketHeight = (numFirstRoundMatches + 1) * (matchHeight + 10)
        self.scrollViewBracket.contentSize = CGSizeMake((matchWidth + horizontalSpacing) * CGFloat(numRounds+5) + paddingX, winnerBracketHeight * 2 + matchHeight)
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
        //bracketMatches.count i.e. is 31, or n * 2 - 1.
        k = (bracketMatches.count + 1) / 2
        var startIdx = bracketMatches.count / 1 //because double-elimination
        var endIdx = startIdx - k / 2
        var highestViewInRound : UIView!
        var championshipFrame = CGRectMake(paddingX + horizontalSpacing, currentY, matchWidth, matchHeight)
        var i = startIdx - 1
        //starting with winner's bracket:
        while i >= endIdx {
            let eachMatch = bracketMatches[i]
            var horizontalSpaceMultiplier = roundNum - 1
            if roundNum > 2 {
                horizontalSpaceMultiplier += roundNum - 2
            }
            let spacePerBoxHorizontal = matchWidth + horizontalSpacing
            let vw = UIView(frame: CGRect(x: paddingX + CGFloat(horizontalSpaceMultiplier) * (spacePerBoxHorizontal), y: currentY, width: matchWidth, height: matchHeight))
            //vw.heightAnchor.constraintEqualToConstant(matchHeight).active = true
            //vw.widthAnchor.constraintEqualToConstant(matchWidth).active = true
            vw.clipsToBounds = false
            //vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            vw.backgroundColor = GlobalConstants.grayVeryLight
            vw.tag = i + 200
            if (roundNum != 1 || self.bracketMatches.count == 2) && i >= 1 {
                //so not the first round, and not the if-necessary match.
                //30 and 29 want to go to 22. (n - k) / 2 - 1 + k = a;
                //(n - k) / 2 = a - k + 1;
                //(n - k) = (a - k + 1) * 2;
                //(n) = (a - k + 1) * 2 + k;
                //for middle rounds, get the previous round's match, which is i * 2 + 1.
                //22 must find 29 and 30. (n - k + 1) +
                let previousVwTop : UIView? = self.largeSubView.viewWithTag((i - k + 1) * 2 + k + 200)
                let previousVwBottom : UIView? = self.largeSubView.viewWithTag((i - k + 1) * 2 + k + 199)
                //this is set to the center of the previous 2 views
                if previousVwTop != nil && previousVwBottom != nil {
                    vw.frame.origin.y = (previousVwTop!.center.y + previousVwBottom!.center.y) / 2 - (matchHeight / 2)
                }
                if i == k {
                    championshipFrame = vw.frame
                    let heightOfLabel : CGFloat = 40
                    let lblChampionship = UILabel(frame: CGRect(x: 0, y: 0 - heightOfLabel, width: matchWidth, height: heightOfLabel))
                    lblChampionship.text = "Upper-Bracket Final"
                    vw.addSubview(lblChampionship)
                    //check if championship is completed
                }
            }
                //if-necessary match will be index 0, and championship is index 1, for math purposes
            else if i == 0 {
                //this area of code should never be executed
                assert(2 == 1)
                vw.frame.origin.y = championshipFrame.origin.y + 3 / 2 * matchHeight + verticalSpacing
                vw.frame.origin.x = championshipFrame.origin.x
                //add label indicating 3rd-place match:
                let heightOfLabel : CGFloat = 21
                let lbl3rdPlace = UILabel(frame: CGRect(x: 0, y: 0 - heightOfLabel, width: matchWidth, height: heightOfLabel))
                vw.addSubview(lbl3rdPlace)
                lbl3rdPlace.text = "If-necessary Match"
            }
            
            if i == (startIdx - 1) {
                //TO-DO?
                highestViewInRound = vw
            }
            
            let idLeft : String? = eachMatch.leftId
            let idRight : String? = eachMatch.rightId
            let ids : [String?] = [idLeft, idRight]
            
            for j in 0...1 {
                let eachId = ids[j]
                let labelTop = UILabel(frame: CGRect(x: labelPadding, y: CGFloat(j) * matchHeight / 2, width: matchWidth, height: matchHeight / 2))
                print("current \(i) end \(endIdx) j: \(j), id: \(eachId)")
                if AlgorithmUtil.isPlayerId(eachId) {
                    labelTop.text = eachId!
                }
                else if AlgorithmUtil.isPlayerId(eachId) {
                    let eachEntrant = CoreDataUtil.getEntrantById(Int(eachId!)!, tournament: eachMatch.tournament!)![0]
                    labelTop.text = eachEntrant.name!
                }
                else if i >= (3 * k / 2 - 1) {
                    //else, that means there is no first-round player in that slot.
                    labelTop.text = GlobalConstants.bye
                    //if i is < (3 * k / 2 - 1), don't add a bye, because later winner-bracket-rounds don't have byes.
                }
                labelTop.tag = j
                
                //if tournament has started, add appropriate score boxes too.
                if self.tournament.bracket?.isStarted == true {
                    //TO-DO?
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
                //labelTop.text = "\(labelTop.text) \(i)"
                vw.addSubview(labelTop)
            }
            //if i is odd, add a vertical line that extends to previous box.
            if i % 2 == 1 /*&& (roundNum != numRounds)*/ && self.bracketMatches.count != 2 {
                //TO-DO?
                let previousVw : UIView? = self.largeSubView.viewWithTag(i + 200 + 1)
                if let prevVw = previousVw {
                    let distanceToPrevious = vw.center.y - prevVw.center.y
                    //this is a negative-y position:
                    let verticalLine = UILabel(frame: CGRect(x: matchWidth - 1, y: matchHeight / 2 - distanceToPrevious, width: 1, height: distanceToPrevious))
                    verticalLine.backgroundColor = UIColor.blackColor()
                    
                    var horizontalLineWidth = horizontalSpacing + 1
                    if roundNum >= 2 {
                        horizontalLineWidth += spacePerBoxHorizontal
                    }
                    let horizontalLine = UILabel(frame: CGRect(x: 0, y: verticalLine.frame.size.height / 2, width: horizontalLineWidth, height: 1))
                    horizontalLine.backgroundColor = UIColor.blackColor()
                    verticalLine.addSubview(horizontalLine)
                    
                    vw.addSubview(verticalLine)
                }
            }
            //constraint may not be helpful here.
            //what I want is a subview
            self.largeSubView.addSubview(vw)
            currentY += matchHeight + verticalSpacing
            //TO-DO above?
            if i == endIdx {
                currentY = highestViewInRound.frame.origin.y + (matchHeight + verticalSpacing) / 2
                roundNum += 1
                startIdx = endIdx
                endIdx = startIdx - k / MathHelper.powerOf(2, power: roundNum)
                //when endIdx is exactly 16, I still want to keep going
                if endIdx <= (k - 1) {
                    
                    //because this section is only for winners bracket.
                    i = 0
                }
            }
            i -= 1
        }
        //now to loser's bracket:
        var finals1Frame = CGRect()
        currentY = winnerBracketHeight
        roundNum = 1
        startIdx = k
        endIdx = startIdx - k / (MathHelper.powerOf(2, power: 2))
        i = startIdx - 1
        while (i >= 0) {
            let eachMatch = bracketMatches[i]
            //link to roundNum:
            let vw = UIView(frame: CGRect(x: paddingX + CGFloat(roundNum - 1) * (matchWidth + horizontalSpacing), y: currentY, width: matchWidth, height: matchHeight))
            vw.clipsToBounds = false
            //vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            vw.backgroundColor = GlobalConstants.grayVeryLight
            vw.tag = i + 200
            if i == 1 {
                let heightOfLabel : CGFloat = 40
                let lblChampionship = UILabel(frame: CGRect(x: 0, y: 0 - heightOfLabel, width: matchWidth, height: heightOfLabel))
                lblChampionship.text = "Championship"
                vw.addSubview(lblChampionship)
            }
            else if i == 2 {
                let heightOfLabel : CGFloat = 40
                let lblChampionship = UILabel(frame: CGRect(x: 0, y: 0 - heightOfLabel, width: matchWidth, height: heightOfLabel))
                lblChampionship.text = "Lower-Bracket Final"
                vw.addSubview(lblChampionship)
            }
            if (roundNum != 1 || self.bracketMatches.count == 2) && i >= 1 {
                var temp = 0
                var bottomIdx : Int! = 0
                //so not the first round, and not the if-necessary match.
                //formulas for these depend if even or odd rounds.
                //use helper. get roundNum, and previousBottomIdx. pass in k, i.
                //even roundNumbers will have null top. odd will have both fine.
                (temp, bottomIdx) = DoubleEliminationCalculator.loserGetPrevious(k, i: i)
                let previousVwTop : UIView? = self.largeSubView.viewWithTag(bottomIdx + 201)
                let previousVwBottom : UIView? = self.largeSubView.viewWithTag(bottomIdx + 200)
            }
            if i == (startIdx - 1) {
                highestViewInRound = vw
            }
            if i == 1 {
                var frame = vw.frame
                let lowerChampionshipFrame = self.largeSubView.viewWithTag(200 + 2)!.frame
                frame.origin.y = (championshipFrame.origin.y + lowerChampionshipFrame.origin.y) / 2
                vw.frame = frame
                finals1Frame = vw.frame
                vw.backgroundColor = UIColor(red: 1.0, green: 215.0 / 255.0, blue: 0.0, alpha: 1.0)
            }
            else if i == 0 {
                var frame = vw.frame
                frame.origin.y = finals1Frame.origin.y + verticalSpacing + matchHeight
                vw.frame = frame
                vw.backgroundColor = UIColor(red: 1.0, green: 215.0 / 255.0, blue: 0.0, alpha: 1.0)
            }
            
            let idLeft : String? = eachMatch.leftId
            let idRight : String? = eachMatch.rightId
            let ids : [String?] = [idLeft, idRight]
            
            for j in 0...1 {
                let eachId = ids[j]
                let labelTop = UILabel(frame: CGRect(x: labelPadding, y: CGFloat(j) * matchHeight / 2, width: matchWidth, height: matchHeight / 2))
                if AlgorithmUtil.isPlayerId(eachId) || eachId == GlobalConstants.bye {
                    labelTop.text = eachId!
                }
                else if AlgorithmUtil.isPlayerId(eachId) {
                    let eachEntrant = CoreDataUtil.getEntrantById(Int(eachId!)!, tournament: eachMatch.tournament!)![0]
                    labelTop.text = eachEntrant.name!
                }
                else if i >= (3 * k / 2 - 1) {
                    //else, that means there is no first-round player in that slot.
                    labelTop.text = GlobalConstants.bye
                    //if i is < (3 * k / 2 - 1), don't add a bye, because later winner-bracket-rounds don't have byes.
                }
                labelTop.tag = j
                
                //if tournament has started, add appropriate score boxes too.
                if self.tournament.bracket?.isStarted == true {
                    //TO-DO?
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
                //labelTop.text = "\(labelTop.text) \(i)"
                vw.addSubview(labelTop)
            }
            if i == 0 && !self.isAdditionalMatchNecessary() {
                vw.hidden = true
            }
            
            if i == 2 {
                let previousVw : UIView? = self.largeSubView.viewWithTag(200 + k)
                if let prevVw = previousVw {
                    let distanceToPrevious = vw.center.y - prevVw.center.y
                    //this is a negative-y position:
                    let verticalLine = UILabel(frame: CGRect(x: matchWidth - 1, y: matchHeight / 2 - distanceToPrevious, width: 1, height: distanceToPrevious))
                    verticalLine.backgroundColor = UIColor.blackColor()
                    
                    let horizontalLineWidth = horizontalSpacing + 1
                    let horizontalLine = UILabel(frame: CGRect(x: 0, y: verticalLine.frame.size.height / 2, width: horizontalLineWidth, height: 1))
                    horizontalLine.backgroundColor = UIColor.blackColor()
                    verticalLine.addSubview(horizontalLine)
                    
                    vw.addSubview(verticalLine)
                }
            }
            self.largeSubView.addSubview(vw)
            currentY += matchHeight + verticalSpacing
            
            if i == endIdx {
                currentY = highestViewInRound.frame.origin.y + (matchHeight + verticalSpacing) / 2
                roundNum += 1
                startIdx = endIdx
                endIdx -= k / (MathHelper.powerOf(2, power: (roundNum + 1) / 2 + 1))
            }
            i -= 1 //check what i and endIdx are, when i = 1.
        }
        
    }
    
    func isAdditionalMatchNecessary() -> Bool {
        let match1 = self.bracketMatches[1]
        if AlgorithmUtil.winnerOfMatch(match1) == match1.rightId {
            return true //TODO: make sure never reaches nil == nil
        }
        return false
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
            let matchIdx = (textField.superview?.tag)! - 200
            let matchId = self.bracketMatches[matchIdx].id!.integerValue
            let updatedMatch = CoreDataUtil.updateMatchScore(textScore, matchId: matchId, entrantPos: textField.tag - 100, tournament: self.tournament)
            DataAnalytics.sharedInstance.trackEventInTournament(self.tournament, event: GlobalConstants.matchUpdated, matchType: GlobalConstants.knockoutMatch)
            //check if updatedMatch has a winner.
            let winnerId = AlgorithmUtil.winnerOfMatch(updatedMatch!)
            self.updateLaterMatchWithWinner(winnerId, idxOfPrevMatch: matchIdx)
            if matchIdx >= k {
                //losers from winner's bracket must be added to losers bracket.
                let loserId = AlgorithmUtil.loserOfMatch(updatedMatch!)
                self.updateMatchWithLoser(loserId, idxOfPrevMatch: matchIdx)
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
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { _ in
        })
        alert.addAction(noAction)
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { _ in
            self.startBracket()
            DataAnalytics.sharedInstance.trackEvent(GlobalConstants.buttonPressed, properties: [GlobalConstants.buttonName: GlobalConstants.startBracket])
        })
        alert.addAction(yesAction)
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func startBracket() {
        //start the tournament
        CoreDataUtil.setBracket(self.tournament.bracket!, isStarted: true)
        //check for byes, and advance the opponents.
        for matchIdx in (self.bracketMatches.count - 1).stride(through: 0, by: -1) {
            let eachMatch = self.bracketMatches[matchIdx]
            let winnerId = AlgorithmUtil.winnerOfMatch(eachMatch)
            let loserId = AlgorithmUtil.loserOfMatch(eachMatch)
            self.updateLaterMatchWithWinner(winnerId, idxOfPrevMatch: matchIdx)
            self.updateMatchWithLoser(loserId, idxOfPrevMatch: matchIdx)
        }
        self.reloadStackViewBracket()
        self.displayBracketStarted()
    }
    
    func displayBracketStarted() {
        self.lblTitle.text = GlobalConstants.bracketStageStarted
        self.btnBeginOrEnd.hidden = true
    }
    
    func clearMatch(idx: Int) {
        let match = self.bracketMatches[idx]
        CoreDataUtil.updateEntrantsInMatch(match, leftId: nil, rightId: nil)
    }
    
    func updateLaterMatchWithWinner(winnerId: String?, idxOfPrevMatch: Int) {
        if winnerId == nil {
            return
        }
        else if idxOfPrevMatch <= 1 {
            return
        }
        else if idxOfPrevMatch == k {
            var nextMatch = self.bracketMatches[1]
            if winnerId == GlobalConstants.tie {
                CoreDataUtil.clearMatch(self.bracketMatches[1], clearLeft: true, clearRight: false)
                CoreDataUtil.clearMatch(self.bracketMatches[0], clearLeft: true, clearRight: false)
                return
            }
            CoreDataUtil.updateEntrantsInMatch(self.bracketMatches[1], leftId: "\(winnerId!)", rightId: nextMatch.rightId)
            //because match 0 and 1 would feature same entrants:
            nextMatch = self.bracketMatches[0]
            CoreDataUtil.updateEntrantsInMatch(self.bracketMatches[0], leftId: "\(winnerId!)", rightId: nextMatch.rightId)
        }
        else if idxOfPrevMatch == 2 {
            if winnerId == GlobalConstants.tie {
                CoreDataUtil.clearMatch(self.bracketMatches[1], clearLeft: true, clearRight: false)
                CoreDataUtil.clearMatch(self.bracketMatches[0], clearLeft: true, clearRight: false)
                return
            }
            var nextMatch = self.bracketMatches[1]
            CoreDataUtil.updateEntrantsInMatch(self.bracketMatches[1], leftId: nextMatch.leftId, rightId: "\(winnerId!)")
            nextMatch = self.bracketMatches[0]
            CoreDataUtil.updateEntrantsInMatch(self.bracketMatches[0], leftId: nextMatch.leftId, rightId: "\(winnerId!)")
        }
        else if idxOfPrevMatch >= k {
            let nextId = (idxOfPrevMatch - k + 1) / 2 - 1 + k //(n - k) / 2 - 1 + k = a
            let nextMatch = self.bracketMatches[nextId]
            print("\(idxOfPrevMatch) will update \(nextId)")
            //remember, matchId is the correct variable here.
            if idxOfPrevMatch % 2 == 0 {
                //it is the top match. update leftId
                CoreDataUtil.updateEntrantsInMatch(nextMatch, leftId: "\(winnerId!)", rightId: nextMatch.rightId)
            }
            else {
                //it is the bottom match. update rightId
                CoreDataUtil.updateEntrantsInMatch(nextMatch, leftId: nextMatch.leftId, rightId: "\(winnerId!)")
            }
        }
        else if idxOfPrevMatch < k {
            
            let (roundNum, nextId) = DoubleEliminationCalculator.loserGetNext(k, i: idxOfPrevMatch)
            let nextMatch = self.bracketMatches[nextId]
            if roundNum % 2 == 0 {
                if idxOfPrevMatch % 2 == 1 {
                    CoreDataUtil.updateEntrantsInMatch(nextMatch, leftId: "\(winnerId!)", rightId: nextMatch.rightId)
                }
                else {
                    CoreDataUtil.updateEntrantsInMatch(nextMatch, leftId: nextMatch.leftId, rightId: "\(winnerId!)")
                }
            }
            else {
                CoreDataUtil.updateEntrantsInMatch(nextMatch, leftId: nextMatch.leftId, rightId: "\(winnerId!)")
            }
        }
    }
    
    func updateMatchWithLoser(loserId: String?, idxOfPrevMatch: Int) {
        //even if it's a bye:
        if loserId != nil && idxOfPrevMatch >= k {
            var nextId : Int?
            var isLeft = true
            (nextId, isLeft) = DoubleEliminationCalculator.getLoserMatchId(k, idxOfPrevMatch: idxOfPrevMatch)
            //figure out what round the loss was from.
            //also figure out whether belong top or bottom.
            if nextId == nil {
                return
            }
            let loserMatch = self.bracketMatches[nextId!]
            if isLeft == true {
                CoreDataUtil.updateEntrantsInMatch(loserMatch, leftId: "\(loserId!)", rightId: loserMatch.rightId)
                //check if this next match has an opponent bye
                if let laterWinner = AlgorithmUtil.winnerOfMatch(loserMatch) {
                    self.updateLaterMatchWithWinner("\(laterWinner)", idxOfPrevMatch: nextId!)
                }
            }
            else {
                CoreDataUtil.updateEntrantsInMatch(loserMatch, leftId: loserMatch.leftId, rightId: "\(loserId!)")
                //check if this next match has an opponent bye
                if let laterWinner = AlgorithmUtil.winnerOfMatch(loserMatch) {
                    self.updateLaterMatchWithWinner("\(laterWinner)", idxOfPrevMatch: nextId!)
                }
            }
            print("loser \(idxOfPrevMatch) will update \(nextId) isLeft: \(isLeft)")
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
        if self.originalFrame != nil {
            self.view.frame = self.originalFrame
            self.scrollViewDistanceContraint.constant = 0
        }
    }
    
    func addKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BracketViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BracketViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
}
