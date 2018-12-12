//
//  ViewController.swift
//  SmartCats
//
//  Created by Zhang, Ann on 2018/12/12.
//  Copyright © 2018 Zhang, Ann. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        donateIntents()
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
}

