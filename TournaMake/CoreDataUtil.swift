//
//  CoreDataUtil.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/24/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit
import CoreData

class CoreDataUtil {
    
    class func addTournament(data: TournamentData) -> Tournament! {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let newTournament : Tournament = NSEntityDescription.insertNewObjectForEntityForName("Tournament", inManagedObjectContext: context) as! Tournament
        let tournaments = self.getTournaments()
        var tournamentId = tournaments.count
        var existingTournament : [Tournament]!
        repeat {
            existingTournament = CoreDataUtil.searchTournament("id", value: "-\(tournamentId)")
            //repetition of same condition:
            if existingTournament.count != 0 {
                tournamentId++
            }
        } while existingTournament.count != 0
        newTournament.id = "-\(tournamentId)"
        newTournament.name = data.name
        //create dictionary for entrant id's:
        let entrantDict = NSMutableDictionary()
        var id = 0
        for eachGroup in data.groups {
            for eachEntrant in eachGroup {
                entrantDict.setValue(id, forKey: eachEntrant)
                //save all entrant to core data:
                self.addEntrant(eachEntrant, id: id, tournament: newTournament)
                id++
            }
            //create round robin within each group, and associate using player id's:
            let eachIdGroup = self.entrantNamesToIds(eachGroup, tournament: newTournament)
            let roundRobin = GroupCalculator.getRoundRobinSchedule(eachIdGroup)
            for var j = 0; j < roundRobin.count; j++ {
                let eachMatch = roundRobin[j]
                //create a core data match, save its 2 players' id's.
                
            }
            print(roundRobin)
        }
        do {
            try context.save()
        } catch {
            print("could not save")
            return nil
        }
        return newTournament
        //get existing tournament counts.
    }
    
    class func getTournaments() -> [Tournament]! {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Tournament")
        request.returnsObjectsAsFaults = false
        var results : [Tournament]?
        do {
            results = try context.executeFetchRequest(request) as? [Tournament]
        }
        catch {
            print("could not fetch")
            return nil
        }
        return results
    }
    
    class func searchTournament(key : String, value : String) -> [Tournament]? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Tournament")
        request.predicate = NSPredicate(format: "\(key) = %@", value)
        request.returnsObjectsAsFaults = false
        var results : [Tournament]?
        do {
            results = try context.executeFetchRequest(request) as? [Tournament]
        }
        catch {
            print("could not fetch")
            return nil
        }
        return results
    }
    
    class func addEntrant(name: String, id: Int, tournament: Tournament) -> Entrant? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let newEntrant : Entrant = NSEntityDescription.insertNewObjectForEntityForName("Entrant", inManagedObjectContext: context) as! Entrant
        newEntrant.id = "\(id)"
        newEntrant.name = name
        newEntrant.tournament = tournament
        newEntrant.tournamentId = tournament.id
        do {
            try context.save()
        } catch {
            print("could not save")
            return nil
        }
        return newEntrant
    }
    
    class func getEntrantById(id : Int, tournament: Tournament) -> [Entrant]? {
        return self.getEntrant(key: "id", value: "\(id)", tournament: tournament)
    }
    
    class func getEntrantByName(name : String, tournament: Tournament) -> [Entrant]? {
        return self.getEntrant(key: "name", value: name, tournament: tournament)
    }
    
    class func getEntrant(key key : String, value: String, tournament: Tournament) -> [Entrant]? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Entrant")
        let myFormat = "\(key) LIKE '\(value)' AND tournamentId = \(tournament.id!)"
        request.predicate = NSPredicate(format: myFormat)
        var results : [Entrant]?
        do {
            results = try context.executeFetchRequest(request) as? [Entrant]
        }
        catch {
            print("could not fetch")
            return nil
        }
        return results
    }
    
    class func entrantNamesToIds(names : [String], tournament: Tournament) -> [String] {
        var newNames : [String] = []
        for eachName in names {
            let entrantResults = self.getEntrantByName(eachName, tournament: tournament)
            var entrant : Entrant?
            if entrantResults?.count > 0 {
                entrant = entrantResults![0]
            }
            newNames.append(entrant!.id!)
        }
        return newNames
    }
}
