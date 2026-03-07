//
//  DrinkManager.swift
//  H2O
//
//  Created by Robert Kotrutsa on 05.03.26.
//

import Foundation

class DrinkManager {
    static let shared = DrinkManager()
    private init() { }
    
    var drinkEntrys = [DrinkEntry]()
    var defaultGoal = 2_000
    var currentGoal: Int {
        let goal = UserDefaults.standard.integer(forKey: UserDefaultsKeys.goal.rawValue)
        guard goal > 0 else {
            UserDefaults.standard.set(defaultGoal, forKey: UserDefaultsKeys.goal.rawValue)
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.goal.rawValue)
        }
        return goal
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
    
    func addDrink(_ amount: Int) {
        lastAdd = amount
        currentVolume += lastAdd
    
        self.drinkEntrys.insert(DrinkEntry(date: Date(), volume: lastAdd, type: .water), at: 0)
        
        saveHistory()
    }
    
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
    
    func resetDay() {
        self.currentVolume = 0
        self.lastAdd = 0
        // FIXME: Reset only the current day
        self.drinkEntrys.removeAll()
        self.saveHistory()
    }
    
    func undoLast() {
        guard self.currentVolume >= self.lastAdd else {
            self.currentVolume = 0
            self.lastAdd = 0
            return
        }
        self.currentVolume -= self.lastAdd
        self.lastAdd = 0
        if !drinkEntrys.isEmpty {
            self.drinkEntrys.remove(at: 0)
        }
        self.saveHistory()
    }
    
    func checkDate() {
        let lastOpenDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastOpenDate.rawValue) as? Date ?? Date()
        guard Calendar.current.isDateInToday(lastOpenDate) else {
            self.currentVolume = 0
            UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastOpenDate.rawValue)
            return
        }
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastOpenDate.rawValue)
    }
}
