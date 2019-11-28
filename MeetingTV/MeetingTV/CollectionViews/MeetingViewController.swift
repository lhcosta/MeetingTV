//
//  MeetingViewController.swift
//  MeetingTV
//
//  Created by Paulo Ricardo on 11/27/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import UIKit
import CloudKit

class MeetingViewController: UIViewController, UpdateTimerDelegate {
    
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet var topicsCollectionView: UICollectionView!
    var meeting: Meeting!
    var topics: [Topic]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chronometer = Chronometer(delegate: self)
        chronometer?.config()
        
//        let record = CKRecord()
//        meeting = Meeting(record: record)
//
//        meeting.
    }
    
    func updateLabel(_ stringLabel: String!) {
        labelTimer.text = stringLabel
       }
}


//extension MeetingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}
