//
//  ViewController.swift
//  MeetingTV
//
//  Created by Bernardo Nunes on 21/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UpdateTimerDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let myTimer = Chronometer(delegate: self)
        myTimer?.config()
    
    }
    
    func updateLabel(_ stringLabel: String!) {
        timerLabel.text = stringLabel
    }
    
}

