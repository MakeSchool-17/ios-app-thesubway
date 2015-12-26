//
//  GroupStandingsViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/2/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class GroupStandingsViewController: UIViewController, MDSpreadViewDataSource {

    var tournament : Tournament!
    var groupRecordsArr : [[EntrantRecord]] = []
    var thirdPlaceArr : [EntrantRecord] = []
    var spreadV : MDSpreadView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var stackViewStandings: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let distanceFromTop = (self.navigationController?.navigationBar.frame.size.height)! + 20
        self.spreadV = MDSpreadView(frame: CGRect(x: 0, y: distanceFromTop, width: self.view.frame.width, height: self.view.frame.height - (self.tabBarController?.tabBar.frame.size.height)! - distanceFromTop))
        self.view.addSubview(spreadV)
        spreadV.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
        (self.groupRecordsArr, self.thirdPlaceArr) = StandingsCalculator.getStandingsFromTournament(self.tournament)
        self.reloadStackView()
        self.lblTitle.text = "Standings (based on current match results):"
        self.spreadV.reloadData()
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
    
    func numberOfRowSectionsInSpreadView(aSpreadView: MDSpreadView!) -> Int {
        return self.groupRecordsArr.count
    }
    
    func spreadView(aSpreadView: MDSpreadView!, numberOfColumnsInSection section: Int) -> Int {
        if self.groupRecordsArr.count <= 0 {
            return 0
        }
        let inRecordArr = self.groupRecordsArr[section]
        if inRecordArr.count <= 0 {
            return 0
        }
        return inRecordArr[0].ownArray.count
    }
    
    func spreadView(aSpreadView: MDSpreadView!, numberOfRowsInSection section: Int) -> Int {
        return self.groupRecordsArr[section].count + 1
    }
    
    func spreadView(aSpreadView: MDSpreadView!, cellForRowAtIndexPath rowPath: MDIndexPath!, forColumnAtIndexPath columnPath: MDIndexPath!) -> MDSpreadViewCell! {
        //        let cell = aSpreadView.dequeueReusableCellWithIdentifier("Cell") as MDSpreadViewCell
        let cell = MDSpreadViewCell(style: MDSpreadViewCellStyle.Default, reuseIdentifier: "Cell")
        cell?.layer.borderWidth = 1
        let inRecordArr = self.groupRecordsArr[rowPath.section]
        if rowPath.row == 0 {
            cell?.textLabel.text = GlobalConstants.arrHeader[columnPath.column]
        }
        else {
            let eachRecord = inRecordArr[rowPath.row - 1]
            cell?.textLabel.text = eachRecord.ownArray[columnPath.column]
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
