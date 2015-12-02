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
    
    //assumes group stage + knockout format:
    class func addTournament(data: TournamentData) -> Tournament! {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let newTournament : Tournament = NSEntityDescription.insertNewObjectForEntityForName("Tournament", inManagedObjectContext: context) as! Tournament
        let tournaments = self.getTournaments()
        var tournamentId = tournaments.count
        var existingTournament : [Tournament]!
        repeat {
            existingTournament = CoreDataUtil.searchTournament("id", value: "\(tournamentId)")
            //repetition of same condition:
            if existingTournament.count != 0 {
                tournamentId++
            }
        } while existingTournament.count != 0
        newTournament.id = tournamentId //"-\(tournamentId)"
        newTournament.name = data.name
        //create dictionary for entrant id's:
        let entrantDict = NSMutableDictionary()
        var id = 0
        var matchId = 0
        for eachGroup in data.groups {
            //add group to core data:
            let coreDataGroup = self.addGroup(newTournament)
            for eachEntrant in eachGroup {
                entrantDict.setValue(id, forKey: eachEntrant)
                //save all entrant to core data:
                let newEntrant = self.addEntrantToTournament(newTournament, name: eachEntrant, id: id)
                self.addEntrantExistingToGroup(newEntrant!, group: coreDataGroup!)
                id++
            }
            //create round robin within each group, and associate using player id's:
            let eachIdGroup = self.entrantNamesToIds(eachGroup, tournament: newTournament)
            let roundRobin = GroupCalculator.getRoundRobinSchedule(eachIdGroup)
            for var j = 0; j < roundRobin.count; j++ {
                let eachMatch = roundRobin[j]
                //create a core data match, save its 2 players' id's.
                self.addMatch(id: matchId, leftId: eachMatch[0], rightId: eachMatch[1], group: coreDataGroup!)
                //my template has it set so that
                matchId++
            }
        }
        self.addBracket(newTournament, data: data)
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
    
    class func addGroup(tournament: Tournament) -> Group? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let newGroup : Group = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: context) as! Group
        newGroup.tournament = tournament
        newGroup.tournamentId = tournament.id
        do {
            try context.save()
        } catch {
            print("could not save")
            return nil
        }
        return newGroup
    }
    
    class func getGroups(tournament: Tournament) -> [Group]? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Group")
        request.predicate = NSPredicate(format: "tournamentId = \(tournament.id!)")
        var results : [Group]?
        do {
            results = try context.executeFetchRequest(request) as? [Group]
        }
        catch {
            print("could not fetch")
            return nil
        }
        return results
    }
    
    class func addBracket(tournament: Tournament, data: TournamentData) -> Bracket? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let newBracket : Bracket = NSEntityDescription.insertNewObjectForEntityForName("Bracket", inManagedObjectContext: context) as! Bracket
        newBracket.tournament = tournament
        newBracket.tournamentId = tournament.id
        newBracket.reseed = NSNumber(bool: false)
        for var i = 0; i < data.bracketSlots.count; i += 2 {
            let slotTeams = [data.bracketSlots[i], data.bracketSlots[i + 1]]
            self.addSlotToBracket(newBracket, slotTeams: slotTeams, idx: i / 2)
        }
        do {
            try context.save()
        } catch {
            print("could not save")
            return nil
        }
        return newBracket
    }
    
    class func addSlotToBracket(bracket: Bracket, slotTeams: [String], idx: Int) -> BracketSlot! {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let newSlot : BracketSlot = NSEntityDescription.insertNewObjectForEntityForName("BracketSlot", inManagedObjectContext: context) as! BracketSlot
        newSlot.seedLeft = slotTeams[0]
        newSlot.seedRight = slotTeams[1]
        newSlot.bracket = bracket
        newSlot.tournamentId = bracket.tournamentId
        newSlot.slotNum = idx
        do {
            try context.save()
        } catch {
            print("could not save")
            return nil
        }
        return newSlot
    }
    
    class func addEntrantToTournament(tournament: Tournament, name: String, id: Int) -> Entrant? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let newEntrant : Entrant = NSEntityDescription.insertNewObjectForEntityForName("Entrant", inManagedObjectContext: context) as! Entrant
        newEntrant.id = id
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
    
    class func addEntrantExistingToGroup(entrant: Entrant, group : Group) {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Entrant")
        let myFormat = "id = \(entrant.id!) AND tournamentId = \(entrant.tournamentId!)"
        request.predicate = NSPredicate(format: myFormat)
        var results : [Entrant]?
        do {
            results = try context.executeFetchRequest(request) as? [Entrant]
        }
        catch {
            print("could not fetch")
            return
        }
        let entrantUpdate = results![0]
        entrantUpdate.group = group
        do {
            try context.save()
        } catch {
            print("could not save")
            return
        }
    }
    
    class func getEntrantById(id : Int, tournament: Tournament) -> [Entrant]? {
        return self.getEntrant(key: "id", value: "\(id)", tournament: tournament)
    }
    
    class func getEntrantByName(name : String, tournament: Tournament) -> [Entrant]? {
        return self.getEntrant(key: "name", value: name, tournament: tournament)
    }
    
    private class func getEntrant(key key : String, value: String, tournament: Tournament) -> [Entrant]? {
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
            newNames.append("\(entrant!.id!)")
        }
        return newNames
    }
    
    class func addMatch(id matchId: Int, leftId : String, rightId : String, group : Group) -> Match? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let match : Match = NSEntityDescription.insertNewObjectForEntityForName("Match", inManagedObjectContext: context) as! Match
        match.id = matchId
        match.leftId = leftId
        match.rightId = rightId
        match.leftScore = nil
        match.rightScore = nil
        match.isFinished = NSNumber(bool: false)
        match.group = group
        match.tournament = group.tournament
        match.tournamentId = group.tournament!.id
        do {
            try context.save()
        }
        catch {
            print("Could not save")
            return nil
        }
        return match
    }
    
    class func getMatchesForTournament(tournament : Tournament) -> [Match]? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Match")
        request.predicate = NSPredicate(format: "tournamentId = \(tournament.id!)")
        var results : [Match]?
        do {
            results = try context.executeFetchRequest(request) as? [Match]
        }
        catch {
            print("could not fetch")
            return nil
        }
        return results
    }
}
