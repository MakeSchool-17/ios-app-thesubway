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
    var compareDict = Dictionary<String, Int>()
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDict:", name: GlobalConstants.headToHeadTiebreak, object: nil)
        self.compareDict = Dictionary<String, Int>()
        entrantRecords.sortInPlace({$0.compareTo($1) > 0})
        for eachRecord in entrantRecords {
            eachRecord.printSelf()
        }
        //now check if any of the compareDict had a result of 2 or more.
        print(self.compareDict)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDict(notification : NSNotification) {
        let info = notification.userInfo! as! [String : [EntrantRecord]]
        let entrants = info[GlobalConstants.entrants]
        for eachEntrant in entrants! {
            if self.compareDict[eachEntrant.entrant.name!] == nil {
                self.compareDict[eachEntrant.entrant.name!] = 1
            }
            else {
                self.compareDict[eachEntrant.entrant.name!]! += 1
            }
        }
    }

}
