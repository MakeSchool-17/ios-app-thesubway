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
    var groupRecordsArr : [[EntrantRecord]] = []
    var thirdPlaceArr : [EntrantRecord] = []
    var standingsArr : [[EntrantRecord]] = []
    @IBOutlet var stackViewStandings: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
        self.groupRecordsArr = []
        self.thirdPlaceArr = []
        self.standingsArr = []
        var groupStage = self.tournament.groupStage?.allObjects as! [Group]
        groupStage.sortInPlace({$0.id?.integerValue < $1.id?.integerValue})
        for eachGroup in groupStage {
            let entrants = eachGroup.entrants?.allObjects as! [Entrant]
            var entrantsInGroup : [EntrantRecord] = []
            for eachEntrant in entrants {
                let eachRecord = StandingsCalculator.getGroupRecordForEntrant(eachEntrant)
                entrantsInGroup.append(eachRecord)
                entrantRecords.append(eachRecord)
            }
            let groupRecord = StandingsCalculator.computeStandings(entrantsInGroup)
            //get third place team from each group
            if groupRecord.count > 2 {
                self.thirdPlaceArr.append(groupRecord[2])
            }
            self.groupRecordsArr.append(groupRecord)
        }
        self.thirdPlaceArr = StandingsCalculator.computeStandings(self.thirdPlaceArr)
        //self.standingsArr = StandingsCalculator.computeStandings(self.entrantRecords)
        self.reloadStackView()
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
