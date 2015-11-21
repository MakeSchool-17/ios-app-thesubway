//
//  GroupCalculator.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/20/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class GroupCalculator {
    class func getGroupsOf4Or3(entrants : [String]) -> [[String]] {
        var finalGroups : [[String]] = []
        //this algorithm works best with 6-32, or 61-64 teams in tournament:
        var numGroups = 0
        var numGroupsOf3 = 0
        
        //take ceiling of entrant count:
        numGroups = Int(ceil(Float(entrants.count) / 4.0))
        numGroupsOf3 = (4 - (entrants.count % 4)) % 4
        let numGroupsOf4 = numGroups - numGroupsOf3
        var entrantsNotEntered = entrants
        for (var i = 0; i < numGroups; i++) {
            //1.create group
            var groupOfEntrants : [String] = []
            //2.add n group members to it randomly
            var n : Int!
            //find n.
            if i < numGroupsOf4 {
                //this is a group of 3
                n = 4
            }
            else {
                n = 3
            }
            for (var j = 0; j < n; j++) {
                //randomly get one entrant
                let randomIdx = Int(arc4random()) % entrantsNotEntered.count
                groupOfEntrants.append(entrantsNotEntered[randomIdx])
                entrantsNotEntered.removeAtIndex(randomIdx)
            }
            finalGroups.append(groupOfEntrants)
        }
        return finalGroups
    }
}
