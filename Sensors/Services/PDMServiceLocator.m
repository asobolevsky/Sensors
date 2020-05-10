//
//  PDMServiceLocator.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "PDMServiceLocator.h"
#import <objc/runtime.h>

static NSMutableDictionary *_servicesRegistry;
static dispatch_once_t onceToken;

@implementation PDMServiceLocator

+ (void)registerService:(id)service forProtocol:(Protocol *)protocol
{
    dispatch_once(&onceToken, ^{
        _servicesRegistry = [NSMutableDictionary dictionary];
    });

    NSString *protocolName = [NSString stringWithUTF8String:protocol_getName(protocol)];
    if ([service conformsToProtocol:protocol] == NO) {
        NSLog(@"PDMServiceLocator | Service %@ does not conform to protocol %@", service, protocolName);
        return;
    }

    _servicesRegistry[protocolName] = service;
}

+ (id)serviceForProtocol:(Protocol *)protocol
{
    NSString *protocolName = [NSString stringWithUTF8String:protocol_getName(protocol)];
    id result = _servicesRegistry[protocolName];

    if (result == nil) {
        NSLog(@"PDMServiceLocator | No services is registred for a protocol %@", protocolName);
    }

    return result;
}

@end
