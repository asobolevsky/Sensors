//
//  PDMGPSTrackerServiceProtocol.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDMGPSTrackerData;

@protocol PDMGPSTrackerServiceObserver <NSObject, NSCopying>

- (void)gpsTrackerDidUpdateWithData:(PDMGPSTrackerData *)gpsTrackerData;

@end

@protocol PDMGPSTrackerServiceProtocol <NSObject>

- (void)requestAuthorization;

- (void)startUpdates;
- (void)stopUpdates;

- (void)registerObserver:(id<PDMGPSTrackerServiceObserver>)observer timeinterval:(NSTimeInterval)timeinterval;
- (void)removeObserver:(id<PDMGPSTrackerServiceObserver>)observer;

@end
