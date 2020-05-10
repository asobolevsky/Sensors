//
//  PDMAccelerometerServiceProtocol.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDMAccelerometerData;

@protocol PDMAccelerometerServiceProtocol <NSObject>

@property (nonatomic, strong, readonly) PDMAccelerometerData *accelerometerData;

- (void)startAccelerometerUpdates;
- (void)stopAccelerometerUpdates;

@end
