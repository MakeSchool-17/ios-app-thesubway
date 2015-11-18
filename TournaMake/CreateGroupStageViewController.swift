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
    func calculateNumGroups() -> Int {
        if self.tournamentData.entrants.count <= 5 {
            return 1
        }
        return self.tournamentData.entrants.count % 4
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
