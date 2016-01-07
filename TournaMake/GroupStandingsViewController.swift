//
//  GroupStandingsViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/2/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class GroupStandingsViewController: UIViewController, MDSpreadViewDataSource, MDSpreadViewDelegate {

    var tournament : Tournament!
    var groupRecordsArr : [[EntrantRecord]] = []
    var thirdPlaceArr : [EntrantRecord] = []
    var spreadV : MDSpreadView!
    @IBOutlet var viewTitle: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblCaption: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = GlobalConstants.backgroundColorVc
        let distanceFromTop = (self.navigationController?.navigationBar.frame.size.height)! + 20 + self.viewTitle.frame.size.height
        self.spreadV = MDSpreadView(frame: CGRect(x: 0, y: distanceFromTop, width: self.view.frame.width, height: self.view.frame.height - (self.tabBarController?.tabBar.frame.size.height)! - distanceFromTop))
        self.spreadV.backgroundColor = UIColor.clearColor()
        self.view.addSubview(spreadV)
        spreadV.dataSource = self
        spreadV.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
        (self.groupRecordsArr, self.thirdPlaceArr) = StandingsCalculator.getStandingsFromTournament(self.tournament)
        var standingsText  = ""
        if self.tournament.bracket?.isStarted == true {
            standingsText = "Final Standings:"
            self.lblCaption.hidden = true
        }
        else {
            standingsText = "Standings:"
            self.lblCaption.text = "(based on current match results):"
            self.lblCaption.hidden = false
        }
        self.lblTitle.text = standingsText
        self.spreadV.reloadData()
    }
    
    func numberOfRowSectionsInSpreadView(aSpreadView: MDSpreadView!) -> Int {
        //add one, for third-place rankings
        if self.groupRecordsArr.count == 0 {
            //prevent it from returning (0 + 1).
            return 0
        }
        return self.groupRecordsArr.count + 1
    }
    
    func spreadView(aSpreadView: MDSpreadView!, cellForHeaderInRowSection section: Int, forColumnAtIndexPath columnPath: MDIndexPath!) -> MDSpreadViewCell! {
        let cell = MDSpreadViewCell(style: MDSpreadViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel.font = UIFont(name: (cell.textLabel?.font?.fontName)!, size: 12.0)
        //even if the column is not 0, color it anyway:
        cell.backgroundColor = GlobalConstants.grayVeryLight
        //but if it is 0, do more:
        if columnPath.column == 0 {
            //cell?.layer.borderWidth = 0.5
            if section < self.groupRecordsArr.count {
                cell.textLabel.text = "Group \(GlobalConstants.groupNames[section])"
            }
            else {
                cell.textLabel.text = "Rank 3rd-Place Teams"
            }
        }
        return cell
    }
    
    func spreadView(aSpreadView: MDSpreadView!, widthForColumnAtIndexPath indexPath: MDIndexPath!) -> CGFloat {
        if indexPath.column == 0 {
            return 190.0 //minimum for "Rank 3rd-Place Teams" to fit
        }
        return 100.0
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
        //add 1, because the win-loss row is not a header.
        if section < self.groupRecordsArr.count {
            return self.groupRecordsArr[section].count + 1
        }
        return self.thirdPlaceArr.count + 1
    }
    
    func spreadView(aSpreadView: MDSpreadView!, cellForRowAtIndexPath rowPath: MDIndexPath!, forColumnAtIndexPath columnPath: MDIndexPath!) -> MDSpreadViewCell! {
        //        let cell = aSpreadView.dequeueReusableCellWithIdentifier("Cell") as MDSpreadViewCell
        let cell = MDSpreadViewCell(style: MDSpreadViewCellStyle.Default, reuseIdentifier: "Cell")
        //cell.backgroundColor = GlobalConstants.yellowVitaminC
        //default font size is 16
        cell.textLabel.font = UIFont(name: (cell.textLabel?.font?.fontName)!, size: 18.0)
        if rowPath.row == 0 {
            cell?.backgroundColor = GlobalConstants.grayVeryLight
            cell?.textLabel.text = GlobalConstants.arrHeader[columnPath.column]
            cell.textLabel.font = UIFont(name: (cell.textLabel?.font?.fontName)!, size: 12.0)
        }
        //note that thirdPlaceArr.count == self.groupRecordsArr.count
        else if rowPath.section < self.thirdPlaceArr.count {
            let inRecordArr = self.groupRecordsArr[rowPath.section]
            let eachRecord = inRecordArr[rowPath.row - 1]
            cell?.textLabel.text = eachRecord.ownArray[columnPath.column]
        }
        else {
            let eachRecord = self.thirdPlaceArr[rowPath.row - 1]
            cell?.textLabel.text = eachRecord.ownArray[columnPath.column]
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
