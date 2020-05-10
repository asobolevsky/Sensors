//
//  PDMHeap.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDMHeap : NSObject

@property (nonatomic, assign, readonly) double top;
@property (nonatomic, assign, readonly) NSUInteger count;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithComparator:(BOOL(^)(double, double))comparator;

- (void)insert:(double)d;
- (double)extractTop;

@end
