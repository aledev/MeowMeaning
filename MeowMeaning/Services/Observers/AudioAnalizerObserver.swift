//
//  AudioAnalizerObserver.swift
//  MeowMeaning
//
//  Created by Alejandro Ignacio Aliaga Martinez on 12/1/23.
//

import Foundation
import SoundAnalysis

protocol AudioAnalizerObserverProtocol: SNResultsObserving {
    associatedtype AnalyzerResult
    associatedtype AnalyzerResultCompletion
    var results: AnalyzerResult { get set }
    var completion: AnalyzerResultCompletion? { get set }
}

class AudioAnalizerObserver: NSObject, AudioAnalizerObserverProtocol {
    typealias AnalyzerResult = [String: Double]
    typealias AnalyzerResultCompletion = ([String: Double]) -> Void
    
    var completion: AnalyzerResultCompletion? = nil
    var results: AnalyzerResult = [:]
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let results = (result as? SNClassificationResult)?.classifications else {
            return
        }
        
        debugPrint(results)
                
        results.forEach { item in
            self.results[item.identifier] = item.confidence
        }
    }
    
    func requestDidComplete(_ request: SNRequest) {
        self.completion?(self.results)
    }
}
