//
//  PDMGPSTrackerService.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "PDMGPSTrackerService.h"
#import <CoreLocation/CoreLocation.h>

NSInteger const kPDMDistanceFilterValue = 10;

@interface PDMGPSTrackerService () <CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray<CLLocation *> *lastLocations;
@property (nonatomic, assign) CLLocationDistance totalDistance;
@property (nonatomic, strong) NSTimer *walkTimer;

@end

@implementation PDMGPSTrackerService

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _lastLocations = [NSMutableArray array];
        _totalDistance = 0;
    }
    return self;
}

- (void)requestAuthorization
{
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)startUpdates
{
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kPDMDistanceFilterValue;
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdates
{
    [self.locationManager stopUpdatingLocation];
}

- (void)filterLocations
{


    @synchronized (self.lastLocations) {
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    for (CLLocation *newLocation in locations) {
        NSTimeInterval timeSpan = newLocation.timestamp.timeIntervalSinceNow;
        if (newLocation.horizontalAccuracy < 20 && fabs(timeSpan) < 10) {
            if (self.lastLocations.lastObject != nil) {
                CLLocationDistance delta =  [newLocation distanceFromLocation:self.lastLocations.lastObject];
                self.totalDistance += delta;
            }
            @synchronized (self.lastLocations) {
                [self.lastLocations addObject:newLocation];
            }
        }
    }
}

@end
