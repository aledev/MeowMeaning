//
//  LoadingView.swift
//  SoundClassification
//
//  Created by Alejandro Ignacio Aliaga Martinez on 11/1/23.
//

import SwiftUI

struct LoadingView: View {
    
    // MARK: - Body
    var body: some View {
        
        VStack {
            
            ProgressView(label: {
                
                Text("Loading...")
                
            }) //: ProgressView
            .tint(.primary)
            .foregroundColor(.primary)
            .progressViewStyle(.circular)
            
        } //: VStack
        .padding()
        
    } //: Body
    
}

// MARK: - Preview
struct LoadingView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        // Light Theme
        LoadingView()
            .preferredColorScheme(.light)
        
        // Dark Theme
        LoadingView()
            .preferredColorScheme(.dark)
        
    }
    
}
