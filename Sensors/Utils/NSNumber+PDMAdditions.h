//
//  NSNumber+PDMAdditions.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (PDMAdditions)

@property (nonatomic, assign, readonly) NSInteger pdm_signum;

@end
