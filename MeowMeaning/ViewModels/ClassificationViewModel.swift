//
//  ClassificationViewModel.swift
//  MeowMeaning
//
//  Created by Alejandro Ignacio Aliaga Martinez on 11/1/23.
//

import Foundation
import SwiftUI

@MainActor
class ClassificationViewModel: ObservableObject {
    // MARK: - Properties
    @Published var recording: Bool = false
    @Published var allowed: Bool = false
    @Published var classification: [AnalysisResult] = []
    @Published var recordContainsCat: Bool = false
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
        guard await self.identifyCatSound() else {
            withAnimation(.default) {
                self.recordContainsCat = false
                self.classification = []
            }
            return
        }
        
        self.recordContainsCat = true
        
        guard let result = await self.classifyMeowSound() else {
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
}

// MARK: - Private Functions
extension ClassificationViewModel {
    
    private func identifyCatSound() async -> Bool {
        await withCheckedContinuation { continuation in
            self.audioAnalizerService?.identifyCatSound(audioFile: self.audioFilePath, completion: { result in
                guard let result = result,
                      let catSound = result[CatIdentifierLabels.cat.rawValue] else {
                    continuation.resume(returning: false)
                    return
                }
                                
                continuation.resume(returning: catSound >= 0.8)
            })
        }
    }
    
    private func classifyMeowSound() async -> [String: Double]? {
        await withCheckedContinuation { continuation in
            self.audioAnalizerService?.classifyMeowFeelingSound(audioFile: self.audioFilePath, completion: { result in
                guard let result = result else {
                    continuation.resume(returning: nil)
                    return
                }
                
                var formattedResult: [String: Double] = [:]
                
                result.forEach { (key, value) in
                    formattedResult[key] = value * 100.0
                }
                
                continuation.resume(returning: formattedResult)
            })
        }
    }
    
}
