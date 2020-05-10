//
//  PDMRunningCalculator.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDMRunningCalculator : NSObject

@property (nonatomic, assign, readonly) double min;
@property (nonatomic, assign, readonly) double max;
@property (nonatomic, assign, readonly) double mean;
@property (nonatomic, assign, readonly) double median;
@property (nonatomic, assign, readonly) double stdev;
@property (nonatomic, assign, readonly) NSUInteger zeroCrossings;

- (void)append:(double)n;

@end
