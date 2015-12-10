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
        let spacing : CGFloat = 10
        var currentY : CGFloat = 0.0
        //stackViewBracket.spacing = spacing
        //stackViewBracket.alignment = UIStackViewAlignment.Center
        
        let matchHeight : CGFloat = 100
        let matchWidth : CGFloat = 250
        
        //get matches directly from tournament.
        var bracketMatches = tournament.bracket?.matches?.allObjects as! [Match]
        bracketMatches.sortInPlace({$0.id?.integerValue < $1.id?.integerValue})
        
        let numFirstRoundMatches = CGFloat(bracketMatches.count) / 2 //for height
        let numRounds = MathHelper.numRoundsForEntrantCount(bracketMatches.count / 2) //for width
        self.scrollViewBracket.contentSize = CGSizeMake(matchWidth * CGFloat(numRounds), numFirstRoundMatches * (matchHeight + 10))
        
        for var i = 0; i < bracketMatches.count; i++ {
            let eachMatch = bracketMatches[i]
            
            let vw = UIView(frame: CGRect(x: 0, y: currentY, width: matchWidth, height: matchHeight))
            //vw.heightAnchor.constraintEqualToConstant(matchHeight).active = true
            //vw.widthAnchor.constraintEqualToConstant(matchWidth).active = true
            vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            
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
                let verticalLine = UILabel(frame: CGRect(x: matchWidth - 1, y: 0, width: 1, height: matchHeight * 2 + spacing))
                verticalLine.backgroundColor = UIColor.blackColor()
                vw.addSubview(verticalLine)
            }
            //constraint may not be helpful here.
            //what I want is a subview
            self.scrollViewBracket.addSubview(vw)
            currentY += matchHeight + spacing
        }
    }

}
