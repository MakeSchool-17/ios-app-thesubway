//
//  BracketViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/8/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class BracketViewController: UIViewController {

    var tournament : Tournament!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollViewBracket: UIScrollView!
    @IBOutlet var btnBeginOrEnd: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        BracketCalculator.getMatchupsFromBracket(self.tournament)
        //set tournament back again.
        self.tournament = CoreDataUtil.getTournamentById(self.tournament.id!.integerValue)
        self.lblTitle.text = "If the bracket stage were to begin now, based on current standings:"
        self.reloadStackViewBracket()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadStackViewBracket() {
        for var i = 0; i < self.scrollViewBracket.subviews.count; i++ {
            let eachSubview = self.scrollViewBracket.subviews[i]
            eachSubview.removeFromSuperview()
            i--
        }
        let verticalSpacing : CGFloat = 10
        let horizontalSpacing : CGFloat = 15
        var currentY : CGFloat = 0.0
        //stackViewBracket.spacing = spacing
        //stackViewBracket.alignment = UIStackViewAlignment.Center
        
        let matchHeight : CGFloat = 100
        let matchWidth : CGFloat = 250
        
        //get matches directly from tournament.
        var bracketMatches = tournament.bracket?.matches?.allObjects as! [Match]
        //sort BACKWARDS, to simplify math calculations.
        bracketMatches.sortInPlace({$0.id?.integerValue > $1.id?.integerValue})
        
        let numFirstRoundMatches = CGFloat(bracketMatches.count) / 2 //for height
        let numRounds = MathHelper.numRoundsForEntrantCount(bracketMatches.count / 2) //for width
        self.scrollViewBracket.contentSize = CGSizeMake((matchWidth + horizontalSpacing) * CGFloat(numRounds), numFirstRoundMatches * (matchHeight + 10))
        if numRounds <= 2 {
            //If there are only 2 rounds, there must be enough space for 3rd-place match underneath championship match.
            self.scrollViewBracket.contentSize.height += verticalSpacing + matchHeight
        }
        
        var roundNum = 1
        var endIdx = bracketMatches.count / 2
        var startIdx = bracketMatches.count
        var highestViewInRound : UIView!
        var championshipFrame : CGRect!
        for var i = startIdx - 1; i >= endIdx; i-- {
            let eachMatch = bracketMatches[i]
            
            let vw = UIView(frame: CGRect(x: CGFloat(roundNum - 1) * (matchWidth + horizontalSpacing), y: currentY, width: matchWidth, height: matchHeight))
            //vw.heightAnchor.constraintEqualToConstant(matchHeight).active = true
            //vw.widthAnchor.constraintEqualToConstant(matchWidth).active = true
            vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            vw.tag = i
            if roundNum != 1 && i >= 1 {
                //so not the first round, and not the third place match.
                //for middle rounds, get the previous round's match, which is i * 2 + 1.
                let previousVwTop : UIView? = self.scrollViewBracket.viewWithTag(i * 2 + 1)
                let previousVwBottom : UIView? = self.scrollViewBracket.viewWithTag(i * 2)
                //this is set to the center of the previous 2 views
                if previousVwTop != nil && previousVwBottom != nil {
                    vw.frame.origin.y = (previousVwTop!.center.y + previousVwBottom!.center.y) / 2 - (matchHeight / 2)
                }
                if i == 1 {
                    championshipFrame = vw.frame
                }
            }
            //third-place match will be index 0, and championship is index 1, for math purposes
            else if i == 0 {
                vw.frame.origin.y = championshipFrame.origin.y + matchHeight + verticalSpacing
            }
            
            if i == (startIdx - 1) {
                highestViewInRound = vw
            }
            
            let idLeft : String? = eachMatch.leftId
            let idRight : String? = eachMatch.rightId
            let ids : [String?] = [idLeft, idRight]
            
            for j in 0...1 {
                let eachId = ids[j]
                let labelTop = UILabel(frame: CGRect(x: 0, y: CGFloat(j) * matchHeight / 2, width: matchWidth, height: matchHeight / 2))
                if eachId != nil {
                    let eachEntrant = CoreDataUtil.getEntrantById(Int(eachId!)!, tournament: eachMatch.tournament!)![0]
                    labelTop.text = eachEntrant.name!
                }
                else if i >= bracketMatches.count / 2 {
                    //else, that means there is no first-round player in that slot.
                    labelTop.text = GlobalConstants.bye
                    //if i is < half, don't add a bye, because later rounds don't have byes.
                }
                labelTop.tag = j
                vw.addSubview(labelTop)
            }
            //if i is even, add a vertical line that extends to previous box.
            if i % 2 == 0 && (roundNum != numRounds) {
                let previousVw : UIView? = self.scrollViewBracket.viewWithTag(i + 1)
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
            self.scrollViewBracket.addSubview(vw)
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
    
    @IBAction func btnPressed(sender: AnyObject) {
        print("start")
    }

}
