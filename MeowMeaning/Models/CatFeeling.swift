//
//  CatFeeling.swift
//  MeowMeaning
//
//  Created by Alejandro Ignacio Aliaga Martinez on 11/1/23.
//

import Foundation

enum CatFeeling: String {
    case brushing = "😌"
    case food = "😋"
    case isolation = "😑"
    case other = "🫥"
    
    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "brushing":
            self = .brushing
        case "food":
            self = .food
        case "isolation":
            self = .isolation
        default:
            self = .other
        }
    }
}
