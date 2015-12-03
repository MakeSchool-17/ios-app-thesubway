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
    override func viewDidLoad() {
        super.viewDidLoad()
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
        entrantRecords.sortInPlace({$0.compareTo($1) > $1.compareTo($0)})
        for eachRecord in entrantRecords {
            eachRecord.printSelf()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
