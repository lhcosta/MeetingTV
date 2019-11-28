//
//  Chronometer.m
//  MeetingTV
//
//  Created by Caio Azevedo on 27/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timer.h"

@interface Chronometer ()

@end

@implementation
- (void)config {
    seconds = 0;
    minutes = 0;
    hours = 0;
    
    [self setTimer];
}

- (void)setTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector: @selector(updateTimer) userInfo: nil repeats: YES];
}

- (void)updateTimer {
    seconds += 1;
    if (seconds == 60) {
        minutes += 1;
        seconds = 0;
    }
    if (minutes == 60) {
        hours += 1;
        minutes = 0;
    }
    
    NSString *secondsString = [NSString stringWithFormat:@"%02d", seconds];
    NSString *minutesString = [NSString stringWithFormat:@"%02d:", minutes];
    NSString *hoursString = [NSString stringWithFormat:@"%02d:", hours];
    
    NSString *chronometerString = [hoursString stringByAppendingFormat:@"%@", minutesString];
    NSString *chronometerString2 = [chronometerString stringByAppendingFormat:@"%@", secondsString];
    
//    _labelTimer.text = chronometerString2;
}

@protocol UpdateTimerDelegate <NSObject>

<#methods#>

@end
