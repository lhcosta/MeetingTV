//
//  ConclusionsTableViewCell.swift
//  MeetingTV
//
//  Created by Paulo Ricardo on 1/31/20.
//  Copyright © 2020 Bernardo Nunes. All rights reserved.
//

import UIKit

class ConclusionsTableViewCell: UITableViewCell {
    
    @IBOutlet var conclusionPqLabel: UILabel!
    @IBOutlet var circle: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupFocus()
    }
    
    
    func setupFocus() {
        
        circle.layer.masksToBounds = false
        circle.layer.shadowOpacity = 0.3
        circle.layer.shadowRadius = 1
        circle.layer.shadowOffset = CGSize(width: 1, height: 2)
        circle.clipsToBounds = false
        circle.layer.cornerRadius = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
