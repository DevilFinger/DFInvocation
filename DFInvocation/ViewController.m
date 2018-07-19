//
//  ViewController.m
//  DFInvocation
//
//  Created by RaymondChen on 2018/7/17.
//  Copyright © 2018 DevilFinger. All rights reserved.
//

#import "ViewController.h"
#import "Core/NSObject+DFInvocation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:246.0f / 255.0f  green:206.0f / 255.0f blue:70.0f / 255.0f alpha:1.0f];

    /**If your want to catch error when perform selector is mistake, you should change this to "YES" */
    //[DFInvocationHelper sharedHelper].isCatchAndThrow = YES;
    
    /**If you want to call your own method, you can call like this as follow:*/
    
    /** with no arguments*/
    [self dfPerformSelector:@selector(customClassMethodWithoutArgument)];
    
    /** with only one argument*/
    NSArray *arguments = @[@"i am argumen 1", @"i am argumen 2"];
    NSArray *resutlA = [self dfPerformSelector:@selector(customClassMethodWithOneArgument:) argument:arguments];
    /** if the method has return value, it will give the return value */
    NSLog(@"resultA : %@", resutlA);
    
    /** with a lots of arguments*/
    NSArray *argumentsEx = @[arguments, @(1), @(CGRectMake(0, 0, 100, 200))];
    NSArray *resutlEx = [self dfPerformSelector:@selector(customClassMethodWithManyArguments:argument2:argument3:) arguments:argumentsEx];
    NSLog(@"resutlEx : %@", resutlEx);
    
    
    /**when the method argument is block, you could call like this*/
    /**First of all, Declaring "block"*/
    void (^blk)(NSInteger ) = ^(NSInteger count) {
        NSLog(@"block %@", @(count));
    };
    /**Second,Call the methond*/
    [self  dfPerformSelector:@selector(block:) argument:blk];
    
    /**method "errorMethod" is not exist, call fail and nothing will happend. if u want to catch the error,change "isCatchAndThrow" to "YES" */
    //[self dfPerformSelector:@selector(errorMethod)];
}

-(void)customClassMethodWithoutArgument
{
    NSLog(@"call method success (customClassMethodWithoutArgument)");
}

-(NSArray *)customClassMethodWithOneArgument:(NSArray *)arry
{
    NSLog(@"call method success (customClassMethodWithOneArgument) with argument @%@", arry);
    return arry;
}

-(NSArray *)customClassMethodWithManyArguments:(NSArray *)arry  argument2:(NSInteger)intValue argument3:(CGRect)rect
{
    NSLog(@"call method success (customClassMethodWithManyArguments) arguments as the follow:");
    NSLog(@"arg1 : %@", arry);
    NSLog(@"arg2 : %@", @(intValue));
    NSLog(@"arg3 : %@", @(rect));
    return arry;
}


-(void)block:(void (^)(NSInteger a))completion
{
    if (completion) {
        completion(1);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
