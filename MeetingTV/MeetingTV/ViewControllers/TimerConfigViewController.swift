//
//  TimerConfigViewController.swift
//  MeetingTV
//
//  Created by Caio Azevedo on 27/01/20.
//  Copyright © 2020 Bernardo Nunes. All rights reserved.
//

import UIKit

class TimerConfigViewController: UIViewController {
    
    var timerMet = Chronometer()
    var setUpDelegate: SetUpTimerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startButton(_ sender: Any) {
        self.setUpDelegate?.setUpTimer()
        
        dismiss(animated: true)
    }
    
    @IBAction func resetButton(_ sender: Any) {
        
    }

}

protocol SetUpTimerDelegate {
    func setUpTimer()
}
