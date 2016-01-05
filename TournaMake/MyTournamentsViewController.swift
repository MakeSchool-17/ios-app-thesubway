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
    @IBOutlet var lblTournamentNum: UILabel!
    var tournaments : [Tournament] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewTournaments.delegate = self
        self.tableViewTournaments.dataSource = self
        self.tableViewTournaments.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = GlobalConstants.backgroundColorVc
        
        //to prevent extra tableView padding at top:
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tournaments = CoreDataUtil.getTournaments()
        self.lblTournamentNum.text = "Number of tournaments: \(self.tournaments.count)"
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
        let selectedTournament = self.tournaments[indexPath.row]
        let tournamentTab = self.storyboard?.instantiateViewControllerWithIdentifier("tournamentTabBar") as! TournamentTabBarController
        tournamentTab.tournament = selectedTournament
        self.navigationController?.pushViewController(tournamentTab, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tournaments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tournamentCell")! as! TournamentCell
        let tournament = self.tournaments[indexPath.row]
        cell.backgroundColor = GlobalConstants.yellowVitaminC
        cell.labelName.text = tournament.name!
        cell.labelFormat.text = "Format: \(tournament.type!)"
        cell.labelEntrantNum.text = "# Entrants: \(tournament.entrants!.count)"
        cell.labelCreationDate.text = "Created: \(AlgorithmUtil.dateToStringWithMinutes(tournament.date!))"
        return cell
    }

}
