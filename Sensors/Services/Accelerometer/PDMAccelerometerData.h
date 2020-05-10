//
//  PDMAccelerometerData.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "PDMUtils.h"
#import <Foundation/Foundation.h>

@interface PDMAccelerometerData : NSObject

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) PDMVector3 current;
@property (nonatomic, assign) PDMVector3 min;
@property (nonatomic, assign) PDMVector3 max;
@property (nonatomic, assign) PDMVector3 mean;
@property (nonatomic, assign) PDMVector3 median;
@property (nonatomic, assign) PDMVector3 stdev;
@property (nonatomic, assign) PDMVector3 zeroCrossings;

@end
