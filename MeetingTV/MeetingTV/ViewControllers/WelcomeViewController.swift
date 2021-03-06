//
//  PresentationViewController.swift
//  MeetingTV
//
//  Created by Lucas Costa  on 11/12/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var welcomeLabel : UILabel!
    
    var multipeer : MeetingAdvertiserPeer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardView.layer.cornerRadius = 13
        setShadow(view: self.cardView)
        
        self.multipeer = MeetingAdvertiserPeer()
        multipeer.delegate = self
        
        welcomeLabel.text = NSLocalizedString("Welcome\nto Meeting", comment: "")
        self.changeColorMeetingName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        multipeer.startAdvertisingPeer()        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? MeetingViewController else {return}
        viewController.meetingData = sender as? Data
    }
    
    func setShadow (view: UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset  = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowRadius = 13
    }
}

extension WelcomeViewController : MeetingConnectionPeerDelegate {
    
    func didReceiveMeeting(data: Data) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowMeeting", sender: data)
        }
    }
    
}

//MARK:- Change color Meeting name
extension WelcomeViewController {
    
    func changeColorMeetingName() {
        
        let name = NSLocalizedString("Welcome\nto Meeting", comment: "") as NSString
        let range = name.range(of: "Meeting")
        let atributteString = NSMutableAttributedString(string: name as String)
        atributteString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "MeetingColor")!, range: range)
        
        self.welcomeLabel.attributedText = atributteString
    }    
}
