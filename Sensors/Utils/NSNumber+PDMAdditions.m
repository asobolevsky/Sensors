//
//  NSNumber+PDMAdditions.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "NSNumber+PDMAdditions.h"

@implementation NSNumber (PDMAdditions)

- (NSInteger)pdm_signum
{
    double n = self.doubleValue;
    return (n < 0) ? -1 : (n > 0) ? +1 : 0;
}

@end
