//
//  MeetingViewController.swift
//  MeetingTV
//
//  Created by Paulo Ricardo on 11/27/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import UIKit
import CloudKit


/// Tela inicial da Meeting espelhada
class MeetingViewController: UIViewController, UpdateTimerDelegate {
    
    /// Label que será exibida o tempo de duração da Meeting
    @IBOutlet weak var labelTimer: UILabel!
    
    /// Título da Meeting
    @IBOutlet var meetingTittle: UILabel!
    
    /// Collection View com os Topics da Meeting
    @IBOutlet var topicsCollectionView: UICollectionView!
    
    /// Meeting em si (Que será passada pelo Multipeer)
    var meeting: Meeting!
    
    /// Topics da meeting, serão passados pelo Multipeer, não será carregado pela Reference do record da Meeting
    var topics: [Topic] = []
    
    /// Index Path do Topic focado da CollectionView
    var currTopicOnCollection: IndexPath?
    
    /// Focus será terminado no momento do Front-End.

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chronometer = Chronometer(delegate: self)
        chronometer?.config()
        
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        
        //MARK: SIMULAÇÃO
        /// Inicializando a Meeting (será substituída pelo que vier do Multipeer)
        let record = CKRecord(recordType: "Meeting")
        meeting = Meeting(record: record)
//        meeting.theme = "Reunião semestral."
        meetingTittle.text = "Reunião semestral."
        
        /// Adicionando Topics falsos na reunião para teste
        for i in 0...9 {
            topics.append(createTopic(tittle: "\(i)", authorName: "author\(i)"))
        }
        
        /// Adicionando conclusions na Topic criada.
        for i in 0...6 {
            addConclusion("Conclusionnnnnnnnnnnnn\(i)")
        }
    }
    
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [topicsCollectionView]
    }
    
    
    func updateLabel(_ stringLabel: String!) {
        labelTimer.text = stringLabel
    }
    
    
    /// Método feito para testes dos Topics
    /// - Parameters:
    ///   - tittle: Topic em si.
    ///   - authorName: Nome do autor que criou o tópico
    func createTopic(tittle: String, authorName: String) -> Topic {
        
        let record = CKRecord(recordType: "Meeting")
        var newTopic = Topic(record: record)
        newTopic.authorName = authorName
        newTopic.editDescription(tittle)
        
        return newTopic
    }
    
    
    /// Arrumar quando a função de subscription for adicionada.
    /// - Parameter conclusion: Conclusion do Topic
    func addConclusion(_ conclusion: String) {
        
        topics[1].sendConclusion(conclusion)
    }
}


extension MeetingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TopicsCollectionViewCell
        
        cell.isHidden = false
        if indexPath.row == 0 || indexPath.row == topics.count-1 {
            cell.isHidden = true
        } else {
            cell.topicDescription.text = topics[indexPath.row].description
            cell.topicAuthor.text = topics[indexPath.row].authorName
            cell.conclusions = topics[indexPath.row].conclusions
            
            ///1- TableViewCell sendo adicionada pelo código;
            ///2/3- Setamos o delegate e dataSource da tableView da célula;
            ///4- Focus será configurado no momento de Front-End.
            cell.conclusionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            cell.conclusionsTableView.delegate = cell
            cell.conclusionsTableView.dataSource = cell
            cell.thisIndexPath = indexPath
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        currTopicOnCollection = context.nextFocusedIndexPath
        
        if let button = context.nextFocusedItem as? UIButton {
            guard let cell = button.superview?.superview as? TopicsCollectionViewCell else { return }
//            collectionView.isScrollEnabled = false
            let indexPath = collectionView.indexPath(for: cell)
//            collectionView.scrollToItem(at: indexPath!, at: .centeredHorizontally, animated: true)
        }
    }
}


extension MeetingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width*0.3, height: collectionView.bounds.width*0.3)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.size.width * 0.07
    }
}
