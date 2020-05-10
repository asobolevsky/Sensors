//
//  PDMGPSTrackerServiceProtocol.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PDMGPSTrackerServiceProtocol <NSObject>

- (void)requestAuthorization;

- (void)startUpdates;
- (void)stopUpdates;

@end
