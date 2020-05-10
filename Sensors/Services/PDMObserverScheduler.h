//
//  PDMObserverScheduler.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PDMObserverSchedulerDelegate <NSObject>

- (void)updateObserverWithTimer:(NSTimer *)timer;

@end


@interface PDMObserverScheduler : NSObject

@property (nonatomic, weak) id<PDMObserverSchedulerDelegate> delegate;

- (void)registerObserver:(id)observer timeinterval:(NSTimeInterval)timeinterval;
- (void)removeObserver:(id)observer;

@end
