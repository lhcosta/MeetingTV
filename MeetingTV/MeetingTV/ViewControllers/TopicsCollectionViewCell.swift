//
//  TopicsCollectionViewCell.swift
//  MeetingTV
//
//  Created by Paulo Ricardo on 11/27/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import UIKit

/// CollectionView para a exibição dos Topics da Meeting.
class TopicsCollectionViewCell: UICollectionViewCell {    
    
    /// Label da Topic em si.
    @IBOutlet var topicDescription: UILabel!
    
    /// Label do author da Topic.
    @IBOutlet var topicAuthor: UILabel!
    
    /// TableView que conterá uma lista das Conclusions desse Topic.
//    @IBOutlet var conclusionsTableView: UITableView!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var viewMoreButton: UIButton!
    @IBOutlet var separatorView: UIView!
    @IBOutlet var conclusionsTableView: UITableView!
    
    
    @IBOutlet var infoButtonWidth: NSLayoutConstraint!
    @IBOutlet var infoButtonHeight: NSLayoutConstraint!
    @IBOutlet var checkButtonWidth: NSLayoutConstraint!
    @IBOutlet var checkButtonHeight: NSLayoutConstraint!
    @IBOutlet var closeButtonWidth: NSLayoutConstraint!
    @IBOutlet var closeButtonHeight: NSLayoutConstraint!
    
    @IBOutlet var infoView: UIView!
    
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var timerTopicLabel: UILabel!
    
    
    var toNextCell = false
    
    var conclusions: [String] = []
    
    var topicPorque: String?
    
    var thisIndexPath: IndexPath?
    
    let rightFocusGuide = UIFocusGuide()
    let leftFocusGuide = UIFocusGuide()
    
    var count = 0
    
    var conclusionsArray = [String]()
    
    var flipped = false {
        didSet {
            rightFocusGuide.isEnabled = !rightFocusGuide.isEnabled
            leftFocusGuide.isEnabled = !leftFocusGuide.isEnabled
        }
    }
    
    
//    override var preferredFocusedView: UIView? {
//        if !flipped {
//            return checkButton
//        } else {
//            return closeButton
//        }
//    }
    
    override func awakeFromNib() {
        
        self.conclusionsTableView.delegate = self
        self.conclusionsTableView.dataSource = self
        self.conclusionsTableView.flashScrollIndicators()
        self.contentView.clipsToBounds = false
        setupDesigns()
        setupConstraints()
        setupFocus()
        
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 4, height: 8)
        self.layer.cornerRadius = 18
        
        infoView.layer.shadowOpacity = 0.2
        infoView.layer.shadowRadius = 5
        infoView.layer.shadowOffset = CGSize(width: -4, height: 8)
        infoView.layer.cornerRadius = 18
        
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        self.closeButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        self.conclusionsTableView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    
    /// View (filha dessa Cell) que entrará em Focus quando esta CollectionViewCell estiver em Focus.
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if !flipped {
            return [checkButton]
        } else {
            return [closeButton]
        }
    }
    
    
    override var canBecomeFocused: Bool {
        return false
    }
    
    
    func setupDesigns() {
        
        viewMoreButton.layer.masksToBounds = false
        viewMoreButton.layer.shadowOpacity = 0.2
        viewMoreButton.layer.shadowRadius = 7
        viewMoreButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        viewMoreButton.clipsToBounds = false
        viewMoreButton.layer.cornerRadius = 7
        
        checkButton.setBackgroundImage(UIImage(named: "uncheckButton"), for: .normal)
        checkButton.layer.masksToBounds = false
        checkButton.layer.shadowOpacity = 0.2
        checkButton.layer.shadowRadius = 5
        checkButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        checkButton.clipsToBounds = false
        checkButton.layer.cornerRadius = 7
        
        closeButton.layer.masksToBounds = false
        closeButton.layer.shadowOpacity = 0.2
        closeButton.layer.shadowRadius = 7
        closeButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        closeButton.clipsToBounds = false
        closeButton.layer.cornerRadius = 7
    }
    
    
    func setupConstraints() {
        /*Numeros "reais"*/
        self.infoButtonWidth.constant = self.bounds.width*0.27
        self.infoButtonHeight.constant = self.bounds.height*0.06
        
        self.closeButtonWidth.constant = self.bounds.width*0.27
        self.closeButtonHeight.constant = self.bounds.height*0.06

        self.checkButtonWidth.constant = self.bounds.height*0.06/*0.06*/
        self.checkButtonHeight.constant = self.bounds.height*0.06/*0.06*/
    }
    
    
    func setupFocus() {
        addLayoutGuide(rightFocusGuide)
//        rightFocusGuide.leftAnchor.constraint(equalTo: checkButton.rightAnchor).isActive = true
        rightFocusGuide.widthAnchor.constraint(equalToConstant: 1).isActive = true
        rightFocusGuide.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightFocusGuide.topAnchor.constraint(equalTo: conclusionsTableView.topAnchor).isActive = true
        rightFocusGuide.bottomAnchor.constraint(equalTo: conclusionsTableView.bottomAnchor).isActive = true
        rightFocusGuide.isEnabled = false
        
        addLayoutGuide(leftFocusGuide)
        leftFocusGuide.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        leftFocusGuide.widthAnchor.constraint(equalToConstant: 1).isActive = true
//        leftFocusGuide.rightAnchor.constraint(equalTo: viewMoreButton.leftAnchor).isActive = true
        leftFocusGuide.topAnchor.constraint(equalTo: conclusionsTableView.topAnchor).isActive = true
        leftFocusGuide.bottomAnchor.constraint(equalTo: conclusionsTableView.bottomAnchor).isActive = true
        leftFocusGuide.isEnabled = false
    }
    
    
    @IBAction func viewMore(_ sender: Any) {
        
        UIView.animateKeyframes(withDuration: 0.35, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.transform = CGAffineTransform(scaleX: -1.1, y: 1.1)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.01) {
                self.infoView.isHidden = false
                self.infoView.alpha = 1
                self.layer.shadowOpacity = 0
            }
            
        }, completion: { (_) in
            self.flipped = true
            self.setNeedsFocusUpdate()
            self.updateFocusIfNeeded()
//            self.rightFocusGuide.isEnabled = true
//            self.leftFocusGuide.isEnabled = true
        })
    }
    
    
    @IBAction func closeInfo(_ sender: Any) {
        
        selectingAnimation(button: sender as! UIButton, flag: true)
        
        UIView.animateKeyframes(withDuration: 0.35, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.01) {
                self.infoView.alpha = 0
                self.layer.shadowOpacity = 0.2
            }
            
        }, completion: { (_) in
            self.infoView.isHidden = true
            self.flipped = false
            self.setNeedsFocusUpdate()
            self.updateFocusIfNeeded()
            self.closeButton.transform = CGAffineTransform(scaleX: -1, y: 1)
//            self.rightFocusGuide.isEnabled = false
//            self.leftFocusGuide.isEnabled = false
        })
    }
}


extension TopicsCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.conclusions.last != "" {
            return self.conclusions.count + 1
        }
        return self.conclusions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "conclusion") as! ConclusionsTableViewCell
        if indexPath.row == 0 {
            cell.conclusionPqLabel.text = self.topicPorque?.isEmpty ?? false ? self.topicPorque : NSLocalizedString("Not specified.", comment: "") 
        } else if self.conclusions[indexPath.row-1] != "" {
            cell.conclusionPqLabel.text = self.conclusions[indexPath.row-1]
        }
        cell.conclusionPqLabel.sizeToFit()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let previousCell = context.previouslyFocusedView as? ConclusionsTableViewCell {
            
            let animation = CABasicAnimation(keyPath: "shadowOffset")
            animation.fromValue = previousCell.circle.layer.shadowOffset
            animation.toValue = CGSize(width: 1, height: 2)
            animation.duration = 0.1
            previousCell.circle.layer.shadowOpacity = 0.3
            previousCell.circle.layer.add(animation, forKey: animation.keyPath)
            previousCell.circle.layer.shadowOffset = CGSize(width: 1, height: 2)
            
            UIView.animate(withDuration: 0.1) {
                previousCell.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
                previousCell.circle.tintColor = UIColor(hexString: "#002CBF")
            }
        }
        
        
        if let nextCell = context.nextFocusedView as? ConclusionsTableViewCell {
            
            let animation = CABasicAnimation(keyPath: "shadowOffset")
            animation.fromValue = nextCell.circle.layer.shadowOffset
            animation.toValue = CGSize(width: 3, height: 4)
            animation.duration = 0.1
            nextCell.circle.layer.shadowOpacity = 0.3
            nextCell.circle.layer.add(animation, forKey: animation.keyPath)
            nextCell.circle.layer.shadowOffset = CGSize(width: 3, height: 4)
            
            UIView.animate(withDuration: 0.1) {
                nextCell.circle.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                nextCell.circle.tintColor = UIColor(hexString: "#003FFF")
            }
        }
    }
}
