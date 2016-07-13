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
    
    class func getAllExisting() {
        self.printEntity("Tournament")
        self.printEntity("Entrant")
        self.printEntity("Group")
        self.printEntity("Match")
        self.printEntity("Bracket")
        self.printEntity("BracketSlot")
    }
    
    private class func printEntity(entityName: String) {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        //var results : [Tournament]?
        do {
            let instances = try context.executeFetchRequest(request)
            print("\(entityName)s: \(instances)")
        }
        catch {
            print("could not fetch")
            return
        }
    }
    
    //assumes group stage + knockout format:
    class func addTournament(data: TournamentData) -> Tournament! {
        DataAnalytics.sharedInstance.trackEvent(GlobalConstants.tournamentCreated, properties: [GlobalConstants.format: data.format, GlobalConstants.numEntrants: data.entrants.count])
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
                tournamentId += 1
            }
        } while existingTournament.count != 0
        newTournament.id = tournamentId //"-\(tournamentId)"
        newTournament.name = data.name
        newTournament.date = NSDate()
        //create dictionary for entrant id's:
        let entrantDict = NSMutableDictionary()
        var id = 0
        var matchId = 0
        if data.format == GlobalConstants.groupStageKnockout {
            newTournament.type = GlobalConstants.groupStageKnockout
            for i in 0 ..< data.groups.count {
                let eachGroup = data.groups[i]
                //add group to core data:
                let coreDataGroup = self.addGroup(newTournament, idx: i)
                for eachEntrant in eachGroup {
                    entrantDict.setValue(id, forKey: eachEntrant)
                    //save all entrant to core data:
                    let newEntrant = self.addEntrantToTournament(newTournament, name: eachEntrant, id: id)
                    self.addEntrantExistingToGroup(newEntrant!, group: coreDataGroup!)
                    id += 1
                }
                //create round robin within each group, and associate using player id's:
                let eachIdGroup = self.entrantNamesToIds(eachGroup, tournament: newTournament)
                let roundRobin = GroupCalculator.getRoundRobinSchedule(eachIdGroup)
                for j in 0 ..< roundRobin.count {
                    let eachMatch = roundRobin[j]
                    //create a core data match, save its 2 players' id's.
                    self.addMatch(id: matchId, leftId: eachMatch[0], rightId: eachMatch[1], group: coreDataGroup!)
                    //my template has it set so that
                    matchId += 1
                }
            }
        }
        else if data.format == GlobalConstants.knockout || data.format == GlobalConstants.doubleElimination {
            newTournament.type = data.format
            for i in 0 ..< data.entrants.count {
                let eachEntrant = data.entrants[i]
                self.addEntrantToTournament(newTournament, name: eachEntrant, id: i)
            }
        }
        self.addBracket(newTournament, data: data)
        //add bracketMatches to tournament, based off Bracket data.
        var numBracketMatches = (newTournament.bracket?.slots?.count)! * 2 //because third-place match is included
        if newTournament.groupStage?.count == 1 {
            numBracketMatches /= 2
        }
        for _ in 0 ..< numBracketMatches {
            self.addMatchToBracket(newTournament.bracket!, matchId: matchId)
            matchId += 1
        }
        do {
            try context.save()
        } catch {
            print("could not save")
            return nil
        }
        if data.format == GlobalConstants.knockout || data.format == GlobalConstants.doubleElimination {
            //this should be done after the save
            BracketCalculator.getMatchupsFromPureBracket(newTournament)
        }
        return newTournament
        //get existing tournament counts.
    }
    
    class func deleteTournament(tournament: Tournament) {
        if let entrants = tournament.entrants, type = tournament.type {
            DataAnalytics.sharedInstance.trackEvent(GlobalConstants.tournamentDeleted, properties: [GlobalConstants.numEntrants: entrants.count, GlobalConstants.format: type])
        }
        else {
            DataAnalytics.sharedInstance.trackEvent(GlobalConstants.tournamentDeleted, properties: [GlobalConstants.numEntrants: 0, GlobalConstants.format: "none"])
        }
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        //delete group-stage group:
        if let gs = tournament.groupStage {
            let groups = gs.allObjects as! [Group]
            for eachGroup in groups {
                context.deleteObject(eachGroup)
            }
        }
        //delete all matches:
        if let matchArr = tournament.matches {
            let matches = matchArr.allObjects as! [Match]
            for eachMatch in matches {
                context.deleteObject(eachMatch)
            }
        }
        //delete all entrants:
        if let entrantArr = tournament.entrants {
            let entrants = entrantArr.allObjects as! [Entrant]
            for eachEntrant in entrants {
                context.deleteObject(eachEntrant)
            }
        }
        //delete all brackets and their slots:
        if let bracket = tournament.bracket {
            if let bracketSlotArr = bracket.slots {
                let slots = bracketSlotArr.allObjects as! [BracketSlot]
                for eachSlot in slots {
                    context.deleteObject(eachSlot)
                }
            }
            context.deleteObject(bracket)
        }
        
        context.deleteObject(tournament)
        do {
            try context.save()
        } catch {
            print("could not save")
            return
        }
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
    
    class func getTournamentById(id: Int) -> Tournament? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Tournament")
        request.predicate = NSPredicate(format: "id = \(id)")
        request.returnsObjectsAsFaults = false
        var results : [Tournament]?
        do {
            results = try context.executeFetchRequest(request) as? [Tournament]
        }
        catch {
            print("could not fetch")
            return nil
        }
        return results![0]
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
    
    class func addGroup(tournament: Tournament, idx : Int) -> Group? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let newGroup : Group = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: context) as! Group
        newGroup.tournament = tournament
        newGroup.tournamentId = tournament.id
        newGroup.id = idx
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
        newBracket.isStarted = NSNumber(bool: false)
        for i in 0.stride(to: data.bracketSlots.count, by: 2) {
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
    
    class func setBracket(bracket: Bracket, isStarted: Bool) -> Bracket? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Bracket")
        request.predicate = NSPredicate(format: "tournamentId = \(bracket.tournamentId!)")
        var results : [Bracket]?
        do {
            results = try context.executeFetchRequest(request) as? [Bracket]
        }
        catch {
            print("could not fetch")
            return nil
        }
        let bracket = results![0]
        bracket.isStarted = NSNumber(bool: isStarted)
        do {
            try context.save()
        } catch {
            print("could not save")
            return nil
        }
        return bracket
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
    
    class func addMatchToBracket(bracket: Bracket, matchId: Int) -> Match? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let match : Match = NSEntityDescription.insertNewObjectForEntityForName("Match", inManagedObjectContext: context) as! Match
        match.id = matchId
        match.leftId = nil
        match.rightId = nil
        match.isFinished = NSNumber(bool: false)
        match.group = nil
        match.bracket = bracket
        match.tournament = bracket.tournament
        match.tournamentId = bracket.tournamentId
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
    
    class func getMatchesForEntrant(entrant: Entrant) -> [Match]? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Match")
        request.predicate = NSPredicate(format: "tournamentId = \(entrant.tournamentId!) AND (leftId = \(entrant.id!) OR rightId = \(entrant.id!))")
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
    
    class func updateMatchScore(matchScore: Float, matchId: Int, entrantPos: Int, tournament: Tournament) -> Match? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Match")
        request.predicate = NSPredicate(format: "id = \(matchId) AND tournamentId = \(tournament.id!)")
        var results : [Match]?
        do {
            results = try context.executeFetchRequest(request) as? [Match]
        }
        catch {
            print("could not fetch")
            return nil
        }
        let match = results![0]
        if entrantPos == 0 {
            match.leftScore = matchScore
        }
        else {
            match.rightScore = matchScore
        }
        if match.leftScore != nil && match.rightScore != nil {
            match.isFinished = true
        }
        do {
            try context.save()
        }
        catch {
            print("Could not save")
            return nil
        }
        return match
    }
    
    class func resetMatchScore(forMatchId matchId: Int, entrantPos: Int, tournament: Tournament) -> Match? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Match")
        request.predicate = NSPredicate(format: "id = \(matchId) AND tournamentId = \(tournament.id!)")
        var results : [Match]?
        do {
            results = try context.executeFetchRequest(request) as? [Match]
        }
        catch {
            print("could not fetch")
            return nil
        }
        let match = results![0]
        if entrantPos == 0 {
            match.leftScore = nil
        }
        else {
            match.rightScore = nil
        }
        match.isFinished = false
        do {
            try context.save()
        }
        catch {
            print("Could not save")
            return nil
        }
        return match
    }
    
    class func updateEntrantsInMatch(inputMatch: Match, leftId: String?, rightId: String?) -> Match? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Match")
        request.predicate = NSPredicate(format: "id = \(inputMatch.id!) AND tournamentId = \(inputMatch.tournament!.id!)")
        var results : [Match]?
        do {
            results = try context.executeFetchRequest(request) as? [Match]
        }
        catch {
            print("could not fetch")
            return nil
        }
        let match = results![0]
        if leftId != nil {
            match.leftId = "\(leftId!)"
        }
        else {
            match.leftId = nil
        }
        if rightId != nil {
            match.rightId = "\(rightId!)"
        }
        else {
            match.rightId = nil
        }
        do {
            try context.save()
        }
        catch {
            print("Could not save")
            return nil
        }
        return match
    }
}
