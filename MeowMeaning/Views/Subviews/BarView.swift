//
//  BarView.swift
//  SoundClassification
//
//  Created by Alejandro Ignacio Aliaga Martinez on 10/1/23.
//

import SwiftUI

struct BarView: View, Animatable {
    // MARK: - Properties
    let frequencyWidth: CGFloat
    let numberOfSamples: Int
    var value: CGFloat
    
    var animatableData: CGFloat {
        get { value }
        set { value = newValue }
    }

    private var width: CGFloat {
        return (frequencyWidth - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples)
    }
    
    // MARK: - Body
    var body: some View {

        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .blue]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(
                    width: width,
                    height: value
                )
            
        } //: ZStack
        
    }
    
}
