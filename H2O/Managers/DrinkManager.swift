//
//  DrinkManager.swift
//  H2O
//
//  Created by Robert Kotrutsa on 05.03.26.
//

import Foundation
import CoreData

class DrinkManager {
    
    // MARK: - Singleton
    
    static let shared = DrinkManager()
    private init() { }
    
    // MARK: - Stored properties
    
    var drinkEntrys = [DrinkEntry]()
    var defaultGoal = 2_000
    
    // MARK: - Computed properties
    
    var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }
    
    var currentGoal: Int {
        let goal = UserDefaults.standard.integer(forKey: UserDefaultsKeys.goal.rawValue)
        
        if goal > 0 {
            return goal
        }
        
        UserDefaults.standard.set(defaultGoal, forKey: UserDefaultsKeys.goal.rawValue)
        
        return defaultGoal
    }
    
    var currentVolume: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentVolume.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.currentVolume.rawValue)
        }
    }
    
    var isGoalReached: Bool {
        currentVolume >= currentGoal
    }
    
    var lastAdd: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.lastAdd.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.lastAdd.rawValue)
        }
    }
    
    // MARK: Drink actions
    
    func addDrink(amount: Int, drink: DrinkType) {
        let entry = DrinkEntity(context: context)
        entry.id = UUID()
        entry.date = Date()
        entry.volume = Int32(amount)
        entry.type = drink.rawValue
        
        do {
            try context.save()
            loadHistory()
            recalculateCurrentVolume()
        }
        catch {
            print("Failed to save to Core Data", error)
        }
    }
    
    func undoLast() {
        guard !drinkEntrys.isEmpty else { return }
        let id = drinkEntrys[0].id
        let request = NSFetchRequest<DrinkEntity>(entityName: "DrinkEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let result = try context.fetch(request)
            
            if let entity = result.first {
                context.delete(entity)
                try context.save()
                loadHistory()
                recalculateCurrentVolume()
                lastAdd = 0
            }
        }
        catch {
            print(error)
        }
    }
    
    func deleteDrinkEntry(at index: Int) {
        guard drinkEntrys.indices.contains(index) else { return }
        
        let id = drinkEntrys[index].id
        
        let request = NSFetchRequest<DrinkEntity>(entityName: "DrinkEntity")
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            
            let result = try context.fetch(request)
            
            guard let entity = result.first else { return }
            
                context.delete(entity)
            
                try context.save()
            
                loadHistory()
                recalculateCurrentVolume()
            
                if index == 0 {
                    lastAdd = 0
                }
            
        }
        catch {
            print("Delete error: ", error)
        }
    }
    
    // MARK: History actions
    
    func loadHistory() {
        let request = NSFetchRequest<DrinkEntity>(entityName: "DrinkEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let result = try context.fetch(request)
            self.drinkEntrys = result.compactMap { entity in
                guard let date = entity.date,
                      let id = entity.id,
                      let typeString = entity.type,
                      let type = DrinkType(rawValue: typeString) else {
                    return nil
                }
                return DrinkEntry(date: date, volume: Int(entity.volume), type: type, id: id)
            }
        }
        catch {
            print(error)
        }
    }
    
    func updateDrinkEntry(at index: Int, volume: Int, drink: DrinkType) {
        
        guard drinkEntrys.indices.contains(index) else {
            return
        }
        
        let id = drinkEntrys[index].id
        
        let request = NSFetchRequest<DrinkEntity>(entityName: "DrinkEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let result = try context.fetch(request)
            guard let entity = result.first else { return }
            
            entity.volume = Int32(volume)
            entity.type = drink.rawValue
            
            try context.save()
            if let date = entity.date,
               Calendar.current.isDateInToday(date) {
                recalculateCurrentVolume()
            }
            loadHistory()
        }
        catch {
            print("Update drink entry error: ", error)
        }
    }
    
    func clearAllHistory() {
        let request = NSFetchRequest<DrinkEntity>(entityName: "DrinkEntity")
        do {
            let result = try context.fetch(request)
            for entity in result {
                context.delete(entity)
            }
            try context.save()
        }
        catch {
            print("Clear all history error: ", error)
        }
        loadHistory()
        recalculateCurrentVolume()
        self.lastAdd = 0
    }
    
    // MARK: Day actions
    
    func resetDay() {
        self.lastAdd = 0
        let request = NSFetchRequest<DrinkEntity>(entityName: "DrinkEntity")
    
        do {
            let result = try context.fetch(request)
            for entity in result {
                if let date = entity.date,
                   Calendar.current.isDateInToday(date) {
                    context.delete(entity)
                }
            }
            try context.save()
            loadHistory()
            recalculateCurrentVolume()
        }
        catch {
            print("Reset day error: ", error)
        }
    }
    
    // MARK: Date logick
    
    func checkDate() {
        let lastOpenDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastOpenDate.rawValue) as? Date ?? Date()
        guard Calendar.current.isDateInToday(lastOpenDate) else {
            recalculateCurrentVolume()
            UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastOpenDate.rawValue)
            return
        }
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastOpenDate.rawValue)
    }
    
    func recalculateCurrentVolume() {
        currentVolume = drinkEntrys.filter { drinkEntry in
            Calendar.current.isDateInToday(drinkEntry.date)
        }.reduce(0) { sum, drinkEntry in
            sum + drinkEntry.volume
        }
    }
    
    func entries(for section: Int) -> [DrinkEntry] {
        if section == 0 {
            let todayEntries = DrinkManager.shared.drinkEntrys.filter { Calendar.current.isDateInToday($0.date)
            }
            return todayEntries
        }
        
        if section == 1 {
            let yesterdayEntries = DrinkManager.shared.drinkEntrys.filter {
                Calendar.current.isDateInYesterday($0.date)
            }
            return yesterdayEntries
        }
        
        let earlierEntries = DrinkManager.shared.drinkEntrys.filter { !Calendar.current.isDateInToday($0.date) && !Calendar.current.isDateInYesterday($0.date)
        }
        return earlierEntries
    }
    
}
