//
//  ClassificationViewModel.swift
//  MeowMeaning
//
//  Created by Alejandro Ignacio Aliaga Martinez on 11/1/23.
//

import Foundation
import SwiftUI
import SoundAnalysis
import CoreML

@MainActor
class ClassificationViewModel: ObservableObject {
    // MARK: - Properties
    @Published var recording: Bool = false
    @Published var allowed: Bool = false
    @Published var classification: [AnalysisResult] = []
    @Published var soundSamples: [Float] = []
    
    var numberOfSamples: Int
    
    private var audioAnalizerService: AudioAnalizerService? = nil
    private var audioRecorderHelper: AudioRecorderHelper? = nil
    
    private var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private var audioFilePath: URL {
        let directory = documentsDirectory.appendingPathComponent("recordedAudio.m4a")
        debugPrint(directory)
        
        return directory
    }
    
    var recordingButtonTitle: String {
        self.recording ? "Stop Recording" : "Start Recording"
    }
    
    // MARK: - Initializer
    init(numberOfSamples: Int) {
        self.numberOfSamples = numberOfSamples
        self.audioRecorderHelper = AudioRecorderHelper()
        self.audioRecorderHelper?.numberOfSamples = numberOfSamples
        self.audioAnalizerService = AudioAnalizerService()
    }
    
    // MARK: - Functions
    func startStopRecording() {
        self.recording = !self.recording
        
        if self.recording {
            self.audioRecorderHelper?.startRecording(fileURL: self.audioFilePath)
            self.audioRecorderHelper?.soundSampleHandler = { [weak self] data in
                self?.soundSamples = data
            }
        } else {
            self.audioRecorderHelper?.stopRecording()
        }
    }
    
    func requestPermission() async {
        guard let allowed = await self.audioRecorderHelper?.requestPermission() else {
            self.allowed = false
            return
        }
        
        debugPrint("Allowed: \(allowed)")
        self.allowed = allowed
    }
    
    func classify() async {
        guard let result = await self.classifySound() else {
            withAnimation(.default) {
                self.classification = []
            }
            return
        }
        
        withAnimation(.default) {
            self.classification = result.map { (key, value) in
                AnalysisResult(
                    feeling: CatFeeling(rawValue: key),
                    title: key,
                    probability: value
                )
            }
        }
    }
    
    private func classifySound() async -> [String: Double]? {
        await withCheckedContinuation { continuation in
            self.audioAnalizerService?.classifySound(audioFile: self.audioFilePath, completion: { result in
                guard let result = result else {
                    continuation.resume(returning: nil)
                    return
                }
                
                continuation.resume(returning: result)
            })
        }
    }
    
}
