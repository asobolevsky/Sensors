//
//  AppDelegate.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 09.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "AppDelegate.h"
#import "PDMServiceLocator.h"
#import "PDMAccelerometerService.h"
#import "PDMAccelerometerServiceProtocol.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerServices];
    [self startServices];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self startServices];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self stopServices];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self stopServices];
}


#pragma mark -

- (void)registerServices
{
    [PDMServiceLocator registerService:[[PDMAccelerometerService alloc] init]
                           forProtocol:@protocol(PDMAccelerometerServiceProtocol)];
}

- (void)startServices
{
    [self startAccelerometer];
}

- (void)stopServices
{
    [self stopAccelerometer];
}

- (void)startAccelerometer
{
    id<PDMAccelerometerServiceProtocol> accelerometerService;
    accelerometerService = [PDMServiceLocator serviceForProtocol:@protocol(PDMAccelerometerServiceProtocol)];
    [accelerometerService startAccelerometerUpdates];
}

- (void)stopAccelerometer
{
    id<PDMAccelerometerServiceProtocol> accelerometerService;
    accelerometerService = [PDMServiceLocator serviceForProtocol:@protocol(PDMAccelerometerServiceProtocol)];
    [accelerometerService stopAccelerometerUpdates];
}


@end
