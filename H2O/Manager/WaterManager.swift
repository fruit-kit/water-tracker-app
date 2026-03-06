//
//  WaterManager.swift
//  H2O
//
//  Created by Robert Kotrutsa on 05.03.26.
//

import Foundation

class WaterManager {
    static let shared = WaterManager()
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
    
    func addWater(_ amount: Int) {
        lastAdd = amount
        currentVolume += lastAdd
    
        self.drinkEntrys.append(DrinkEntry(date: Date(), volume: lastAdd, type: .water))
    }
    
    func resetDay() {
        self.currentVolume = 0
        self.lastAdd = 0
        self.drinkEntrys.removeAll()
    }
    
    func undoLast() {
        guard self.currentVolume >= self.lastAdd else {
            self.currentVolume = 0
            self.lastAdd = 0
            return
        }
        self.currentVolume -= self.lastAdd
        self.lastAdd = 0
    }
    
    func checkDate() {
        let lastOpenDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastOpenDate.rawValue) as? Date ?? Date()
        guard Calendar.current.isDateInToday(lastOpenDate) else {
            WaterManager.shared.currentVolume = 0
            UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastOpenDate.rawValue)
            return
        }
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastOpenDate.rawValue)
    }
}
