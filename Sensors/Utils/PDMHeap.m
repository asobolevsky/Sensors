//
//  PDMHeap.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "PDMHeap.h"
#import "PDMUtils.h"

const NSInteger kPDMMaxHeapSize = 10000;

@interface PDMHeap ()
{
    NSInteger _heapSize;
}

@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> *heap;
@property (nonatomic, copy, readonly) BOOL (^comparator)(double, double);

@end


@implementation PDMHeap

- (instancetype)initWithComparator:(BOOL(^)(double, double))comparator
{
    self = [super init];
    if (self != nil) {
        _heap = [NSMutableArray arrayWithCapacity:kPDMMaxHeapSize];
        _heapSize = -1;
        _comparator = comparator;
    }
    return self;
}

-(NSInteger)parent:(NSInteger)i
{
    if(i <= 0) {
        return -1;
    }

    return (i - 1) / 2;
}

-(double)top
{
    double max = -1;
    if(_heapSize >= 0) {
        max = self.heap[0].doubleValue;
    }
    return max;
}

- (NSUInteger)count
{
    return _heapSize + 1;
}

- (void)heapify:(NSInteger)i
{
    NSInteger p = [self parent:i];

    // comp - differentiate MaxHeap and MinHeap
    // percolates up
    if(p >= 0 && self.comparator(self.heap[i].doubleValue, self.heap[p].doubleValue))
    {
        [self.heap exchangeObjectAtIndex:i withObjectAtIndex:p];
        [self heapify:p];
    }
}

// Deletes root of heap
- (double)extractTop
{
    double del = -1;
    if(_heapSize > -1)
    {
        del = self.heap[0].doubleValue;
        [self.heap exchangeObjectAtIndex:0 withObjectAtIndex:_heapSize];
        _heapSize -= 1;
        NSInteger p = [self parent:_heapSize + 1];
        [self heapify:p];
    }

    return del;
}

// Helper to insert key into Heap
- (void)insert:(double)d
{
    if (_heapSize < kPDMMaxHeapSize) {
        _heapSize += 1;
        self.heap[_heapSize] = @(d);
        [self heapify:_heapSize];
    }
}

@end
