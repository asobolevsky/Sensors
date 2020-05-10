//
//  PDMAccelerometerService.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "PDMAccelerometerService.h"
#import "PDMAccelerometerData.h"
#import "PDMRunningCalculator.h"
#import "PDMUtils.h"
#import <CoreMotion/CoreMotion.h>

static NSString *const kPDMQueueName = @"com.poissondumars.PDMAccelerometerService";
NSTimeInterval const kPDMAccelerometerUpdateInterval = 1 / 20.f;

@interface PDMAccelerometerService ()

@property (nonatomic, strong, readonly) NSOperationQueue *queue;
@property (nonatomic, strong, readonly) CMMotionManager *motionManager;
@property (nonatomic, strong, readonly) PDMRunningCalculator *xCalculator;
@property (nonatomic, strong, readonly) PDMRunningCalculator *yCalculator;
@property (nonatomic, strong, readonly) PDMRunningCalculator *zCalculator;
@property (nonatomic, assign) NSUInteger updatesReceived;

@end


@implementation PDMAccelerometerService

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = kPDMQueueName;
        _queue.maxConcurrentOperationCount = 1;
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = kPDMAccelerometerUpdateInterval;
        _xCalculator = [[PDMRunningCalculator alloc] init];
        _yCalculator = [[PDMRunningCalculator alloc] init];
        _zCalculator = [[PDMRunningCalculator alloc] init];
        _updatesReceived = 0;
    }
    return self;
}

- (PDMAccelerometerData *)accelerometerData
{
    PDMAccelerometerData *accelerometerData = [[PDMAccelerometerData alloc] init];
    @synchronized (self) {
        accelerometerData.count = self.updatesReceived;
        accelerometerData.current = (PDMVector3) {
            .x = self.xCalculator.current,
            .y = self.yCalculator.current,
            .z = self.zCalculator.current
        };
        accelerometerData.min = (PDMVector3) {
            .x = self.xCalculator.min,
            .y = self.yCalculator.min,
            .z = self.zCalculator.min
        };
        accelerometerData.max = (PDMVector3) {
            .x = self.xCalculator.max,
            .y = self.yCalculator.max,
            .z = self.zCalculator.max
        };
        accelerometerData.mean = (PDMVector3) {
            .x = self.xCalculator.mean,
            .y = self.yCalculator.mean,
            .z = self.zCalculator.mean
        };
        accelerometerData.median = (PDMVector3) {
            .x = self.xCalculator.median,
            .y = self.yCalculator.median,
            .z = self.zCalculator.median
        };
        accelerometerData.stdev = (PDMVector3) {
            .x = self.xCalculator.stdev,
            .y = self.yCalculator.stdev,
            .z = self.zCalculator.stdev
        };
        accelerometerData.zeroCrossings = (PDMVector3) {
            .x = self.xCalculator.zeroCrossings,
            .y = self.yCalculator.zeroCrossings,
            .z = self.zCalculator.zeroCrossings
        };
    }
    return accelerometerData;
}

- (void)startAccelerometerUpdates
{
    if (self.motionManager.isAccelerometerAvailable && self.motionManager.accelerometerActive == NO)
        [self.motionManager startAccelerometerUpdatesToQueue:self.queue
                                                 withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            if (accelerometerData != nil) {
                [self processAccelerometerData:accelerometerData];
            }
        }];
}

- (void)stopAccelerometerUpdates
{
    [self.motionManager stopAccelerometerUpdates];
}

- (void)processAccelerometerData:(CMAccelerometerData *)accelerometerData
{
    self.updatesReceived += 1;
    [self.xCalculator append:accelerometerData.acceleration.x];
    [self.yCalculator append:accelerometerData.acceleration.y];
    [self.zCalculator append:accelerometerData.acceleration.z];
}

@end
