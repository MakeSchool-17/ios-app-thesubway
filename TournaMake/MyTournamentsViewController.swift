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
    var tournaments : [Tournament] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewTournaments.delegate = self
        self.tableViewTournaments.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tournaments = CoreDataUtil.getTournaments()
        self.tableViewTournaments.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addPressed(sender: AnyObject) {
        let createTournamentVc = self.storyboard?.instantiateViewControllerWithIdentifier("createtournament") as! CreateTournamentViewController
        self.navigationController?.pushViewController(createTournamentVc, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //push to tab bar controller here.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tournaments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tournamentCell")! as UITableViewCell
        let tournament = self.tournaments[indexPath.row]
        cell.textLabel?.text = tournament.name!
        return cell
    }

}
