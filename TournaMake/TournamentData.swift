//
//  TournamentData.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/18/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class TournamentData {
    var entrants : [String]
    var groups : [[String]]!
    var name : String
    
    init(entrants : [String], name : String) {
        self.entrants = entrants
        self.name = name
    }
}
