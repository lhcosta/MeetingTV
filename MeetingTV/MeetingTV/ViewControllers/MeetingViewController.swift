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
    
    /// Label que será exibida o tempo de duração da Meeting/Tópico
    @IBOutlet weak var buttonTimer: UIButton!
    @IBOutlet weak var labelTimerTopic: UILabel!
    
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
    
    // Variável responsável por guardar o anterior perdido
    var previousIndex = 0
    
    // Timer das pautas
    var topicsTimer: [Chronometer] = []
    
    //Flag primeiro Foco - Se existe um foco anterior
    var hasPrevious = false
    
    ///Data da Meeting recebida pelo Multipeer
    var meetingData : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        
        self.decoderMeeting()
        
    
        //MARK: SIMULAÇÃO
        /// Inicializando a Meeting (será substituída pelo que vier do Multipeer)
        let record = CKRecord(recordType: "Meeting")
        meeting = Meeting(record: record)
//        self.meetingTittle.text = self.meeting.theme
        self.meetingTittle.text = "Reunião semestral"
        
        /// Adicionando Topics falsos na reunião para teste
        for i in 0...9 {
            topics.append(createTopic(tittle: "\(i)", authorName: "author\(i)"))
        }
        
        addConclusion("")
        /// Adicionando conclusions na Topic criada.
        for i in 0...6 {
            addConclusion("Conclusionnnnnnnnnnnnn\(i)")
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        ///Este comportamento agora será realizado ao clicar no botão de Iniciar Timer
        
        // Inicializa o timer de todas as pautas
        for i in 0..<topics.count {
            self.topicsTimer.append(Chronometer(delegate: self, isMeeting: false))
            self.topicsTimer[i].config()
        }
        
        let timerMeeting = Chronometer(delegate: self, isMeeting: true)
        timerMeeting?.config()
        
        // Start nos Timers tanto da Reunião quanto de cada tópico
        timerMeeting?.setTimer()
        topicsTimer[0].setTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTopicCell(_:)), name: NSNotification.Name(rawValue: "topicUpdate"), object: nil)
    }
    
    @IBAction func openConfig(_ sender: Any) {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame

        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [topicsCollectionView]
    }
    
    /// Método para atualizar célula de pauta quando receber notificação do cloudkit
    /// - Parameter notification: notificação recebida no notificationcenter
    @objc private func updateTopicCell(_ notification: NSNotification) {
        guard let topicUpdated = notification.object as? [String: Any] else { return }
        
        if let recordName = topicUpdated["recordName"] as? String {
            if let row = self.topics.firstIndex(where: {$0.recordName == recordName}) {
                if let conclusions = topicUpdated["conclusion"] as? [String]{
                    topics[row].conclusions = conclusions
                    topicsCollectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
                }
            }
        }
    }
    
    // Funções de Atualização do Timer na Tela
    func updateLabelMeeting(_ stringLabel: String!) {
        buttonTimer.titleLabel?.text = stringLabel
    }
    
    func updateLabelTopic(_ stringLabel: String!) {
        labelTimerTopic.text = stringLabel
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

//
// MARK: - CollectionView Delegate/DataSource
//
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
//            cell.conclusionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//            cell.conclusionsTableView.delegate = cell
//            cell.conclusionsTableView.dataSource = cell
            cell.thisIndexPath = indexPath
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        currTopicOnCollection = context.nextFocusedIndexPath
        
        collectionView.remembersLastFocusedIndexPath = true
        
        if hasPrevious {
            // Verifica se o anterior possui valor, caso contrário o movimento de swipe foi muito rapido entre os Itens
            if let index = context.previouslyFocusedIndexPath {
                print("Index Anterior: \(index.row))")
                // Pausa o Timer do último Item de fato acessado
                topicsTimer[previousIndex].pauseTimer()
                
                let indexNext = context.nextFocusedIndexPath
                print("Index Previous: \(previousIndex+1))")
                print("Index Atual: \(indexNext!.row)")
                
                // Guarda o index do Item que está em foco para utiliza-lo como o ultimo Item de fato acessado
                previousIndex = indexNext!.row-1
                
                // Inicia a contage do Timer do Item atual
                topicsTimer[indexNext!.row-1].setTimer()
            }
        } else {
            hasPrevious = true
        }
        
        //
        // Foco customizado dos botoes
        //
        if let button = context.nextFocusedItem as? UIButton {
            guard let cell = button.superview?.superview as? TopicsCollectionViewCell else { return }
//            collectionView.isScrollEnabled = false
//            let indexPath = collectionView.indexPath(for: cell)
//            collectionView.scrollToItem(at: indexPath!, at: .centeredHorizontally, animated: true)
            let animation = CABasicAnimation(keyPath: "shadowOffset")
            animation.fromValue = button.layer.shadowOffset
            animation.toValue = CGSize(width: 6, height: 10)
            animation.duration = 0.12
            button.layer.add(animation, forKey: animation.keyPath)
            button.layer.shadowOffset = CGSize(width: 6, height: 10)
            
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
                button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: nil)
        }
        
        if let previousButton = context.previouslyFocusedItem as? UIButton {
            
            let animation = CABasicAnimation(keyPath: "shadowOffset")
            animation.fromValue = previousButton.layer.shadowOffset
            animation.toValue = CGSize(width: 0, height: 5)
            animation.duration = 0.12
            previousButton.layer.add(animation, forKey: animation.keyPath)
            previousButton.layer.shadowOffset = CGSize(width: 0, height: 5)
            
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
                previousButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            
        }
        
    }
}


extension MeetingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.height*1.37, height: collectionView.bounds.height)
//        return CGSize(width: 568, height: 414)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.size.width * 0.07
    }
}

//MARK:- Decoder Meeting
extension MeetingViewController {
        
    func decoderMeeting() {
        
        let decoder = JSONDecoder()
        
        if let data = meetingData {
            do {
                self.meeting = try decoder.decode(Meeting.self, from: data)
            } catch let error as NSError {
                print("Decoder -> \(error.userInfo)")
            }
        }
        
    }
}
