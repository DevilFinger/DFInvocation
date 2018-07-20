//
//  DFInvocationHelper.h
//  DFInvocation
//
//  Created by RaymondChen on 2018/7/18.
//  Copyright © 2018 DevilFinger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DFInvocationTypeConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface DFInvocationHelper : NSObject

/**
 When there is an error, whether to throw an exception. Default is "NO"
 */
@property (nonatomic, assign) BOOL isCatchAndThrow;

@property (nonatomic, readonly, copy) NSString *version;


/**
 Singleton
 */
+ (instancetype)sharedHelper;

/**
 Setting Argument for Inovation

 @param index index of argument(Index starts from 2)
 @param inv NSInvocation
 @param sig NSMethodSignature
 @param obj the value of argument
 */
+(void)setMethodArgumentAtIndex:(NSInteger)index invocation:(NSInvocation *)inv methodSignature:(NSMethodSignature *)sig object:(id)obj;

/**
 Get the return value of method

 @param inv NSInvocation
 @param sig NSMethodSignature
 @return methodn's return value;
 */
+(id)getMethodReturnValueWithInv:(NSInvocation *)inv sig:(NSMethodSignature *)sig;

@end

NS_ASSUME_NONNULL_END
