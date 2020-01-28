//
//  TimerConfigViewController.swift
//  MeetingTV
//
//  Created by Caio Azevedo on 27/01/20.
//  Copyright © 2020 Bernardo Nunes. All rights reserved.
//

import UIKit

class TimerConfigViewController: UIViewController {
    
    @IBOutlet weak var buttonUp: UIButton!
    
    @IBOutlet weak var buttonDown: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var reset: UIButton!
    
    var timerMet = Chronometer()
    var setUpDelegate: SetUpTimerDelegate?
    
    var focusGuide = UIFocusGuide()
    
    var minutes = 0
    var hours = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpDelegate = self as? SetUpTimerDelegate
        
        addFocusGuide(from: start, to: buttonDown, direction: .top)
        addFocusGuide(from: reset, to: buttonDown, direction: .top)
        addFocusGuide(from: buttonDown, to: buttonUp, direction: .top)
        addFocusGuide(from: buttonDown, to: start, direction: .bottom)
        addFocusGuide(from: buttonUp, to: buttonDown, direction: .bottom)
        
    }
    
    func addFocusGuide(from origin: UIView, to destination: UIView, direction: UIRectEdge) {
        let focusGuide = UIFocusGuide()
        view.addLayoutGuide(focusGuide)
        focusGuide.preferredFocusEnvironments = [destination]

        // Configura o tamanho para o mesmo da view
        focusGuide.widthAnchor.constraint(equalTo: origin.widthAnchor).isActive = true
        focusGuide.heightAnchor.constraint(equalTo: origin.heightAnchor).isActive = true

        switch direction {
        case .bottom: // swipe down
            focusGuide.topAnchor.constraint(equalTo: origin.bottomAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
        case .top: // swipe up
            focusGuide.bottomAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
        case .left: // swipe left
            focusGuide.topAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.rightAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
        case .right: // swipe right
            focusGuide.topAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.rightAnchor).isActive = true
        default:
            // Não suporta!
            break
        }
    }
    
    @IBAction func startButton(_ sender: Any) {
        self.setUpDelegate?.setUpTimer()
        
        dismiss(animated: true)
    }
    
    @IBAction func resetButton(_ sender: Any) {
        
    }
    
    @IBAction func timeUp(_ sender: Any) {
        if minutes == 50 {
            minutes = 0
            hours += 1
        } else {
            minutes += 10
        }
        
        if hours == 24 {
            hours = 0
        }
        
        var stringHours = String()
        var stringMinutes = String()
        
        ///Conversão para o formato de horas correto
        if hours < 10 {
            stringHours = "0\(hours)"
        } else {
            stringHours = "\(hours)"
        }
        
        if minutes == 0 {
            stringMinutes = "0\(minutes)"
        } else {
            stringMinutes = "\(minutes)"
        }
        
        timeLabel.text = "\(stringHours):\(stringMinutes):00"
    }
    
    @IBAction func timeDown(_ sender: Any) {
        
    }
    
}

protocol SetUpTimerDelegate {
    func setUpTimer()
}
