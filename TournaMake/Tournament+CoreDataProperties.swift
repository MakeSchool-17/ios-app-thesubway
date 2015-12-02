//
//  Tournament+CoreDataProperties.swift
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

extension Tournament {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var bracket: Bracket?
    @NSManaged var entrants: NSSet?
    @NSManaged var groupStage: NSSet?
    @NSManaged var matches: NSSet?

}
