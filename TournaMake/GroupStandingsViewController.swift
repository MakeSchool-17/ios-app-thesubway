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
    var entrantRecords : [EntrantRecord] = []
    var standingsArr : [[EntrantRecord]] = []
    @IBOutlet var stackViewStandings: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
        var groupStage = self.tournament.groupStage?.allObjects as! [Group]
        groupStage.sortInPlace({$0.id?.integerValue < $1.id?.integerValue})
        for eachGroup in groupStage {
            var entrants = eachGroup.entrants?.allObjects as! [Entrant]
            entrants.sortInPlace({$0.id?.integerValue < $1.id?.integerValue})
            for eachEntrant in entrants {
                let eachRecord = StandingsCalculator.getGroupRecordForEntrant(eachEntrant)
                entrantRecords.append(eachRecord)
            }
        }
        self.standingsArr = StandingsCalculator.computeStandings(self.entrantRecords)
        self.reloadStackView()
    }
    
    func reloadStackView() {
        for var i = 0; i < self.stackViewStandings.arrangedSubviews.count; i++ {
            let eachSubview = self.stackViewStandings.arrangedSubviews[i]
            eachSubview.removeFromSuperview()
            self.stackViewStandings.removeArrangedSubview(eachSubview)
            i--
        }
        for eachArr in self.standingsArr {
            for eachRecord in eachArr {
                let lbl = UILabel()
                lbl.text = "\(eachRecord.printSelf())"
                self.stackViewStandings.addArrangedSubview(lbl)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
