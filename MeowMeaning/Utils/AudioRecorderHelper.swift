//
//  AudioRecorderHelper.swift
//  MeowMeaning
//
//  Created by Alejandro Ignacio Aliaga Martinez on 11/1/23.
//

import Foundation
import AVFoundation

class AudioRecorderHelper: NSObject {
    // MARK: - Properties
    private lazy var recordingSession: AVAudioSession = {
        return AVAudioSession.sharedInstance()
    }()
    
    private var audioRecorder: AVAudioRecorder? = nil
    private var timer: Timer?
    private var soundSamples: [Float] = []
    private var currentSample: Int = 0
    
    var numberOfSamples: Int = 0 {
        willSet {
            self.soundSamples = [Float](repeating: .zero, count: newValue)
        }
    }
    
    var soundSampleHandler: (([Float]) -> Void)? = nil
    
    // MARK: - Initializer
    override init() {
        super.init()
    }
    
    // MARK: - Deinit
    deinit {
        self.timer?.invalidate()
    }
    
    // MARK: - Functions
    func stopRecording() {
        if self.audioRecorder != nil {
            self.audioRecorder!.stop()
            self.audioRecorder = nil
            self.timer?.invalidate()
        }
    }
    
    func startRecording(fileURL: URL) {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            self.audioRecorder!.delegate = self
            self.audioRecorder!.record()
            self.audioRecorder!.isMeteringEnabled = true
            
            timer = Timer.scheduledTimer(
                withTimeInterval: 0.01,
                repeats: true,
                block: { [weak self] timer in
                    guard let self = self else {
                        return
                    }
                            
                    self.audioRecorder!.updateMeters()
                    self.soundSamples[self.currentSample] = self.audioRecorder!.averagePower(forChannel: 0)
                    self.currentSample = (self.currentSample + 1) % self.numberOfSamples
                    self.soundSampleHandler?(self.soundSamples)
                })
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func requestPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            do {
                try self.recordingSession.setCategory(.playAndRecord, mode: .default)
                try recordingSession.setActive(true)
                recordingSession.requestRecordPermission { allowed in
                    continuation.resume(returning: allowed)
                    return
                }
            } catch {
                debugPrint(error.localizedDescription)
                continuation.resume(returning: false)
            }
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension AudioRecorderHelper: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.stopRecording()
    }
    
}



