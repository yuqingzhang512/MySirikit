//
//  MessageIntentsHandler.swift
//  IntentsHandler
//
//  Created by Zhang, Ann on 2018/12/12.
//  Copyright © 2018 Zhang, Ann. All rights reserved.
//

import Foundation
import Intents

class MessageIntentsHandler: NSObject, INSendMessageIntentHandling {
//    func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INSendMessageRecipientResolutionResult]) -> Void) {
//        if let recipients = intent.recipients {
//            
//            // If no recipients were provided we'll need to prompt for a value.
//            if recipients.count == 0 {
//                completion([INSendMessageRecipientResolutionResult.needsValue()])
//                return
//            }
//            
//            var resolutionResults = [INSendMessageRecipientResolutionResult]()
//            for recipient in recipients {
//                let matchingContacts = [recipient] // Implement your contact matching logic here to create an array of matching contacts
//                switch matchingContacts.count {
//                case 2  ... Int.max:
//                    // We need Siri's help to ask user to pick one from the matches.
//                    resolutionResults += [INSendMessageRecipientResolutionResult.disambiguation(with: matchingContacts)]
//                    
//                case 1:
//                    // We have exactly one matching contact
//                    resolutionResults += [INSendMessageRecipientResolutionResult.success(with: recipient)]
//                    
//                case 0:
//                    // We have no contacts matching the description provided
//                    resolutionResults += [INSendMessageRecipientResolutionResult.unsupported()]
//                    
//                default:
//                    break
//                    
//                }
//            }
//            completion(resolutionResults)
//        }
//    }
    
    func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        
        print("Message Content: \(intent.content ?? "NIL")")
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
        
    }
    
    
    
    
}
