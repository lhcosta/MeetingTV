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
        self.multipeer?.startAdvertisingPeer()
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
