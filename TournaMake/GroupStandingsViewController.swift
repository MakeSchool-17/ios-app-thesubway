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
        //compare array
        let tiebreakArr = [TieBreakerType.Points, TieBreakerType.HeadToHead]
        var twoDimensionalArr = [entrantRecords]
        for var i = 0; i < tiebreakArr.count; i++ {
            var new2DArr : [[EntrantRecord]] = []
            for var j = 0; j < twoDimensionalArr.count; j++ {
                var eachGroup = twoDimensionalArr[j]
                if tiebreakArr[i] == TieBreakerType.HeadToHead {
                    eachGroup = StandingsCalculator.sortHeadToHead(eachGroup)
                }
                else {
                    eachGroup.sortInPlace({$0.compareTo($1, tiebreakerType: tiebreakArr[i]) > 0})
                }
                //next, split arrays by tiebreaking factor, use StandingsCalculator
                new2DArr += StandingsCalculator.splitArr(eachGroup, tiebreakerType: tiebreakArr[i])
            }
            twoDimensionalArr = new2DArr
        }
        for eachArr in twoDimensionalArr {
            print("arr")
            for eachRecord in eachArr {
                eachRecord.printSelf()
            }
        }
        self.standingsArr = twoDimensionalArr
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
