//
//  Chronometer.h
//  MeetingTV
//
//  Created by Caio Azevedo on 27/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

#ifndef Timer_h
#define Timer_h

#import <UIKit/UIKit.h>

#endif /* Chronometer_h */

@protocol UpdateTimerDelegate

- (void)updateLabelDelegateMeeting:(NSString*)stringLabel;
- (void)updateLabelDelegateTopic:(NSString*)stringLabel;

@end

@interface Chronometer : NSObject 

- (instancetype)initWithDelegate:(id<UpdateTimerDelegate>) delegate isMeeting:(BOOL) isMeeting;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger seconds;
@property (nonatomic) NSInteger minutes;
@property (nonatomic) NSInteger hours;
@property (nonatomic, weak) id< UpdateTimerDelegate > delegate;
@property (nonatomic) BOOL isMeeting;

- (void)config;
- (void)setTimer;
- (void)updateTimer;
- (void)pauseTimer;
- (NSString*)getTime;
@end
