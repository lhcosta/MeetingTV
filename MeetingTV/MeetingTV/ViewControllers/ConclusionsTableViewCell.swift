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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
