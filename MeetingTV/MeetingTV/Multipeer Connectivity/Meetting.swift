//
//  Meetting.swift
//  MeetingTV
//
//  Created by Lucas Costa  on 27/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import Foundation
import CloudKit

struct Meeting : Decodable {
    
    enum CodingKeys : CodingKey {
        case record, selectedTopics, employees
    }
    
    var record : CKRecord?
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let record_data = try container.decode(Data.self, forKey: .record) 
        
        self.record = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(record_data) as? CKRecord
    }
    
}
