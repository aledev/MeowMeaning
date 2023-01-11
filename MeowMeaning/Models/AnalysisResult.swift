//
//  AnalysisResult.swift
//  MeowMeaning
//
//  Created by Alejandro Ignacio Aliaga Martinez on 11/1/23.
//

import Foundation

struct AnalysisResult: Identifiable {
    let id: UUID = UUID()
    let feeling: CatFeeling
    let title: String
    let probability: Double
}
