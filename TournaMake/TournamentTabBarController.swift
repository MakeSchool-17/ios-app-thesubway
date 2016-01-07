//
//  TournamentTabBarController.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/2/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class TournamentTabBarController: UITabBarController {

    var tournament : Tournament!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UITabBar.appearance().tintColor = GlobalConstants.tealVitaminC
        self.viewControllers![0].tabBarItem = UITabBarItem(title: "Group Stage", image: UIImage(named: "groupStage"), tag: 0)
        self.viewControllers![1].tabBarItem = UITabBarItem(title: "Standings", image: UIImage(named: "standings"), tag: 0)
        self.viewControllers![2].tabBarItem = UITabBarItem(title: "Bracket", image: UIImage(named: "bracket"), tag: 0)
        if self.tournament.type == GlobalConstants.knockout {
            self.viewControllers?.removeAtIndex(0)
            self.viewControllers?.removeAtIndex(0)
            self.tabBar.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
