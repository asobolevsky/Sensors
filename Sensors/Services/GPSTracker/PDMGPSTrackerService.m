//
//  PDMGPSTrackerService.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "PDMGPSTrackerData.h"
#import "PDMGPSTrackerService.h"
#import "PDMObserverScheduler.h"
#import "PDMUtils.h"
#import <CoreLocation/CoreLocation.h>

NSInteger const kPDMDistanceFilterValue = 10;
NSTimeInterval const kPDMWalkDurationInSeconds = 60 * 3;

@interface PDMGPSTrackerService () <CLLocationManagerDelegate, PDMObserverSchedulerDelegate>

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, strong, readonly) PDMObserverScheduler *scheduler;
@property (nonatomic, strong) NSMutableArray<CLLocation *> *lastLocations;
@property (nonatomic, assign) CLLocationDistance totalDistance;

@end

@implementation PDMGPSTrackerService

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _scheduler = [[PDMObserverScheduler alloc] init];
        _scheduler.delegate = self;
        _lastLocations = [NSMutableArray array];
        _totalDistance = 0;
    }
    return self;
}

- (void)requestAuthorization
{
    [self.locationManager requestWhenInUseAuthorization];
}

- (PDMGPSTrackerData *)gpsTrackerData
{
    var data = [[PDMGPSTrackerData alloc] init];
    data.distance = self.totalDistance;
    return data;
}

- (void)startUpdates
{
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kPDMDistanceFilterValue;

    [self requestAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdates
{
    [self.locationManager stopUpdatingLocation];
}

- (void)filterLocations
{
    var currentDate = NSDate.date;
    var calendar = NSCalendar.currentCalendar;
    var targetDate =  [calendar dateByAddingUnit:NSCalendarUnitSecond
                                           value:-kPDMWalkDurationInSeconds
                                          toDate:currentDate
                                         options:0];
    @synchronized (self.lastLocations) {
        var indicesToDelete = [[NSMutableIndexSet alloc] init];
        for (NSInteger i = 0; i + 1 < self.lastLocations.count; i++) {
            var location = self.lastLocations[i];
            var nextLocation = self.lastLocations[i + 1];
            if (location.timestamp.timeIntervalSinceNow < targetDate.timeIntervalSinceNow) {
                var delta = [nextLocation distanceFromLocation:location];
                self.totalDistance -= delta;
                [indicesToDelete addIndex:i];
            }
        }
        if (indicesToDelete.count > 0) {
            [self.lastLocations removeObjectsAtIndexes:indicesToDelete];
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    for (CLLocation *newLocation in locations) {
        NSTimeInterval timeSpan = newLocation.timestamp.timeIntervalSinceNow;
        if (newLocation.horizontalAccuracy < 20 && fabs(timeSpan) < 10) {
            if (self.lastLocations.lastObject != nil) {
                var delta = [newLocation distanceFromLocation:self.lastLocations.lastObject];
                self.totalDistance += delta;
            }
            @synchronized (self.lastLocations) {
                [self.lastLocations addObject:newLocation];
            }
        }
    }
}

- (void)registerObserver:(id<PDMGPSTrackerServiceObserver>)observer timeinterval:(NSTimeInterval)timeinterval
{
    [self.scheduler registerObserver:observer timeinterval:timeinterval];
}

- (void)removeObserver:(id<PDMGPSTrackerServiceObserver>)observer
{
    [self.scheduler removeObserver:observer];
}


#pragma mark - PDMObserverSchedulerDelegate

- (void)updateObserverWithTimer:(NSTimer *)timer
{
    if (timer.isValid && [timer.userInfo conformsToProtocol:@protocol(PDMGPSTrackerServiceObserver)]) {
        [self filterLocations];
        var observer = (id<PDMGPSTrackerServiceObserver>)timer.userInfo;
        [observer gpsTrackerDidUpdateWithData:self.gpsTrackerData];
    }
}

@end
