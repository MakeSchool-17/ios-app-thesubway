//
//  TournamentNavigationController.swift
//  TournaMake
//
//  Created by Dan Hoang on 1/4/16.
//  Copyright © 2016 Dan Hoang. All rights reserved.
//

import UIKit

class TournamentNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //For all nav, use: UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        self.navigationBar.barTintColor = GlobalConstants.tealVitaminC
        self.navigationBar.tintColor = UIColor.whiteColor()
        
        //from stack overflow, to change UINavigationBar Text color:
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
