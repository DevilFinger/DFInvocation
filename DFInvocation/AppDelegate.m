//
//  AppDelegate.m
//  DFInvocation
//
//  Created by RaymondChen on 2018/7/17.
//  Copyright © 2018 DevilFinger. All rights reserved.
//

#import "AppDelegate.h"
#import "Core/NSObject+DFDynamicSelector.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [DFInvocationHelper sharedHelper].isCatchAndThrow = YES;
    NSArray *tA = @[@"ta1", @"ta2"];
    NSMutableArray *mA = [NSMutableArray array];
    [mA addObject:@"m-ma1"];

    NSDictionary *tD = @{@"td1":@"1",
                         @"td2":@"2",
                         };

    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"ob" forKey:@"md"];
    
    void (^blk)(NSInteger ) = ^(NSInteger count) {
        NSLog(@"block %@", @(count));
    };

//    NSArray *resutlA = [self dfPerformSelector:@selector(testArray:) argument:tA];
//    NSMutableArray *resutlMA = [self dfPerformSelector:@selector(testMuArray:) argument:mA];
//
//    NSDictionary *resDict = [self dfPerformSelector:@selector(testDict:) argument:tD];
//    NSMutableDictionary *muDict = [self dfPerformSelector:@selector(testMuDict:) argument:mDict];
//
//
//
//    [self  dfPerformSelector:@selector(block:) argument:blk];
    
    [self dfPerformSelector:@selector(testArray:) ];
    return YES;
}


-(void)block:(void (^)(NSInteger a))completion
{
    if (completion) {
        completion(1);
    }
}

-(NSArray *)testArray:(NSArray *)arry
{
    NSLog(@"%@", [NSThread currentThread]);
    NSLog(@"%@",arry);
    return arry;
}

-(NSMutableArray *)testMuArray:(NSMutableArray *)mArry
{
    NSLog(@"%@", [NSThread currentThread]);
    NSLog(@"%@",mArry);
    return mArry;
}

-(NSDictionary *)testDict:(NSDictionary *)dict
{
    NSLog(@"%@", [NSThread currentThread]);
    NSLog(@"%@",dict);
    return dict;
}

-(NSMutableDictionary *)testMuDict:(NSMutableDictionary *)mDict
{
    NSLog(@"%@", [NSThread currentThread]);
    NSLog(@"%@",mDict);
    return mDict;
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
