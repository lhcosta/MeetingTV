//
//  Topic.swift
//  MeetingiOS
//
//  Created by Paulo Ricardo on 11/26/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import Foundation
import CloudKit


/// Struct utilizada na criação de uma pauta, edição desta 
struct Topic  {
    
    enum CodingKeys : String, CodingKey {
        case record
    }
    
    //MARK: - Properties
    /// Record do tipo Topic
    private(set) var record: CKRecord!
    
    /// Topico em si.
    var description : String? {
        set { self.record["description"] = newValue }
        get { return self.record.value(forKey: "description") as? String } 
    }
    
    /// Referência do autor do Topic.
    var author: CKRecord.Reference? {
        set { self.record["author"] = newValue }
        get { return self.record.value(forKey: "author") as? CKRecord.Reference}
    }
    
    /// Nome do autor para espelhamaneto na TV. (não sendo necessária a requisição no servidor)
    var authorName : String? {
        set { self.record["authorName"] = newValue }
        get { return self.record.value(forKey: "authorName") as? String}
    }
    
    /// Se já foi discutida ou não durante a reunião
    /// Será usada para filtrar as pautas não discutidas e discutidas para a visualização do autor delas.
    var discussed : Bool {
        set { self.record["discussed"] = newValue }
        get { return self.record.value(forKey: "discussed") as? Bool ?? false}
    }
    
    
    /// O Porquê do Topic ter sido feito pelo author
    var topicPorque: String! {
        set { self.record["topicPorque"] = newValue }
        get { return self.record.value(forKey: "topicPorque") as? String ?? "Não especificado." }
    }
    
    
    /// Conclusões enviadas pelos funcionários/gerente durante a reunião (quando já discutida?)
    var conclusions : [String] {
        set { self.record["conclusions"] = newValue }
        get { return self.record.value(forKey: "conclusions") as? [String] ?? []}
    }
    
    /// Tempo final levado para a discussão da pauta
    /// Este valor é armazenado automaticamente pelo sistema ao término da reunião.
    var duration: String? {
        set { self.record["duration"] = newValue }
        get { return self.record.value(forKey: "duration") as? String}
    }
    
    /// Atributo que decide se o tópico vai ou não para a Meeting, setado peli gerente. (criador da Meeting)
    var selectedForReunion : Bool {
        set { self.record["selectedForReunion"] = newValue }
        get { return self.record.value(forKey: "selectedForReunion") as? Bool ?? false}
    }
    
    /// Atributo utilizado para reconhecer o record (recordID em formato de String)
      var recordName : String {
        get { return self.record.recordID.recordName }
      }
        
    //MARK: - Methods
    /// Adicionar/editar a pauta do Topic
    /// - Parameter description: Pauta em si.
    mutating func editDescription(_ description: String) {
        
        self.description = description
        self.record["description"] = self.description
    }
    
    
    /// Adicionar conclusão nas pautas discutidas.
    /// - Parameter conclusion: Conclusão da pauta.
    mutating func sendConclusion(_ conclusion: String) {
        
        self.conclusions.append(conclusion)
        self.record["conclusions"] = self.conclusions
    }
    
    
    /// Guardar o tempo final da pauta quando esta é encerrada na reunião.
    /// - Parameter duration: Tempo em Date (dia/mês/ano vazios).
    mutating func setDuration(duration: String) {
        self.duration = duration
        self.record["duration"] = self.duration
    }
}

extension Topic : Decodable {
    
    //MARK:- Decoder
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let record_data = try container.decode(Data.self, forKey: .record)
        
        guard let record = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(record_data) as? CKRecord else {return}
        
        self.record = record
    }
    
}
