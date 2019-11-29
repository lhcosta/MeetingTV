//
//  Cloud.m
//  SubsCKObjc
//
//  Created by Bernardo Nunes on 28/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

#import "CloudManager.h"

@implementation CloudManager

/// Método utilizado para retornar instancia unica da classe (singleton)
+(CloudManager *) shared {
    static CloudManager *_shared = nil;
    @synchronized(self) {
        if (_shared == nil)
          _shared = [[self alloc] init];
        return _shared;
    }
    return nil;
}

/// Método utilizado para instanciar e retornar database para ser utilizado
- (CKDatabase *)publicCloudDatabase {
    return [[CKContainer containerWithIdentifier: @"iCloud.com.QuartetoFantastico.Meeting"] publicCloudDatabase];
}

/// Método para fazer update de algum record
/// @param records array de records para terem update
/// @param completionPerRecord completion depois de fazer update de cada record
/// @param finalCompletion completion final depois de finalizar a tarefa
- (void) updateRecords:(NSArray <CKRecord *> *)records completionPerRecord:(void (^ _Nullable)(CKRecord * _Nonnull record, NSError * _Nullable error))completionPerRecord completionHandler:(void (^ _Nullable)(void))finalCompletion {
    CKModifyRecordsOperation *operation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:records recordIDsToDelete:nil];
    operation.savePolicy = CKRecordSaveChangedKeys;
    
    operation.perRecordCompletionBlock = completionPerRecord;
    operation.completionBlock = finalCompletion;
    
    [[self publicCloudDatabase] addOperation:operation];
}

- (void) subscribe:(NSString*)recordType withPredicate:(NSPredicate*)predicate desiredKeys:(NSArray<NSString *> *) keys completionHandler:(void (^ _Nullable)(CKSubscription * _Nullable, NSError * _Nullable)) completion{
    
    CKQuerySubscription *subscription = [[CKQuerySubscription alloc] initWithRecordType:recordType predicate:predicate options: CKQuerySubscriptionOptionsFiresOnRecordUpdate];
    
    CKNotificationInfo *notificationInfo = [[CKNotificationInfo alloc] init];
    notificationInfo.desiredKeys = keys;
    notificationInfo.shouldBadge = YES;
    subscription.notificationInfo = notificationInfo;
    
    [[self publicCloudDatabase] saveSubscription:subscription completionHandler:completion];
}

@end
