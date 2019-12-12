//
//  PresentationViewController.swift
//  MeetingTV
//
//  Created by Lucas Costa  on 11/12/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    //MARK:- Properties
    private var multipeer : MeetingAdvertiserPeer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.multipeer = MeetingAdvertiserPeer()
        self.multipeer?.delegate = self
        self.multipeer?.startAdvertisingPeer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? MeetingViewController else {return}
        viewController.meetingData = sender as? Data
    }
}

extension WelcomeViewController : MeetingConnectionPeerDelegate {
    
    func receiveMeetingFromPeer(data: Data) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowMeeting", sender: data)
        }
    }
    
}

