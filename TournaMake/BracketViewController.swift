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
    @IBOutlet var stackViewBracket: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
//        let entrantRecords = StandingsCalculator.getStandingsFromTournament(self.tournament)
        BracketCalculator.getMatchupsFromBracket(self.tournament)
        self.reloadStackViewBracket()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadStackViewBracket() {
        for var i = 0; i < self.stackViewBracket.arrangedSubviews.count; i++ {
            let eachSubview = self.stackViewBracket.arrangedSubviews[i]
            eachSubview.removeFromSuperview()
            self.stackViewBracket.removeArrangedSubview(eachSubview)
            i--
        }
    }

}
