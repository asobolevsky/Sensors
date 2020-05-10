//
//  PDMServiceLocatorTests.m
//  SensorsTests
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PDMServiceLocator.h"
#import "PDMTestServiceOne.h"
#import "PDMTestServiceTwo.h"
#import "PDMTestProtocolOne.h"
#import "PDMTestProtocolTwo.h"

@interface PDMServiceLocatorTests : XCTestCase

@end


@implementation PDMServiceLocatorTests

- (void)setUp
{
    [super setUp];

    [PDMServiceLocator registerService:[[PDMTestServiceOne alloc] init] forProtocol:@protocol(PDMTestProtocolOne)];
    [PDMServiceLocator registerService:[[PDMTestServiceTwo alloc] init] forProtocol:@protocol(PDMTestProtocolTwo)];
}

- (void)testServices
{
    id serviceOne = [PDMServiceLocator serviceForProtocol:@protocol(PDMTestProtocolOne)];
    XCTAssertNotNil(serviceOne, @"Service should be registered");

    id serviceTwo = [PDMServiceLocator serviceForProtocol:@protocol(PDMTestProtocolTwo)];
    XCTAssertNil(serviceTwo, @"Service should not be present as it doesn't conform to a protocol");
}


@end
