//
//  PDMServiceLocator.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDMServiceLocator : NSObject

+ (void)registerService:(id)service forProtocol:(Protocol *)protocol;
+ (id)serviceForProtocol:(Protocol *)protocol;

@end
