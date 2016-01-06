//
//  Bracket+CoreDataProperties.swift
//  TournaMake
//
//  Created by Dan Hoang on 1/6/16.
//  Copyright © 2016 Dan Hoang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Bracket {

    @NSManaged var isStarted: NSNumber?
    @NSManaged var reseed: NSNumber?
    @NSManaged var tournamentId: NSNumber?
    @NSManaged var isFinished: NSNumber?
    @NSManaged var matches: NSSet?
    @NSManaged var slots: NSSet?
    @NSManaged var tournament: Tournament?

}
