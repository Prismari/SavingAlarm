//
//  Item.swift
//  SaveAlarm
//
//  Created by Maria Ugorets on 19/01/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Entry {
    var timestamp: Date
    var source: String
    var sum: Int
    
    init(timestamp: Date, source: SourceOfMoney, sum: Int) {
        self.timestamp = timestamp
        self.source = source.rawValue
        self.sum = sum
    }
}

enum SourceOfMoney: String, Hashable, Codable, CaseIterable {
    case appoalimStocks = "Apoalim Stoks"
    case binance = "Binance"
    case kupatGemelHaAshka = "Kupat gemel haashka"
    case appoalimCurrency = "Appoalim USD"
    
    func getColor() -> Color {
        switch self {
        case .appoalimStocks:
            return .myPrimary
        case .binance:
            return .secondaryBackground
        case .kupatGemelHaAshka:
            return .tetraryBackground
        case .appoalimCurrency:
            return .quaternaryBackground
        }
    }
}
