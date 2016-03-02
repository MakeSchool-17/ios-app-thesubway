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
        self.getTournamentCount()
        self.tableViewTournaments.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTournamentCount() {
        self.lblTournamentNum.text = "Number of tournaments: \(self.tournaments.count)"
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        let createTournamentVc = self.storyboard?.instantiateViewControllerWithIdentifier("createtournament") as! CreateTournamentViewController
        self.navigationController?.pushViewController(createTournamentVc, animated: true)
    }
    
    func deleteTournamentAtIndexPath(indexPath: NSIndexPath) {
        CoreDataUtil.deleteTournament(self.tournaments[indexPath.row])
        self.tournaments.removeAtIndex(indexPath.row)
        self.tableViewTournaments.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.getTournamentCount()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.deleteTournamentAtIndexPath(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //push to tab bar controller here.
        let selectedTournament = self.tournaments[indexPath.row]
        let tournamentTab = self.storyboard?.instantiateViewControllerWithIdentifier("tournamentTabBar") as! TournamentTabBarController
        tournamentTab.tournament = selectedTournament
        self.navigationController?.pushViewController(tournamentTab, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tournaments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tournamentCell")! as! TournamentCell
        let tournament = self.tournaments[indexPath.row]
        cell.backgroundColor = GlobalConstants.grayVeryLight
        cell.labelName.text = tournament.name!
        cell.labelFormat.text = "Format: \(tournament.type!)"
        var entrantsList = ""
        for var i = 0; i < tournament.entrants!.count; i++ {
            let eachEntrant = tournament.entrants!.allObjects[i]
            if i != 0 {
                entrantsList += ", "
            }
            entrantsList += eachEntrant.name!
        }
        cell.labelEntrantNames.textColor = GlobalConstants.mediumGray
        cell.labelEntrantNum.textColor = GlobalConstants.mediumGray
        cell.labelCreationDate.textColor = GlobalConstants.mediumGray
        cell.labelEntrantNames.text = entrantsList
        cell.labelEntrantNum.text = "\(tournament.entrants!.count) Entrants"
        cell.labelCreationDate.text = tournament.date?.timeAgoSinceDate(NSDate())
        return cell
    }

}
