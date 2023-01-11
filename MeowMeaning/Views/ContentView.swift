//
//  ContentView.swift
//  MeowMeaning
//
//  Created by Alejandro Ignacio Aliaga Martinez on 10/1/23.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @StateObject private var viewModel = ClassificationViewModel(numberOfSamples: 10)
    @State private var animateRecordButton = false
    @State private var loading = false
    
    // MARK: - Body
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
            
                ResultView(results: viewModel.classification)
                    .frame(width: 300)
                    .padding()
                
                Spacer()
                
                ZStack {
                    
                    FrequencyView(
                        samples: viewModel.soundSamples
                    )
                    .frame(
                        width: 250,
                        height: 300,
                        alignment: .center
                    )
                    
                    if loading {
                        
                        LoadingView()
                        
                    }
                    
                } //: ZStack
                
                Spacer()
                
                VStack(spacing: 20) {
                    
                    Button(viewModel.recordingButtonTitle) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            HapticFeedbackHelper.shared.notify()
                            viewModel.startStopRecording()
                        }
                    }
                    .frame(width: 200)
                    .padding()
                    .foregroundColor(.white)
                    .background(viewModel.recording ? .red : .green)
                    .shadow(color: .red, radius: animateRecordButton ? 10 : 0, x: 0, y: 0)
                    .cornerRadius(5)
                    
                    Button("Classify") {
                        Task {
                            self.loading = true
                            HapticFeedbackHelper.shared.notify()
                            await viewModel.classify()
                            self.loading = false
                        }
                    }
                    .frame(width: 200)
                    .padding()
                    .foregroundColor(.white)
                    .background(.secondary)
                    .cornerRadius(5)
                    
                } //: VStack
                
            } //: VStack
            .navigationTitle("🐈 Meow Meaning!")
            .task {
                await viewModel.requestPermission()
            }
            
        } //: NavigationView
        
    } //: Body
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Light Theme
        ContentView()
            .preferredColorScheme(.light)
        
        // Dark Theme
        ContentView()
            .preferredColorScheme(.dark)
        
    }
}
