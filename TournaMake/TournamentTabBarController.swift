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
