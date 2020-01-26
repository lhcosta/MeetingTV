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
    
    @IBOutlet var infoButtonWidth: NSLayoutConstraint!
    @IBOutlet var infoButtonHeight: NSLayoutConstraint!
    @IBOutlet var checkButtonWidth: NSLayoutConstraint!
    @IBOutlet var checkButtonHeight: NSLayoutConstraint!
    
    
    var toNextCell = false
    
    var conclusions: [String] = []
    
    var thisIndexPath: IndexPath?
    
    let rightFocusGuide = UIFocusGuide()
    
    var count = 0
    
    var conclusionsArray = [String]()
    
    
    override func awakeFromNib() {
        
        self.contentView.clipsToBounds = false
        setupDesigns()
        setupConstraints()
        setupFocus()
        
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 4, height: 8)
        self.layer.cornerRadius = 6
        
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
    }
    
    
    /// View (filha dessa Cell) que entrará em Focus quando esta CollectionViewCell estiver em Focus.
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [checkButton]
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
    }
    
    
    func setupConstraints() {
        /*Numeros "reais"*/
        self.infoButtonWidth.constant = self.bounds.width*0.4/*0.27*/
        self.infoButtonHeight.constant = self.bounds.height*0.07
        
        self.checkButtonWidth.constant = self.bounds.height*0.08/*0.07*/
        self.checkButtonHeight.constant = self.bounds.height*0.08/*0.07*/
    }
    
    
    func setupFocus() {
        addLayoutGuide(rightFocusGuide)
        rightFocusGuide.leftAnchor.constraint(equalTo: checkButton.rightAnchor).isActive = true
        rightFocusGuide.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightFocusGuide.topAnchor.constraint(equalTo: checkButton.bottomAnchor).isActive = true
        rightFocusGuide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}


//extension TopicsCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        conclusionsArray = []
//        count = 0
//
//        for conclusion in conclusions {
//            if conclusion != "" {
//                conclusionsArray.append(conclusion)
//                count += 1
//            }
//        }
//        print("Array: \(conclusionsArray), conclusions: \(conclusions)")
//        return count
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        /// Setamos a textLabel da TableViewCell com a respecticva Conclusion.
//        print("Con: ", conclusionsArray[indexPath.row])
//        cell.textLabel?.text = conclusionsArray[indexPath.row]
//        return cell
//    }
//
//
//    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        guard let _ = context.nextFocusedItem as? UITableViewCell else { return }
//        rightFocusGuide.preferredFocusEnvironments = [checkButton]
//    }
//}
