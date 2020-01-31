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
    
    var topFocus = UIFocusGuide()
    var bottomFocus = UIFocusGuide()
    var timeAlreadyStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addFocus()
        
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let button = context.nextFocusedItem as? UIButton {
            
            switch button {
            case start:
                topFocus.preferredFocusEnvironments = [buttonDown]
            case reset:
                topFocus.preferredFocusEnvironments = [buttonDown]
            case buttonDown:
                bottomFocus.preferredFocusEnvironments = [start]
            default:
                print("nada")
            }
                
                let animation = CABasicAnimation(keyPath: "shadowOffset")
                animation.fromValue = button.layer.shadowOffset
                animation.toValue = CGSize(width: 0, height: 20)
                animation.duration = 0.1
                button.layer.shadowOpacity = 0.3
                button.layer.add(animation, forKey: animation.keyPath)
                button.layer.shadowOffset = CGSize(width: 0, height: 10)

                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
                    button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }, completion: nil)
        }
        
        if let previousButton = context.previouslyFocusedItem as? UIButton {

            let animation = CABasicAnimation(keyPath: "shadowOffset")
            animation.fromValue = previousButton.layer.shadowOffset
            animation.toValue = CGSize(width: 0, height: 5)
            animation.duration = 0.1
            previousButton.layer.add(animation, forKey: animation.keyPath)
            previousButton.layer.shadowOffset = CGSize(width: 0, height: 5)

            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
                previousButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)

        }
    }
    
    func addFocus(){
        
        /// Configuração do Focus para acesso dos botões superiores - Up / Down
        view.addLayoutGuide(topFocus)
        topFocus.leftAnchor.constraint(equalTo: reset.leftAnchor).isActive = true
        topFocus.rightAnchor.constraint(equalTo: start.rightAnchor).isActive = true
        topFocus.topAnchor.constraint(equalTo: buttonDown.bottomAnchor).isActive = true
        topFocus.heightAnchor.constraint(equalTo: buttonDown.heightAnchor).isActive = true
        
        /// Configuração do Focus para acesso dos botões inferiores - Start / Reset
        view.addLayoutGuide(bottomFocus)
        bottomFocus.leftAnchor.constraint(equalTo: reset.leftAnchor).isActive = true
        bottomFocus.rightAnchor.constraint(equalTo: start.rightAnchor).isActive = true
        bottomFocus.topAnchor.constraint(equalTo: start.bottomAnchor).isActive = true
        bottomFocus.heightAnchor.constraint(equalTo: buttonDown.heightAnchor).isActive = true
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
        self.setUpDelegate?.compareTime(minute: minutes, hour: hours)
        self.setUpDelegate?.setUpTimer()
        
        dismiss(animated: true)
        
    }
    
    @IBAction func resetButton(_ sender: Any) {
        self.setUpDelegate?.resetTimer()
        
        dismiss(animated: true)
    }
    
    func labelTimerFormat() {
        var stringHours = String()
        var stringMinutes = String()
        
        ///Conversão da String para o formato de horas correto
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
    
    @IBAction func timeUp(_ sender: Any) {
        /// Lógica para a Label ser apresentada como Cronometro comum
        if minutes == 50 {
            minutes = 0
            hours += 1
        } else {
            minutes += 10
        }
        
        if hours == 24 {
            hours = 0
        }
        
        labelTimerFormat()
    }
    
    @IBAction func timeDown(_ sender: Any) {
        if minutes != 0 {
            minutes -= 10
        } else if hours > 0 {
            hours -= 1
            minutes = 50
        }
        
        labelTimerFormat()
    }
    
}

protocol SetUpTimerDelegate {
    func setUpTimer()
    func compareTime(minute: Int, hour: Int)
    func resetTimer()
}
