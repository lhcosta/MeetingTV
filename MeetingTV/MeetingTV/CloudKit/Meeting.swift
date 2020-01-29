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
    var duration : String? {
        get {
            self.record.value(forKey: "duration") as? String ?? "00:00:00"
        }
        
        set {
            self.record.setValue(newValue, forKey: "duration")
        }
    }

    ///Reunião finalizada
    var finished : Bool {
        set {
            self.record.setValue(newValue, forKey: "finished")
        }
        
        get {
            self.record.value(forKey: "finished") as? Bool ?? false
        }
    }
    
    ///Reunião iniciada
    var started : Bool {
        set {
            self.record.setValue(newValue, forKey: "started")
        }
        
        get {
            return self.record.value(forKey: "started") as? Bool ?? false
        }
        
    }
    
    ///Tema da reunião
    var theme : String? {
        return self.record.value(forKey: "theme") as? String
    }
    
    ///Data da realização da reunião
    var date : Date? {
        return self.record.value(forKey: "date") as? Date
    }
    
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
    }
}
