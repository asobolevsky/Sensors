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
#import "PDMGPSTrackerService.h"

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
    [PDMServiceLocator registerService:[[PDMGPSTrackerService alloc] init]
                           forProtocol:@protocol(PDMGPSTrackerServiceProtocol)];
}

- (void)startServices
{
    id<PDMAccelerometerServiceProtocol> accelerometerService;
    accelerometerService = [PDMServiceLocator serviceForProtocol:@protocol(PDMAccelerometerServiceProtocol)];
    [accelerometerService startUpdates];

    id<PDMGPSTrackerServiceProtocol> gpsTrackerService;
    gpsTrackerService = [PDMServiceLocator serviceForProtocol:@protocol(PDMGPSTrackerServiceProtocol)];
}

- (void)stopServices
{
    id<PDMAccelerometerServiceProtocol> accelerometerService;
    accelerometerService = [PDMServiceLocator serviceForProtocol:@protocol(PDMAccelerometerServiceProtocol)];
    [accelerometerService stopUpdates];

    id<PDMGPSTrackerServiceProtocol> gpsTrackerService;
    gpsTrackerService = [PDMServiceLocator serviceForProtocol:@protocol(PDMGPSTrackerServiceProtocol)];
}


@end
