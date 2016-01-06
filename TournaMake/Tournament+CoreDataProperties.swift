//
//  Tournament+CoreDataProperties.swift
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

extension Tournament {

    @NSManaged var date: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var ownerUsername: String?
    @NSManaged var type: String?
    @NSManaged var state: String?
    @NSManaged var about: String?
    @NSManaged var bracket: Bracket?
    @NSManaged var entrants: NSSet?
    @NSManaged var groupStage: NSSet?
    @NSManaged var matches: NSSet?

}
