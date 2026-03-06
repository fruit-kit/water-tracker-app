//
//  WaterModel.swift
//  H2O
//
//  Created by Robert Kotrutsa on 05.03.26.
//
import Foundation

struct DrinkEntry: Codable {
    let date: Date
    let volume: Int
    let type: DrinkType
}
