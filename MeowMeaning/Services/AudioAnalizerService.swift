//
//  AudioAnalizerService.swift
//  MeowMeaning
//
//  Created by Alejandro Ignacio Aliaga Martinez on 11/1/23.
//

import Foundation
import AVFoundation
import SoundAnalysis
import CoreML

class AudioAnalizerService {
    // MARK: - Properties
    private var meowMLModel: CatMeowV1? = nil
    private var catIdentifierMLModel: CatIdentifierV1? = nil
    private var catMeowObserver: AudioAnalizerObserver? = nil
    private var catIdentifyObserver: AudioAnalizerObserver? = nil
    
    // MARK: - Initializer
    init() {
        let mlConfig = MLModelConfiguration()
        self.meowMLModel = try? CatMeowV1(configuration: mlConfig)
        self.catIdentifierMLModel = try? CatIdentifierV1(configuration: mlConfig)
        self.catMeowObserver = AudioAnalizerObserver()
        self.catIdentifyObserver = AudioAnalizerObserver()
    }
    
    deinit {
        self.meowMLModel = nil
        self.catIdentifierMLModel = nil
        self.catMeowObserver = nil
        self.catIdentifyObserver = nil
    }
    
    // MARK: - Functions
    func identifyCatSound(audioFile: URL, completion: @escaping ([String: Double]?) -> Void) {
        guard let observer = self.catIdentifyObserver else {
            completion(nil)
            return
        }
                
        guard let catIdentifierMLModel = self.catIdentifierMLModel?.model,
              let soundRequest = try? SNClassifySoundRequest(mlModel: catIdentifierMLModel) else {
            debugPrint("Error trying to initialize the SoundRequest")
            completion(nil)
            return
        }
                
        guard let analyzer = try? SNAudioFileAnalyzer(url: audioFile) else {
            debugPrint("Error trying to initialize the SoundAnalizer")
            completion(nil)
            return
        }
             
        guard let _ = try? analyzer.add(soundRequest, withObserver: observer) else {
            debugPrint("Error trying to add the sound request observer")
            completion(nil)
            return
        }
        
        observer.completion = completion
        analyzer.analyze()
    }
    
    func classifyMeowFeelingSound(audioFile: URL, completion: @escaping ([String: Double]?) -> Void) {
        guard let observer = self.catMeowObserver else {
            completion(nil)
            return
        }
        
        guard let meowMLModel = meowMLModel?.model,
              let soundRequest = try? SNClassifySoundRequest(mlModel: meowMLModel) else {
            debugPrint("Error trying to initialize the SoundRequest")
            completion(nil)
            return
        }
                
        guard let analyzer = try? SNAudioFileAnalyzer(url: audioFile) else {
            debugPrint("Error trying to initialize the SoundAnalizer")
            completion(nil)
            return
        }
                        
        guard let _ = try? analyzer.add(soundRequest, withObserver: observer) else {
            debugPrint("Error trying to add the sound request observer")
            completion(nil)
            return
        }
        
        observer.completion = completion
        analyzer.analyze()
    }
}
