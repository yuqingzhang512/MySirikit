//
//  ZASpeechRecognizer.swift
//  SmartCats
//
//  Created by Zhang, Ann on 2018/12/14.
//  Copyright © 2018 Zhang, Ann. All rights reserved.
//

import Foundation
import Speech

public protocol ZASpeechRecognizerDelegate: class {
    func speechRecognitionNotAuthorized()
    func speechRecognitionTimeout()
    func speechRecognitionDidFinish(text: String)
    func speechRecognitionPartialResult(text: String)
}

class ZASpeechRecognizer: NSObject {
    weak var delegate: ZASpeechRecognizerDelegate?
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    
    override init() {
        super.init()
        
        self.setupSpeechRecognition()
    }
    
    func setupSpeechRecognition() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            OperationQueue.main.addOperation {
                if authStatus != .authorized {
                    self.delegate?.speechRecognitionNotAuthorized()
                }
            }
        }
    }
    
    private var speechRecognitionTimer: Timer?
    
    public var speechTimeoutInterval: TimeInterval = 2 {
        didSet {
            
        }
    }
    
    private func restartSpeechTimer() {
        self.speechRecognitionTimer?.invalidate()
        
        self.speechRecognitionTimer = Timer.scheduledTimer(timeInterval: self.speechTimeoutInterval, target: self, selector: #selector(recognitionTimeout), userInfo: nil, repeats: false)
    }
    
    @objc private func recognitionTimeout() {
        self.stopRecording()
        
        self.delegate?.speechRecognitionTimeout()
    }
    
    public func startRecording() throws {
        if let recognitionTask = self.recognitionTask {
            recognitionTask.cancel()
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionTask = nil
            self.recognitionRequest = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest")
        }
        
        self.recognitionRequest?.shouldReportPartialResults = true
        
        let inputNode = self.audioEngine.inputNode
        self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
                self.delegate?.speechRecognitionPartialResult(text: result.bestTranscription.formattedString)
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
            
            if isFinal {
                self.delegate?.speechRecognitionDidFinish(text: result!.bestTranscription.formattedString)
                self.stopRecording()
            } else {
                if error == nil {
                    self.restartSpeechTimer()
                }
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        try self.audioEngine.start()
    }
    
    public func stopRecording() {
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        
        self.recognitionRequest?.endAudio()
        
        self.speechRecognitionTimer?.invalidate()
        self.speechRecognitionTimer = nil
    }
}
