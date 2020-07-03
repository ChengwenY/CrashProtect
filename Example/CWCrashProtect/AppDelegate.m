//
//  AppDelegate.m
//  CWCrashProtect
//
//  Created by Chengwen.Y on 2020/6/30.
//  Copyright © 2020 CW. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "CWCrashProtect.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController *vc = [[ViewController alloc] init];
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    [CWCrashProtect openCrashProtect:ECWCrashProtectAll];
    [CWCrashProtect setErrorHandlerBlock:^(CWCrashCatchError * error) {
//        NSLog(@"%@", error);
        NSAssert(NO, error.errorDesc);
    }];
    return YES;
}


#pragma mark - UISceneSession lifecycle


@end
