//
//  Group+CoreDataProperties.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/1/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Group {

    @NSManaged var tournamentId: String?
    @NSManaged var tournament: Tournament?
    @NSManaged var entrants: NSSet?
    @NSManaged var schedule: NSSet?

}
