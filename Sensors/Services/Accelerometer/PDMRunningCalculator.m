//
//  PDMRunningCalculator.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "PDMRunningCalculator.h"
#import "PDMHeap.h"
#import "NSNumber+PDMAdditions.h"

@interface PDMRunningCalculator ()

@property (nonatomic, assign) double min;
@property (nonatomic, assign) double max;
@property (nonatomic, assign) NSUInteger zeroCrossings;
@property (nonatomic, assign) NSUInteger runningCount;
@property (nonatomic, assign) double runningSum;
@property (nonatomic, assign) double runningMedian;
@property (nonatomic, assign) double current;
@property (atomic, copy) NSMutableArray<NSNumber *> *numbers;
@property (nonatomic, strong) PDMHeap *minHeap;
@property (nonatomic, strong) PDMHeap *maxHeap;

@end


@implementation PDMRunningCalculator

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _runningCount = 0;
        _runningSum = 0;
        _runningMedian = 0;
        _current = 0;
        _min = DBL_MAX;
        _max = DBL_MIN;
        _numbers = [NSMutableArray array];
        _minHeap = [[PDMHeap alloc] initWithComparator:^BOOL(double a, double b) {
            return a < b;
        }];
        _maxHeap = [[PDMHeap alloc] initWithComparator:^BOOL(double a, double b) {
            return a > b;
        }];
    }
    return self;
}

- (void)append:(double)n
{
    @synchronized (self.numbers) {
        [self.numbers addObject:@(n)];
    }
    self.runningCount += 1;
    self.runningSum += n;
    self.max = MAX(self.max, n);
    self.min = MIN(self.min, n);
    [self calculateZeroCrossing:n];
    self.current = n;
    [self calculateMedian];
}

- (double)mean
{
    return self.runningSum / self.runningCount;
}

- (double)median
{
    return self.runningMedian;
}

- (void)calculateZeroCrossing:(double)newElement
{
    NSInteger a = @(self.current).pdm_signum;
    NSInteger b = @(newElement).pdm_signum;
    if (a != b && (a == 0 || b == 0) == NO) {
        self.zeroCrossings += 1;
    }
}

- (void)calculateMedian
{
    PDMHeap *l = self.maxHeap;
    PDMHeap *r = self.minHeap;
    double e = self.current;
    double m = self.runningMedian;
    int signum = self.heapsSignum;

    switch(signum) {
        case 1: // There are more elements in left (max) heap
            if(e < m) // current element fits in left (max) heap
            {
                // Remore top element from left heap and
                // insert into right heap
                [r insert:[l extractTop]];

                // current element fits in left (max) heap
                [l insert:e];
            }
            else {
                // current element fits in right (min) heap
                [l insert:e];
            }
            // Both heaps are balanced
            m = (l.top + r.top) / 2;
            break;

        case 0: // The left and right heaps contain same number of elements
            if(e < m) // current element fits in left (max) heap
            {
                [l insert:e];
                m = l.top;
            }
            else
            {
                // current element fits in right (min) heap
                [r insert:e];
                m = r.top;
            }
            break;

        case -1: // There are more elements in right (min) heap

            if(e < m) // current element fits in left (max) heap
            {
                [l insert:e];
            }
            else
            {
                // Remove top element from right heap and
                // insert into left heap
                [l insert:[r extractTop]];

                // current element fits in right (min) heap
                [r insert:e];
            }

            // Both heaps are balanced
            m = (l.top + r.top) / 2;
            break;
    }

    self.runningMedian = m;
}

- (double)stdev
{
    double sqDiff = 0;
    double mean = self.mean;
    @synchronized (self.numbers) {
        for (NSNumber *value in self.numbers) {
            double n = value.doubleValue;
            sqDiff += ((n - mean) * (n - mean));
        }
    }
    return sqrt(sqDiff / self.runningCount);
}

- (int)heapsSignum
{
    NSUInteger minCount = self.minHeap.count;
    NSUInteger maxCount = self.maxHeap.count;
    if(minCount == maxCount) {
        return 0;
    }

    return minCount < maxCount ? -1 : 1;
}

@end
