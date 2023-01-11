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

class AudioAnalizerService: NSObject {
    // MARK: - Properties
    private var model: CatMeowV1? = nil
    private var results: [String: Double] = [:]
    private var completion: (([String: Double]?) -> Void)? = nil
    
    // MARK: - Initializer
    override init() {
        self.model = try? CatMeowV1(configuration: MLModelConfiguration())
    }
    
    // MARK: - Functions
    func classifySound(audioFile: URL, completion: @escaping ([String: Double]?) -> Void){
        self.completion = completion
        
        guard let mlModel = model?.model,
              let soundRequest = try? SNClassifySoundRequest(mlModel: mlModel) else {
            debugPrint("Error trying to initialize the SoundRequest")
            self.completion?(nil)
            return
        }
        
        guard let analyzer = try? SNAudioFileAnalyzer(url: audioFile) else {
            debugPrint("Error trying to initialize the SoundAnalizer")
            self.completion?(nil)
            return
        }
        
        guard let _ = try? analyzer.add(soundRequest, withObserver: self) else {
            debugPrint("Error trying to add the sound request observer")
            self.completion?(nil)
            return
        }
        
        analyzer.analyze()
    }
}

// MARK: - SNResultsObserving
extension AudioAnalizerService: SNResultsObserving {
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let results = (result as? SNClassificationResult)?.classifications else {
            return
        }
        
        results.forEach { item in
            self.results[item.identifier] = item.confidence
        }
    }
    
    func requestDidComplete(_ request: SNRequest) {
        var responseData: [String: Double] = [:]
        
        results.sorted(by: { $0.value > $1.value })
            .prefix(3)
            .forEach { (key, value) in
                responseData[key] = value
            }
        
        debugPrint(responseData)
        
        self.completion?(responseData)
    }
    
}

