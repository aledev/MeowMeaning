//
//  ResultView.swift
//  MeowMeaning
//
//  Created by Alejandro Ignacio Aliaga Martinez on 11/1/23.
//

import SwiftUI

struct ResultView: View {
    // MARK: - Properties
    let containsCatSound: Bool
    let results: [AnalysisResult]
    
    // MARK: - Body
    var body: some View {
            
        VStack {
            
            if containsCatSound {
                
                VStack {
                    
                    HStack {
                        
                        Text("Probabilities:")
                            .font(.body)
                            .bold()
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                    } //: HStack
                    .padding(.bottom, 2)
                    
                    if results.isEmpty {
                        
                        Text("No available results")
                            .foregroundColor(.secondary)
                            .font(.title2)
                        
                    } else {
                        
                        ForEach(results, id: \.id) { result in
                            
                            HStack {
                                
                                Text(result.feeling.rawValue)
                                    .font(.custom("Arial", size: 40))
                                
                                Spacer()
                                
                                Text(result.title)
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Spacer()
                                
                                Text(String(format: "%.2f%@", result.probability, "%"))
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                                
                            } //: HStack
                            
                        } //: ForEach
                        
                    } //: Else
                    
                } //: VStack
                
            } else {
                
                VStack(spacing: 10) {
                    
                    Text("The record doesn't contains a cat sound")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "x.circle")
                        .font(.title)
                        .foregroundColor(.secondary)
                    
                }                
                
            } //: Else
            
        } //: VStack
        
    } //: Body
    
}

// MARK: - Preview
struct ResultView_Previews: PreviewProvider {
    private static let results = [
        AnalysisResult(feeling: .food, title: "Food", probability: 79.5),
        AnalysisResult(feeling: .isolation, title: "Isolation", probability: 10.5),
        AnalysisResult(feeling: .brushing, title: "Brushing", probability: 5.3)
    ]
    
    static var previews: some View {

        // Light Theme
        // Contains Cat Sound & Result with Data
        ResultView(
            containsCatSound: true,
            results: results
        )
        .preferredColorScheme(.light)
        
        // Light Theme
        // Contains Cat Sound & Empty Result
        ResultView(
            containsCatSound: true,
            results: []
        )
        .preferredColorScheme(.light)
        
        // Light Theme
        // Doesn't contains Cat Sound & Empty Result
        ResultView(
            containsCatSound: false,
            results: []
        )
        .preferredColorScheme(.light)
      
        
        // Dark Theme
        // Contains Cat Sound & Result with Data
        ResultView(
            containsCatSound: true,
            results: results
        )
        .preferredColorScheme(.light)
        
    }
}
