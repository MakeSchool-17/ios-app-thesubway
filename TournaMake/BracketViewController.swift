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
    @IBOutlet var scrollViewBracket: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
//        let entrantRecords = StandingsCalculator.getStandingsFromTournament(self.tournament)
        BracketCalculator.getMatchupsFromBracket(self.tournament)
        //set tournament back again.
        self.tournament = CoreDataUtil.getTournamentById(self.tournament.id!.integerValue)
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
        //vertical spacing will change every new round.
        let verticalSpacing : CGFloat = 10
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
        self.scrollViewBracket.contentSize = CGSizeMake(matchWidth * CGFloat(numRounds), numFirstRoundMatches * (matchHeight + 10))
        
        var roundNum : CGFloat = 1
        var endIdx = bracketMatches.count / 2
        var startIdx = bracketMatches.count
        var highestViewInRound : UIView!
        for var i = startIdx - 1; i >= endIdx; i-- {
            let eachMatch = bracketMatches[i]
            
            let vw = UIView(frame: CGRect(x: (roundNum - 1) * matchWidth, y: currentY, width: matchWidth, height: matchHeight))
            //vw.heightAnchor.constraintEqualToConstant(matchHeight).active = true
            //vw.widthAnchor.constraintEqualToConstant(matchWidth).active = true
            vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            
            if i == (startIdx - 1) {
                highestViewInRound = vw
            }
            
            let idLeft : String? = eachMatch.leftId
            let idRight : String? = eachMatch.rightId
            let ids : [String?] = [idLeft, idRight]
            
            for var j = 0; j < 2; j++ {
                let eachId = ids[j]
                let labelTop = UILabel(frame: CGRect(x: 0, y: CGFloat(j) * matchHeight / 2, width: matchWidth, height: matchHeight / 2))
                if eachId != nil {
                    let eachEntrant = CoreDataUtil.getEntrantById(Int(eachId!)!, tournament: eachMatch.tournament!)![0]
                    labelTop.text = eachEntrant.name!
                }
                vw.addSubview(labelTop)
            }
            //if i is even, add a vertical line that extends to next box.
            if i % 2 == 0 {
                let verticalLine = UILabel(frame: CGRect(x: matchWidth - 1, y: matchHeight / 2, width: 1, height: matchHeight + verticalSpacing))
                verticalLine.backgroundColor = UIColor.blackColor()
                vw.addSubview(verticalLine)
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

}
