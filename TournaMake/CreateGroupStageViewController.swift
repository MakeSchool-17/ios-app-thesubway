//
//  CreateGroupStageViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/18/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class CreateGroupStageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tournamentData : TournamentData!
    @IBOutlet var tableViewGroups: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewGroups.dataSource = self
        self.tableViewGroups.delegate = self
        self.calculateNumGroups()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func calculateNumGroups() {
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
        print(finalGroups)
    }
    @IBAction func submitPressed(sender : AnyObject?) {
        print("submit groups")
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("createGroupSlotCell") as! CreateGroupSlotCell
        return cell
    }

}
