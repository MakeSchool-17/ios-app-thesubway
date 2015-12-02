//
//  GroupStageViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/2/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class GroupStageViewController: UIViewController {

    @IBOutlet var matchStackView: UIStackView!
    var tournament : Tournament!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tournament = (self.tabBarController as! TournamentTabBarController).tournament
        self.reloadStackView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadStackView() {
        var allGroups = self.tournament.groupStage?.allObjects as! [Group]
//        allGroups.sort({ $0.id})
        print(allGroups)
    }

}
