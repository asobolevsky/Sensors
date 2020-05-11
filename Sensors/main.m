//
//  main.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 09.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        Class appDelegateClass = NSClassFromString(@"PDMTestAppDelegate");
        if (appDelegateClass == nil) {
            appDelegateClass = [AppDelegate class];
        }
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass(appDelegateClass);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
