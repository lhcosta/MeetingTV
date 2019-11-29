//
//  Cloud.h
//  SubsCKObjc
//
//  Created by Bernardo Nunes on 28/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CloudManager : NSObject
+(CloudManager *) shared;
- (void) updateRecords:(NSArray <CKRecord *> *)records completionPerRecord:(void (^ _Nullable)(CKRecord * _Nonnull record, NSError * _Nullable error))completionPerRecord completionHandler:(void (^ _Nullable)(void))finalCompletion;

- (void) subscribe:(NSString*)recordType withPredicate:(NSPredicate*)predicate desiredKeys:(NSArray<NSString *> *) keys completionHandler:(void (^ _Nullable)(CKSubscription * _Nullable, NSError * _Nullable)) completion;
@end

NS_ASSUME_NONNULL_END
