//
//  DrinkManager.swift
//  H2O
//
//  Created by Robert Kotrutsa on 05.03.26.
//

import Foundation

class DrinkManager {
    
    // MARK: - Singleton
    
    static let shared = DrinkManager()
    private init() { }
    
    // MARK: - Stored properties
    
    var drinkEntrys = [DrinkEntry]()
    var defaultGoal = 2_000
    
    // MARK: - Computed properties
    
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
    
    var lastAdd: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.lastAdd.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.lastAdd.rawValue)
        }
    }
    
    // MARK: - Methods
    
    // MARK: Drink actions
    
    func addDrink(amount: Int, drink: DrinkType) {
        lastAdd = amount
        self.drinkEntrys.insert(DrinkEntry(date: Date(), volume: lastAdd, type: drink), at: 0)
        recalculateCurrentVolume()
        saveHistory()
    }
    
    func undoLast() {
        guard lastAdd != 0,
        !drinkEntrys.isEmpty else {
            return
        }
        drinkEntrys.remove(at: 0)
        recalculateCurrentVolume()
        lastAdd = 0
        saveHistory()
    }
    
    func deleteDrinkEntry(at index: Int) {
        guard drinkEntrys.indices.contains(index) else {
            return
        }
        if index == 0 {
            lastAdd = 0
        }
        drinkEntrys.remove(at: index)
        recalculateCurrentVolume()
        saveHistory()
    }
    
    // MARK: History actions
    
    func saveHistory() {
        let data = try? JSONEncoder().encode(self.drinkEntrys)
        UserDefaults.standard.set(data, forKey: UserDefaultsKeys.drinkEntrys.rawValue)
    }
    
    func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.drinkEntrys.rawValue),
           let decodedData = try? JSONDecoder().decode([DrinkEntry].self, from: data) {
            self.drinkEntrys = decodedData
        }
    }
    
    func updateDrinkEntry(at index: Int, volume: Int, drink: DrinkType) {
        guard drinkEntrys.indices.contains(index) else {
            return
        }
        
        let oldEntry = drinkEntrys[index]
        
        let updatedEntry = DrinkEntry(date: oldEntry.date, volume: volume, type: drink)
        
        drinkEntrys[index] = updatedEntry
        
        if index == 0, Calendar.current.isDateInToday(updatedEntry.date) { lastAdd = updatedEntry.volume
        }
        
        recalculateCurrentVolume()
        saveHistory()
    }
    
    func clearAllHistory() {
        self.lastAdd = 0
        self.drinkEntrys.removeAll()
        recalculateCurrentVolume()
        self.saveHistory()
    }
    
    // MARK: Day actions
    
    func resetDay() {
        self.lastAdd = 0
        drinkEntrys.removeAll {
            Calendar.current.isDateInToday($0.date)
        }
        recalculateCurrentVolume()
        self.saveHistory()
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
    
}
