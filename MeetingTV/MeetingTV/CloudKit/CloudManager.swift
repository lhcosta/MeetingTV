//
//  CloudManager.swift
//  MeetingiOS
//
//  Created by Bernardo Nunes on 26/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import Foundation
import CloudKit

/// Classe com métodos genêricos CRUD para CloudKit
class CloudManager {
    
    static let shared = CloudManager()
    private let database = CKContainer(identifier: "iCloud.com.QuartetoFantastico.Meeting").publicCloudDatabase
    
    /// Método que cria CKModifyRecordsOperation a partir de container padrao
    /// - Parameters:
    ///   - savePolicy: savepolicy da operacao
    ///   - perRecordCompletion: completion que será executado após cada record
    ///   - finalCompletion: completion final após final da operação
    private func setOP(savePolicy: CKModifyRecordsOperation.RecordSavePolicy, perRecordCompletion: @escaping ((CKRecord, Error?) -> Void), finalCompletion: @escaping (() -> Void)) -> CKModifyRecordsOperation {
        let operation = CKModifyRecordsOperation()
        operation.savePolicy = savePolicy
        
        operation.perRecordCompletionBlock = {(record, error) in
            perRecordCompletion(record, error)
        }
        
        operation.completionBlock = {
            finalCompletion()
        }
        
        return operation
    }
    
    /// Método que faz update nos records
    /// - Parameters:
    ///   - records: Array de ckrecords para serem alterados
    ///   - perRecordCompletion: completion que será executado após cada record
    ///   - finalCompletion: completion final após final da operação
    func updateRecords(records: [CKRecord], perRecordCompletion: @escaping ((CKRecord, Error?) -> Void), finalCompletion: @escaping (() -> Void)){
        let updateOp = setOP(savePolicy: .changedKeys, perRecordCompletion: perRecordCompletion, finalCompletion: finalCompletion)
        updateOp.recordsToSave = records
        
        database.add(updateOp)
    }
}
