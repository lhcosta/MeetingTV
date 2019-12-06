//
//  Chronometer.m
//  MeetingTV
//
//  Created by Caio Azevedo on 27/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chronometer.h"

@implementation Chronometer

- (instancetype)initWithDelegate:(id<UpdateTimerDelegate>) delegate{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}

- (void)config {
    _seconds = 0;
    _minutes = 0;
    _hours = 0;
}

- (void)setTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector: @selector(updateTimer) userInfo: nil repeats: YES];
}

- (void)updateTimer {
    _seconds += 1;
    if (_seconds == 60) {
        _minutes += 1;
        _seconds = 0;
    }
    if (_minutes == 60) {
        _hours += 1;
        _minutes = 0;
    }
    
    NSString *secondsString = [NSString stringWithFormat:@"%02ld", (long)_seconds];
    NSString *minutesString = [NSString stringWithFormat:@"%02ld:", (long)_minutes];
    NSString *hoursString = [NSString stringWithFormat:@"%02ld:", (long)_hours];
    
    NSString *chronometerString = [hoursString stringByAppendingFormat:@"%@", minutesString];
    NSString *chronometerString2 = [chronometerString stringByAppendingFormat:@"%@", secondsString];
    
    [_delegate updateLabelDelegate:(chronometerString2)];
}

- (NSString*) getTime {
    NSString *secondsString = [NSString stringWithFormat:@"%02ld", (long)_seconds];
    NSString *minutesString = [NSString stringWithFormat:@"%02ld:", (long)_minutes];
    NSString *hoursString = [NSString stringWithFormat:@"%02ld:", (long)_hours];
    
    NSString *chronometerString = [hoursString stringByAppendingFormat:@"%@", minutesString];
    NSString *chronometerString2 = [chronometerString stringByAppendingFormat:@"%@", secondsString];
    
    return chronometerString2;
}

- (void)pauseTimer {
    [_timer invalidate];
}
@end

