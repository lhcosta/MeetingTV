//
//  Chronometer.h
//  MeetingTV
//
//  Created by Caio Azevedo on 27/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

#ifndef Timer_h
#define Timer_h


#endif /* Chronometer_h */

@interface Chronometer {

    NSTimer *timer;
    int seconds;
    int minutes;
    int hours;

}

- (void)config;
- (void)setTimer;
- (void)updateTimer;

@end
