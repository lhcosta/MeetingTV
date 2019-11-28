//
//  Meeting.swift
//  MeetingiOS
//
//  Created by Lucas Costa  on 25/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import Foundation
import CloudKit

/**
Struct utilizada para criar um nova reunião, Update de Meeting ou
utilizar como auxílio de manipulação de CKRecord Meeting
- Author: Lucas Costa 
 */

struct Meeting {
    
    //MARK:- JSON keys
    enum CodingKeys : CodingKey {
        case record, selectedTopics
    }
    
    //MARK:- Properties
    
    ///Record do tipo Meeting
    private(set) var record : CKRecord!
    
    ///Topicos que foram selecionados para reuniao
    private(set) var selectedTopics : [Topic] = []

    ///Duração da reunião
    var duration : Int64? {
        didSet {
            self.record.setValue(duration, forKey: "duration")
        }
    }

    ///Reunião finalizada
    var finished = Bool() {
        didSet {
            self.record.setValue(finished, forKey: "finished")
        }
    }
    
    ///Reunião iniciada
    var started = Bool(){
        didSet {
            self.record.setValue(started, forKey: "started")
        }
    }
    
    ///Tema da reunião
    private(set) var theme : String?
    
    ///Data da realização da reunião
    private(set) var date : Date?
    
}

extension Meeting : Decodable {
    
    //MARK:- Decoder
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let record_data = try container.decode(Data.self, forKey: .record)
        let topics = try container.decode([Topic].self, forKey: .selectedTopics) 
        
        guard let record = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(record_data) as? CKRecord else {return}
        
        self.record = record
        self.selectedTopics = topics
        self.duration = record.value(forKey: "duration") as? Int64
        self.finished = record.value(forKey: "finished") as? Bool ?? false
        self.started = record.value(forKey: "started") as? Bool ?? false
        self.date = record.value(forKey: "date") as? Date
        self.theme = record.value(forKey: "theme") as? String ?? ""
    }
}
