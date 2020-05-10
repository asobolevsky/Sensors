//
//  PDMAccelerometerServiceProtocol.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDMAccelerometerData;

@protocol PDMAccelerometerServiceObserver <NSObject, NSCopying>

- (void)accelerometerDidUpdateWithData:(PDMAccelerometerData *)accelerometerData;

@end


@protocol PDMAccelerometerServiceProtocol <NSObject>

- (void)startUpdates;
- (void)stopUpdates;

- (void)registerObserver:(id<PDMAccelerometerServiceObserver>)observer timeinterval:(NSTimeInterval)timeinterval;
- (void)removeObserver:(id<PDMAccelerometerServiceObserver>)observer;

@end
