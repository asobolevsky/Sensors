//
//  PDMAccelerometerData.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "PDMAccelerometerData.h"

@implementation PDMAccelerometerData

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.count = 0;
        self.current = (PDMVector3) { .x = 0, .y = 0, .z = 0};
        self.max = (PDMVector3) { .x = 0, .y = 0, .z = 0};
        self.min = (PDMVector3) { .x = 0, .y = 0, .z = 0};
        self.mean = (PDMVector3) { .x = 0, .y = 0, .z = 0};
        self.median = (PDMVector3) { .x = 0, .y = 0, .z = 0};
        self.stdev = (PDMVector3) { .x = 0, .y = 0, .z = 0};
        self.zeroCrossings = (PDMVector3) { .x = 0, .y = 0, .z = 0};
    }
    return self;
}

@end
