//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Zhang, Ann on 2018/12/12.
//  Copyright © 2018 Zhang, Ann. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var textLabel: WKInterfaceLabel!
    @IBOutlet weak var startBtn: WKInterfaceButton!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didAppear() {
        super.didAppear()
        
//        startBtnClicked()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func recordBtnClicked() {
        let url = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.com.sap.smb.ilab")?.appendingPathComponent("recording.m4a")
        guard let fileUrl = url else {
            return
        }
        self.presentAudioRecorderController(withOutputURL: fileUrl, preset: .wideBandSpeech, options: nil) { (didSave, error) in
            if (didSave) {
                print("Save Recording success");
            }
        }
    }
    
    @IBAction func startBtnClicked() {
        
        self.presentTextInputController(withSuggestions: nil, allowedInputMode: .plain) { (results) in
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                guard let text = aResult else {
                    return
                }
                
                
                self.textLabel.setText(text)
                
                self.speechSynthesizer.speak(AVSpeechUtterance(string: text))
            }
        }
    }
    
    
}
