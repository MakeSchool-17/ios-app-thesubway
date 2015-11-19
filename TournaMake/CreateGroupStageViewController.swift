//
//  CreateGroupStageViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/18/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class CreateGroupStageViewController: UIViewController {

    var tournamentData : TournamentData!
    var groups : [[String]]!
    @IBOutlet var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableViewGroups.dataSource = self
//        self.tableViewGroups.delegate = self
        self.groups = self.calculateNumGroups()
        
        //set up stackView settings:
        stackView.spacing = 10
        stackView.alignment = UIStackViewAlignment.Center
        let headerHeight = CGFloat(25.0)
        
        //set up groupView settings:
        let entrantHeight = 50
        let entrantWidth : CGFloat = 250
        let groupNames = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ123456".characters)
        //add groupViews:
        for var i = 0; i < self.groups.count; i++ {
            let eachGroup = self.groups[i]
            let vw = NSBundle.mainBundle().loadNibNamed("GroupView", owner: nil, options: nil)[0] as! GroupView
            vw.heightAnchor.constraintEqualToConstant(headerHeight + CGFloat(entrantHeight * eachGroup.count)).active = true
            vw.widthAnchor.constraintEqualToConstant(entrantWidth).active = true
            vw.tag = i
            vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            
            //add group letter
            let groupTitle = UILabel(frame: CGRect(x: 0, y: 0, width: entrantWidth, height: headerHeight))
            groupTitle.text = "Group \(groupNames[i])"
            vw.addSubview(groupTitle)
            
            //add group entrants:
            for var j = 0; j < eachGroup.count; j++ {
                let eachEntrant = eachGroup[j]
                let lblY = CGFloat(entrantHeight) * CGFloat(j) + headerHeight
                let lblWidth : CGFloat = 90
                let entrantLabel = UILabel(frame: CGRect(x: 0.0, y: lblY, width: lblWidth, height: CGFloat(entrantHeight)))
                entrantLabel.text = "Entrant \(j+1):"
                vw.addSubview(entrantLabel)
                
                //add textField for current team:
                let textFieldEntrant = UITextField()
                textFieldEntrant.frame = CGRect(x: lblWidth, y: entrantLabel.frame.origin.y, width: entrantWidth - lblWidth, height: entrantLabel.frame.size.height)
                textFieldEntrant.text = eachEntrant
                vw.addSubview(textFieldEntrant)
            }
            self.stackView.addArrangedSubview(vw)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func calculateNumGroups() -> [[String]] {
        //this algorithm works best with 6-16 teams in tournament:
        var numGroups = 0
        var numGroupsOf3 = 0
        
        //take ceiling of entrant count:
        numGroups = Int(CGFloat(self.tournamentData.entrants.count) / 4.0 + 1)
        numGroupsOf3 = (4 - (self.tournamentData.entrants.count % 4)) % 4
        var entrantsCopy = self.tournamentData.entrants
        var finalGroups : [[String]] = []
        for (var i = 0; i < numGroups; i++) {
            //1.create group
            var groupOfEntrants : [String] = []
            //2.add n group members to it randomly
            var n : Int!
            //find n.
            if i < numGroupsOf3 {
                //this is a group of 3
                n = 3
            }
            else {
                n = 4
            }
            for (var j = 0; j < n; j++) {
                //randomly get one entrant
                let randomIdx = Int(arc4random()) % entrantsCopy.count
                groupOfEntrants.append(entrantsCopy[randomIdx])
                entrantsCopy.removeAtIndex(randomIdx)
            }
            finalGroups.append(groupOfEntrants)
        }
        return finalGroups
    }
    @IBAction func submitPressed(sender : AnyObject?) {
        print("submit groups")
    }
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return self.groups.count
//    }
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let currentGroup = self.groups[section]
//        return currentGroup.count
//    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("createGroupSlotCell") as! CreateGroupSlotCell
//        let currentGroup = self.groups[indexPath.section]
//        let currentEntrant = currentGroup[indexPath.row]
//        cell.textLabel?.text = currentEntrant
//        return cell
//    }

}