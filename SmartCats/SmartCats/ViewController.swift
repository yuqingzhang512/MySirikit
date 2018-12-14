//
//  ViewController.swift
//  SmartCats
//
//  Created by Zhang, Ann on 2018/12/12.
//  Copyright © 2018 Zhang, Ann. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController, ZASpeechRecognizerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var startBtn: UIButton!
    
    var speechRecognizer: ZASpeechRecognizer!
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // donate shortcuts
        donateIntents()
        
        // speech recognition
        self.speechRecognizer = ZASpeechRecognizer()
        self.speechRecognizer.delegate = self
    }

    @IBAction func startBtnTapped(_ sender: Any) {
        self.toggleRecording()
    }
    
    func toggleRecording() {
        self.isRecording = !self.isRecording
        
        self.startBtn.setTitle(isRecording ? "Stop" : "Start", for: .normal)
        
        if !self.isRecording {
            self.speechRecognizer.stopRecording()
        } else {
            do {
                try self.speechRecognizer.startRecording()
            } catch {
                print(error)
            }
        }
    }
    
    func donateIntents() {
        let intent = RecordTimeIntent()
        
        intent.suggestedInvocationPhrase = "CATS"
        intent.projectName = "B1"
        
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            if let error = error {
                print("Interaction donation failed: \(error.localizedDescription)")
            } else {
                print("Successfully donated interaction")
            }
        }
        
    }
    
    func speechRecognitionPartialResult(text: String) {
        self.textView.text = text
    }
    
    func speechRecognitionTimeout() {
        toggleRecording()
    }
    
    func speechRecognitionDidFinish(text: String) {
        self.textView.text = text
        print("Finish :\(text)")
    }
    
    func speechRecognitionNotAuthorized() {
        let alert = UIAlertController(title: "Not Authorized", message: "Microphone and speech recognition access must be enabled for this app in order to perform speech recognition. Go to iOS privacy settings to fix this.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

