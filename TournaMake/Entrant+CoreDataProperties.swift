//
//  Entrant+CoreDataProperties.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/2/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Entrant {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var tournamentId: NSNumber?
    @NSManaged var group: Group?
    @NSManaged var matches: NSSet?
    @NSManaged var tournament: Tournament?

}
