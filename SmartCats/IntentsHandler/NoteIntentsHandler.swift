//
//  NoteIntentsHandler.swift
//  IntentsHandler
//
//  Created by Zhang, Ann on 2018/12/12.
//  Copyright © 2018 Zhang, Ann. All rights reserved.
//

import Foundation
import Intents

class NoteIntentsHandler: NSObject, INCreateNoteIntentHandling {
    
    func resolveContent(for intent: INCreateNoteIntent, with completion: @escaping (INNoteContentResolutionResult) -> Void) {
        let result: INNoteContentResolutionResult
        
        if let text = intent.content {
            result = INNoteContentResolutionResult.success(with: text)
        } else {
            result = INNoteContentResolutionResult.needsValue()
        }
        
        completion(result)
    }
    
    func confirm(intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Void) {
//        let userActivity = NSUserActivity(activityType: NSStringFromClass(INCreateNoteIntent.self))
        let response = INCreateNoteIntentResponse(code: .ready, userActivity: nil)
        completion(response)
    }
    
    func handle(intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Void) {
        
        print("Note Content: \(intent.content?.description ?? "NIL")")
        
//        let userActivity = NSUserActivity(activityType: NSStringFromClass(INCreateNoteIntent.self))
        let response = INCreateNoteIntentResponse(code: .success, userActivity: nil)
        response.createdNote = INNote(title: INSpeakableString(spokenPhrase: "Cats"), contents: [intent.content!], groupName: nil, createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil)
        
        completion(response)
    }
}
