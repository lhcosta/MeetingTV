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
class MeetingViewController: UIViewController, UpdateTimerDelegate, SetUpTimerDelegate {
    
    /// Label que será exibida o tempo de duração da Meeting/Tópico
    @IBOutlet weak var buttonTimer: UIButton!
    @IBOutlet var endMeetingButton: UIButton!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var clock: UIImageView!
    
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    
    /// Título da Meeting
    @IBOutlet var meetingTittle: UILabel!
    
    /// Collection View com os Topics da Meeting
    @IBOutlet var topicsCollectionView: UICollectionView!
    
    /// Hora e minuto setados na configuração do Timer
    var hoursSet = Int()
    var minutesSet = Int()
    
    var labelTimerTopic: UILabel!
    var firstLabelTimerTopic: UILabel!
    
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
    var timerMeeting: Chronometer?
    
    //Flag primeiro Foco - Se existe um foco anterior
    var hasPrevious = false
    
    ///Flag do Botão Iniciar do Timer
    ///O timer de cada pauta é monitorada através do foco para realizar a contagem do timer por pauta somente após o Timer ser iniciado
    var timerStarted = false
    
    ///Data da Meeting recebida pelo Multipeer
    var meetingData : Data?
    
    let bottomFocusGuide = UIFocusGuide()
    
    let topFocusGuide = UIFocusGuide()
    
    var flag = 0
    
    var blurEffectView = UIVisualEffectView()
    
    var resetFlag = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topicsCollectionView.clipsToBounds = false
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        
        collectionViewHeight.constant = (self.view.frame.height*0.34)*1.1
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTopicCell(_:)), name: NSNotification.Name(rawValue: "topicUpdate"), object: nil)
                
        self.setupFocus()
        
        self.decoderMeeting()
        
        ///Configura o timer geral da Reunião
        self.timerMeeting = Chronometer(delegate: self, isMeeting: true)

        /// Configura o timer de todas as pautas
        for _ in 0..<topics.count {
            self.topicsTimer.append(Chronometer(delegate: self, isMeeting: false))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func setUpTimer() {
        /// Inicia nos Timers tanto da Reunião quanto de cada tópico
        timerMeeting?.setTimer()
//        topicsTimer[0].setTimer()
        
        timerStarted = true
        self.resetFlag = false
        self.hasPrevious = false
    }
    
    func compareTime(minute: Int, hour: Int) {
        minutesSet = minute
        hoursSet = hour
    }
    
    func resetTimer() {
        if self.traitCollection.userInterfaceStyle == .light {
            labelTimer.textColor = UIColor(hexString: "#003FFF")
            clock.image = UIImage(named: "relogio")
        } else {
            labelTimer.textColor = UIColor(hexString: "#9FB9FF")
            clock.image = UIImage(named: "RelogioDark")
        }
        
        timerMeeting?.resetTimer()
        labelTimer.text = timerMeeting?.getTime()
        
        for i in 0..<topics.count {
            topicsTimer[i].resetTimer()
        }
        
        timerStarted = false
        self.resetFlag = true
        topicsCollectionView.reloadData()
    }
    
    
    func setupFocus() {
        
        view.addLayoutGuide(bottomFocusGuide)
        bottomFocusGuide.leftAnchor.constraint(equalTo: topicsCollectionView.leftAnchor).isActive = true
        bottomFocusGuide.rightAnchor.constraint(equalTo: endMeetingButton.leftAnchor).isActive = true
        bottomFocusGuide.topAnchor.constraint(equalTo: topicsCollectionView.bottomAnchor).isActive = true
        bottomFocusGuide.bottomAnchor.constraint(equalTo: endMeetingButton.topAnchor).isActive = true
        
//        view.addLayoutGuide(topFocusGuide)
//        topFocusGuide.leftAnchor.constraint(equalTo: topicsCollectionView.leftAnchor).isActive = true
//        topFocusGuide.rightAnchor.constraint(equalTo: buttonTimer.leftAnchor).isActive = true
//        topFocusGuide.topAnchor.constraint(equalTo: buttonTimer.topAnchor).isActive = true
//        topFocusGuide.bottomAnchor.constraint(equalTo: buttonTimer.bottomAnchor).isActive = true
    }
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        guard let nextView = context.nextFocusedItem as? UIButton else { return }
        
        switch nextView {
        case endMeetingButton:
            bottomFocusGuide.preferredFocusEnvironments = [topicsCollectionView]
            
            let animation = CABasicAnimation(keyPath: "shadowOffset")
            animation.fromValue = nextView.layer.shadowOffset
            animation.toValue = CGSize(width: 0, height: 20)
            animation.duration = 0.1
            nextView.layer.shadowOpacity = 0.3
            nextView.layer.add(animation, forKey: animation.keyPath)
            nextView.layer.shadowOffset = CGSize(width: 0, height: 10)

            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
                nextView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: nil)
            
        case buttonTimer:
            bottomFocusGuide.preferredFocusEnvironments = [topicsCollectionView]
            
            let animation = CABasicAnimation(keyPath: "shadowOffset")
            animation.fromValue = nextView.layer.shadowOffset
            animation.toValue = CGSize(width: 0, height: 20)
            animation.duration = 0.1
            nextView.layer.shadowOpacity = 0.3
            nextView.layer.add(animation, forKey: animation.keyPath)
            nextView.layer.shadowOffset = CGSize(width: 0, height: 10)

            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
                nextView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: nil)
        default:
            bottomFocusGuide.preferredFocusEnvironments = [buttonTimer]
//            topFocusGuide.preferredFocusEnvironments = [buttonTimer]
        }
        
        if let previousButton = context.previouslyFocusedItem as? UIButton {
            
            // Close button não pode ter essa animação.
            if previousButton.titleLabel?.text != "Close" {

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
    }
    
    
    @IBAction func checkTopicButton(_ sender: Any) {
        
        guard let button = sender as? UIButton else { return }
        guard let collectionCell = button.superview?.superview as? TopicsCollectionViewCell else {
            return
        }
        guard let indexPath = self.topicsCollectionView.indexPath(for: collectionCell) else {
            return
        }
        
        selectingAnimation(button: button, flag: false)
        
        if topics[indexPath.row].discussed {
            button.setBackgroundImage(UIImage(named: "uncheckButton"), for: .normal)
            topics[indexPath.row].discussed = false
        } else {
            button.setBackgroundImage(UIImage(named: "checkButton"), for: .normal)
            topics[indexPath.row].discussed = true
        }
    }
    
    
    @IBAction func moreInfoButton(_ sender: Any) {
        
        guard let button = sender as? UIButton else { return }
        selectingAnimation(button: button, flag: false)
        
        let topic = topics[button.tag]
        
    }
    
    
    @IBAction func endMeeting(_ sender: Any) {
        
        meeting.finished = true
        meeting.duration = buttonTimer.titleLabel?.text
        timerMeeting?.pauseTimer()
        
        for i in 0..<meeting.selectedTopics.count {
            meeting.selectedTopics[i].duration = topicsTimer[i].getTime()
            topicsTimer[i].pauseTimer()
        }
        
        CloudManager.shared().update([meeting.record], completionPerRecord: { (_, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }, completionHandler: {})
    }
    
    
    @IBAction func openConfig(_ sender: Any) {
        
        self.labelTimerTopic = self.firstLabelTimerTopic
        self.setNeedsFocusUpdate()
        self.updateFocusIfNeeded()
        self.topicsCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)
        performSegue(withIdentifier: "openConfig", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TimerConfigViewController {
            vc.setUpDelegate = self
            vc.timeAlreadyStarted = timerStarted
            vc.minutes = minutesSet
            vc.hours = hoursSet
        }
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

    
    func updateLabelMeeting(_ stringLabel: String!) {
        labelTimer.text = stringLabel
        let currentHour = timerMeeting?.getHours()
        let currentMinute = timerMeeting?.getMinutes()
        
        if hoursSet == currentHour && minutesSet == currentMinute {
            labelTimer.textColor = .red
            clock.image = UIImage(named: "RelogioVermelho")
        }
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
        if indexPath.row <= 1 || indexPath.row >= topics.count-2 {
            cell.isHidden = true
        } else {
            if let _ = topics[indexPath.row].description {
                cell.topicDescription.text = topics[indexPath.row].description
                cell.topicAuthor.text = topics[indexPath.row].authorName
                cell.conclusions = topics[indexPath.row].conclusions
                cell.topicPorque = topics[indexPath.row].topicPorque
                cell.contentView.alpha = 0.3
                if topics[indexPath.row].discussed {
                    cell.checkButton.setBackgroundImage(UIImage(named: "checkButton"), for: .normal)
                } else {
                    cell.checkButton.setBackgroundImage(UIImage(named: "uncheckButton"), for: .normal)
                }
                
                ///1- TableViewCell sendo adicionada pelo código;
                ///2/3- Setamos o delegate e dataSource da tableView da célula;
                ///4- Focus será configurado no momento de Front-End.
    //            cell.conclusionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    //            cell.conclusionsTableView.delegate = cell
    //            cell.conclusionsTableView.dataSource = cell
                cell.thisIndexPath = indexPath
                
                //Tag utilizada para identificar o tópico quando escolhido.
                cell.viewMoreButton.tag = indexPath.row
                
                cell.topicDescription.sizeToFit()
                
                if resetFlag {
                    cell.timerTopicLabel.text = "00:00:00"
                }
                
                if indexPath.row == 2 {
                    self.firstLabelTimerTopic = cell.timerTopicLabel
                }
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let currTopicOnCollection = context.nextFocusedView?.superview?.superview as? TopicsCollectionViewCell {
            UIView.animate(withDuration: 0.2) {
                currTopicOnCollection.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                currTopicOnCollection.contentView.alpha = 1
            }
            
            self.labelTimerTopic = currTopicOnCollection.timerTopicLabel
        }
        
        //
        // Quando mudamos de cell sem fechar a info
        //
        if let _ = context.nextFocusedView?.superview?.superview as? UITableView {}
        else if let prevTopicOnCollectionFlipped = context.previouslyFocusedView?.superview?.superview?.superview as? TopicsCollectionViewCell, prevTopicOnCollectionFlipped.flipped {
            
            UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    prevTopicOnCollectionFlipped.transform = CGAffineTransform(scaleX: 1, y: 1)
                    prevTopicOnCollectionFlipped.contentView.alpha = 0.3
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.01) {
                    prevTopicOnCollectionFlipped.infoView.alpha = 0
                    prevTopicOnCollectionFlipped.layer.shadowOpacity = 0.2
                }
                
            }, completion: { (_) in
                prevTopicOnCollectionFlipped.infoView.isHidden = true
                // Nao é aqui
                prevTopicOnCollectionFlipped.closeButton.transform = CGAffineTransform(scaleX: -1, y: 1)
            })
            prevTopicOnCollectionFlipped.flipped = false
        }
        
        //
        // Quando mudamos de cell com a info fechada
        //
        if let prevTopicOnCollection = context.previouslyFocusedView?.superview?.superview as? TopicsCollectionViewCell, context.nextFocusedIndexPath != context.previouslyFocusedIndexPath {
            // Nao é aqui
                UIView.animate(withDuration: 0.2) {
                    prevTopicOnCollection.transform = CGAffineTransform(scaleX: 1, y: 1)
                    prevTopicOnCollection.contentView.alpha = 0.3
//                }
            }
        }
        
        collectionView.remembersLastFocusedIndexPath = true
        
        if hasPrevious {
            /// Verifica se o anterior possui valor, caso contrário o movimento de swipe foi muito rapido entre os Itens
            if let previousCell = context.previouslyFocusedView?.superview?.superview as? TopicsCollectionViewCell {
                guard let nextCell = context.nextFocusedView?.superview?.superview as? TopicsCollectionViewCell else {
                    return
                }
                let nextIndexPath = topicsCollectionView.indexPath(for: nextCell)
                let indexNext = context.nextFocusedIndexPath
                
                if let previousIndexPath = topicsCollectionView.indexPath(for: previousCell) {
                    print("Index Previous: \(previousIndexPath.row))")
                    print("Index Atual: \(nextIndexPath!.row)")
                    
                    /// Guarda o index do Item que está em foco para utiliza-lo como o ultimo Item de fato acessado
                    if let index = nextIndexPath?.row {
                        previousIndex = index
                    }
                    
                    /// Inicia a contage do Timer do Item atual somente quando o timer for iniciado
                    if timerStarted && nextIndexPath?.row != previousIndexPath.row {
                        /// Pausa o Timer do último Item de fato acessado
                        topicsTimer[previousIndexPath.row].pauseTimer()
                        
                        /// Inicia o Timer é iniciado em relação ao proximo item a ser focado por isso necessita o ( -1 ),
                        /// caso este item perca a referencia o previousIndex de segurança
                        if let _ = nextIndexPath?.row {
                            topicsTimer[nextIndexPath!.row].setTimer()
                        }
                    }
                } else {
                    /// Inicia a contage do Timer do Item atual somente quando o timer for iniciado
                    if timerStarted {
                        /// Pausa o Timer do último Item de fato acessado
                        topicsTimer[previousIndex].pauseTimer()
                        
                        /// Inicia o Timer é iniciado em relação ao proximo item a ser focado por isso necessita o ( -1 ),
                        /// caso este item perca a referencia o previousIndex de segurança
                        if let _ = nextIndexPath?.row {
                            topicsTimer[nextIndexPath!.row].setTimer()
                        }
                    }
                }
            }
        } else {
            hasPrevious = true
        }
        
        //
        // Foco customizado dos botoes
        //
        if let button = context.nextFocusedItem as? UIButton {
            if let cell = button.superview?.superview as? TopicsCollectionViewCell {
                collectionView.isScrollEnabled = false
                let indexPath = collectionView.indexPath(for: cell)
                collectionView.scrollToItem(at: indexPath ?? IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)
                
                let animation = CABasicAnimation(keyPath: "shadowOffset")
                animation.fromValue = button.layer.shadowOffset
                animation.toValue = CGSize(width: 0, height: 10)
                animation.duration = 0.1
                button.layer.shadowOpacity = 0.3
                button.layer.add(animation, forKey: animation.keyPath)
                button.layer.shadowOffset = CGSize(width: 0, height: 10)

                // Nao é aqui
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
                    button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }, completion: nil)
            }
            /// Quando o foco vai para o botao "close" da info.
            if let _ = button.superview?.superview?.superview as? TopicsCollectionViewCell {
                let animation = CABasicAnimation(keyPath: "shadowOffset")
                animation.fromValue = button.layer.shadowOffset
                animation.toValue = CGSize(width: 0, height: 10)
                animation.duration = 0.1
                button.layer.shadowOpacity = 0.3
                button.layer.add(animation, forKey: animation.keyPath)
                button.layer.shadowOffset = CGSize(width: 0, height: 10)

                // Nao é aqui
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
                    button.transform = CGAffineTransform(scaleX: -1.2, y: 1.2)
                }, completion: nil)
            }
        }
        
        if let previousButton = context.previouslyFocusedItem as? UIButton {
                
            if previousButton.titleLabel?.text != "Close" {
                let animation = CABasicAnimation(keyPath: "shadowOffset")
                animation.fromValue = previousButton.layer.shadowOffset
                animation.toValue = CGSize(width: 0, height: 5)
                animation.duration = 0.1
                previousButton.layer.add(animation, forKey: animation.keyPath)
                previousButton.layer.shadowOffset = CGSize(width: 0, height: 5)
                
                // Nao é aqui
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
                    previousButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            } else {
                /// Quando o foco sai do botao "close" da info.
                let animation = CABasicAnimation(keyPath: "shadowOffset")
                animation.fromValue = previousButton.layer.shadowOffset
                animation.toValue = CGSize(width: 0, height: 5)
                animation.duration = 0.1
                previousButton.layer.add(animation, forKey: animation.keyPath)
                previousButton.layer.shadowOffset = CGSize(width: 0, height: 5)
                
                // Nao é aqui
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
                    previousButton.transform = CGAffineTransform(scaleX: -1, y: 1)
                }, completion: nil)
            }
        }
    }
}


extension MeetingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width*0.28, height: self.view.frame.height*0.34)
//        return CGSize(width: 568, height: 414)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.size.width * 0.04
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionView.frame.size.height, left: 0, bottom: 0, right: 0)
    }
}


//MARK:- Decoder Meeting
extension MeetingViewController {
        
    func decoderMeeting() {
        
        let decoder = JSONDecoder()
        
        if let data = meetingData {
            do {
                
                self.meeting = try decoder.decode(Meeting.self, from: data)
                self.meetingTittle.text = self.meeting.theme
                self.topics = self.meeting.selectedTopics
                topics.insert(Topic(record: nil), at: 0)
                topics.insert(Topic(record: nil), at: 0)
                topics.append(Topic(record: nil))
                topics.append(Topic(record: nil))
                self.topicsCollectionView.reloadData()
                
            } catch let error as NSError {
                print("Decoder -> \(error.userInfo)")
            }
        }
    }
}


//MARK:- UIColor Extension
@objc extension UIColor {
    
    @objc convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    @objc func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}



func selectingAnimation(button: UIButton, flag: Bool) {
    
    var time = 0.06
    
    let animation = CABasicAnimation(keyPath: "shadowOffset")
    animation.fromValue = button.layer.shadowOffset
    animation.toValue = CGSize(width: 0, height: 5)
    animation.duration = time + 0.1
    button.layer.add(animation, forKey: animation.keyPath)
    button.layer.shadowOffset = CGSize(width: 0, height: 8)
    
    UIView.animate(withDuration: time, delay: 0, options: [.curveEaseInOut], animations: {
        button.transform = CGAffineTransform(scaleX: flag ? -1.1 : 1.1, y: 1.1)
    }, completion: nil)
    
    let animation2 = CABasicAnimation(keyPath: "shadowOffset")
    animation2.fromValue = button.layer.shadowOffset
    animation2.toValue = CGSize(width: 0, height: 10)
    animation2.duration = time + 0.1
    button.layer.shadowOpacity = 0.3
    button.layer.add(animation2, forKey: animation.keyPath)
    button.layer.shadowOffset = CGSize(width: 0, height: 10)

    UIView.animate(withDuration: time + 0.02, delay: 0.1, options: [.curveEaseInOut], animations: {
        button.transform = CGAffineTransform(scaleX: flag ? -1.2 : 1.2, y: 1.2)
        
    }, completion: nil)
}
