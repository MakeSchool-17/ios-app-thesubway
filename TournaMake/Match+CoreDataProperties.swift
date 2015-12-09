//
//  Match+CoreDataProperties.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/8/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Match {

    @NSManaged var id: NSNumber?
    @NSManaged var isFinished: NSNumber?
    @NSManaged var leftId: String?
    @NSManaged var leftScore: NSNumber?
    @NSManaged var rightId: String?
    @NSManaged var rightScore: NSNumber?
    @NSManaged var tournamentId: NSNumber?
    @NSManaged var entrants: NSSet?
    @NSManaged var group: Group?
    @NSManaged var tournament: Tournament?
    @NSManaged var bracket: Bracket?

}
