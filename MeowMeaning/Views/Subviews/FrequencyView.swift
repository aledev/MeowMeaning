//
//  FrequencyView.swift
//  SoundClassification
//
//  Created by Alejandro Ignacio Aliaga Martinez on 10/1/23.
//

import SwiftUI

struct FrequencyView: View, Animatable {
    // MARK: - Properties
    var samples: [Float]
    
    var animatableData: [CGFloat] {
        get { samples.map { CGFloat($0) } }
        set { samples = newValue.map { Float($0) } }
    }
    
    private var samplesCount: Int {
        samples.count
    }
    
    private var enumeratedData: [(index: Int, value: Float)] {
        samples.enumerated().map {
            ($0.offset, $0.element)
        }
    }
    
    // MARK: - Functions
    private func normalizeSoundLevel(_ sample: Float, height: CGFloat) -> CGFloat {
        let level = max(0.2, CGFloat(sample) + 50) / 2
        let normalized = CGFloat(level * (height / 25))
        
        return normalized
    }
    
    // MARK: - Body
    var body: some View {
                      
        GeometryReader { geometry in
            
            VStack {
                
                HStack(spacing: 4) {
                    
                    ForEach(enumeratedData, id: \.index) { (index, sample) in
                        
                        BarView(
                            frequencyWidth: geometry.size.width,
                            numberOfSamples: samplesCount,
                            value: normalizeSoundLevel(sample, height:  geometry.size.height)
                        )
                        
                    } //: ForEach
                    
                } //: HStack
                
            } //: VStack
            
        } //: GeometryReader
        
    }
    
}

// MARK: - Preview
struct FrequencyView_Previews: PreviewProvider {
    private static let samples: [Float] = [
        -10.0, -5.3, 6.4, 6.7, 8.0, 11.4, 23.4, 9.8, -19.4, 2.0
    ]
    
    static var previews: some View {
        
        // Light Theme
        FrequencyView(
            samples: samples
        )
        .frame(width: 300, height: 300, alignment: .center)
        .preferredColorScheme(.light)
        
        // Dark Theme
        FrequencyView(
            samples: samples
        )
        .frame(width: 300, height: 300, alignment: .center)
        .preferredColorScheme(.dark)
        
    }
}

