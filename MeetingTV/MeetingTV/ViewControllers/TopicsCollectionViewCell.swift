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
    @IBOutlet var conclusionsTableView: UITableView!
    
    var conclusions: [String] = []
    
    /// Focus será terminado no momento do Front-End.
//    let bottomFocusGuide = UIFocusGuide()
//    let topFocusGuide = UIFocusGuide()
//    let leftFocusGuide = UIFocusGuide()
//    let rightFocusGuide = UIFocusGuide()
    
    
    /// View (filha dessa Cell) que entrará em Focus quando esta CollectionViewCell estiver em Focus.
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [conclusionsTableView]
    }
    
    
    /// Focus será terminado no momento do Front-End.
//    func updateFocus() {
//
//        addLayoutGuide(bottomFocusGuide)
//        bottomFocusGuide.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        bottomFocusGuide.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        bottomFocusGuide.topAnchor.constraint(equalTo: self.conclusionsTableView.bottomAnchor).isActive = true
//        bottomFocusGuide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//
//        addLayoutGuide(topFocusGuide)
//        topFocusGuide.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        topFocusGuide.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        topFocusGuide.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        topFocusGuide.bottomAnchor.constraint(equalTo: self.topicAuthor.topAnchor).isActive = true
//
//        addLayoutGuide(leftFocusGuide)
//        leftFocusGuide.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        leftFocusGuide.rightAnchor.constraint(equalTo: self.conclusionsTableView.leftAnchor).isActive = true
//        leftFocusGuide.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        leftFocusGuide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//
//        addLayoutGuide(rightFocusGuide)
//        rightFocusGuide.leftAnchor.constraint(equalTo: self.conclusionsTableView.rightAnchor).isActive = true
//        rightFocusGuide.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        rightFocusGuide.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        rightFocusGuide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//    }
}


extension TopicsCollectionViewCell: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conclusions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        /// Setamos a textLabel da TableViewCell com a respecticva Conclusion.
        cell.textLabel?.text = conclusions[indexPath.row]
        return cell
    }
}
