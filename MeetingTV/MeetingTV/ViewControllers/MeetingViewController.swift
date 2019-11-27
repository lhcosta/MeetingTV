//
//  MeetingViewController.swift
//  MeetingTV
//
//  Created by Paulo Ricardo on 11/27/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import UIKit
import CloudKit

class MeetingViewController: UIViewController {
    
    @IBOutlet var meetingTittle: UILabel!
    @IBOutlet var topicsCollectionView: UICollectionView!
    var meeting: Meeting!
    var topics: [Topic] = []
    
    let leftFocusGuide = UIFocusGuide()
    let rightFocusGuide = UIFocusGuide()
    let bottomFocusGuide = UIFocusGuide()
    let topFocusGuide = UIFocusGuide()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let record = CKRecord(recordType: "Meeting")
        meeting = Meeting(record: record)
        
        meeting.theme = "Reunião semestral."
        
        meetingTittle.text = meeting.theme
        
        
        for i in 0...30 {
            topics.append(createTopic(tittle: "\(i)", authorName: "author\(i)"))
        }
        
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self        
    }
    
    
    func createTopic(tittle: String, authorName: String) -> Topic {
        
        let record = CKRecord(recordType: "Meeting")
        var newTopic = Topic(record: record)
        newTopic.authorName = authorName
        newTopic.editDescription(tittle)
        
        return newTopic
    }
    
//    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//
//        if let nextFocusedItem = context.nextFocusedItem as? TopicsCollectionViewCell {
//
//            leftFocusGuide.preferredFocusEnvironments = [topicsCollectionView]
//            rightFocusGuide.preferredFocusEnvironments = [topicsCollectionView]
//            bottomFocusGuide.preferredFocusEnvironments = [topicsCollectionView]
//            topFocusGuide.preferredFocusEnvironments = [topicsCollectionView]
//        }
//    }
}


extension MeetingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TopicsCollectionViewCell
        cell.backgroundColor = .blue
        cell.topicDescription.text = topics[indexPath.row].description
        cell.topicAuthor.text = topics[indexPath.row].authorName
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        topics[indexPath.row].discussed = !topics[indexPath.row].discussed
        
        for topic in topics {
            print("\(topic.authorName), \(topic.discussed)")
        }
    }
    
    
//    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
//        return IndexPath(item: 0, section: 0)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let nextCell = context.nextFocusedItem as? TopicsCollectionViewCell {
            nextCell.backgroundColor = .gray
        }
        
        if let previousCell = context.previouslyFocusedItem as? TopicsCollectionViewCell {
            previousCell.backgroundColor = .blue
        }
    }
}
