//
//  AppDelegate.m
//  JsonToModel
//
//  Created by haogaoming on 2018/5/2.
//  Copyright © 2018年 郝高明. All rights reserved.
//

#import "AppDelegate.h"
#import "SubModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDictionary *dic = @{ @"str1":@"123", @"str2":@"456", @"str3":@222, @"str5":@"1",
                           @"str7":@[@"1",@"2",@"3"], @"str8":@[@{@"str":@"123"},@{@"str":@123},@{@"Number":@"32"}],
                           @"str10":@23, @"str11":@23.3,@"id":@"999"
                          };
    
    SubModel *model = [[SubModel alloc] initWithDictionary:dic];
    NSLog(@"%@",model);
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
