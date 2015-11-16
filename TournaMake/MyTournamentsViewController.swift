//
//  MyTournamentsViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/14/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class MyTournamentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableViewTournaments: UITableView!
    var tournaments : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tournaments.append("tournament1")
        self.tournaments.append("tournament2")
        self.tableViewTournaments.delegate = self
        self.tableViewTournaments.dataSource = self
        self.tableViewTournaments.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addPressed(sender: AnyObject) {
        print("add")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tournaments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tournamentCell")! as UITableViewCell
        let tournament = self.tournaments[indexPath.row]
        cell.textLabel?.text = tournament
        return cell
    }

}
