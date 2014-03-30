//
//  JSAAppDelegate.m
//  JSACollection
//
//  Created by Nelson LeDuc on 3/30/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "JSAAppDelegate.h"
#import "JSAViewController.h"

@implementation JSAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    JSAViewController *viewController = [[JSAViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:viewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
