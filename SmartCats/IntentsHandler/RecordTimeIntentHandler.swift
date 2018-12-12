//
//  RecordTimeIntentHandler.swift
//  SmartCats
//
//  Created by Zhang, Ann on 2018/12/12.
//  Copyright © 2018 Zhang, Ann. All rights reserved.
//

import Foundation
import Intents

class RecordTimeIntentHandler: NSObject, RecordTimeIntentHandling {
    
    func confirm(intent: RecordTimeIntent, completion: @escaping (RecordTimeIntentResponse) -> Void) {
        completion(RecordTimeIntentResponse(code: .ready, userActivity: nil))
    }
    
    func handle(intent: RecordTimeIntent, completion: @escaping (RecordTimeIntentResponse) -> Void) {
        completion(RecordTimeIntentResponse.success(projectName: "Development"))
    }
    
}
