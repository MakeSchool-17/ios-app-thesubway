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
                let randomIdx = Int(arc4random_uniform(UInt32(entrantsNotEntered.count)))
                groupOfEntrants.append(entrantsNotEntered[randomIdx])
                entrantsNotEntered.removeAtIndex(randomIdx)
            }
            finalGroups.append(groupOfEntrants)
        }
        return finalGroups
    }
    
    class func getGroupsOf5Or6(entrants : [String]) -> [[String]] {
        //for cases where entrants.count is between 33 and 44 inclusive.
        var finalGroups : [[String]] = []
        var numGroups = 0
        var numGroupsOf5 = 0
        numGroups = Int(ceil(Float(entrants.count) / 6.0))
        numGroupsOf5 = (6 - (entrants.count % 6)) % 6
        let numGroupsOf6 = numGroups - numGroupsOf5
        var entrantsNotEntered = entrants
        for (var i = 0; i < numGroups; i++) {
            //1.create group
            var groupOfEntrants : [String] = []
            //2.add n group members to it randomly
            var n : Int!
            //find n.
            if i < numGroupsOf6 {
                n = 6
            }
            else {
                n = 5
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
    
    class func getnGroups(numGroups : Int, entrants : [String]) -> [[String]] {
        var finalGroups : [[String]] = []
        //this algorithm works best with 49-64 teams in tournament:
        let numGroupsOf4 = entrants.count - numGroups * 3
        var entrantsNotEntered = entrants
        for (var i = 0; i < numGroups; i++) {
            //1.create group
            var groupOfEntrants : [String] = []
            //2.add n group members to it randomly
            var n : Int!
            //find n.
            if i < numGroupsOf4 {
                //this is a group of 4
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
    
    class func getRoundRobinSchedule(var group : [String]) -> [String] {
        var schedule : [String] = []
        if group.count % 2 != 0 {
            group.append(GlobalConstants.bye)
        }
        var numRounds = 0
        while numRounds < group.count - 1 {
            //beginning of array faces last in array
            for var i = 0; i < group.count / 2; i++ {
                schedule.append("\(group[i]) vs. \(group[group.count - i - 1])")
            }
            //rotate everything to the right except first element.
            var newRound = [group[0], group[group.count - 1]]
            for var i = 1; i < group.count - 1; i++ {
                newRound.append(group[i])
            }
            group = newRound
            numRounds++
        }
        return schedule
    }
}
