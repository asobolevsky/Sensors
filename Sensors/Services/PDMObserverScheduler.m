//
//  PDMObserverScheduler.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "PDMObserverScheduler.h"
#import "PDMUtils.h"

NSTimeInterval const kPDMMinObserverUpdateInterval = 1 / 20.f;

@interface PDMObserverScheduler ()

@property (nonatomic, strong) NSMutableDictionary<id, NSTimer *> *observers;

@end


@implementation PDMObserverScheduler

- (instancetype)init
{
    self = [super init];
    if (self != nil) {

    }
    return self;
}

- (void)registerObserver:(id)observer timeinterval:(NSTimeInterval)timeinterval
{
    if (timeinterval < kPDMMinObserverUpdateInterval) {
        timeinterval = kPDMMinObserverUpdateInterval;
    }

    NSTimer *timer;
    if ([self.observers objectForKey:observer] != nil) {
        timer = (NSTimer *)[self.observers objectForKey:observer];
        [timer invalidate];
        self.observers[observer] = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:timeinterval
                                             target:self.delegate
                                           selector:@selector(updateObserverWithTimer:)
                                           userInfo:observer repeats:YES];
    self.observers[observer] = timer;
}

- (void)removeObserver:(id)observer
{
    if ([self.observers objectForKey:observer] != nil) {
        var timer = (NSTimer *)[self.observers objectForKey:observer];
        [timer invalidate];
        [self.observers removeObjectForKey:observer];
    }
}

@end
