//
//  AppDelegate.m
//  CrashReport
//
//  Created by  huiyuan on 2017/4/19.
//  Copyright © 2017年 张宇超. All rights reserved.
//

#import "AppDelegate.h"

#import "HYCrashManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#pragma mark --- 获取崩溃日志
    /**
     * 此处崩溃日志,可以获取oc层面的崩溃日志,也可以获取到c++层面的崩溃日志。
     */
    [HYCrashManager installCrashReportHandler];
    
    //发送崩溃日志
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *Name1 = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSString *Version1 = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"path:%@",path);
    NSString *dataPat = [NSString stringWithFormat:@"%@/%@_%@.txt",path,Name1,Version1];
    NSLog(@"dataPat:%@",dataPat);
    NSData *data = [NSData dataWithContentsOfFile:dataPat];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"----str:%@----",str);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
