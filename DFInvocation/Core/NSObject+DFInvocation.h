//
//  NSObject+DFInvocation.h
//  DevilFinger Team
//
//  Created by RaymondChen on 15/03/2018.
//  Copyright © 2018 DevilFinger Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DFInvocationHelper.h"
@interface NSObject (DFDynamicSelector)

/**
 根据keypath去动态执行方法
 
 @param keyPath keypath
 @param value keypath的值
 */
-(void)dfPerformSelectorWithKeyPath:(NSString *)keyPath value:(id)value;

/**
 根据seleotor名字去动态执行
 
 @param sel 方法名称
 @return seleotor的方法的返回值
 */
-(id)dfPerformSelector:(SEL)sel;

/**
 根据seleotor名字去动态执行
 
 @param sel 方法名称
 @param argument 参数
 @return seleotor的方法的返回值
 */
-(id)dfPerformSelector:(SEL)sel argument:(id)argument;

/**
 根据seleotor名字去动态执行
 
 @param sel 方法名称
 @param arguments 多参数
 @return seleotor的方法的返回值
 */
-(id)dfPerformSelector:(SEL)sel arguments:(NSArray *)arguments;


@end
