//
//  Match+CoreDataProperties.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/17/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Match {

    @NSManaged var id: String?
    @NSManaged var leftId: String?
    @NSManaged var rightId: String?
    @NSManaged var leftScore: NSNumber?
    @NSManaged var rightScore: NSNumber?
    @NSManaged var isFinished: NSNumber?
    @NSManaged var tournament: Tournament?
    @NSManaged var entrants: NSSet?

}
