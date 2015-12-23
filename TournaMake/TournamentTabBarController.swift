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
        self.viewControllers![0].title = "Group Stage"
        self.viewControllers![1].title = "Standings"
        self.viewControllers![2].title = "Bracket"
        if self.tournament.type == GlobalConstants.knockout {
            self.viewControllers?.removeAtIndex(0)
            self.viewControllers?.removeAtIndex(0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
