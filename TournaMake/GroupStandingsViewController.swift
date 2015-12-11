//
//  GroupStandingsViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/2/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class GroupStandingsViewController: UIViewController {

    var tournament : Tournament!
    var groupRecordsArr : [[EntrantRecord]] = []
    var thirdPlaceArr : [EntrantRecord] = []
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var stackViewStandings: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
        (self.groupRecordsArr, self.thirdPlaceArr) = StandingsCalculator.getStandingsFromTournament(self.tournament)
        self.reloadStackView()
        self.lblTitle.text = "Standings (based on current match results):"
    }
    
    func reloadStackView() {
        for var i = 0; i < self.stackViewStandings.arrangedSubviews.count; i++ {
            let eachSubview = self.stackViewStandings.arrangedSubviews[i]
            eachSubview.removeFromSuperview()
            self.stackViewStandings.removeArrangedSubview(eachSubview)
            i--
        }
        for var i = 0; i < self.groupRecordsArr.count; i++ {
            let eachGroupRecord = self.groupRecordsArr[i]
            let lblGroup = UILabel()
            lblGroup.numberOfLines = 0
            lblGroup.text = "\nGroup \(GlobalConstants.groupNames[i])"
            self.stackViewStandings.addArrangedSubview(lblGroup)
            for eachRecord in eachGroupRecord {
                let lbl = UILabel()
                lbl.text = "\(eachRecord.printSelf())"
                self.stackViewStandings.addArrangedSubview(lbl)
            }
        }
        let lblThirdPlace = UILabel()
        lblThirdPlace.text = "\nRanking of Third-Place Teams"
        self.stackViewStandings.addArrangedSubview(lblThirdPlace)
        for var i = 0; i < self.thirdPlaceArr.count; i++ {
            let eachRecord = self.thirdPlaceArr[i]
            let lbl = UILabel()
            lbl.text = "\(eachRecord.printSelf())"
            self.stackViewStandings.addArrangedSubview(lbl)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
